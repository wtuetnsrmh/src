package project.view.module.scene.longbao 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.config.ItemConfig;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.friends.BonusModel;
	import project.model.longBao.LongBaoModel;
	import project.model.longBao.vo.Difficulty;
	import project.model.longBao.vo.StoryLevel;
	import project.model.newBie.NewBieModelId;
	import project.utils.CustomTool;
	import project.utils.DepthManager;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSprite;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.helppane.NewbiePane;
	
	/**
	 * 关卡
	 * @author bbjxl 2013
	 */
	public class PassBase extends MovieClip 
	{
		private var _difficultMc:MovieClip;//当前进度
		private var _selectedEffectMc:MovieClip;
		private var _lastPass:MovieClip;//剧情所在关
		private var _diffcultText:TextField;//当前所在关卡编号
		private var _passNameText:TextField;//关卡名称
		private var _passName:String;
		private var _searchBt:MovieClipButton;//探索
		private var _battleBt:MovieClipButton;//战斗
		private var _enable:Boolean = false;
		private var _selected:Boolean = false;
		private var _passed:Boolean = false;//是否是已经通关的
		private var _id:int;//关卡唯一编号
		private var _level:int;//关卡编号1-10
		private var _chapterId:int;//章编号
		private var _storyLevel:StoryLevel;//战斗数据模型
		private var _searchStoryLevel:StoryLevel;//探索数据模型
		private var _isLastPass:Boolean = false;//是否剧情所在关
		private var _ui:MovieClip;
		private var _bgBar:MovieClip;//透明底条
		public function PassBase() 
		{
			_ui = Reflection.createInstance("passBaseUI") as MovieClip;
			_ui.stop();
			addChild(_ui);
			_bgBar = _ui.getChildByName("bgBar") as MovieClip;
			_bgBar.mouseEnabled = false;
			_bgBar.stop();
			_passNameText = _ui.getChildByName("passNameText") as TextField;
			_passNameText.mouseEnabled = false;
			_diffcultText = _ui.getChildByName("diffcultText") as TextField;
			_diffcultText.mouseEnabled = false;
			//_diffcultText.autoSize = TextFieldAutoSize.CENTER;
			_selectedEffectMc = _ui.getChildByName("selectedEffectMc") as MovieClip;
			_difficultMc = _ui.getChildByName("difficultMc") as MovieClip;
			_difficultMc.stop();
			_lastPass = _ui.getChildByName("lastPass") as MovieClip;
			_lastPass.visible = false;
			_lastPass.mouseEnabled = false;
			_searchBt = _ui.getChildByName("searchBt") as MovieClipButton;
			_battleBt = _ui.getChildByName("battleBt") as MovieClipButton;
			_searchBt.clickEnable = false;
			_searchBt.onClick = searchClickHandler;
			_battleBt.onClick = clickHandler;
			_diffcultText.mouseEnabled = false;
			enable = false;//默认都为不可点击
			selected = false;
			//this.addEventListener(MouseEvent.CLICK, selectedHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		}
		
		private function rollOverHandler(e:MouseEvent):void 
		{
			DepthManager.bringToTop(this);
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			selected = true;
			
			if (passed) {
				PassTipPanel.getInstance().difficult = "通过";
				PassTipPanel.getInstance().report = "通过";
				PassTipPanel.getInstance().passReport = "通过";
				}else {
					PassTipPanel.getInstance().difficult = Difficulty.returnString(_storyLevel.difficulty);
					PassTipPanel.getInstance().report = _storyLevel.rank.returnString();
					PassTipPanel.getInstance().passReport = _storyLevel.passRank.returnString();
					}
			if (_searchStoryLevel == null) {
				PassTipPanel.getInstance().goldBonus = "";
				PassTipPanel.getInstance().bonus = "";
				}else {
					PassTipPanel.getInstance().bonus = _searchStoryLevel.searchBonus.ToStringByLongBao(1);
					PassTipPanel.getInstance().goldBonus = _searchStoryLevel.searchBonus.ToStringByLongBao(2);
					}
			if (_storyLevel == null) {
				PassTipPanel.getInstance().passBonus = "";
				}else if(_storyLevel.passBonus!=null) {
					PassTipPanel.getInstance().passBonus = _storyLevel.passBonus.ToStringByLongBao(1);
					}
			
			PassTipPanel.getInstance().show();
		}
		
		private function rollOutHandler(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			selected = false;
			PassTipPanel.getInstance().hide();
		}
		
		
		
		/**
		 * 点击展开
		 * @param	e
		 */
		private function selectedHandler(e:MouseEvent):void 
		{
			selected = true;
		}
		
		/**
		 * 探索
		 * @param	e
		 */
		private function searchClickHandler(e:MouseEvent):void 
		{
			if (_searchStoryLevel == null) return;
			if (LongBaoModel.getInstance().energy <LongBaoModel.getInstance().searchCost) {
				showBuyTip();
				return;
				}
				
			SMZTController.getInstance().searchStory(_searchStoryLevel.id,function(param:Object):void {
				var tempBonus:BonusModel = new BonusModel();
				tempBonus.setData(param.bonus);
				SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus);
				tempBonus = null;
				LongBaoModel.getInstance().getInfo(true);
				});
		}
		
		/**
		 * 战斗
		 * @param	e
		 */
		private function clickHandler(e:MouseEvent):void 
		{
			if (_storyLevel == null) return;
			
			if (LongBaoModel.getInstance().energy <LongBaoModel.getInstance().challengCost) {
				showBuyTip();
				return;
				}
			
			if (_storyLevel.talks == null || _storyLevel.talks.length==0) {
				//没有情节时直接显示出战设置
				LongBaoModel.getInstance().currentChallengePassId = _storyLevel.id;
				BattleReadyPanel.getInstance().show(true);
				BattleReadyPanel.getInstance().initUIByBattleModel(_storyLevel.mode, BattleReadyPanel.LONG_BAO);
				}else {
					//-------------------新手引导用-----------------------
					   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					   NewBieControler.getInstance().nextStep();
					   NewbiePane.getInstance().hide();
					   }
					   //--------------------end--------------------
					
				//播放情节
				SMZTUIManager.getInstance().longBaoScene.dramaPlayer.currentStoryLevel = _storyLevel;
				
				}
		}
		
		/**
		 * 如果挑战时体力不够,先判断背包是否有道具,有则提示是否使用,如果没用则提示购买物品
		 * 
		 * @param	e
		 */
		private function showBuyTip():void {
			UseItemControler.judgestItemExistAndCallBack(SpecialItemIdConfig.STORY_ITEM, function():void {
				//使用增加2体力道具
				var userItemAddDynamic:Function = function(okOrCancel:String):void {
				if (okOrCancel==AlertSelectPane.ALERT_YES) {
					UseItemControler.userItemNew(SpecialItemIdConfig.STORY_ITEM);
					}
				}
				AlertSelectPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.LongBaoPane.UserItemTip.@Text).replace("{ItemName}",ItemConfig.ITEM_CONFIG.Item.(@ID == SpecialItemIdConfig.STORY_ITEM).@Name), userItemAddDynamic, true);
				},function():void {
					//没有道具时提示购买体力的道具
					var buyItem:Function = function(okOrCancel:String):void {
					if (okOrCancel==AlertSelectPane.ALERT_YES) {
						UseItemControler.showBuyWin(SpecialItemIdConfig.STORY_ITEM);
						}
					}
					AlertSelectPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.LongBaoPane.BuyItemTip.@Text).replace("{ItemName}",ItemConfig.ITEM_CONFIG.Item.(@ID == SpecialItemIdConfig.STORY_ITEM).@Name), buyItem, true);
					
					});
			}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (!value) {
				this.mouseEnabled = false;
				//this.buttonMode = false;
				this.visible = false;
				} else {
				this.mouseEnabled = true;
				//this.buttonMode = true;
				this.visible = true;
				}
		}
		
		public function get selected():Boolean 
		{
			return _selected;
			
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (value) {
				_battleBt.visible = true;
				_searchBt.visible = true;
				_selectedEffectMc.visible = true;
				}else {
					_battleBt.visible = false;
					_searchBt.visible = false;
					_selectedEffectMc.visible = false;
					}
		}
		
		public function get passed():Boolean 
		{
			return _passed;
		}
		
		public function set passed(value:Boolean):void 
		{
			_passed = value;
			if (value) {
				_battleBt.clickEnable = false;
				_difficultMc.gotoAndStop(4);
				_lastPass.visible = false;
				}else {
					_battleBt.clickEnable = true;
					_difficultMc.gotoAndStop(1);
					}
			this.visible = true;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			//_diffcultText.text = _chapterId + "-" + value;
		}
		
		public function get storyLevel():StoryLevel 
		{
			return _storyLevel;
		}
		
		public function set storyLevel(value:StoryLevel):void 
		{
			_storyLevel = value;
			
			id = value.id;
			enable = true;
			_difficultMc.gotoAndStop(value.difficulty);
			
			_bgBar.gotoAndStop(LongBaoModel.getInstance().currentChapter);
			/*if (value.difficulty == Difficulty.EASY) {
				//如果普通没通过则探索不可点
				_searchBt.clickEnable = false;
				}else {
					_searchBt.clickEnable = true;
					}*/
		}
		
		public function get passName():String 
		{
			return _passName;
		}
		
		public function set passName(value:String):void 
		{
			_passName = value;
			_passNameText.text = value;
		}
		
		public function get chapterId():int 
		{
			return _chapterId;
		}
		
		public function set chapterId(value:int):void 
		{
			_chapterId = value;
			_diffcultText.text = value + "-" + level;
			
		}
		
		public function get isLastPass():Boolean 
		{
			return _isLastPass;
		}
		
		public function set isLastPass(value:Boolean):void 
		{
			_isLastPass = value;
			if (value) {
				_lastPass.visible = true;
				}else {
					_lastPass.visible = false;
					}
		}
		
		public function get searchStoryLevel():StoryLevel 
		{
			return _searchStoryLevel;
		}
		
		public function set searchStoryLevel(value:StoryLevel):void 
		{
			_searchStoryLevel = value;
			_searchBt.clickEnable = true;

		}
		
	}

}