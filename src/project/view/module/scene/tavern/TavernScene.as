package project.view.module.scene.tavern
{
	/**
	 *描述：酒馆
	 *
	 */
	import com.bbjxl.utils.Tools;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.item.CardModel;
	import project.model.item.ItemModel;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.model.shop.ShopModel;
	import project.model.tavern.TavernModel;
	import project.model.tavern.TavernSlot;
	import project.utils.CustomTool;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.component.comboBox.AchivComboBox;
	import project.view.layout.BaseGridContainer;
	import project.view.MainPane;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.cell.Card;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	import project.view.module.shop.PurchasePanel;
	import project.view.ui.SpecialScroll;
	import project.view.module.helppane.NewbiePane;
	
	public class TavernScene extends BaseGameScene
	{
		
		//----------------------容器---------------------------------
		private var _gidContent:BaseGridContainer; //四张卡
		private var _cardsContainer:Sprite;//四张卡容器
		//-----------------------UI---------------------------------
		private var _timeText:TextField; //剩余刷新时间
		private var _RecruitItemBt:MovieClipButton; //招募令按钮
		private var _refreshBt:MovieClipButton; //刷新按钮
		private var _RecruitBt1:MovieClipButton; //第1栏招募按钮
		private var _RecruitBt2:MovieClipButton; //第2栏招募按钮
		private var _RecruitBt3:MovieClipButton; //第3栏招募按钮
		private var _RecruitBt4:MovieClipButton; //第4栏招募按钮
		private var _unlock0:MovieClipButton; //1解锁按钮
		private var _unlock1:MovieClipButton; //10解锁按钮
		private var _unlock2:MovieClipButton; //25解锁按钮
		private var _unlock3:MovieClipButton; //40解锁按钮
		private var _lock0:Sprite;//10加锁层
		private var _lock1:Sprite;//10加锁层
		private var _lock2:Sprite;//25加锁层
		private var _lock3:Sprite;//40加锁层
		private var _recruited1:Sprite;//10已招募
		private var _recruited2:Sprite;//10已招募
		private var _recruited3:Sprite;//10已招募
		private var _recruited4:Sprite;//10已招募
		private var _priceText1:TextField;//价格
		private var _priceText2:TextField;//价格
		private var _priceText3:TextField;//价格
		private var _priceText4:TextField;//价格
		//-----------------------数据---------------------------------
		private var levelUnlock:Array = [1,20,40,60];//根据等级设置哪些解锁按钮可点
		private var _cards:Vector.<Card>;
		private var _tavernModel:TavernModel;
		private var _rectimer:Timer=new Timer(1000);
		private var _secondNext:int;//下次刷新时间
		private var _firstShow:Boolean = true;//是否是第一次显示
		//-----------------------事件--------------------------------
		public function TavernScene()
		{
			rubishPosArr = [[360, 300], [411, 198], [646, 261]];
			sceneId = MainScene.TAVERN_SCENE;
			setSpriteInstance("tavenScene");
			configerUIInstance();
			
			_tavernModel = TavernModel.getInstance();
			dataModel = _tavernModel;
			PlayerData.getInstance().addEventListener(SMZTDataChangeEvent.ON_LEVELUP_EVENT, onPlayerLevelUP);
			_rectimer.addEventListener(TimerEvent.TIMER, timerHandler);
			return;
		} // end function
		/**
		 * 控制时间
		 * @param	e
		 */
		public function setTimer(value:Boolean = false):void {
			if (value) {
				_rectimer.start();
				}else {
					_rectimer.stop();
					}
			
			}
		//每秒倒计时
		private function timerHandler(e:TimerEvent):void 
		{
			if (_secondNext == 0) {
				_rectimer.stop();
				//refreshBtOnClickHandler();
				_refreshBt.clickEnable = true;
				}else {
					_secondNext--;
					}
			_timeText.text = Tools.formatTime(_secondNext);
		}
		
		private function configerUIInstance():void
		{
			
			_cardsContainer = getChild("cardsContainer") as Sprite;
			_priceText1 = getChild("priceText1") as TextField;
			_priceText3 = getChild("priceText3") as TextField;
			_priceText4 = getChild("priceText4") as TextField;
			_priceText2 = getChild("priceText2") as TextField;
			_timeText = getChild("timeText") as TextField;
			_timeText.autoSize = TextFieldAutoSize.LEFT;
			
			_RecruitItemBt = getChild("RecruitItemBt") as MovieClipButton;
			_RecruitItemBt.toolTip = LocalConfig.LOCAL_LAN.TavernScene.RecruitBtTip.@Text;
			_refreshBt = getChild("refreshBt") as MovieClipButton;
			_refreshBt.clickEnable = false;
			_refreshBt.toolTip=LocalConfig.LOCAL_LAN.TavernScene.RefreshTip.@Text;
			
			_RecruitBt1 = getChild("RecruitBt1") as MovieClipButton;
			_RecruitBt2 = getChild("RecruitBt2") as MovieClipButton;
			_RecruitBt3 = getChild("RecruitBt3") as MovieClipButton;
			_RecruitBt4 = getChild("RecruitBt4") as MovieClipButton;
			_unlock0 = getChild("unlock0") as MovieClipButton;
			_unlock1 = getChild("unlock1") as MovieClipButton;
			_unlock2 = getChild("unlock2") as MovieClipButton;
			_unlock3 = getChild("unlock3") as MovieClipButton;
			
			_lock0 = getChild("lock0") as Sprite;
			_lock1 = getChild("lock1") as Sprite;
			_lock2 = getChild("lock2") as Sprite;
			_lock3 = getChild("lock3") as Sprite;
			
			_recruited1 = getChild("recruited1") as Sprite;
			_recruited2 = getChild("recruited2") as Sprite;
			_recruited3 = getChild("recruited3") as Sprite;
			_recruited4 = getChild("recruited4") as Sprite;
			_recruited1.mouseEnabled = false;
			_recruited2.mouseEnabled = false;
			_recruited3.mouseEnabled = false;
			_recruited4.mouseEnabled = false;
			
			_RecruitItemBt.onClick = clickhandler;
			_refreshBt.onClick = refreshBtOnClickHandler;
			_RecruitBt1.onClick = clickhandler;
			_RecruitBt2.onClick = clickhandler;
			_RecruitBt3.onClick = clickhandler;
			_RecruitBt4.onClick = clickhandler;
			_unlock0.onClick = clickhandler;
			_unlock1.onClick = clickhandler;
			_unlock2.onClick = clickhandler;
			_unlock3.onClick = clickhandler;
			
			_cards = new Vector.<Card>();
			_gidContent = new BaseGridContainer(1, 4, 44, 96, 135);
			_gidContent.setLocation(119.05,292.6);
			for (var i:uint = 0; i <4; i++ ) {
				var tempArm:Card = new Card();
				tempArm.showTip = true;
				tempArm._currentCardTye = 1;
				tempArm.hideAll();
				tempArm.showMask();
				_gidContent.appendChild(tempArm);
				
				_cards.push(tempArm);
				tempArm = null;
				}
			
			_cardsContainer.addChild(_gidContent);
			
			
		}
		
		/**
		 * 按钮点击
		 */
		private function clickhandler(e:MouseEvent = null):void
		{
			switch(e.currentTarget) {
				case _RecruitItemBt:
					//使用招募令
					UseItemControler.userItemNew(SpecialItemIdConfig.RecruitItemId)
					/*var tempItem:ItemModel = BagData.getInstance().findBagItemById(SpecialItemIdConfig.RecruitItemId);
					if (tempItem) {
						UseItemControler.userItem(tempItem);
						}else {
							//如果商场中没有数据则先加载商场数据
							var temp:PurchasePanel = PurchasePanel.getInstance();
							var tempGoodModel:GoodsModel;
							if (!ShopModel.getInstance().list.length > 0) {
								SMZTController.getInstance().getShopGoods(function ():void {
									//背包中没有招募令时提示购买
										temp.show(true);
										tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(SpecialItemIdConfig.RecruitItemId);
										tempGoodModel.autoSetPriceType();
										temp.goodModel = tempGoodModel;
										temp = null;
										tempGoodModel = null;
									},true);
								}else {
									temp.show(true);
									tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(SpecialItemIdConfig.RecruitItemId);
									tempGoodModel.autoSetPriceType();
									temp.goodModel = tempGoodModel;
									temp = null;
									tempGoodModel = null;
									}
							}*/
					break;
				case _RecruitBt1:
					
					SMZTController.getInstance().purchaseCard(_tavernModel.slots[0].id, PurchaseType.GOLD, function recruitSuccess(param:Object):void {
						if (param.cards) {
							for (var i:String in param.cards) {
								PlayerData.getInstance().addOneCard(int(i));
								}
							PlayerData.getInstance().updataTotalType();
							_RecruitBt1.clickEnable = false;
							_recruited1.visible = true;
							
							PlayerData.getInstance().gold -= _tavernModel.slots[0].gold;
							AlertConfirmPane.getInstance().type = 0;
							AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TavernScene.RecruitSuccess.@Text);
							
							//-------------------新手引导用-----------------------
							if (!NewBieControler.getInstance().finishDic[NewBieModelId.TAVER]) {
								NewBieControler.getInstance().nextStep();
								}
							//--------------------end--------------------
					}});
					break;
				case _RecruitBt2:
					SMZTController.getInstance().purchaseCard(_tavernModel.slots[1].id, PurchaseType.GOLD, function recruitSuccess(param:Object):void {
						if (param.cards) {
								for (var i:String in param.cards) {
									PlayerData.getInstance().addOneCard(int(i));
									}
							PlayerData.getInstance().updataTotalType();
							_RecruitBt2.clickEnable = false;
							_recruited2.visible = true;
							
							PlayerData.getInstance().gold -= _tavernModel.slots[1].gold;
							AlertConfirmPane.getInstance().type = 0;
							AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TavernScene.RecruitSuccess.@Text);
					}});
					break;
				case _RecruitBt3:
					SMZTController.getInstance().purchaseCard(_tavernModel.slots[2].id, PurchaseType.GOLD, function recruitSuccess(param:Object):void {
						if (param.cards) {
								for (var i:String in param.cards) {
									PlayerData.getInstance().addOneCard(int(i));
									}
							PlayerData.getInstance().updataTotalType();
							_RecruitBt3.clickEnable = false;
							_recruited3.visible = true;
							
							PlayerData.getInstance().gold -= _tavernModel.slots[2].gold;
							AlertConfirmPane.getInstance().type = 0;
							AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TavernScene.RecruitSuccess.@Text);
					}});
					break;
				case _RecruitBt4:
					SMZTController.getInstance().purchaseCard(_tavernModel.slots[3].id, PurchaseType.GOLD, function recruitSuccess(param:Object):void {
						if (param.cards) {
								for (var i:String in param.cards) {
									PlayerData.getInstance().addOneCard(int(i));
									}
							PlayerData.getInstance().updataTotalType();
							_RecruitBt4.clickEnable = false;
							_recruited4.visible = true;
							
							PlayerData.getInstance().gold -= _tavernModel.slots[3].gold;
							AlertConfirmPane.getInstance().type = 0;
							AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TavernScene.RecruitSuccess.@Text);
					}});
					break;
				case _unlock0:
					SMZTController.getInstance().unlockSlotById(_tavernModel.slots[0].id, function ():void {
						_unlock0.visible = false;
						_lock0.visible = false;
						_RecruitBt1.visible = true;
						_priceText1.text = _tavernModel.slots[0].gold.toString();
						//-------------------新手引导用-----------------------
						if (!NewBieControler.getInstance().finishDic[NewBieModelId.TAVER]) {
							SMZTController.getInstance().SetNext(NewBieModelId.TAVER);
							
							if (PlayerData.getInstance().gold < _tavernModel.slots[0].gold) {
								//判断是否有足够的金币，如果不够则直接弹出提示，引导结束
								NewBieControler.getInstance().setModelFinishById(NewBieModelId.TAVER);
								NewbiePane.getInstance().hide();
								}else {
									NewBieControler.getInstance().nextStep();
									}
							}
						//--------------------end--------------------
						
						});
					break;
				case _unlock1:
					SMZTController.getInstance().unlockSlotById(_tavernModel.slots[1].id, function ():void {
						_unlock1.visible = false;
						_lock1.visible = false;
						_RecruitBt2.visible = true;
						_priceText2.text=_tavernModel.slots[1].gold.toString();
						});
					break;
				case _unlock2:
					SMZTController.getInstance().unlockSlotById(_tavernModel.slots[2].id,function ():void {
						_unlock2.visible = false;
						_lock2.visible = false;
						_RecruitBt3.visible = true;
						_priceText3.text=_tavernModel.slots[2].gold.toString();
						});
					break;
				case _unlock3:
					SMZTController.getInstance().unlockSlotById(_tavernModel.slots[3].id,function ():void {
						_unlock3.visible = false;
						_lock3.visible = false;
						_RecruitBt4.visible = true;
						_priceText4.text=_tavernModel.slots[3].gold.toString();
						});
					break;
				}
		}
		

		
		/**
		 * 刷新后重新获取酒馆信息
		 */
		private function refreshBtOnClickHandler(e:MouseEvent = null):void
		{
			
			SMZTController.getInstance().refreshTavernData(function(param:Object):void
				{
					/*//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.TAVER]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------*/
					
					SMZTController.getInstance().getTavernData(function (param:Object):void {
						TavernModel.getInstance().setData(param);
						}, false);
				}); 
		}
		
		
		/**
		 * 更新界面
		 * @param	e
		 */
		private function updataUI():void
		{
			if (_tavernModel.slots == null) return;
			for (var i:int = 0; i < _tavernModel.slots.length; i++)
			{
				_cards[i].setCardModel(new CardModel(_tavernModel.slots[i].card));
				
				if (_tavernModel.slots[i].purchased) {
					//已招募
					this["_priceText" + (i + 1)].text = _tavernModel.slots[i].gold;
					this["_unlock" + i].visible = false;
					this["_RecruitBt" + (i + 1)].visible = true;
					this["_recruited" + (i + 1)].visible = true;
					(this["_RecruitBt" + (i + 1)] as MovieClipButton).clickEnable = false;
					this["_lock" + i].visible = false;
					}else {
						this["_lock" + i].visible = true;
						this["_RecruitBt" + (i + 1)].visible = false;
						this["_recruited" + (i + 1)].visible = false;
						(this["_RecruitBt" + (i + 1)] as MovieClipButton).clickEnable = true;
						this["_unlock" + i].visible = true;
						this["_priceText" + (i + 1)].text = "—— ——";
						}
						
				if (_tavernModel.slots[i].locked) {
					this["_lock" + i].visible = true;
					this["_RecruitBt" + (i + 1)].visible = false;
					this["_unlock" + i].visible = true;
					this["_priceText" + (i + 1)].text = "—— ——";
					
					}else {
						this["_priceText" + (i + 1)].text = _tavernModel.slots[i].gold;
						this["_unlock" + i].visible = false;
						this["_RecruitBt" + (i+1)].visible = true;
						this["_lock" + i].visible = false;
						}
			}
			
			//根据等级设置哪些解锁按钮可点
			for (var j:int = 0; j < 4; j++ ) {
				if (PlayerData.getInstance().level >= levelUnlock[j]) {
					(this["_unlock"+j] as MovieClipButton).clickEnable = true;
					}else {
						(this["_unlock"+j] as MovieClipButton).clickEnable = false;
						}
				}
			
			updataTimer();
			
		}
		
		
		private function updataTimer():void
		{
			_secondNext = _tavernModel.cd;
			if (_secondNext >= 0) {
				_rectimer.start();
				_refreshBt.clickEnable = false;
				}else {
					_refreshBt.clickEnable = true;
					_rectimer.stop();
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
		 * 用户升级时
		 * @param	event
		 */
		private function onPlayerLevelUP(event:SMZTDataChangeEvent):void
		{
			updataUI();
			return;
		} // end function
		
		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			updataUI();
		} // end function
		
		
		
		public function get firstShow():Boolean 
		{
			return _firstShow;
		}
		
		public function set firstShow(value:Boolean):void 
		{
			_firstShow = value;
		}
	
	}
}
