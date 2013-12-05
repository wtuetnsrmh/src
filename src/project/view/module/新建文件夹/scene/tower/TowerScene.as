package project.view.module.scene.tower
{
	/**
	 *描述：宿命之塔
	 *
	 */
	import com.adobe.serialization.json.JSON;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.ItemConfig;
	import project.config.LocalConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.BagData;
	import project.model.data.DeckModel;
	import project.model.data.PlayerData;
	import project.model.defence.DefenceModel;
	import project.model.friends.BonusModel;
	import project.model.item.CardModel;
	import project.model.item.ItemModel;
	import project.model.newBie.NewBieModelId;
	import project.model.tower.ResultReport;
	import project.model.tower.TowerLevel;
	import project.model.tower.TowerStateModle;
	import project.utils.ControlPageNoView;
	import project.utils.DepthManager;
	import project.view.artplug.MovieClipButton;
	import project.view.common.FriendsControlPage;
	import project.view.controls.ToolTip;
	import project.view.layout.BaseGridContainer;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertMasterPane;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.cell.Card;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	import com.bbjxl.utils.Tools;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class TowerScene extends BaseGameScene
	{
		//----------------------容器---------------------------------
		private var _cardGrid:BaseGridContainer; //当前敌人卡牌容器
		//-----------------------UI---------------------------------
		private var _cancelArea:MovieClip;//自动战斗时屏敝场景
		private var _currentPros:Sprite; //当前塔层进度
		private var _maxPros:Sprite;
		private var _itemText:TextField;//当前可能掉落的物品
		private var _vipText:TextField;
		private var _currentLayeText:TextField;
		private var _timerText:TextField;
		private var _reportLayeText:TextField; //战报中的层数
		private var _freeEnterText:TextField;
		private var _addNumText:TextField;
		private var _expText:TextField;
		private var _glodText:TextField;
		private var _honorText:TextField;
		private var _sweepBt:MovieClipButton; //扫荡按钮
		private var _startBattleBt:MovieClipButton;
		private var _autoBattleBt:MovieClipButton;
		private var _cancleAutoBattleBt:MovieClipButton;
		private var _showBonus:MovieClipButton;
		//private var _prevBt:MovieClipButton;
		//private var _nextBt:MovieClipButton;
		private var _exitBt:MovieClipButton;
		
		private var _itemImage:BaseIcoCellLoader; //获得的物品
		private var _resultType:MovieClip; //战报结果类型
		
		private var _currentSlectedBt:TeleportButton;//当前传送的关卡按钮
		private var _oldSlectedBt:TeleportButton;//当前传送的关卡按钮
		private var _bossBonusPopWin:Sprite;//各boss奖励弹出框
		private var _enterTip:MovieClip;//进入提示标志
		//-----------------------数据---------------------------------
		private var _currentAnemyArr:Array;//当前敌人
		private var _currentPage:int=1;//当前页
		private var _autoBattleFlag:Boolean = false;//当前是否处于自动战斗状态
		private var _currentBigLayer:int = 0; //当前处于十大层中的哪一层
		private var _passArr:Array; //所有的关卡入口按钮
		private var _towerStateModel:TowerStateModle;
		private var _cards:Vector.<Card>;
		private var _initX:Number = 381.85; //进度标尺初始位置
		private var _maxX:Number = 671.65; //进度标尺最大进度Ｘ坐标
		private var _timer:Timer = new Timer(1000); //自动战斗时剩余时间
		private var _purceTimer:int = 30; //30秒挑战一次
		public var maxAutoTime:int = 30;
		
		//private var _controlPage:ControlPageNoView;
		private var _controlPage:FriendsControlPage;//分页控件
		private var _targetLayer:int=1;//目标层
		//-----------------------事件--------------------------------
		private var _canRefresh:Boolean = true;
		private var opentX:Number=0;
		private var closeX:Number=-50;
		
		public function TowerScene()
		{
			
			rubishPosArr = [[360, 300], [411, 198], [646, 261]];
			sceneId = MainScene.TOWER_SCENE;
			setSpriteInstance("towerSceneUI");
			configinstance();
			
			_towerStateModel = TowerStateModle.getInstance();
			dataModel = _towerStateModel;
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			return;
		} // end function
		
		private function timerHandler(e:TimerEvent):void
		{
			if (_purceTimer == 0)
			{
				_timer.stop();
				//时间到后挑战下一层
				if (getDefenceData()) {
					var tempArr:Array = getDefenceArrByType();
					if (tempArr) {
						SMZTController.getInstance().TowerChallenge(JSON.encode(tempArr), function battleOver(param:Object):void {
							//战斗结束后刷新界面
							SMZTController.getInstance().getTowerStateData(function (param:Object):void {
								TowerStateModle.getInstance().setData(param);
								});//刷新宿命之塔
							})
						}
					tempArr = null;
					}else {
						//提示设置防线
						AlertConfirmPane.getInstance().type = 0;
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TowerScene.DefenceTip.@Text);
						resetTimer();
						}
			}
			else
			{
				_purceTimer--;
			}
			_timerText.text = _purceTimer+"秒";
		}
		
		/**
		 * 根据当前的敌人战斗模式（ＸＶＸ）返回相应的防御卡组
		 * @return
		 */
		private function getDefenceArrByType():Array {
			
			switch(_towerStateModel.lv.mode) {
				case 1:
					return returnDeckCardId(DefenceModel.getInstance().v1);
					break;
				case 2:
					return returnDeckCardId(DefenceModel.getInstance().v2);
					break;
				case 3:
					return returnDeckCardId(DefenceModel.getInstance().v3);
					break;
				case 4:
					return returnDeckCardId(DefenceModel.getInstance().v4);
					break;
				}
				return null;
			}
		/**
		 * 返回卡组中卡的ＩＤ数组
		 * @return
		 */
		private function returnDeckCardId(value:Array):Array {
			var temp:Array = new Array();
			for (var i:String in value) {
				temp.push((value[i] as DeckModel).id)
				}
			return temp;
			}
	 
		/**
		 * 获取卡组设置中是否四个类型都设置了防线
		 */
		private function getDefenceData():Boolean {
			var flag:Boolean = false;
			if (DefenceModel.getInstance().v1 == null || DefenceModel.getInstance().v2 == null || DefenceModel.getInstance().v3 == null || DefenceModel.getInstance().v4 == null) {
				SMZTController.getInstance().getDefenceData(function():void
					{
						//不会执行到这步否则就表示出错
						Debug.log("不会执行到这步否则就表示出错");
					})
				}else {
					if (DefenceModel.getInstance().v1.length != 1 || DefenceModel.getInstance().v2.length != 2 || DefenceModel.getInstance().v3.length != 3 || DefenceModel.getInstance().v4.length != 4) {
							flag= false;
							}else {
								flag= true;
								}
					}
				return flag;
			}
		 
		private function configinstance():void
		{
			_cardGrid = new BaseGridContainer(1, 4,27.5,ApplicationConfig.SMALL_CARD_WH,ApplicationConfig.SMALL_CARD_WH);
			addChild(_cardGrid);
			_cardGrid.setLocation(376.1,360.05);
			
			_cards = new Vector.<Card>();
			for (var i:int = 0; i < 4; i++)
			{
				var temp:Card = new Card();
				temp._currentCardTye = 2;
				temp.showTip = true;
				_cardGrid.appendChild(temp);
				_cards.push(temp);
				temp = null;
			}
			
			_passArr = new Array();
			for (var j:int = 0; j < 10; j++)
			{
				var tempTeleportButton:TeleportButton = this.getChild("pass" + j) as TeleportButton;
				tempTeleportButton.id = j;
				tempTeleportButton.telePortFun = UsetelePort;
				tempTeleportButton.onClick = passBtClick;
				_passArr.push(tempTeleportButton);
			}
			
			_cancelArea = getChild("cancelArea") as MovieClip;
			_currentPros = getChild("currentPros") as Sprite;
			_currentPros.x = _initX;
			_maxPros = getChild("maxPros") as Sprite;
			_maxPros.x = _initX;
			_vipText = getChild("vipText") as TextField;
			_currentLayeText = getChild("currentLayeText") as TextField;
			_itemText = getChild("itemText") as TextField;
			_expText = getChild("expText") as TextField;
			_glodText = getChild("glodText") as TextField;
			_honorText = getChild("honorText") as TextField;
			_expText.autoSize = TextFieldAutoSize.LEFT;
			_glodText.autoSize = TextFieldAutoSize.LEFT;
			_honorText.autoSize = TextFieldAutoSize.LEFT;
			
			_timerText = getChild("timerText") as TextField;
			_reportLayeText = getChild("reportLayeText") as TextField;
			_freeEnterText = getChild("freeEnterText") as TextField;
			_addNumText = getChild("addNumText") as TextField;
			_sweepBt = getChild("sweepBt") as MovieClipButton;
			_sweepBt.visible = false;
			_showBonus = getChild("showBonus") as MovieClipButton;
			
			_startBattleBt = getChild("startBattleBt") as MovieClipButton;
			_autoBattleBt = getChild("autoBattleBt") as MovieClipButton;
			//_againBattleBt = getChild("againBattleBt") as MovieClipButton;
			_autoBattleBt.clickEnable = false;
			//_againBattleBt.clickEnable = false;
			_cancleAutoBattleBt = getChild("cancleAutoBattleBt") as MovieClipButton;
			_cancleAutoBattleBt.visible = false;
			
			_enterTip = getChild("enterTip") as MovieClip;
			_enterTip.visible = true;
			//_prevBt = getChild("prevBt") as MovieClipButton;
			//_nextBt = getChild("nextBt") as MovieClipButton;
			
			_exitBt = getChild("exitBt") as MovieClipButton;
			
			_resultType = getChild("resultType") as MovieClip;
			_resultType.gotoAndStop(1);
			
			_sweepBt.onClick = clickHandler;
			_startBattleBt.onClick = clickHandler;
			_autoBattleBt.onClick = clickHandler;
			_cancleAutoBattleBt.onClick = clickHandler;
			_exitBt.onClick = clickHandler;
			_showBonus.onClick = clickHandler;
			
			_itemImage = new BaseIcoCellLoader();
			_itemImage.toolTipEnabled = false;
			_itemImage.setLocation(488.65, 521.3);
			_itemImage.restrictHW = 42.5;
			addChild(_itemImage);
			_itemImage.showBg = false;
			
			//_controlPage = new ControlPageNoView(_nextBt, _prevBt);
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(565.15, 323.55);
			addChild(_controlPage);
			_controlPage.updatLoc = updatLoc;
			
			
			_cancelArea.visible = false;
			_cancelArea.gotoAndStop(1);
			
			_bossBonusPopWin = getChild("bossBonusPopWin") as Sprite;
			_bossBonusPopWin.visible = false;
			_bossBonusPopWin["closeBt"].buttonMode = true;
			_bossBonusPopWin["closeBt"].addEventListener(MouseEvent.CLICK, closePopWin);
			addChild(_bossBonusPopWin);
		}
		
		/**
		 * 关闭弹出的奖励窗口
		 * @param	e
		 */
		private function closePopWin(e:MouseEvent):void 
		{
			//_bossBonusPopWin.visible = false;
			
			TweenLite.to(_bossBonusPopWin, 0.3, { alpha:0, onComplete:function():void {
				_bossBonusPopWin.visible = false;
			}});
		}
		
		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			
			_controlPage.setLocation(565.15+(178.95 - _controlPage.width)/2, 323.55);
		}
		
		/**
		 * 使用传送进入指定层
		 */
		private function UsetelePort(value:int):void 
		{
			SMZTController.getInstance().TowerTelePort(value * 10 + 1, function ():void {
				SMZTController.getInstance().getTowerStateData(function (param:Object):void {
					TowerStateModle.getInstance().setData(param);
					
					});//刷新宿命之塔
				} );
		}
		
		/**
		 * 关卡按钮点击
		 * @param	e
		 */
		private function passBtClick(e:MouseEvent):void
		{
			if (_currentSlectedBt != e.currentTarget) {
				//-------------------新手引导用-----------------------
				//如果点的是第一个大层选项
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.TOWER]) {
					NewBieControler.getInstance().nextStep();
					}
				//--------------------end--------------------
			//获取所点中的关卡信息并显示相应的敌人
			var cl:int = (e.currentTarget as TeleportButton).id * 10 + 1;
			SMZTController.getInstance().TowerPassInfo(cl, function (param:Object):void {
				showCurrentLayerBonus(cl);
				
				var temp:TowerLevel = new TowerLevel();
				temp.setData(param);
				_currentPros.x = _initX + (_maxX - _initX) / 100 * (temp.id);
				_currentLayeText.text = temp.id.toString();
				resetTimer();
				//_controlPage.initData(temp.cards, 4);
				_currentAnemyArr = temp.cards;
				if(_currentAnemyArr){
					_controlPage.starCompute(4, (_currentAnemyArr.length > 0)?Math.ceil(_currentAnemyArr.length / 4):1, updataUI);
					}
				})
			
				moveCurrenntSelectedBt(e.currentTarget as TeleportButton);
				}
			
		}
		
		
		
		private function moveCurrenntSelectedBt(param:TeleportButton):void 
		{
			if (_oldSlectedBt == null ) {
				_oldSlectedBt = param;
				}else {
					if(_currentSlectedBt!=null){
						_oldSlectedBt = _currentSlectedBt;
						if (_currentSlectedBt == param) return;
						TweenLite.killTweensOf(_oldSlectedBt);
						TweenLite.to(_oldSlectedBt, .5, { x:closeX, ease:Cubic.easeOut } );
						_oldSlectedBt.showEnterBt(false);
						
							//_enterTip.visible = true;
							
						}
					}
			_currentSlectedBt = param;
			_enterTip.visible = false;
			TweenLite.to(_currentSlectedBt, .5, { x:opentX, ease:Cubic.easeOut, onComplete:function completeHandler():void {
				_currentSlectedBt.showEnterBt(true);
					
				}});
			
		}
		
		private function resetTimer():void
		{
			if (_timer.running)
			{
				_timer.stop();
			}
			_autoBattleFlag = false;
			_timerText.text = "∞";
			_purceTimer = maxAutoTime;
			_cancleAutoBattleBt.visible = false;
			_autoBattleBt.visible = true;
			_cancelArea.visible = false;
			_cancelArea.gotoAndStop(1);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case _showBonus: 
					//显示各ＢＯＳＳ层可能的奖励
					if (_bossBonusPopWin.visible) return;
					_bossBonusPopWin.visible = true;
					_bossBonusPopWin.alpha = 1;
					DepthManager.bringToTop(_bossBonusPopWin);
					TweenLite.from(_bossBonusPopWin, 0.3, {alpha:0, y:this.y - 20});
					break;
				
				case _sweepBt: 
					//扫荡
					
					break;
				case _exitBt: 
					//退出
					var exitFun:Function = function(okOrCancel:String):void {
						if (okOrCancel==AlertSelectPane.ALERT_YES) {
							//发送退出塔请求
							SMZTController.getInstance().TowerQuit(function returnMainScene():void {
								//返回到主场景
								SMZTUIManager.getInstance().mainPane.returnMainScene();
								});
							}
						}
					AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TowerScene.ExitTip.@Text,exitFun,true);
					break;
				case _cancleAutoBattleBt: 
					//取消自动战斗
					
					autoBattleFlag = false;
					resetTimer();
					_cancleAutoBattleBt.visible = false;
					_autoBattleBt.visible = true;
					
					AutoBattleTargetPanel.getInstance().hide();
					break;
				case _startBattleBt: 
					autoBattleFlag = false;
					resetTimer();
					BattleReadyPanel.getInstance().show(true);
					BattleReadyPanel.getInstance().initUIByBattleModel(_towerStateModel.lv.mode, BattleReadyPanel.TOWER_TYPE);
					
					//-------------------新手引导用-----------------------
					//如果点的是第一个大层选项
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.TOWER]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
					
					break;
				case _autoBattleBt:
					AutoBattleTargetPanel.getInstance().callBack = function(param:int):void {
						_targetLayer = param;
						if (!getDefenceData()) {
								//提示设置防线
								AlertConfirmPane.getInstance().type = 0;
								AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TowerScene.DefenceTip.@Text);
								return;
								}
							autoBattleFlag = true;
							_cancleAutoBattleBt.visible = true;
							_autoBattleBt.visible = false;
							_purceTimer = maxAutoTime;
							if (!_timer.running)
							{
								_timer.start();
							}
						}
						
					AutoBattleTargetPanel.getInstance().show();
					break;
			
			}
		}
		
		/**
		 * 帮助点击
		 * @param	event
		 */
		override public function showHelp(event:MouseEvent = null):void
		{
		/*HelpPane.getInstance().playInstance("NEWBIE_SHOW_OFFICE_HELP");
		   if (HelpPane.getInstance().isOpened)
		   {
		   helpBtn.gotoAndPlay(2);
		   }
		   else
		   {
		   helpBtn.gotoAndStop(1);
		   }
		   this.newbieOnly();
		 return;*/
		} // end function
		
		public function newbieOnly():void
		{
			/*if (this.officerContainer.selectedOfficerBox && this.officerContainer.selectedOfficerBox.item)
			   {
			   OfficerDisplayer.getInstance().show();
			   OfficerDisplayer.getInstance().setData(this.officerContainer.selectedOfficerBox.item);
			   }
			   else
			   {
			   this.officerContainer.setDefaultDisplay();
			 }*/
			return;
		} // end function
		
		override protected function onRemoveFromStage(event:Event):void
		{
			clearRubish();
			
			return;
		} // end function
		
		/**
		 * 显示当前层可能掉落的奖励
		 * @param	event
		 */
		private function showCurrentLayerBonus(layerid:int):void {
			var temp:XML;
			for each(temp in ItemConfig.TOWER_CONFIG.children()) {
				if (temp.@ID == layerid) {
					var tempObj:Object = new Object();
					tempObj.item=int(temp.Bonus.Items.Item.@ID)
					var tempItem:ItemModel = new ItemModel(tempObj);
					_itemText.text = tempItem.name;
					tempObj = null;
					temp = null;
					tempItem= null;
					return;
					}
				}
			_itemText.text = "";
			}
		
		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			if (PlayerData.getInstance().vipLevel > 0) {
				_vipText.htmlText = "[ <font color='#ff9900'>VIP" + PlayerData.getInstance().vipLevel + ":</font>" + (maxAutoTime-30) + "秒 ]";
				}else {
					_vipText.htmlText = "<font color='#ff9900'>VIP等级越高自动战斗时间越少</font>";
					}
			
			
			//增加屏敝对象到顶层
			if(!SMZTUIManager.getInstance().mainPane._uiLayer.contains(_cancelArea))
			SMZTUIManager.getInstance().mainPane._uiLayer.addChild(_cancelArea);
			
			if(!_autoBattleFlag){
				resetTimer();
				}else {
					//如果自动战斗时，要判断是否已经到达之前设置的层数
					if (_towerStateModel.lv.id <= _targetLayer) {
						_purceTimer = maxAutoTime;
						_timer.start();
						}else {
							autoBattleFlag = false;
							resetTimer();
							}
					}
			//-----------------显示当前层可能掉落的物品---------------------------------------
			showCurrentLayerBonus(_towerStateModel.lv.id);
			
			//-------------------------当前层为０，且战报的层为１００时表示通关,-------------------------------
			//if (_towerStateModel.lv.id != 0 && _towerStateModel.report && _towerStateModel.report.lv!=100)
			//{
				//通关后当前的进度标尺为最初位置,即只有在没通关时标尺才会设置位置
				_currentPros.x = _initX + (_maxX - _initX) / 100 * (_towerStateModel.lv.id);
			//}
			
			_maxPros.x = _initX + (_maxX - _initX) / 100 * (_towerStateModel.hi_lv);
			_currentLayeText.text = _towerStateModel.lv.id.toString();
			//--------------------------------------------------------
			_freeEnterText.text = _towerStateModel.free.toString() + "/" + TowerStateModle.MAX_FREE_ENTER;
			_addNumText.text = _towerStateModel.pay.toString() + "/" + TowerStateModle.MAX_ITEM_ENTER;
			//允许挑战两次并且已经进入塔内
			if (_towerStateModel.lose <2 && _towerStateModel.lv.id !=0)
			{
				_startBattleBt.visible = true;
				_startBattleBt.clickEnable = true;
				_autoBattleBt.clickEnable = true;
				_exitBt.clickEnable = true;
			}
			else if (_towerStateModel.lose >= 2 && _towerStateModel.lv.id != 0) {
				//失败次数大于２且在塔内，则自动退出塔
				_startBattleBt.visible = true;
				_startBattleBt.clickEnable = false;
				_autoBattleBt.clickEnable = false;
				_exitBt.clickEnable = true;
				}else
				{
					//塔外
					_startBattleBt.visible = true;
					_startBattleBt.clickEnable = false;
					_autoBattleBt.clickEnable = false;
					_exitBt.clickEnable = false;
				}
			//-----------根据失败数显示相应的提示框---------------------------------------------
			if (_towerStateModel.lose == 1 && _towerStateModel.report && _towerStateModel.report.result.result == ResultReport.Fail) {
				resetTimer();
				AlertConfirmPane.getInstance().type = 0;
				AlertConfirmPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.TowerScene.LoseOneTip.@Text).replace("{layerId}",_towerStateModel.report.lv.toString()));
				}else if (_towerStateModel.lose == 2 && _towerStateModel.report && _towerStateModel.report.result.result == ResultReport.Fail) {
					//退出后失败次数清零
					AlertMasterPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TowerScene.FailTip.@Text, function okClickHandler():void {
						//发送退出塔请求
						SMZTController.getInstance().TowerQuit(function returnMainScene():void {
							//返回到主场景
							AlertMasterPane.getInstance().hide();//关闭窗口
							SMZTUIManager.getInstance().mainPane.returnMainScene();
							});
						});
					}
			
			//--------------------------------------------------------		
			if (_towerStateModel.report)
			{
				if (_towerStateModel.report.bonus.items && _towerStateModel.report.bonus.items.length>0)
				{
					var tempItemModel:ItemModel = new ItemModel({"item": _towerStateModel.report.bonus.items[0].id});
					_itemImage.imgMode = -1; //图片ＵＲＬ为ＩＣＯ
					_itemImage.item = tempItemModel;
					_itemImage.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
					//更新背包数据
					SMZTController.getInstance().getBagData(false);
				}else {
					_itemImage.clearImgIco();
					}
				_expText.text = _towerStateModel.report.bonus.exp.toString();
				_glodText.text = _towerStateModel.report.bonus.gold.toString();
				_honorText.text = _towerStateModel.report.bonus.honor.toString();
				SMZTUIManager.getInstance().mainPane.refreshSelfData();//更新个人信息
				
				_resultType.visible = true;
				_resultType.gotoAndStop(_towerStateModel.report.result.result + 3);//第一帧为空
				_reportLayeText.text = _towerStateModel.report.lv.toString();
				
				//如果失败则停止自动战斗
				if (_towerStateModel.report.result.result == ResultReport.Fail) {
					if (_autoBattleFlag) {
						autoBattleFlag = false;
						resetTimer();
						AutoBattleTargetPanel.getInstance().hide();
						}
					}
			}
			else
			{
				//没有战报
				_itemImage.clearImgIco();
				_expText.text = "";
				_glodText.text = "";
				_honorText.text = "";
				_resultType.visible = false;
				_reportLayeText.text = "";
			}
			//-------------------显示敌人卡牌-------------------------------------
			//_controlPage.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, updataCards);
			//_controlPage.initData(_towerStateModel.lv.cards, 4);
			_currentAnemyArr = _towerStateModel.lv.cards;
			if(_currentAnemyArr){
				_controlPage.starCompute(4, (_currentAnemyArr.length > 0)?Math.ceil(_currentAnemyArr.length / 4):1, updataUI);
				}else {
					updatLoc();//更新分布样式
					}
			//--------------------------------------------------------
			if (_towerStateModel.lv.id == 0){// && _towerStateModel.report && _towerStateModel.report.lv!=100) {
				//０表示在塔外,传送入口可以点击
				telePortActive();
				//如果之前有点出的入口则合上
				if (_currentSlectedBt!=null) {
					TweenLite.killTweensOf(_currentSlectedBt);
					_currentSlectedBt.showEnterBt(false);
					_enterTip.visible = true;
					TweenLite.to(_currentSlectedBt, .5, { x:closeX, ease:Cubic.easeOut, onComplete:function completeHandler():void {
						
						//_currentSlectedBt = null;
						} } );
					_currentSlectedBt = null;
					}
				if (_oldSlectedBt != null) {
					_enterTip.visible = true;
					TweenLite.killTweensOf(_oldSlectedBt);
					TweenLite.to(_oldSlectedBt, .5, { x:closeX, ease:Cubic.easeOut, onComplete:function completeHandler():void {
						_oldSlectedBt = null;
						
						} } );
					_oldSlectedBt.showEnterBt(false);
					}
				}else {
					telePortActive(false);
					}
			//----------------100层通关时弹出提示点确定后退出到主场景----------------------------------------
			if (_towerStateModel.lv.id == 0 && _towerStateModel.report &&  _towerStateModel.report.lv ==100)
			{
				resetTimer();
				AlertMasterPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TowerScene.WinTip.@Text, function okClickHandler():void {
					//发送退出塔请求
					SMZTController.getInstance().TowerQuit(function returnMainScene():void {
						AlertMasterPane.getInstance().hide();//关闭窗口
						//SMZTUIManager.getInstance().mainPane.returnMainScene();
						});
					});
			}
			
			//--------------------------------------------------------
		} // end function
		
		/**
		 * 左边传送入口是否响应鼠标
		 * @param	value　是否可以点击
		 */
		private function telePortActive(value:Boolean = true):void
		{
			_currentBigLayer = Math.ceil((_towerStateModel.lv.id) / 10);
			var maxBigLayer:int = Math.ceil(((_towerStateModel.hi_lv+1>100)?100:_towerStateModel.hi_lv) / 10);
			for (var i:int = 0; i < _passArr.length; i++)
			{
				if (value)
				{
					if (i < maxBigLayer)
					{
						//(_passArr[i] as MovieClipButton).active = true;
						(_passArr[i] as TeleportButton).clickEnable = true;
						//(_passArr[i] as MovieClipButton).setSelected(false);
					}
					else
					{
						//(_passArr[i] as MovieClipButton).active = false;
						(_passArr[i] as TeleportButton).clickEnable = false;
						//(_passArr[i] as MovieClipButton).setSelected(false);
					}
				}
				else
				{
					(_passArr[i] as TeleportButton).clickEnable = false;
					//(_passArr[i] as MovieClipButton).setSelected(false);
				}
			}
			//没开始战斗设第一个大类可以点
			if (_towerStateModel.lv.id <= 10 && value) {
				_passArr[0].clickEnable = true;
				return;
				}
			//新手时刚进入不响应下面的展开入口功能
			if (_towerStateModel.lv.id == 0) {
				return;
				}
			moveCurrenntSelectedBt(_passArr[(_currentBigLayer>0)?_currentBigLayer-1:0]);//拉出当前层
		}
		
		/**
		 * 更新当当敌人卡牌
		 * @param	e
		 */
		private function updataCards(e:SMZTDataChangeEvent):void
		{
			var temp:Array = e.dataObject as Array;
			for (var i:int = 0; i < _cards.length; i++)
			{
				if (temp && temp[i] != null)
				{
					_cards[i].setCardModel(new CardModel(temp[i]));
					_cards[i].visible = true;
				}
				else
				{
					_cards[i].visible = false;
				}
			}
			temp = null;
		}
		
		private function updataUI():void 
		{
			if (_currentAnemyArr == null) return;
			_currentPage = _controlPage.currentPageNum;
		
			for (var i:int; i < _cards.length; i++) {
				var tempIndex:int = ((_currentPage-1) * 4 + i);
				if ( tempIndex< _currentAnemyArr.length) {
					if (_currentAnemyArr[tempIndex]) {
						_cards[i].setCardModel(new CardModel(_currentAnemyArr[tempIndex]));
						_cards[i].visible = true;
						}else {
							_cards[i].visible = false;
							}
					}else {
						_cards[i].visible = false;
						}
				}
		}
		
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			_itemImage.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point = new Point(_itemImage.x - 100, _itemImage.y -125);
			//trace(temp);
			//trace(_bagGridContainer.localToGlobal(temp).y)
			SMZTUIManager.getInstance().bagPopPanel.setData(_itemImage.item, this.localToGlobal(temp));
			SMZTUIManager.getInstance().bagPopPanel.show(false);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
			SMZTUIManager.getInstance().bagPopPanel.hide();
		}
		
		public function get canRefresh():Boolean
		{
			return this._canRefresh;
		} // end function
		
		public function set canRefresh(param1:Boolean):void
		{
			this._canRefresh = param1;
			return;
		} // end function
		
		public function get autoBattleFlag():Boolean 
		{
			return _autoBattleFlag;
		}
		
		public function set autoBattleFlag(value:Boolean):void 
		{
			_autoBattleFlag = value;
			_cancelArea.visible = value;
			_cancelArea.gotoAndPlay(1);
		}
	
	}
}
