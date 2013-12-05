package project.view.module.DeckPane 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.AppliactionManager;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.DeckModel;
	import project.model.data.PlayerData;
	import project.model.editDeck.EditDeckModel;
	import project.model.item.CardModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.CardFactary;
	import project.utils.CardTipManager;
	import project.utils.DepthManager;
	import project.utils.MathTool;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.common.ControlPage;
	import project.view.layout.BaseGridContainer;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.Card;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import project.view.module.chat.ChatPane;
	import project.view.module.helppane.NewbiePane;
	
	/**
	 * 编辑卡组面板
	 * @author bbjxl 2012
	 */
	public class EditDeckPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _currentSelectdOption:MovieClipButton;//当前选的是哪个按钮
		//private var _currentDragCar:Card;//当前拖动的卡
		
		private var _deckNameText:TextField;//输入卡组名称
		
		private var _bar0:CanDragArea;
		private var _bar1:CanDragArea;
		private var _bar2:CanDragArea;
		private var _bar3:CanDragArea;
		private var _bar4:CanDragArea;
		private var _bar5:CanDragArea;
		private var _bar6:CanDragArea;//法宝区
		private var _bar7:CanDragArea;
		private var _bar8:CanDragArea;//神通区
		private var _bar9:CanDragArea;
		
		private var _saveBt:MovieClipButton;//保存按钮
		private var _soldrsBt:MovieClipButton;//佣兵按钮
		private var _talismanBt:MovieClipButton;//装备按钮
		private var _mitacBt:MovieClipButton;//神通按钮
		
		//private var _MTBar:Sprite;//法宝背景
		//private var _TBar:Sprite;//神通背景
		//private var _soldierBar:Sprite;//兵背景
		private var _heroBigImage:Sprite;//头像容器
		private var _heroImage:BaseIcoCell;//头像
		private var _heroCard:Card;//英雄卡
		
		private var _num0:TextField;
		private var _num1:TextField;
		private var _num2:TextField;
		private var _num3:TextField;
		private var _num4:TextField;
		private var _num5:TextField;
		
		private var _controlPage:ControlPage;//上下页控制组件
		
		private var tempmask:Sprite = new Sprite();//用于双击选区时先屏蔽鼠标，让卡牌提示信息更新
			
		//-----------------------数据---------------------------------
		public static const CANUSER:String = " 可用";
		private var _gap:int = 10;//卡牌的间隔
		private var _editDeckModel:EditDeckModel;
		private var _barArr:Vector.<CanDragArea>;//所有的拖动区数组
		private var _numArr:Array;//所有的数量文本数组
		private var _dragedCardArr:Vector.<Card>;//被拖动的六张卡
		
		private var _deckId:int;//当前卡组ID
		
		private var _currentClickDragedCard:Card;//当前点击拖动的卡
		private var _currentHitCard:CanDragArea;//当前碰到的卡
		private var _currentDragedArea:CanDragArea;//当前哪个嵌入框的卡被拖动
		
		private var _dragArea:int = 0;//当前拖动的卡是在已经嵌入的区内的卡还是下面的选卡区内的卡，0表示选卡区，1表示嵌入区
		
		private var _savedFlag:Boolean = false;//是否保存成功
		private var doubleClick:Boolean = false;//双击判断
		
		private var _oldDeckSoldiers:Vector.<CardModel>;//编辑卡组时，原先被编辑的卡组所带的兵,法宝，神通
		//-----------------------事件--------------------------------
		private static var _instance:EditDeckPanel;
		
		public function EditDeckPanel() 
		{
			_dragedCardArr = new Vector.<Card>;
			_barArr = new Vector.<CanDragArea>;
			_numArr = new Array();
			
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("EditDeckPanel");
			configerUIInstance();
			
			_editDeckModel = EditDeckModel.getInstance();
            dataModel = _editDeckModel;
			
			
			
			/*_gridCardContainer = new BaseGridContainer(1, 6, 10, ApplicationConfig.CARD_WIDTH / 2, ApplicationConfig.CARD_HEIGHT / 2);
			_gridCardContainer.setLocation(45.15, 447.15);
			addChild(_gridCardContainer);*/
			for (var i:uint = 0; i < 6; i++ ) {
				var tempArm:Card = new Card();
				tempArm.showTip = true;
				tempArm.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				tempArm.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				tempArm.addEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
				tempArm.addEventListener(MouseEvent.DOUBLE_CLICK, cardDoubleClickHandler);
				tempArm.doubleClickEnabled = true;
				
				addChild(tempArm);
				_dragedCardArr.push(tempArm);
				}
			
			tempmask.graphics.beginFill(0xffffff, 0);
			tempmask.graphics.drawRect( 0,0, 760, 678);
			tempmask.graphics.endFill();
			
			//this.addEventListener(MouseEvent.CLICK, cardClickHandler);
		}
		
		/**
		 * 如果点击的是卡牌且按了shift则显示到聊天窗口
		 * @param	e
		 */
		private function cardClickHandler(e:MouseEvent):void 
		{
			if (e.target is Card && ApplicationConfig._ctrlKeyDown) {
				ChatPane.getInstance().sendCardInfo((e.target as Card).cardId + "_bbjxl_" + (e.target as Card).getCardModel().name+"_bbjxl_"+(e.target as Card).getCardModel().quality);
				}
		}
		
		
		//--------------------------------------------------------
		/**
		 * 关闭时如果嵌入区有卡则还原
		 * @param	event
		 */
        override public function hide(event:MouseEvent = null) : void
        {
			cardMouseUpHandler(null);
			
			if (_oldDeckSoldiers && _oldDeckSoldiers.length > 0) {
				//编辑卡组时
				if (!_savedFlag) {
						//如果没有保存成功就关闭则还原原先的卡组兵卡－－－－先去掉全部再还原之前的备份数量（为了保持数量一致）
						for (var i:String in _barArr) {
							if (_barArr[i].card && _barArr[i].canDrag) {
								updataEditDeckModel(_barArr[i], 1);
								}
							}
						
						/*for (var n:String in _oldDeckSoldiers) {
							PlayerData.getInstance().findCardById(_oldDeckSoldiers[n].id).number--;
							}	*/
						for (var n:String in _oldDeckSoldiers) {
							var tempbackCard:CardModel = PlayerData.getInstance().findCardById(_oldDeckSoldiers[n].id);
							tempbackCard.number = tempbackCard.editDeckOldNum;//--------------------------
							}
						}
						
					_oldDeckSoldiers = null;
				}else {
					//新建卡组时
					if (!_savedFlag) {
						//如果没有保存成功就关闭则回收嵌入区已经有的卡（使数量一致）
						for (var j:String in _barArr) {
							if (_barArr[j].card && _barArr[j].canDrag) {
								updataEditDeckModel(_barArr[j], 1);
								}
							}
						}
					
					}
			
			
            if (rootContainer)
            {
				if (contains(tempmask)) {
					removeChild(tempmask);
					}
				
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
                if (this.showEffect)
                {
                    TweenLite.to(this, 0.3, {alpha:0.2, y:this.y - 40, onComplete:this.onTweenClose});
                }
                else
                {
                    if (rootContainer.contains(this))
                    {
                        rootContainer.removeChild(this);
                    }
                    this.isOpened = false;
                    this.isPopUP = false;
                }
				
				if(AppliactionManager.stage){
					AppliactionManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					AppliactionManager.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
					}
					
				if (closeButton) {
					ApplicationController.removeAtWin(this);
					}
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		/**
		 * 更新选区卡的数量
		 */
		private function updataCardNum(param:CanDragArea):void {
			for (var i:int = 0; i < _dragedCardArr.length; i++ ) {
				if (_dragedCardArr[i].cardId == param.card.cardId) {
					//_dragedCardArr[i].getCardModel().number = _dragedCardArr[i].getCardModel().number - 20;
					if (_dragedCardArr[i].getCardModel().number <= 0) {
						_dragedCardArr[i].enable = false;
						if (_dragedCardArr[i].hasEventListener(MouseEvent.MOUSE_DOWN)) {
							_dragedCardArr[i].removeEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
							}
						}else {
							_dragedCardArr[i].enable = true;
							if (!_dragedCardArr[i].hasEventListener(MouseEvent.MOUSE_DOWN)) {
								_dragedCardArr[i].addEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
								}
							}
					_numArr[i].text = _dragedCardArr[i].getCardModel().number.toString()+CANUSER;
					return;
					}
				}
			}
		/**
		 * 更新数据模型
		 * @param 有变化的嵌入区
		 * @param 增加这个嵌入区的卡还是去掉卡，增：0，去：1
		 */
		private function updataEditDeckModel(param:CanDragArea,param2:int=0):void {
			//更新相应的数据
			var tempCard:CardModel;
			if(param2==0){
			switch(param.cardClass) {
				case 0:
					_editDeckModel.usedSoldier[param.index] = param.card.getCardModel();
					tempCard = _editDeckModel.findCardFormTotalCanUseSoldierById(param.card.getCardModel().id);
					if(tempCard!=null){
					tempCard.number--;
					}
					break;
				case 1:
					_editDeckModel.usedTalisman[param.index] = param.card.getCardModel();
					tempCard = _editDeckModel.findCardFormTotalCanUseTalismaById(param.card.getCardModel().id);
					if(tempCard!=null){
					tempCard.number--;
					}
					break;
				case 2:
					_editDeckModel.usedMitac[param.index] = param.card.getCardModel();
					tempCard = _editDeckModel.findCardFormTotalCanUseMitacById(param.card.getCardModel().id);
					if(tempCard!=null){
					tempCard.number--;
					}
					break;
				
				}
				
			}else {
				
				switch(param.cardClass) {
					case 0:
						_editDeckModel.usedSoldier[param.index] = null;
						tempCard = _editDeckModel.findCardFormTotalCanUseSoldierById(param.card.getCardModel().id);
						if(tempCard!=null){
						tempCard.number++;
						}
						break;
					case 1:
						_editDeckModel.usedTalisman[param.index] = null;
						tempCard = _editDeckModel.findCardFormTotalCanUseTalismaById(param.card.getCardModel().id);
						if(tempCard!=null){
						tempCard.number++;
						}
						break;
					case 2:
						_editDeckModel.usedMitac[param.index] = null;
						tempCard = _editDeckModel.findCardFormTotalCanUseMitacById(param.card.getCardModel().id);
						if(tempCard!=null){
						tempCard.number++;
						}
						break;
					}
				}
			tempCard = null;
			updataCardNum(param);
			judgestDeckSet();
			//刷新界面
			//checkUpPard();
			//_controlPage.currentPageNum = _controlPage.currentPageNum;
			}
		/**
		 * 找到双击后要飞向的嵌入框是哪个
		 * @return
		 */
		private function findTarget(startCard:Card):CanDragArea {
			var target:CanDragArea = null;
			switch(devideClass(startCard.getCardModel()._Class)) {
				case 0:
					//兵
					if (_editDeckModel.usedSoldierNum != _editDeckModel.usedSoldier.length) {
						//兵没有装满
						for (var i:String in _editDeckModel.usedSoldier) {
							if (!_editDeckModel.usedSoldier[i]) {
								//找到没有填的嵌入框
								target = _barArr[i];
								return target;
								}
							}
						}
					
					break;
				case 1:
					//装备
					if (_editDeckModel.usedTalismaNum != _editDeckModel.usedTalisman.length) {
						//装备没有装满
						for (var j:String in _editDeckModel.usedTalisman) {
							if (!_editDeckModel.usedTalisman[j]) {
								//找到没有填的嵌入框
								target = _barArr[int(j)+6];
								return target;
								}
							}
						}
					break;
				case 2:
					//卷轴
					if (_editDeckModel.usedMitacNum != _editDeckModel.usedMitac.length) {
						//装备没有装满
						for (var n:String in _editDeckModel.usedMitac) {
							if (!_editDeckModel.usedMitac[n]) {
								//找到没有填的嵌入框
								target = _barArr[int(n)+8];
								return target;
								}
							}
						}
					break;
				}
			
			return null;
			}
		/**
		 * 卡双击事件
		 * @param	e
		 */
		private function cardDoubleClickHandler(e:MouseEvent):void {
			stage.removeEventListener(Event.MOUSE_LEAVE, leaveFromStage);
			
			for (var i:String in _dragedCardArr) {
				_dragedCardArr[i].removeEventListener(MouseEvent.MOUSE_MOVE, currentTargeCardMouseMoveHandler);
				//_dragedCardArr[i].removeEventListener(MouseEvent.MOUSE_UP, currentTargeCardMouseUpHandler);
				}
			
			Debug.log("双击");
			
			var tempCard:Card;
			 tempCard = (e.currentTarget as Card).clone(2);
			 
			//判断是否数量为０，如果为0则不执行下面操作
			if (tempCard.getCardModel().number <= 0) {
				return;
				}
			 
			var targetArea:CanDragArea = findTarget((e.currentTarget as Card));
			if (!targetArea) return;//没找到
			
			tempCard.showSmallImage();
			tempCard.showTip = false;
			tempCard.mouseChildren = false;
			tempCard.mouseEnabled = false;
			tempCard.setLocation((e.currentTarget as Card).x+ (ApplicationConfig.CARD_WIDTH/2-ApplicationConfig.SMALL_CARD_WH) / 2, (e.currentTarget as Card).y+(ApplicationConfig.CARD_HEIGHT/2 - ApplicationConfig.SMALL_CARD_WH) / 2);
			addChild(tempCard);
			
			//addChild(tempmask);
			
			if (targetArea.card) {
				//如果之前嵌入框内已经有卡
				updataEditDeckModel(targetArea,1);
					}
			targetArea.card = tempCard.clone(2);
			targetArea.card.visible = false;
			
			updataEditDeckModel(targetArea);
			TweenLite.to(tempCard, .4, { alpha:1, x:targetArea.x+2, y:targetArea.y+2, ease:Cubic.easeOut, onComplete:function onCompleteHandler():void {
				//_currentClickDragedCard.visible = false;
				tempCard.disposeBM();
				tempCard.dispose();
				//removeChild(tempmask)
				targetArea.card.visible = true;
				
				tempCard = null;
				targetArea = null;
				}});
			
			}
		/**
		 * 判断卡与要嵌入的框是否类型符合
		 * @param	cardclass1
		 * @param	cardclass2
		 * @return
		 */
		private function judgestCardCalss(cardclass1:int, cardclass2:int):Boolean {
			if (cardclass1 == devideClass(cardclass2)) {
				return true;
				}else {
					return false;
					}
				return false;
			
			}
		private function devideClass(arg:int):int {
			var temp:int=-1;
			if (arg==12) {
			temp = 1;
			}else  if (arg == 13) {
				temp = 2;
				}else {
					temp =0;
					}
			return temp;
			}
		/**
		 * 移动过程中
		 * @param	e
		 */
		private function cardMouseMoveHandler(e:MouseEvent):void {
			
			for (var i:int = 0; i < _barArr.length; i++ ) {
				if (_barArr[i]._mask.hitTestPoint(this.mouseX, this.mouseY,true)) {
					//trace(this.mouseX+"/"+this.mouseY)
					
					if (_barArr[i].canDrag == true) {
						//判断是否卡的类型符合
						if (!judgestCardCalss(_barArr[i].cardClass, _currentClickDragedCard.getCardModel()._Class)) {
							return;
							}
						
						_currentHitCard = _barArr[i];
						setTotalBarSelected();
						_barArr[i].selected = true;
						
						}
					}else {
						_barArr[i].selected = false;
						}
				}
			}
		/**
		 * 设置所有的嵌入框为未选中状态
		 */
		private function setTotalBarSelected():void {
			
			for (var i:int = 0; i < _barArr.length; i++ ) {
				//if (_currentHitCard != _barArr[0]) {
					_barArr[0].selected = false;
					//}
				
				}
			}
		//--------------------------------------------------------
		/**
		 * 鼠标放开后如果当前在嵌入区上面则嵌入卡，否则消失
		 * @param	e
		 */
		private function cardMouseUpHandler(e:MouseEvent):void {
			//Debug.log("cardMouseUpHandler");
			if (!stage) return;
			stage.removeEventListener(MouseEvent.MOUSE_UP, cardMouseUpHandler);
			
			if(_currentMouseDownCard)
			_currentMouseDownCard.removeEventListener(MouseEvent.MOUSE_MOVE, currentTargeCardMouseMoveHandler);
			//如果当前没有拖动的卡则不执行
			if (_currentClickDragedCard.visible == false) return;
			
			if (_dragArea == 1) {
				//嵌入区卡拖动
				_currentClickDragedCard.stopDrag();
				if (_currentDragedArea == null || _currentClickDragedCard==null || !contains(_currentClickDragedCard)) { return; }
				if (MathTool.distance(new Point(_currentClickDragedCard.x, _currentClickDragedCard.y), _currentClickDragedCard.oldPoint) > 30) {
					removeChild(_currentClickDragedCard);
					updataEditDeckModel(_currentDragedArea, 1);
					_currentDragedArea.dispose();
					}else {
						_currentDragedArea.card.showSmallImage();
						_currentDragedArea.card.checkVisible();
						removeChild(_currentClickDragedCard);
						}
				
				return;
				}
			if (_currentClickDragedCard == null || !contains(_currentClickDragedCard)) { return; }
			_currentClickDragedCard.stopDrag();
			if (_currentHitCard && _currentHitCard.selected) {
				//当前有碰到卡
				if (_currentHitCard.card) {
					//如果之前嵌入框内已经有卡
					updataEditDeckModel(_currentHitCard,1);
					}
				_currentHitCard.card = _currentClickDragedCard.clone(2);
				removeChild(_currentClickDragedCard);
				updataEditDeckModel(_currentHitCard);
				}else {
					//如果没有碰到卡
					TweenLite.to(_currentClickDragedCard, 0.3, { alpha:0, x:_currentClickDragedCard.oldPoint.x, y:_currentClickDragedCard.oldPoint.y, onComplete:function onCompleteHandler():void {
						//_currentClickDragedCard.visible = false;
						if(contains(_currentClickDragedCard)){
						removeChild(_currentClickDragedCard);
						}
						}});
					}
					
			//所有的嵌入框设为没选中状态
			setTotalBarSelected();
			
			if (_currentHitCard) {
				_currentHitCard.selected = false;
				_currentHitCard = null;
				}
			_currentClickDragedCard.removeEventListener(MouseEvent.MOUSE_MOVE,cardMouseMoveHandler);
			}
		//--------------------------------------------------------
		/**
		 * 鼠标点击拖动时复制出一张卡拖动（先鼠标点下时复制一张卡但不显示出来，只有移动时才显示出来，如果没移动就释放鼠标则移除相应的侦听事件）
		 * @param	e
		 */
		private var _currentMouseDownCard:Card;//当前点击的卡
		private function cardMouseDownHandler(e:MouseEvent):void {
			//Debug.log("cardMouseDownHandler");
			stage.addEventListener(MouseEvent.MOUSE_UP, cardMouseUpHandler);
			
			_dragArea = 0;
			_currentMouseDownCard = (e.currentTarget as Card);
			_currentMouseDownCard.addEventListener(MouseEvent.MOUSE_MOVE, currentTargeCardMouseMoveHandler);
			//(e.currentTarget as Card).addEventListener(MouseEvent.ROLL_OUT, currentTargeCardRolloutHandler);
			//(e.currentTarget as Card).addEventListener(MouseEvent.MOUSE_UP, currentTargeCardMouseUpHandler);
			//tempCard = null;
			}
		//
		private function currentTargeCardRolloutHandler(e:MouseEvent):void {
			(e.currentTarget as Card).removeEventListener(MouseEvent.ROLL_OUT, currentTargeCardRolloutHandler);
			(e.currentTarget as Card).removeEventListener(MouseEvent.MOUSE_MOVE, currentTargeCardMouseMoveHandler);
			(e.currentTarget as Card).removeEventListener(MouseEvent.MOUSE_UP, currentTargeCardMouseUpHandler);
			}
		//当前被拖出的选区卡增加移动侦听，如果有移动则拖出卡
		private function currentTargeCardMouseMoveHandler(e:MouseEvent):void {
			//Debug.log("currentTargeCardMouseMoveHandler");
			
			_currentMouseDownCard.removeEventListener(MouseEvent.MOUSE_MOVE, currentTargeCardMouseMoveHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, leaveFromStage);
			
			var tempCard:Card;
			 tempCard= (e.currentTarget as Card).clone(2);
			
			_currentClickDragedCard.alpha = 1;
			_currentClickDragedCard.hideAll();
			_currentClickDragedCard._currentCardTye = tempCard._currentCardTye;
			_currentClickDragedCard.setCardModel(tempCard.getCardModel());
			_currentClickDragedCard.showSmallImage();
			_currentClickDragedCard.setLocation(this.mouseX - ApplicationConfig.SMALL_CARD_WH / 2, this.mouseY - ApplicationConfig.SMALL_CARD_WH / 2);
			if (_currentSelectdOption == _soldrsBt) {
				_currentClickDragedCard.oldPoint=new Point((e.currentTarget as Card).x+(ApplicationConfig.CARD_WIDTH/2-ApplicationConfig.SMALL_CARD_WH)/2, (e.currentTarget as Card).y+(ApplicationConfig.CARD_HEIGHT/2-ApplicationConfig.SMALL_CARD_WH));
				}else {
					//如果是装备跟神通就把回到的位置设为0
					_currentClickDragedCard.oldPoint=new Point((e.currentTarget as Card).x,(e.currentTarget as Card).y);
					}
			
			_currentClickDragedCard.visible = true;
			
			_currentClickDragedCard.setLocation(this.mouseX - ApplicationConfig.SMALL_CARD_WH / 2, this.mouseY - ApplicationConfig.SMALL_CARD_WH / 2);
			addChild(_currentClickDragedCard);
			_currentClickDragedCard.startDrag(false);
			/*if(!_currentClickDragedCard.hasEventListener(MouseEvent.MOUSE_UP)){
				_currentClickDragedCard.addEventListener(MouseEvent.MOUSE_UP, cardMouseUpHandler);
				}*/
			if(!_currentClickDragedCard.hasEventListener(MouseEvent.MOUSE_MOVE)){
				_currentClickDragedCard.addEventListener(MouseEvent.MOUSE_MOVE,cardMouseMoveHandler);
				}
			
			}
		private function currentTargeCardMouseUpHandler(e:MouseEvent):void {
			(e.currentTarget as Card).removeEventListener(MouseEvent.MOUSE_MOVE, currentTargeCardMouseMoveHandler);
			
			if((e.currentTarget as Card).hasEventListener(MouseEvent.MOUSE_UP)){
				(e.currentTarget as Card).removeEventListener(MouseEvent.MOUSE_UP, currentTargeCardMouseUpHandler);
				}
			_currentClickDragedCard.stopDrag();
			}	
		//--------------------------------------------------------
		/**
		 * 嵌入区卡拖动 
		 * @param	e
		 */
		private function removeCardMouseHandler(e:MouseEvent):void {
			//单击拖动
			_dragArea = 1;
			var tempCurrentTarge:CanDragArea = e.currentTarget as CanDragArea;
			if (!tempCurrentTarge.card || tempCurrentTarge.card.visible==false) {
				return;
				}
			
			var tempCard:Card = new Card();
			 tempCard = tempCurrentTarge.card.clone(2);
			 _currentDragedArea = tempCurrentTarge;
			 //_currentDragedArea.card.hideAll();
			 
			_currentClickDragedCard.alpha = 1;
			_currentClickDragedCard.hideAll();
			_currentClickDragedCard._currentCardTye = tempCard._currentCardTye;
			_currentClickDragedCard.setCardModel(tempCard.getCardModel());
			_currentClickDragedCard.oldPoint = new Point((tempCurrentTarge as CanDragArea).x, (tempCurrentTarge as CanDragArea).y);
			_currentDragedArea.addEventListener(MouseEvent.MOUSE_MOVE, currentClcikDrageCardMouseMoveHandler);
			_currentDragedArea.addEventListener(MouseEvent.ROLL_OUT, currentClcikDrageRolloutHandler);
			//_currentClickDragedCard.setLocation(parent.mouseX - ApplicationConfig.SMALL_CARD_WH / 2, parent.mouseY - ApplicationConfig.SMALL_CARD_WH / 2);
			//addChild(_currentClickDragedCard);
			//_currentClickDragedCard.mouseEnabled = false;
			//_currentClickDragedCard.startDrag(false);
			if(!_currentDragedArea.hasEventListener(MouseEvent.MOUSE_UP)){
				_currentDragedArea.addEventListener(MouseEvent.MOUSE_UP,currentDragedAreaMouseUpHandler);
				}
			}
			
		private function currentClcikDrageRolloutHandler(e:MouseEvent):void {
			_currentDragedArea.removeEventListener(MouseEvent.MOUSE_MOVE, currentClcikDrageCardMouseMoveHandler);
			_currentDragedArea.removeEventListener(MouseEvent.MOUSE_UP,currentDragedAreaMouseUpHandler);
			_currentDragedArea.removeEventListener(MouseEvent.ROLL_OUT, currentClcikDrageRolloutHandler);
			}
				
		//嵌入区鼠标放开时停止当前拖动的卡
		private function currentDragedAreaMouseUpHandler(e:MouseEvent):void {
			_currentDragedArea.removeEventListener(MouseEvent.MOUSE_MOVE, currentClcikDrageCardMouseMoveHandler);
			_currentDragedArea.removeEventListener(MouseEvent.ROLL_OUT, currentClcikDrageRolloutHandler);
			
			if(_currentDragedArea.hasEventListener(MouseEvent.MOUSE_UP)){
				_currentDragedArea.removeEventListener(MouseEvent.MOUSE_UP,currentDragedAreaMouseUpHandler);
				}
			_currentClickDragedCard.stopDrag();
			}
			
		private function currentClcikDrageCardMouseMoveHandler(e:MouseEvent):void {
			stage.addEventListener(Event.MOUSE_LEAVE, leaveFromStage);
			
			_currentDragedArea.removeEventListener(MouseEvent.MOUSE_MOVE, currentClcikDrageCardMouseMoveHandler);
			if(_currentDragedArea.card){
			_currentDragedArea.card.hideAll();
			}
			
			_currentClickDragedCard.setLocation(this.mouseX - ApplicationConfig.SMALL_CARD_WH / 2, this.mouseY - ApplicationConfig.SMALL_CARD_WH / 2);
			addChild(_currentClickDragedCard);
			_currentClickDragedCard.startDrag(false);
			if(!_currentClickDragedCard.hasEventListener(MouseEvent.MOUSE_UP)){
				_currentClickDragedCard.addEventListener(MouseEvent.MOUSE_UP, cardMouseUpHandler);
				}
			
			}
		//鼠标移开场景时
		private function leaveFromStage(e:Event):void {
			//_currentClickDragedCard.stopDrag();
			if (stage) {
				if (stage.hasEventListener(Event.MOUSE_LEAVE)) {
					stage.removeEventListener(Event.MOUSE_LEAVE, leaveFromStage);
					//if (_currentDragedArea == null || _currentClickDragedCard==null || !contains(_currentDragedArea)|| !contains(_currentClickDragedCard)) { return; }
					cardMouseUpHandler(null);
					}
				}
			
			}
		//--------------------------------------------------------
		/**
		 * 嵌入区鼠标双击去掉已有的卡
		 * @param	e
		 */
		private function doubleClickRemoveCardMouseHandler(e:MouseEvent):void {
			////trace("ddddd")
			if (_currentDragedArea.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				_currentDragedArea.removeEventListener(MouseEvent.MOUSE_MOVE, currentClcikDrageCardMouseMoveHandler);
				}
			//(e.currentTarget as CanDragArea).card.hideAll();
				updataEditDeckModel((e.currentTarget as CanDragArea), 1);
				(e.currentTarget as CanDragArea).dispose();
			}
		//--------------------------------------------------------
		private function rollOverHandler(e:MouseEvent):void {
			(e.currentTarget as Card).selected = true;
			}
		private function rollOutHandler(e:MouseEvent):void {
			(e.currentTarget as Card).selected = false;
			}
		//--------------------------------------------------------
		/**
		 * 根据选的是兵还是装备神通，重新定位下面六个卡的位置跟卡的类型
		 */
		private function setCardLocAndType():void {
			_gap = 15.5;
			for (var i:int = 0; i < _dragedCardArr.length; i++ ) {
				_dragedCardArr[i].x = 44.55 + (ApplicationConfig.CARD_WIDTH / 2) * i + i * _gap;
				_dragedCardArr[i].y = 444.15;
				}
			/*if (_currentSelectdOption == _soldrsBt) {
				_gap = 16;
				for (var i:int = 0; i < _dragedCardArr.length; i++ ) {
					_dragedCardArr[i].x = 42.55 + (ApplicationConfig.CARD_WIDTH / 2) * i + i * _gap;
					_dragedCardArr[i].y = 447.15;
					}
				}else {
					_gap = 47.55;
					for (var j:int = 0; j < _dragedCardArr.length; j++ ) {
						_dragedCardArr[j].x =58.9 + (ApplicationConfig.SMALL_CARD_WH) * j+ j * _gap;
						_dragedCardArr[j].y = 481.85;
						}
					}*/
			}
		
		//--------------------------------------------------------
		private function configerUIInstance():void {
			_heroImage = new BaseIcoCell();
			_heroCard = new Card();
			_heroCard.setLocation(424, 107.3);
			addChild(_heroCard);
			
			_deckNameText = getChild("deckNameText") as TextField;
			_deckNameText.maxChars = 8;
			
			_bar0 = getChild("bar0") as CanDragArea;
			_bar1 = getChild("bar1") as CanDragArea;
			_bar2 = getChild("bar2") as CanDragArea;
			_bar3 = getChild("bar3") as CanDragArea;
			_bar4 = getChild("bar4") as CanDragArea;
			_bar5 = getChild("bar5") as CanDragArea;
			_bar6 = getChild("bar6") as CanDragArea;
			_bar7 = getChild("bar7") as CanDragArea;
			_bar8 = getChild("bar8") as CanDragArea;
			_bar9 = getChild("bar9") as CanDragArea;
			//设置嵌入框的类型：0兵，1：装备，2：卷轴
			for (var n:int = 0; n < 10; n++ ) {
				_barArr.push(this["_bar" + n]);
				if (n < 6) {
					(this["_bar" + n] as CanDragArea).cardClass = 0;
					(this["_bar" + n] as CanDragArea).index = n;
					}else if (n < 8) {
						(this["_bar" + n] as CanDragArea).cardClass = 1;
						(this["_bar" + n] as CanDragArea).index = n-6;
						}else {
							(this["_bar" + n] as CanDragArea).cardClass = 2;
							(this["_bar" + n] as CanDragArea).index = n-8;
							}
				}
			
			_saveBt = getChild("saveBt") as MovieClipButton;
			_saveBt.onClick = saveClick;
			
			_soldrsBt = getChild("soldrsBt") as MovieClipButton;
			_talismanBt = getChild("talismanBt") as MovieClipButton;
			_mitacBt = getChild("mitacBt") as MovieClipButton;
			_soldrsBt.onClick = optoinClickHandler;
			_talismanBt.onClick = optoinClickHandler;
			_mitacBt.onClick = optoinClickHandler;
			
			
			
			//_MTBar = getChild("MTBar") as Sprite;
			//_TBar = getChild("TBar") as Sprite;
			//_soldierBar = getChild("soldierBar") as Sprite;
			_heroBigImage = getChild("heroBigImage") as Sprite;
			
			_num0 = getChild("num0") as TextField;
			_num1 = getChild("num1") as TextField;
			_num2 = getChild("num2") as TextField;
			_num3 = getChild("num3") as TextField;
			_num4 = getChild("num4") as TextField;
			_num5 = getChild("num5") as TextField;
			_numArr.push(_num0);
			_numArr.push(_num1);
			_numArr.push(_num2);
			_numArr.push(_num3);
			_numArr.push(_num4);
			_numArr.push(_num5);
			
			_controlPage = new ControlPage();
			_controlPage.setLocation(489.25, 615.35);
			_spriteInstance.addChild(_controlPage);
			}
			
		//--------------------------------------------------------
		/**
		 * 检查要显示哪种边框
		 * @param	e
		 */
		private function checkVisible():void {
			//_soldierBar.visible = true;//显示兵的背景框
			switch(_currentSelectdOption) {
				case _soldrsBt:
					
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && NewBieControler.getInstance().currentNewBieModle.levelId != 5) {
						NewBieControler.getInstance().refreshByValue(-1,-1,NewBieControler.EDIT_SLOD);
						}
					//--------------------end--------------------
					
					_controlPage.starCompute(_editDeckModel.totalCanUseSoldier, updataUI,6);
					break;
				case _talismanBt:
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]&& NewBieControler.getInstance().currentNewBieModle.levelId != 5) {
						NewBieControler.getInstance().refreshByValue(-1,-1,NewBieControler.EDIT_TAIL);
						}
					//--------------------end--------------------
					
					_controlPage.starCompute(_editDeckModel.totalCanUseTalisma, updataUI,6);
					break;
				case _mitacBt:
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]&& NewBieControler.getInstance().currentNewBieModle.levelId != 5) {
						NewBieControler.getInstance().refreshByValue(-1,-1,NewBieControler.EDIT_MIT);
						}
					//--------------------end--------------------
					
					_controlPage.starCompute(_editDeckModel.totalCanUseMitac, updataUI,6);
					break;
				default:
					break;
				}
				
			
			}
		/**
		 * 检查上部分的各装入框哪些要显示
		 * 
		 */
		private function checkUpPard():void {
			
			//备份卡组中已有卡的数量
			if(_oldDeckSoldiers!=null){
			for (var n:String in _oldDeckSoldiers) {
				var tempbackCard:CardModel = PlayerData.getInstance().findCardById(_oldDeckSoldiers[n].id);
				tempbackCard.editDeckOldNum = tempbackCard.number;//--------------------------------
				}
			}
			
			_talismanBt.clickEnable = true;
			_mitacBt.clickEnable = true;
			_soldrsBt.clickEnable = true;
			
			for (var j:String in _barArr) {
				if (_barArr[j].hasEventListener(MouseEvent.MOUSE_DOWN)) {
					_barArr[j].removeEventListener(MouseEvent.MOUSE_DOWN,removeCardMouseHandler);
					}
				if (_barArr[j].hasEventListener(MouseEvent.DOUBLE_CLICK)) {
					_barArr[j].doubleClickEnabled = false;
					_barArr[j].removeEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
					}
				_barArr[j].dispose();
				_barArr[j].canDrag = false;
				}
				
			for (var i:int = 0; i < _editDeckModel.usedSoldier.length; i++ ) {
				if (_editDeckModel.usedSoldier[i]) {
					_barArr[i].card = CardFactary.creaCard(_editDeckModel.usedSoldier[i].id);
					
					}
				_barArr[i].canDrag = true;
				/*if(_barArr[i].card){
				_barArr[i].card.visible = true;
				}*/
				//如果已经嵌入的卡拖动后就删除
				_barArr[i].doubleClickEnabled = true;
				_barArr[i].addEventListener(MouseEvent.MOUSE_DOWN,removeCardMouseHandler);
				_barArr[i].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
				}
			
			if (_editDeckModel.usedMitac.length == 0) {
				//无神通
				_mitacBt.clickEnable = false;//神通不可选
				}else if (_editDeckModel.usedMitac.length == 1) {
					_barArr[8].canDrag = true;
					_barArr[8].doubleClickEnabled = true;
					_barArr[8].addEventListener(MouseEvent.MOUSE_DOWN, removeCardMouseHandler);
					_barArr[8].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
					if (_editDeckModel.usedMitac[0]) {
						_barArr[8].card = CardFactary.creaCard(_editDeckModel.usedMitac[0].id);
						}
					}else {
						_barArr[8].canDrag = true;
						_barArr[8].doubleClickEnabled = true;
						_barArr[9].doubleClickEnabled = true;
						_barArr[9].canDrag = true;
						if (_editDeckModel.usedMitac[0]) {
						_barArr[8].card = CardFactary.creaCard(_editDeckModel.usedMitac[0].id);
						}
						if (_editDeckModel.usedMitac[1]) {
						_barArr[9].card = CardFactary.creaCard(_editDeckModel.usedMitac[1].id);
						}
						_barArr[8].addEventListener(MouseEvent.MOUSE_DOWN,removeCardMouseHandler);
						_barArr[8].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
						_barArr[9].addEventListener(MouseEvent.MOUSE_DOWN,removeCardMouseHandler);
						_barArr[9].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
						}
			if (_editDeckModel.usedTalisman.length== 0) {
				//无法宝
				_talismanBt.clickEnable = false;//法宝不可选
				}else if (_editDeckModel.usedTalisman.length == 1) {
					_barArr[6].canDrag = true;
					_barArr[6].doubleClickEnabled = true;
					if (_editDeckModel.usedTalisman[0]) {
						_barArr[6].card = CardFactary.creaCard(_editDeckModel.usedTalisman[0].id);
						}
					_barArr[6].addEventListener(MouseEvent.MOUSE_DOWN,removeCardMouseHandler);
					_barArr[6].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
					}else {
						_barArr[6].canDrag = true;
						_barArr[6].doubleClickEnabled = true;
						_barArr[7].canDrag = true;
						_barArr[7].doubleClickEnabled = true;
						if (_editDeckModel.usedTalisman[0]) {
						_barArr[6].card = CardFactary.creaCard(_editDeckModel.usedTalisman[0].id);
						}
						if (_editDeckModel.usedTalisman[1]) {
						_barArr[7].card = CardFactary.creaCard(_editDeckModel.usedTalisman[1].id);
						}
						_barArr[6].addEventListener(MouseEvent.MOUSE_DOWN, removeCardMouseHandler);
						_barArr[6].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
						_barArr[7].addEventListener(MouseEvent.MOUSE_DOWN, removeCardMouseHandler);
						_barArr[7].addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickRemoveCardMouseHandler);
						}
					judgestDeckSet();//设置保存按钮状态
			}
		//--------------------------------------------------------
			/*private function clearCard(arg:CanDragArea):void {
				if (arg.card) {
					arg.card.dispose();
					}
				}*/
		
		//--------------------------------------------------------
		/**
		 * 三个按钮选项都为未选中状态
		 * @param	arg
		 */	
		private function resetTotalOptionNoSelected():void {
			_soldrsBt.setSelected(false);
			_talismanBt.setSelected(false);
			_mitacBt.setSelected(false);
			}
		 
		/**
		 * 选择页码变化时更新界面
		 * @param	param1
		 */
		private function updataUI(arg:Vector.<CardModel>):void {
			//trace(arg.length)
			for (var i:String in arg) {
				if (arg[i] != null) {
					_dragedCardArr[i].visible = true;
					_dragedCardArr[i]._currentCardTye = 1;
					(_dragedCardArr[i] as Card).setCardModel(arg[i]);		
					(_dragedCardArr[i] as Card).showMiddleImage(true);//重新加载图片
					
					//更新可用数量	
					_numArr[i].visible = true;
					_numArr[i].text = _dragedCardArr[i].getCardModel().number.toString()+CANUSER;
					//-----------页码改变时重新设置是否可以点击拖动--------------------
					if (_dragedCardArr[i].getCardModel().number <= 0) {
						_dragedCardArr[i].enable = false;
						if (_dragedCardArr[i].hasEventListener(MouseEvent.MOUSE_DOWN)) {
							_dragedCardArr[i].removeEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
							}
						}else {
							_dragedCardArr[i].enable = true;
							if (!_dragedCardArr[i].hasEventListener(MouseEvent.MOUSE_DOWN)) {
								_dragedCardArr[i].addEventListener(MouseEvent.MOUSE_DOWN, cardMouseDownHandler);
								}
							}
					//----------end----------
					}else {
						_dragedCardArr[i].visible = false;
						_numArr[i].visible = false;
						}
				}
			}	
		
		/**
		 * 指定选择某个按钮
		 * @param	e
		 */	
		private function selectedOption(param:MovieClipButton):void {
			if (_currentSelectdOption != param) {
				_currentSelectdOption.setSelected(false);
				_currentSelectdOption =param;
				resetTotalOptionNoSelected();
				_currentSelectdOption.setSelected(true);
				checkVisible();
				setCardLocAndType();
				
				
				}
			}
			
		/**
		 *三个选项的点击
		 */
		private function optoinClickHandler(e:MouseEvent):void {
			if (_currentSelectdOption != e.currentTarget as MovieClipButton) {
				_currentSelectdOption.setSelected(false);
				_currentSelectdOption = e.currentTarget as MovieClipButton;
				resetTotalOptionNoSelected();
				_currentSelectdOption.setSelected(true);
				checkVisible();
				setCardLocAndType();
				
				
				}
			
			}
			
		/**
		 * 是否替换过卡组,即是否卡组中的ID都相同
		 * @return
		 */	
		private function swapedDeck(value:Vector.<CardModel>):Boolean {
			for (var i:String in value) {
				if (value[i].id != value[0].id) {
					return true;
					}
				}
				return false;
			}
		
		/**
		 * 判断卡组中的卡是否都有了
		 * @param	e
		 */
		private function judgestDeckSet():Boolean {
			switch(_currentSelectdOption) {
				case _soldrsBt:
					if (_editDeckModel.usedSoldierNum == _editDeckModel.usedSoldier.length) {
						if (_editDeckModel.usedSoldierNum == 6) {
							//有六个兵则不用检测下面的
							_saveBt.clickEnable = true;
							
							//-------------------新手引导用-----------------------
							if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && swapedDeck(_editDeckModel.usedSoldier) && NewBieControler.getInstance().currentNewBieModle.levelId == 5) {
								//编辑卡组
								NewBieControler.getInstance().nextStep();
								if (NewBieControler.getInstance().currentNewBieModle.levelId == 6) {
									NewbiePane.getInstance().hide();
									}
								}else if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && !NewBieControler.getInstance()._saveDeck && NewBieControler.getInstance().currentNewBieModle.levelId != 5) {
									//新建卡组
									NewBieControler.getInstance()._saveDeck = true;
									NewBieControler.getInstance().refreshByValue(-1,-1,NewBieControler.EDIT_SAVE);
									}
							
							//--------------------end--------------------
							return true;
							}
						//兵都填完
						if (_editDeckModel.usedTalisman.length != 0 && _editDeckModel.usedTalismaNum!=_editDeckModel.usedTalisman.length) {
							selectedOption(_talismanBt);
							}else {
								//没有法宝或法宝已经填完则检测神通
								if (_editDeckModel.usedMitac.length != 0 && _editDeckModel.usedMitacNum != _editDeckModel.usedMitac.length) {
									selectedOption(_mitacBt);
									}
								}
						
						}
					break;
				case _mitacBt:
					if (_editDeckModel.usedMitacNum == _editDeckModel.usedMitac.length) {
						//神通都填完
						if (_editDeckModel.usedSoldier.length != 0 && _editDeckModel.usedSoldierNum!=_editDeckModel.usedSoldier.length) {
							selectedOption(_soldrsBt);
							}else {
								//没有兵则检测法宝
								if (_editDeckModel.usedTalisman.length != 0 && _editDeckModel.usedTalismaNum != _editDeckModel.usedTalisman.length) {
									selectedOption(_talismanBt);
									}
								}
						
						}
					break;
				case _talismanBt:
					if (_editDeckModel.usedTalismaNum == _editDeckModel.usedTalisman.length) {
						//法宝都填完
						if (_editDeckModel.usedSoldier.length != 0 && _editDeckModel.usedSoldierNum!=_editDeckModel.usedSoldier.length) {
							selectedOption(_soldrsBt);
							}else {
								//兵填完则检测神通
								if (_editDeckModel.usedMitac.length != 0 && _editDeckModel.usedMitacNum != _editDeckModel.usedMitac.length) {
									selectedOption(_mitacBt);
									}
								}
						
						}
					break;
				}
			
			
			
			var tempDeckCards:Array = _editDeckModel.cards;
			var tempTotalNum:int = _editDeckModel.hero.ally + _editDeckModel.hero.talisman + _editDeckModel.hero.mitac;
			trace(tempTotalNum)
			//去掉英雄（-1）
			if ((tempDeckCards.length-1) != tempTotalNum) {
				_saveBt.clickEnable=false;
				return false;
				}
				_saveBt.clickEnable = true;
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]  && NewBieControler.getInstance().currentNewBieModle.levelId == 5) {
					//编辑卡组
					NewBieControler.getInstance().nextStep();
					}else if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && !NewBieControler.getInstance()._saveDeck && NewBieControler.getInstance().currentNewBieModle.levelId != 5) {
						//新建卡组
						NewBieControler.getInstance()._saveDeck = true;
						NewBieControler.getInstance().refreshByValue( -1, -1, NewBieControler.EDIT_SAVE);
						NewbiePane.getInstance().show();
						}
				
				//--------------------end--------------------
				return true;
			}
		 
		/**
		 * 保存卡组
		 */
		private function saveClick(e:MouseEvent):void {
			if (_deckNameText.text.length == 0) {
				AlertConfirmPane.getInstance().type = 0;
                AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CreaDeckPanel.DeckNameInvalid.@Text);
				return;
				}
			if (!judgestDeckSet()) {
				//卡组设置有错
				Debug.log("卡组设置有错");
				return;
				}
			var editDeckCallBack:Function = function(param1:Object):void {
				var tempDecks:Vector.<DeckModel> = PlayerData.getInstance().decks;
				for (var i:String in tempDecks) {
					if (tempDecks[i].id == deckId) {
						tempDecks[i].cards = _editDeckModel.cards;
						tempDecks[i].deckName = _deckNameText.text;
						break;
						}
					}
				
				PlayerData.getInstance().decks = tempDecks;//刷新队伍设置界面
				
				_savedFlag = true;
				hide();
				
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					NewBieControler.getInstance().nextStep();
					SMZTController.getInstance().SetNext(NewBieModelId.FISET);
					}
				//--------------------end--------------------
				}
			
			
			SMZTController.getInstance().CreaCardGroup(deckId,_deckNameText.text, _editDeckModel.cards, editDeckCallBack);
			}
	
		//--------------------------------------------------------
		//--------------------------------------------------------
		public function get deckId() : int
		 {
			 _deckId = _editDeckModel.editDeckId;
		   return _deckId;
		}// end function
		
		public function set deckId(param1:int) : void
		{
		  _deckId = param1;
		  _editDeckModel.editDeckId = _deckId;
		  return;
		}// end function
		public function get oldDeckSoldiers() :Vector.<CardModel>
		 {
		   return _oldDeckSoldiers;
		}// end function
		
		public function set oldDeckSoldiers(param1:Vector.<CardModel>) : void
		{
		  _oldDeckSoldiers= param1;
		  return;
		}// end function
		//--------------------------------------------------------
		//要编辑的卡组数据变化（初始化）
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			//_oldDeckSoldiers = new Vector.<CardModel>();
			
			_savedFlag = false;
			
			_heroImage.ico = _editDeckModel.hero.charactersImage;//英雄大图像地址
			_heroImage.showBg = false;
			_heroBigImage.addChild(_heroImage);
			
			//英雄卡
			var cardMod:CardModel = new CardModel(_editDeckModel.hero.id, 1);
			_heroCard._currentCardTye =1;
			_heroCard.setCardModel(cardMod);
			_heroCard.showTip = true;
			_heroCard.showMiddleImage(true);
			cardMod = null;
			
			_deckNameText.text = _editDeckModel.deckName;
			
			
			_currentClickDragedCard = new Card();
			//_currentClickDragedCard.visible = false;
			//addChild(_currentClickDragedCard)
			
			checkUpPard();
			
			if (_currentSelectdOption) {
				_currentSelectdOption.setSelected(false);//去掉之前所选的选项选中状态
				}
			_currentSelectdOption = _soldrsBt;//默认选兵
			_currentSelectdOption.clickEnable = true;
			_currentSelectdOption.setSelected(true);
			
			checkVisible();
			setCardLocAndType();
			
			
            return;
        }// end function
		//--------------------------------------------------------
		//显示
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
                }
                rootContainer.addChild(this);
				//trace("_spriteInstance.width="+_spriteInstance.width)
                this.x = (ApplicationConfig.STAGE_WIDTH - 746) / 2;
                this.y =-40;
                if (this.showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				
				//增加键盘CTRL侦听
				/*if (AppliactionManager.stage) {
					AppliactionManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					AppliactionManager.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				}*/
				
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
            }
            this.playShowSound();
            return;
        }// end function
		
		private function keyUpHandler(e:KeyboardEvent):void 
		{
			//stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			ApplicationConfig._ctrlKeyDown = false;
		}
		
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			//stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			if (e.shiftKey) {
				ApplicationConfig._ctrlKeyDown = true;
				}
		}
		
		//--------------------------------------------------------
		//--------------------------------------------------------	
		
		public static function getInstance() :EditDeckPanel
        {
            if (_instance == null)
            {
                _instance = new EditDeckPanel();
            }
            return _instance;
        }// end function
	}

}