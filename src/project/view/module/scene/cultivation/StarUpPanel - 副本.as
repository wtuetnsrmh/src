package project.view.module.scene.cultivation
{
	import com.bbjxl.effect.MyCataclasm;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.ApplicationController;
	import project.controller.SMZTController;
	import project.core.AppliactionManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.cultivation.CultivationModel;
	import project.model.cultivation.StarUpCandDragArea;
	import project.model.cultivation.StarUpCard;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.item.CardModel;
	import project.model.item.ItemModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.view.common.CheckBox;
	import project.view.common.ControlPage;
	import project.view.controls.TabNavigator;
	import project.view.layout.BaseGridContainer;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.cell.Card;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.chat.ChatPane;
	import project.view.module.chat.ClickPopCard;
	/**
	 * 进阶面板
	 * @author bbjxl 2013
	 */
	public class StarUpPanel extends BaseSpriteSetUI
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;
		private var _tabNav:TabNavigator;
		private var _checkBox:CheckBox;
		//-----------------------UI---------------------------------
		private var _goldText:TextField;
		private var _honorText:TextField;
		private var _targetText:TextField;
		private var _startText:TextField;
		
		private var _controlPage:ControlPage; //上下页控制组件
		private var _startUP:MovieClipButton;//进阶
		private var _soldrsBt:MovieClipButton;//佣兵按钮
		private var _talismanBt:MovieClipButton;//装备按钮
		private var _mitacBt:MovieClipButton;//神通按钮
		private var tempmask:Sprite;//双击时屏蔽鼠标,卡飞到后解除
		private var _currentClickDragedCard:Card; //当前点击拖动的卡
		private var _currentHitCard:StarUpCandDragArea; //当前碰到的卡
		private var _starUpedCard:Card;//升星后的目标卡
		
		private var _protect:MovieClip;
		private var _lucky:MovieClip;
		private var _itemIco:BaseIcoCellLoader;//道具
		//-----------------------数据---------------------------------
		private var _numArr:Array; //所有的数量文本数组
		private var _dragedCardArr:Vector.<StarUpCard>; //被拖动的六张卡
		private var _draging:Boolean = false;//是否在拖动状态
		private var _currentDragCardArea:int = 2;//当前拖动的卡是属于上面的嵌入区还是下面的区域（１：上面，２：下面）
		//-----------------------事件--------------------------------
		public function StarUpPanel()
		{
			_dragedCardArr = new Vector.<StarUpCard>;
			_numArr = new Array();
			
			setSpriteInstance("starUpPanelUI");
			configerInstance();
			
			tempmask = new Sprite();
			tempmask.graphics.beginFill(0xffffff, 0);
			tempmask.graphics.drawRect( 0,0, ApplicationConfig.STAGE_WIDTH, ApplicationConfig.STAGE_HEIGHT);
			tempmask.graphics.endFill();
		}
		
		public function updata():void {
			if (_currentHitCard) {
				_currentHitCard.dispose();
				}
			
			_tabNav.selectedByIndex(0);
			_startUP.clickEnable = false;
			}
			
		private function configerInstance():void
		{
			_startText= getChild("startText") as TextField;
			_targetText= getChild("targetText") as TextField;
			
			_goldText = getChild("goldText") as TextField;
			_honorText = getChild("honorText") as TextField;
			
			_starUpedCard = new Card();
			addChild(_starUpedCard);
			_starUpedCard.x = 356.15;
			_starUpedCard.y = 153.7;
			_starUpedCard.showTip = true;
			
			_currentHitCard = new StarUpCandDragArea();
			_currentHitCard.x = 69.1;
			_currentHitCard.y = 158.2;
			addChild(_currentHitCard);
			_currentHitCard.addEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
			_currentHitCard.addEventListener(MouseEvent.DOUBLE_CLICK, hitCardDoubleClickHandler);
			_currentHitCard.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, refreshTargetCard);
			
			_startUP = getChild("startUP") as MovieClipButton;
			_startUP.onClick=startUpClick;
			_soldrsBt = getChild("soldrsBt") as MovieClipButton;
			_talismanBt = getChild("talismanBt") as MovieClipButton;
			_mitacBt = getChild("mitacBt") as MovieClipButton;
			_tabNav = new TabNavigator();
			_tabNav.setTab(_soldrsBt, _talismanBt, _mitacBt);
			_tabNav.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			_grid = new BaseGridContainer(1, 6, 15.5, ApplicationConfig.CARD_WIDTH >>1, ApplicationConfig.CARD_HEIGHT >>1);
			_grid.setLocation(54,427.6);
			
			for (var i:uint = 0; i < 6; i++)
			{
				var tempArm:StarUpCard = new StarUpCard();
				tempArm.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				tempArm.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				tempArm.addEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
				tempArm.addEventListener(MouseEvent.DOUBLE_CLICK, cardDoubleClickHandler);
				tempArm.doubleClickEnabled = true;
				_grid.appendChild(tempArm);
				
				_dragedCardArr.push(tempArm);
				tempArm = null;
			}
			addChild(_grid);
			
			_controlPage = new ControlPage();
			_controlPage.setLocation(497, 589);
			_spriteInstance.addChild(_controlPage);
			
			_itemIco = new BaseIcoCellLoader();
			_itemIco.showBg = false;
			_itemIco.setLocation(188.65,176.65);
			addChild(_itemIco);
			
			_protect= getChild("protectBt") as MovieClip;
			_lucky = getChild("luckyBt") as MovieClip;
			_lucky.buttonMode = true;
			_protect.buttonMode = true;
			_checkBox = new CheckBox();
			_checkBox.setOptions(_protect, _lucky);
			_checkBox.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, btclickHandler);
			
			//this.addEventListener(MouseEvent.CLICK, cardClickHandler);
		}
		
		/**
		 * 如果点击的是卡牌且按了shift则显示到聊天窗口
		 * @param	e
		 */
		/*private function cardClickHandler(e:MouseEvent):void 
		{
			if (e.target is Card && ApplicationConfig._ctrlKeyDown) {
				ChatPane.getInstance().sendCardInfo((e.target as Card).cardId + "_bbjxl_" + (e.target as Card).getCardModel().name+"_bbjxl_"+(e.target as Card).getCardModel().quality);
				}
		}*/
		
		/**
		 * 刷新当前选项，如果道具不足则不选中当前选项，如果道具足够则继续选中
		 */
		public function refreshChekBox():void {
			var tempItem:ItemModel;
			switch(_checkBox.currentSelectOpion) {
				case 0:
					//防爆石
					tempItem = BagData.getInstance().findBagItemById(SpecialItemIdConfig.PROTECTE);
					if (!tempItem) {
						//如果没有物品，则当前物品设为未选中状态
							_protect.gotoAndStop(1);
							_checkBox.currentSelectOpion = -1;
							_itemIco.clearImgIco();
						}
					break;
				case 1:
					//幸运石
					tempItem = BagData.getInstance().findBagItemById(SpecialItemIdConfig.LUCKY);
					if (!tempItem) {
						//如果没有物品，则当前物品设为未选中状态
							_lucky.gotoAndStop(1);
							_checkBox.currentSelectOpion = -1;
							_itemIco.clearImgIco();
						}
					break;
				case -1:
					//全都没选
					break;
				}
			tempItem = null;
			}
		
		/**
		 * 幸运石，防爆石点击
		 * @param	e
		 */
		private function btclickHandler(e:SMZTDataChangeEvent):void 
		{
			switch(_checkBox.currentSelectOpion) {
				case 0:
					//防爆石
					UseItemControler.judgestItemExist(SpecialItemIdConfig.PROTECTE, function (param:ItemModel):void {
						_itemIco.ico = param.ico;
						},function ():void {
							//如果没有物品，则当前物品设为未选中状态
							_protect.gotoAndStop(1);
							_checkBox.currentSelectOpion = -1;
							_itemIco.clearImgIco();
							} );
					break;
				case 1:
					//幸运石
					UseItemControler.judgestItemExist(SpecialItemIdConfig.LUCKY, function (param:ItemModel):void {
						_itemIco.ico = param.ico;
						},function ():void {
							//如果没有物品，则当前物品设为未选中状态
							_lucky.gotoAndStop(1);
							_checkBox.currentSelectOpion = -1;
							_itemIco.clearImgIco();
							}  );
					break;
				case -1:
					//全都没选
					//trace("全都没选");
					_itemIco.clearImgIco();
					break;
				}
		}
		
		/**
		 * 更新目标卡
		 * @param	e
		 */
		private function refreshTargetCard(e:SMZTDataChangeEvent):void 
		{
			if (e.dataObject) {
				var temp:CardModel = new CardModel(int(e.dataObject));
				_starUpedCard.setCardModel(temp);
				_goldText.text = _currentHitCard.card.getCardModel().starRequiredGold.toString();
				_honorText.text = _currentHitCard.card.getCardModel().starRequiredHonor.toString();
				_startText.text = _currentHitCard.card.getCardModel().star.toString() + "星";
				_targetText.text = temp.star.toString() + "星";
				temp = null;
				}else {
					hideTargetCard();
					}
		}
		
		/**
		 * 去掉目标卡
		 * @param	e
		 */
		private function hideTargetCard():void {
			_starUpedCard.hideAll();
			_startText.text = "";
			_targetText.text = "";
			_goldText.text = "";
			_honorText.text = "";
			}
		 
		/**
		 * 进阶
		 */
		private function startUpClick(e:MouseEvent):void 
		{
			//_startUP.clickEnable = false;
			SMZTController.getInstance().cardStarUp(_currentHitCard.card.cardId, function (param:int):void {
				//更新金币、荣誉数
				PlayerData.getInstance().gold -= int(_goldText.text);
				PlayerData.getInstance().honor -= int(_honorText.text);
				if (_checkBox.currentSelectOpion != -1) {
					//如果有用到道具则更新背包数据
					SMZTController.getInstance().getBagData(false,function():void{refreshChekBox();});
					}
					
				switch(param) {
					case 0:
						//失败且卡牌被摧毁
						var boun:MyCataclasm = new MyCataclasm(10, 10);
						boun.stagW = ApplicationConfig.STAGE_WIDTH;
						boun.stageH = ApplicationConfig.STAGE_HEIGHT;
						var tempBd:BitmapData = new BitmapData(ApplicationConfig.CARD_WIDTH >> 1, ApplicationConfig.CARD_HEIGHT >> 1);
						tempBd.draw(_currentHitCard);
						boun.createTris(tempBd);//重置三角形
						boun.x = _currentHitCard.x;
						boun.y = _currentHitCard.y;
						
						addChild(boun);
						boun.bomb();//爆炸
						
						
						PlayerData.getInstance().deleteOneCard(_currentHitCard.card.cardId);//去掉一张卡
						_currentHitCard.dispose();
						CultivationModel.getInstance().updata();
						
						AlertConfirmPane.getInstance().type = 0;
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.MixPane.Fail0Tip.@Text);
						break;
					case 1:
						//失败但卡牌未被摧毁-不更新
						AlertConfirmPane.getInstance().type = 0;
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.MixPane.Fail1Tip.@Text);
						break;
					case 2:
						//成功
						PlayerData.getInstance().deleteOneCard(_currentHitCard.card.cardId,false);//去掉一张卡
						PlayerData.getInstance().addOneCard(_starUpedCard.cardId);//增加一张卡
						PlayerData.getInstance().updataTotalType();
						_currentHitCard.dispose();
						CultivationModel.getInstance().updata();
						
						StarUpSuccesShow.getInstance().currentCardId = _starUpedCard.cardId;
						StarUpSuccesShow.getInstance().show(true);
						/*AlertConfirmPane.getInstance().type = 0;
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.MixPane.SuccesTip.@Text);*/
						break;
					}
				},(_checkBox.currentSelectOpion==0)?1:0, (_checkBox.currentSelectOpion==1)?1:0);
			
		}
		/**
		 * 上面的嵌入区卡双击则移除
		 * @param	e
		 */
		private function hitCardDoubleClickHandler(e:MouseEvent):void 
		{
			_currentHitCard.dispose();
			
			_startUP.clickEnable = false;
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			switch (e.dataObject)
			{
				case _soldrsBt: 
					_controlPage.starCompute(CultivationModel.getInstance().slods, updataUI,6);
					break;
				case _talismanBt: 
					_controlPage.starCompute(CultivationModel.getInstance().tal, updataUI,6);
					break;
				case _mitacBt: 
					_controlPage.starCompute(CultivationModel.getInstance().mit, updataUI,6);
					break;
			}
		}
		
		/**
		 * 选择页码变化时更新界面
		 * @param	param1
		 */
		private function updataUI(arg:Vector.<CardModel>):void {
			for (var i:String in arg) {
				if (arg[i] != null) {
					_dragedCardArr[i].visible = true;
					_dragedCardArr[i].updataCard(arg[i]);
				}else {
					_dragedCardArr[i].visible = false;
					}
			}
		}
		/**
		 * 双击
		 * @param	e
		 */
		private function cardDoubleClickHandler(e:MouseEvent):void 
		{
			var flyCard:Card = new Card();
			flyCard = (e.currentTarget as StarUpCard).card.clone(1);
			var tempPoint:Point = turnToThisLocPoint(new Point((e.currentTarget as StarUpCard).x, (e.currentTarget as StarUpCard).y));
			flyCard.x = tempPoint.x;
			flyCard.y = tempPoint.y;
			addChild(flyCard);
			_currentHitCard.dispose();
			TweenLite.to(flyCard, .3, { x:_currentHitCard.x, y:_currentHitCard.y, onComplete:function onCompleteHandler():void {
				/*if (_currentHitCard.card) {
					addOrSubCardNum(_currentHitCard.card,true);//数量加１
					}
				addOrSubCardNum(flyCard);//数量减１
				*/
				_currentHitCard.card = flyCard;
				_startUP.clickEnable = true;//进阶可点
				
				flyCard.disposeBM();
				flyCard.dispose();
				flyCard = null;
				}});
		}
		
		/**
		 * 增加/减少一张指定的卡数量
		 * @param	e
		 */
		private function addOrSubCardNum(card:Card, add:Boolean = false):void {
			/*var tempCard:CardModel;
			if (add) {
				//增加一张卡数量
				switch(card.getCardModel()._Class) {
					case 12:
						//装备
						tempCard = CultivationModel.getInstance().findCardFormTotalCanUseTalismaById(card.cardId);
						if(tempCard!=null){
						tempCard.number++;
						}
						break;
					case 13:
						//卷轴
						tempCard = CultivationModel.getInstance().findCardFormTotalCanUseMitacById(card.cardId);
						if(tempCard!=null){
						tempCard.number++;
						}
						break;
					default:
						//兵
						tempCard = CultivationModel.getInstance().findCardFormTotalCanUseSoldierById(card.cardId);
						if(tempCard!=null){
						tempCard.number++;
						}
						break;
					}
				}else {
					switch(card.getCardModel()._Class) {
					case 12:
						//装备
						tempCard = CultivationModel.getInstance().findCardFormTotalCanUseTalismaById(card.cardId);
						if(tempCard!=null){
						tempCard.number--;
						}
						break;
					case 13:
						//卷轴
						tempCard = CultivationModel.getInstance().findCardFormTotalCanUseMitacById(card.cardId);
						if(tempCard!=null){
						tempCard.number--;
						}
						break;
					default:
						//兵
						tempCard = CultivationModel.getInstance().findCardFormTotalCanUseSoldierById(card.cardId);
						if(tempCard!=null){
						tempCard.number--;
						}
						break;
					}
			}
			tempCard = null;
			for (var i:String in _dragedCardArr) {
				if (_dragedCardArr[i].card.cardId == card.cardId) {
					_dragedCardArr[i].updataCardNumber(_dragedCardArr[i].card.getCardModel().number);
					}
				}*/
		}
		
		/**
		 * 点击后增加是否移动侦听
		 * @param	e
		 */
		private function cardMouseDownHandler(e:MouseEvent):void 
		{
			if (!_currentClickDragedCard) { _currentClickDragedCard = new Card(); _currentClickDragedCard._currentCardTye = 1; addChild(_currentClickDragedCard); }
			
			//判断是下面还是上面嵌入区拖动
			if (e.currentTarget is StarUpCard) {
				_currentDragCardArea = 2;
				_currentClickDragedCard.setCardModel((e.currentTarget as StarUpCard).card.getCardModel());
				}else if (e.currentTarget is StarUpCandDragArea) {
					if (!_currentHitCard.card) return;
					_currentDragCardArea = 1;
					_currentClickDragedCard.setCardModel(_currentHitCard.card.getCardModel());
					
					}
			
			_currentClickDragedCard.setLocation(this.mouseX - ((ApplicationConfig.CARD_WIDTH>>1)>> 1), this.mouseY -(( ApplicationConfig.CARD_HEIGHT>>1) >> 1));
			_currentClickDragedCard.visible = false;
			
			_currentClickDragedCard.oldPoint = turnToThisLocPoint(new Point((e.currentTarget).x, (e.currentTarget).y));
			
			if (!this.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				this.addEventListener(MouseEvent.MOUSE_MOVE, startDragCard);
				}
			//if (!stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.addEventListener(MouseEvent.MOUSE_UP, stopDargHandler);
				//}
		}
		
		private function turnToThisLocPoint(value:Point):Point {
			return this.globalToLocal(_grid.localToGlobal(value));
			}
		
		/**
		 * 开始拖动
		 * @param	e
		 */
		private function startDragCard(e:MouseEvent):void 
		{
			_draging = true;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, startDragCard,true);
			_currentClickDragedCard.alpha = 1;
			_currentClickDragedCard.visible = true;
			addChild(_currentClickDragedCard);
			
			if (_currentDragCardArea == 1) {
				//如果拖动是嵌入区的卡则把嵌入区的卡移除掉
				_currentHitCard.card.visible = false;
				}
			
			if (!this.hasEventListener(Event.ENTER_FRAME)) {
				this.addEventListener(Event.ENTER_FRAME, enterFrame);
				}
			if (!stage.hasEventListener(Event.MOUSE_LEAVE)) {
				stage.addEventListener(Event.MOUSE_LEAVE, leaveFromStage);
				}
		}
		/**
		 * 鼠标在场景外释放则停止拖动
		 * @param	e
		 */
		private function leaveFromStage(e:Event):void 
		{
			if (stage) {
				if (stage.hasEventListener(Event.MOUSE_LEAVE)) {
					stage.removeEventListener(Event.MOUSE_LEAVE, leaveFromStage);
					stopDargHandler(null);
					}
				}
		}
		
		/**
		 * 停止拖动
		 * @param	e
		 */
		private function stopDargHandler(e:MouseEvent=null):void 
		{
			if (stage && stage.hasEventListener(Event.MOUSE_LEAVE)) {
				stage.removeEventListener(Event.MOUSE_LEAVE, leaveFromStage);
				}
				
			this.removeEventListener(MouseEvent.MOUSE_MOVE, startDragCard);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDargHandler);
			_draging = false;
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
				
			if (_currentHitCard.selected) {
				_currentHitCard.selected = false;
				
				/*if (_currentHitCard.card) {
					addOrSubCardNum(_currentHitCard.card,true);//数量加１
					}
				addOrSubCardNum(_currentClickDragedCard);//数量减１*/
				
				//有拖动到上面的区域
				_currentHitCard.card = _currentClickDragedCard;
				
				//隐藏当前拖动的卡	
				_currentClickDragedCard.visible = false;	
				if(contains(_currentClickDragedCard)){
					removeChild(_currentClickDragedCard);
					}
					
				_startUP.clickEnable = true;
				}else {
					if (_currentDragCardArea == 1) {
						//如果拖动的是嵌入区的卡就直接移除掉
						if (contains(_currentClickDragedCard)) {
							removeChild(_currentClickDragedCard);
							}
						_currentHitCard.dispose();//移除上面的两张卡
						_startUP.clickEnable = false;
						return;
						}
						
					//如果待升卡没有，则隐藏目标卡
					if (_currentHitCard.card == null || _currentHitCard.card.visible==false) {
						_startUP.clickEnable = false;
						hideTargetCard();
						}
						
					
					TweenLite.to(_currentClickDragedCard, 0.3, { alpha:0, x:_currentClickDragedCard.oldPoint.x, y:_currentClickDragedCard.oldPoint.y, onComplete:function onCompleteHandler():void {
						if(contains(_currentClickDragedCard)){
						removeChild(_currentClickDragedCard);
						}
						}});
					}
		}
		
		private function enterFrame(e:Event):void 
		{
			//trace("enter")
			if (!_draging) return;
			_currentClickDragedCard.setLocation(this.mouseX - ((ApplicationConfig.CARD_WIDTH >> 1) >> 1), this.mouseY -(( ApplicationConfig.CARD_HEIGHT >> 1) >> 1));
			var tempPoint:Point = this.localToGlobal(new Point(this.mouseX,this.mouseY));
			if (_currentHitCard.bg.hitTestPoint(tempPoint.x,tempPoint.y,true)) {
				_currentHitCard.selected = true;
				}else {
					_currentHitCard.selected = false;
					}
		}
		
		private function rollOverHandler(e:MouseEvent):void {
			(e.currentTarget as StarUpCard).selected = true;
			}
		private function rollOutHandler(e:MouseEvent):void {
			(e.currentTarget as StarUpCard).selected = false;
			}
	
	}

}