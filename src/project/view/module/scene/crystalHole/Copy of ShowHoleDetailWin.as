package project.view.module.scene.crystalHole
{
	import com.bbjxl.utils.Tools;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.crystalHole.CrystalHoleModel;
	import project.model.crystalHole.Mine;
	import project.model.crystalHole.MineType;
	import project.model.data.PlayerData;
	import project.model.data.User;
	import project.model.friends.BonusModel;
	import project.model.ModelLocator;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.controls.ManageShowBonus;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.attack.BattleReadyPanel;
	
	/**
	 * 显示矿洞详细弹窗
	 * @author bbjxl 2013
	 */
	public class ShowHoleDetailWin extends BaseTitleWindow
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _typeText:TextField; //矿的类型
		private var _yieldText:TextField;
		private var _occupyTimeText:TextField;
		private var _occupyNameText:TextField;
		private var _robCdTimeText:TextField; //掠夺冷却时间:
		private var _protectedTimeText:TextField; //剩余保护时间:
		private var _occpyBt:MovieClipButton;
		private var _robBt:MovieClipButton;
		private var _assetsBt:MovieClipButton;
		private var _stealBt:MovieClipButton;
		private var _harvestBt:MovieClipButton;
		private var _giveUpBt:MovieClipButton;
		private var _stars:Array;
		//-----------------------数据---------------------------------
		public static const replaceStr:String = "--";
		public static const replaceStr0:String = "00:00:00";
		
		private var _occupyTime:int; //占领剩余时间
		private var _occupyCdTime:int; //占领保护时间
		private var _robCdTime:int; //掠夺保护时间
		private var _occupyNormalTime:int; //占领标准时间
		private var _mineModel:Mine;
		//-----------------------事件--------------------------------
		private static var _showHoleDetailWin:ShowHoleDetailWin;
		private var maxSteal:int=10;//最多偷10次
		
		public function ShowHoleDetailWin()
		{
			if (_showHoleDetailWin != null)
			{
				throw(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
			}
			setSpriteInstance("showHoleDetailWin");
			configerUIInstance();
			SMZTUIManager.getInstance().crystalHoleScene.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		/**
		 * 有占领者返回00:00:00格式,没有占领者返回--格式
		 * @param	e
		 */
		private function retunrReplaceStr():String {
			return  (_mineModel.owner==null)?replaceStr:replaceStr0;
			}
		
		/**
		 * 计时
		 * @param	e
		 */
		private function timerHandler(e:TimerEvent=null):void
		{
			if (!isOpened) return;
			if (_occupyTime > 0)
			{
				_occupyTime--;
				_occupyTimeText.text = Tools.formatTime(_occupyTime);
			}
			else if (_occupyTime == 0)
			{
				//刷新收获跟放弃状态
				refreshHavestAndGiveUp();
				_occupyTime--;
				if (_mineModel.owner == null) {
					_occupyTimeText.text =Tools.formatTime(_mineModel.occupy); //占领标准时间
					}else {
						_occupyTimeText.text = replaceStr0;
						}
				
				if (_mineModel.isFriend && !isMyMine(_mineModel.owner) && _mineModel.steals.length<maxSteal && _mineModel.owner!=null && !stealed())
					{
						//不是自己的矿坑，是好友的矿坑,已完成,10次没被偷完,有矿主,我还没偷过
						_stealBt.clickEnable = true;
					}
					else
					{
						_stealBt.clickEnable = false;
					}
			}
			
			if (_occupyCdTime > 0)
			{
				_occupyCdTime--;
				_protectedTimeText.text = Tools.formatTime(_occupyCdTime);
			}
			else if (_occupyCdTime == 0)
			{
				//刷新占领按钮状态
				refreshOccupyBt();
				_occupyCdTime--;
				_protectedTimeText.text = retunrReplaceStr();
			}
			
			if (_robCdTime > 0)
			{
				_robCdTime--;
				_robCdTimeText.text = Tools.formatTime(_robCdTime);
			}
			else if (_robCdTime == 0)
			{
				//刷新掠夺按钮状态
				refreshRobBt();
				_robCdTime--;
				_robCdTimeText.text = retunrReplaceStr();
			}
		}
		
		/**
		 * 返回是否是自己的矿坑
		 * @return
		 */
		private function isMyMine(value:User):Boolean
		{
			if (value == null)
				return false;
			if (value.userId == PlayerData.getInstance().userId)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 更新
		 */
		public function updataUI(value:Mine):void
		{
			_mineModel = value;
			
			if (_mineModel.owner == null)
			{
				//无人矿坑
				_occupyTimeText.text = Tools.formatTime(_mineModel.occupy); //占领标准时间
				_robCdTimeText.text = replaceStr;
				_protectedTimeText.text = replaceStr;
				
				_yieldText.text = value.yield.toString();
			}else {
				_yieldText.text = value.yieldNow.toString();
				}
			
			//协助数
			for (var i:uint = 0; i < _stars.length; i++)
			{
				_stars[i].gotoAndStop(1);
			}
			for (var j:uint = 0; j < value.assists.length; j++)
			{
				_stars[j].gotoAndStop(2);
			}
			
			_typeText.text = MineType.returnTypeName(value.type);
			
			
			
			_occupyTime = value.occupyLeft;
			_occupyCdTime = value.occupyCd;
			_robCdTime = value.robCd;
			_occupyNormalTime = value.occupy;
			
			if (value.owner)
			{
				_occupyNameText.text = value.owner.nick;
			}
			else
			{
				_occupyNameText.text = "";
			}
			
			refreshOccupyBt();
			
			refreshRobBt();
			
			if (_occupyTime != 0 && value.isFriend && !isMyMine(value.owner) && !assetsed() && !assetsEnable() && value.owner && CrystalHoleModel.getInstance().assist>0)
			{
				//不是自己的矿坑，是好友的矿坑,未完成,自己未协助过,协助次数未满,有矿主,自己的协助次数还有
				_assetsBt.clickEnable = true;
			}
			else
			{
				_assetsBt.clickEnable = false;
			}
			
			if (_occupyTime == 0 && value.isFriend && !isMyMine(value.owner) && value.steals.length<maxSteal && value.owner && !stealed())
			{
				//不是自己的矿坑，是好友的矿坑,已完成,10次没被偷完,有矿主,我还没偷过
				_stealBt.clickEnable = true;
			}
			else
			{
				_stealBt.clickEnable = false;
			}
			
			refreshHavestAndGiveUp();
			
			timerHandler();
		}
		
		/**
		 * 刷新掠夺按钮状态
		 */
		private function refreshRobBt():void 
		{
			if (_occupyTime != 0 && _robCdTime == 0 && !isMyMine(_mineModel.owner) && _mineModel.owner)
			{
				//不是自己的矿坑，占领剩余时间不为0，掠夺保护时间为0,有矿主
				_robBt.clickEnable = true;
			}
			else
			{
				_robBt.clickEnable = false;
			}
		}
		
		/**
		 * 刷新占领按钮状态
		 */
		private function refreshOccupyBt():void 
		{
			if (_occupyCdTime == 0 && !isMyMine(_mineModel.owner))
			{
				//不是自己的矿体,占领保护时间为0,则占领可点
				_occpyBt.clickEnable = true;
			}
			else
			{
				_occpyBt.clickEnable = false;
			}
		}
		
		/**
		 * 刷新收获跟放弃的状态
		 * @return
		 */
		private function refreshHavestAndGiveUp():void
		{
			if (!isMyMine(_mineModel.owner))
			{
				//不是自己的矿则放弃跟收获不显示
				_harvestBt.visible = false;
				_giveUpBt.visible = false;
				return;
			}
			if (_occupyTime == 0)
			{
				//是自己的矿坑，已完成
				_harvestBt.visible = true;
				_harvestBt.clickEnable = true;
				_giveUpBt.visible = false;
			}
			else
			{
				_harvestBt.visible = false;
				_harvestBt.clickEnable = false;
				_giveUpBt.visible = true;
			}
			if (_occupyTime != 0)
			{
				//是自己的矿坑，未完成
				_giveUpBt.visible = true;
				_giveUpBt.clickEnable = true;
				_harvestBt.visible = false;
			}
			else
			{
				_giveUpBt.visible = false;
				_giveUpBt.clickEnable = false;
				_harvestBt.visible = true;
			}
		}
		
		/**
		 * 自己是否已经偷过
		 */
		private function stealed():Boolean
		{
			for (var i:String in _mineModel.steals)
			{
				if (_mineModel.steals[i].userId == PlayerData.getInstance().userId)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 自己是否已经协助过
		 */
		private function assetsed():Boolean
		{
			for (var i:String in _mineModel.assists)
			{
				if (_mineModel.assists[i].userId == PlayerData.getInstance().userId)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 协助次数是否已满
		 */
		private function assetsEnable():Boolean
		{
			if (_mineModel.assists.length == 5)
			{
				return true;
			}
			return false;
		}
		
		private function configerUIInstance():void
		{
			_typeText = getChild("typeText") as TextField;
			_yieldText = getChild("yieldText") as TextField;
			_occupyTimeText = getChild("occupyTimeText") as TextField;
			_occupyNameText = getChild("occupyNameText") as TextField;
			_robCdTimeText = getChild("robCdTimeText") as TextField;
			_protectedTimeText = getChild("protectedTimeText") as TextField;
			_occpyBt = getChild("occpyBt") as MovieClipButton;
			_robBt = getChild("robBt") as MovieClipButton;
			_assetsBt = getChild("assetsBt") as MovieClipButton;
			_stealBt = getChild("stealBt") as MovieClipButton;
			_harvestBt = getChild("harvestBt") as MovieClipButton;
			_giveUpBt = getChild("giveUpBt") as MovieClipButton;
			_occpyBt.onClick = clickHandler;
			_robBt.onClick = clickHandler;
			_assetsBt.onClick = clickHandler;
			_stealBt.onClick = clickHandler;
			_harvestBt.onClick = clickHandler;
			_giveUpBt.onClick = clickHandler;
			
			_stars = new Array();
			for (var i:int = 0; i < 5; i++)
			{
				_stars.push(getChild("star" + i) as MovieClip);
			}
		}
		
		/**
		 * 如果占领跟掠夺时活力不够 则提示购买物品
		 * @param	e
		 */
		private function showBuyTip():void {
			
			}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case _occpyBt:
					if (CrystalHoleModel.getInstance().myMines.length >= 2) {
						//如果自己的矿已经有两个时给出提示
						AlertConfirmPane.getInstance().type = 0;
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CrystalHolePane.ThanTwoTip.@Text);
						return;
						}
					if (CrystalHoleModel.getInstance().stamina <= 0) {
						showBuyTip();
						return;
						}
						
					BattleReadyPanel.getInstance().show(true);
					if (_mineModel.mode == 0) {
						//挑战npc
						BattleReadyPanel.getInstance().initUIByBattleModel(4, BattleReadyPanel.HOLE_OCCUPY, false);
						}else {
							BattleReadyPanel.getInstance().initUIByBattleModel(_mineModel.mode, BattleReadyPanel.HOLE_OCCUPY, true);
							}
					break;
				case _robBt: 
					
					if (CrystalHoleModel.getInstance().stamina <= 0) {
						showBuyTip();
						return;
						}
					
					BattleReadyPanel.getInstance().show(true);
					if (_mineModel.type == 0) {
						//挑战npc
						BattleReadyPanel.getInstance().initUIByBattleModel(4, BattleReadyPanel.HOLE_ROB, false);
						}else {
							BattleReadyPanel.getInstance().initUIByBattleModel(_mineModel.mode, BattleReadyPanel.HOLE_ROB, true);
							}
					break;
				case _assetsBt: 
					SMZTController.getInstance().assetsMines(_mineModel.id, function(param:Object):void {
						var tempBonus:BonusModel = new BonusModel();
						tempBonus.setData(param);
						SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus);
						tempBonus = null;
						
						//更新当前矿区及我的矿体
						SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
						} );
					break;
				case _stealBt: 
					SMZTController.getInstance().stealMines(_mineModel.id, function(param:Object):void {
						var tempBonus1:BonusModel = new BonusModel();
						tempBonus1.setData(param);
						SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus1);
						tempBonus1 = null;
						
						refresh();
						} );
					break;
				case _harvestBt: 
					SMZTController.getInstance().harvestMine(_mineModel.id, function(param:Object):void {
						var tempBonus2:BonusModel = new BonusModel();
						tempBonus2.setData(param);
						SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus2);
						tempBonus2 = null;
						
						//更新当前矿区及我的矿体
						SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
						});
					break;
				case _giveUpBt: 
					var sendGiveUp:Function = function(okOrCancel:String):void {
						if (okOrCancel==AlertSelectPane.ALERT_YES) {
							SMZTController.getInstance().giveUpMines(_mineModel.id, function():void {
								//更新当前矿区及我的矿体
								SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
								});
						}
					}
					AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CrystalHolePane.GiveUpTip.@Text, sendGiveUp, true);
					
					break;
			}
			
		}
		/**
		 * 刷新
		 * @return
		 */
		public function refresh():void {
			//更新该矿坑的数据
			SMZTController.getInstance().getPointMine(_mineModel.id, function(param:Object):void { 
				var temp:Mine = new Mine();
				temp.setData(param);
				updataUI(temp);
				temp = null;
				} );
			}
		

			
		public static function getInstance():ShowHoleDetailWin
		{
			if (_showHoleDetailWin == null)
			{
				_showHoleDetailWin = new ShowHoleDetailWin;
			}
			return _showHoleDetailWin;
		} // end function
		
		public function get occupyNormalTime():int
		{
			return _occupyNormalTime;
		}
		
		public function set occupyNormalTime(value:int):void
		{
			_occupyNormalTime = value;
		}
		
		public function get mineModel():Mine 
		{
			return _mineModel;
		}
		
		public function set mineModel(value:Mine):void 
		{
			_mineModel = value;
		}
	
	}

}