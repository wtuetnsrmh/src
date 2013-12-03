package project.view.module.event.eventTower 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.ApplicationController;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.event.eventTower.EventTowerModel;
	import project.model.item.CardModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.common.FriendsControlPage;
	import project.view.layout.BaseGridContainer;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.cell.Card;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * 泰坦活动界面
	 * @author bbjxl 2013
	 */
	public class EventTowerPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _cardGrid:BaseGridContainer;
		private var _controlPage:FriendsControlPage;//分页控件
		//-----------------------UI---------------------------------
		private var _bonusText:TextField;
		private var _ticketText:TextField;
		private var _surplusText:TextField;
		private var _challengBt:MovieClipButton;
		//private var _ruleBt:MovieClipButton;
		private var _goodsBt:MovieClipButton;
		//-----------------------数据---------------------------------
		private var _currentPage:int=1;//当前页
		private var _cards:Vector.<Card>;
		private var _reviveFlag:int = 0;//是否是复活挑战
		private var _pass:Vector.<PassState>;
		private var _eventTowerModel:EventTowerModel;
		public static var firstLoad:Boolean = true;//是否是第一次加载
		//-----------------------事件--------------------------------
		public function EventTowerPanel() 
		{
			setSpriteInstance("eventTowerPanelUI");
			
			_eventTowerModel = EventTowerModel.getInstance();
			dataModel = _eventTowerModel;
			
			this.rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
			configinstance();
		}
		
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
					this.modal.alpha = 0;
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2+10;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 70});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
            }
            this.playShowSound();
            return;
        }// end function
		
		private function configinstance():void 
		{
			_bonusText = getChild("bonusText") as TextField;
			_ticketText = getChild("ticketText") as TextField;
			_surplusText = getChild("surplusText") as TextField;
			_surplusText.mouseEnabled = false;
			_challengBt = getChild("challengBt") as MovieClipButton;
			_challengBt.onClick = onClickHandler;
			//_ruleBt = getChild("ruleBt") as MovieClipButton;
			_goodsBt = getChild("goodsBt") as MovieClipButton;
			//_ruleBt.onClick = onClickHandler;
			_goodsBt.onClick = onClickHandler;
			_pass = new Vector.<PassState>();
			for (var i:int = 0; i < 10; i++ ) {
				var temp:PassState = new PassState(getChild("pass" + i));
				temp.id = i;
				_pass.push(temp);
				temp = null;
				}
				
			_cardGrid = new BaseGridContainer(1, 4,23,ApplicationConfig.SMALL_CARD_WH,ApplicationConfig.SMALL_CARD_WH);
			addChild(_cardGrid);
			_cardGrid.setLocation(130.55,465.45);
			
			_cards = new Vector.<Card>();
			for (var i:int = 0; i < 4; i++)
			{
				var tempCard:Card = new Card();
				tempCard._currentCardTye = 2;
				tempCard.showTip = true;
				_cardGrid.appendChild(tempCard);
				_cards.push(tempCard);
				tempCard = null;
			}
			
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(240.8,432);
			addChild(_controlPage);
			_controlPage.updatLoc = updatLoc;
		}
		
		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			
			_controlPage.setLocation(240.8,432);
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _challengBt:
					if (_eventTowerModel.revive!=null) {
						//复活点不为0,表示之前失败,要判断是否用水晶复活
						var reviveFun:Function = function(okOrCancel:String):void {
							if (okOrCancel==AlertSelectPane.ALERT_YES) {
								//判断水晶是否足够
								if (PlayerData.getInstance().crystal < _eventTowerModel.reviveCost) {
									AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.EventTowerPane.noenoughCrystalTip.@Text, function(oc:String):void {
										if (oc == AlertSelectPane.ALERT_YES) {
											//前往购买
											Browser.buyItem(SpecialItemIdConfig.CRYSTAL_PACKAGE_ITEM);
											}else {
												//如果选择不复活,则设置当前所处关为1
												_eventTowerModel.revive = null;
												selectedPassByid(_eventTowerModel.level.id - 1);
												}
										},true);
									}else {
										//用水晶复活
										_reviveFlag = 1;
										BattleReadyPanel.getInstance().show(true);
										BattleReadyPanel.getInstance().initUIByBattleModel(_eventTowerModel.revive.mode, BattleReadyPanel.EVENT_TOWER, true);
										}
								}else {
									//如果选择不复活,则设置当前所处关为1
									_eventTowerModel.revive = null;
									selectedPassByid(_eventTowerModel.level.id - 1);
									}
							}
						AlertSelectPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.EventTowerPane.reviveTip.@Text).replace("{passId}",_eventTowerModel.revive.id).replace("{crystal}",_eventTowerModel.reviveCost.toString()),reviveFun,true);
					}else {
						if (_eventTowerModel.surplus < 1) {
						//提示是否用水晶强制挑战
						var sendDeleteDeck:Function = function(okOrCancel:String):void {
							if (okOrCancel==AlertSelectPane.ALERT_YES) {
								//判断水晶是否足够
								if (PlayerData.getInstance().crystal < _eventTowerModel.forceCost) {
									AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.EventTowerPane.noenoughCrystalTip.@Text, function(oc:String):void {
										if (oc == AlertSelectPane.ALERT_YES) {
											//前往购买
											Browser.buyItem(SpecialItemIdConfig.CRYSTAL_PACKAGE_ITEM);
											}else {
												AlertSelectPane.getInstance().hide();
												}
										},true);
									}else {
										//水晶足够时发送强制挑战
										_reviveFlag =0;
										BattleReadyPanel.getInstance().show(true);
										BattleReadyPanel.getInstance().initUIByBattleModel(_eventTowerModel.level.mode, BattleReadyPanel.EVENT_TOWER, true);
										}
								}else {
									AlertSelectPane.getInstance().hide();
									}
							}
						AlertSelectPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.EventTowerPane.userCrystalTip.@Text).replace("{crystal}",_eventTowerModel.forceCost.toString()),sendDeleteDeck,true);
						}else {
							//挑战
							_reviveFlag = 0;
							BattleReadyPanel.getInstance().show(true);
							BattleReadyPanel.getInstance().initUIByBattleModel(_eventTowerModel.level.mode, BattleReadyPanel.EVENT_TOWER, true);
							}
						}
					break;
				//case _ruleBt:
					//break;
				case _goodsBt:
					EventShopPanel.getInstance().show(true);
					EventShopPanel.getInstance().updata();
					break;
				}
		}
		
		/**
		 * 指定关为选中
		 * @param	event
		 */
		private function selectedPassByid(id:int):void {
			resetTotalPass(id);
			_pass[id].setState(2);
			}
			
		/**
		 * 重置所有关
		 * @param	event
		 */
		private function resetTotalPass(id:int):void {
			for (var i:String in _pass) {
				if (int(i) < id) {
					_pass[i].setState(3);//通过的关设为已击破
					}else {
						_pass[i].setState(1);
						}
				
				}
			}
		
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			_bonusText.text = _eventTowerModel.level.exchangeItemNum().toString();
			_ticketText.text = _eventTowerModel.ticket.toString();
			_surplusText.text = _eventTowerModel.surplus.toString();
			
			if(_eventTowerModel.level.cards){
				_controlPage.starCompute(4, (_eventTowerModel.level.cards.length > 0)?Math.ceil(_eventTowerModel.level.cards.length / 4):1, updataUI);
				}
			
			if (_eventTowerModel.revive == null) {
				//如果没有复活点,则设置当前所处关为1
				selectedPassByid(_eventTowerModel.level.id - 1);
				}else {
					//如果有复活点则设置当前处于复活点所在的关
					selectedPassByid(_eventTowerModel.level.id-1);
					//提示是否用水晶复活
					var reviveFun:Function = function(okOrCancel:String):void {
						if (okOrCancel==AlertSelectPane.ALERT_YES) {
							//判断水晶是否足够
							if (PlayerData.getInstance().crystal < _eventTowerModel.reviveCost) {
								AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.EventTowerPane.noenoughCrystalTip.@Text, function(oc:String):void {
									if (oc == AlertSelectPane.ALERT_YES) {
										//前往购买
										Browser.buyItem(SpecialItemIdConfig.CRYSTAL_PACKAGE_ITEM);
										}else {
											//如果选择不复活,则设置当前所处关为1
											_eventTowerModel.revive = null;
											selectedPassByid(_eventTowerModel.level.id - 1);
											}
									},true);
								}else {
									//用水晶复活
									SMZTController.getInstance().useCrystalRevive(function():void {
										SMZTUIManager.getInstance().mainPane.refreshCurrentScene();//刷新当前场景
										});
									/*_reviveFlag = 1;
									BattleReadyPanel.getInstance().show(true);
									BattleReadyPanel.getInstance().initUIByBattleModel(_eventTowerModel.revive.mode, BattleReadyPanel.EVENT_TOWER, true);*/
									}
							}else {
								//如果选择不复活,则设置当前所处关为1
								_eventTowerModel.revive = null;
								selectedPassByid(_eventTowerModel.level.id - 1);
								}
						}
					AlertSelectPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.EventTowerPane.reviveTip.@Text).replace("{passId}",_eventTowerModel.revive.id).replace("{crystal}",_eventTowerModel.reviveCost.toString()),reviveFun,true);
					}
            return;
        }// end function
		
		private function updataUI():void 
		{
			if (_eventTowerModel.level.cards == null) {
				for (var j:int; j < _cards.length; j++) {
					_cards[i].visible = false;
					}
				return;
				}
			_currentPage = _controlPage.currentPageNum;
		
			for (var i:int; i < _cards.length; i++) {
				var tempIndex:int = ((_currentPage-1) * 4 + i);
				if ( tempIndex< _eventTowerModel.level.cards.length) {
					if (_eventTowerModel.level.cards[tempIndex]) {
						_cards[i].setCardModel(new CardModel(_eventTowerModel.level.cards[tempIndex]));
						_cards[i].visible = true;
						}else {
							_cards[i].visible = false;
							}
					}else {
						_cards[i].visible = false;
						}
				}
		}
		
		public function get reviveFlag():int 
		{
			return _reviveFlag;
		}
		
		public function set reviveFlag(value:int):void 
		{
			_reviveFlag = value;
		}
		
	}

}