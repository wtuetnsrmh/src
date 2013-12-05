package project.view.module.DeckPane 
{
	import flash.display.Sprite;
	import project.view.common.LogicView;
	import project.view.common.MyButton;
	import project.view.layout.BaseGridContainer;
	import project.view.scene.IScene;
	import starling.text.TextField;
	
	/**
	 * 卡组设置1界面
	 * @author bbjxl 2012
	 */
	public class CreaCardGroupPane extends LogicView implements IScene
	{
		public static const CLASS_NAME:String = "CreaCardGroupPanel";
		
		
		//--------------------------------------------------------
		private var _cardBar:Sprite;
		//private var _heroBigImage:Sprite;//头像容器的容器
		//private var _heroImage:BaseIcoCell;//头像容器
		private var _gridContainer:BaseGridContainer;//卡组英雄卡
		private var _armsCotainer:BaseGridContainer;//兵的容器
		private var _heroGrid:Sprite;//卡组英雄卡容器
		
		private var _deckName:TextField;//卡组名字
		//--------------------------------------------------------
		private var _editCG:MyButton;//编辑卡组
		private var _cancelCG:MyButton;//解除卡组
		private var _closeBt:MyButton;//关闭
		//--------------------------------------------------------
		private var _totalDeckHeroCardArr:Array;//所有的卡组英雄
		private var playerData:PlayerData;
		private var _crrentSelectedDeck:AddDeckCell;//当前选中的卡组
		private var _sixArms:Vector.<Card>;//六个兵
		private var _currentCreaDeckId:int = 0;//当前要创建的卡组ID
		private static const MAX_DECK:int =20;//总共20个槽
		//--------------------------------------------------------
		
		
		private static var _instance:CreaCardGroupPane;
		
		public function CreaCardGroupPane() 
		{
			
			
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("CreaCardGroupPane");
			configerUIInstance();
			
			this.playerData = PlayerData.getInstance();
            dataModel = this.playerData;
			this.playerData.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, this.onPlayerDataRefresh);//用户个人数据刷新之后触发
			
			_crrentSelectedDeck = new AddDeckCell();
			_sixArms = new Vector.<Card>();
			_totalDeckHeroCardArr = new Array();
			//增加卡组英雄卡区
			var temprow:int = 5;// (Math.ceil((playerData.decks.length) / 4) < 2)?2:Math.ceil(playerData.decks.length / 4);
			//trace("temprow=" + temprow);
			this._gridContainer = new BaseGridContainer(temprow,4,2, 110, 154);
            this._gridContainer.setLocation(254.3, 57.25);
            _heroGrid.addChild(this._gridContainer);
			
			//兵
			_armsCotainer = new BaseGridContainer(1, 6, 15.5, ApplicationConfig.CARD_WIDTH >>1, ApplicationConfig.CARD_HEIGHT >>1);
			_armsCotainer.setLocation(_cardBar.x+3, _cardBar.y);
			addChild(_armsCotainer);
			for (var i:uint = 0; i < 6; i++ ) {
				var tempArm:Card = new Card();
				tempArm.showTip = true;
				tempArm.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				tempArm.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				_armsCotainer.appendChild(tempArm);
				_sixArms.push(tempArm);
				}
			
			//this.addEventListener(MouseEvent.CLICK, clickahandler);
		}
		
		/*private function clickahandler(e:MouseEvent):void 
		{
			if(e.target is Card)//trace("card")
			trace(e.target)
		}*/
		
		//关闭
        override public function hide(event:MouseEvent = null) : void
        {
			
			//MouseWheelEnabler.enable(false);
			
            if (rootContainer)
            {
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
                if (showEffect)
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
				
				if (closeButton) {
					ApplicationController.removeAtWin(this);
					}
					
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					NewBieControler.getInstance().nextStep();
					}
				//--------------------end--------------------
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		/**
		 * 解散卡组
		 * @param	e
		 */
		private function deleteDeckClickHandler(e:MouseEvent):void {
			if (_crrentSelectedDeck.card == null || currentCreaDeckId == 0) {
				_deckName.text = "";
				_heroImage.visible = false;
				return;
				}
			
			var sendDeleteDeck:Function = function(okOrCancel:String):void {
				if (okOrCancel==AlertSelectPane.ALERT_YES) {
					SMZTController.getInstance().DeleteDeck(currentCreaDeckId, deleteDeckCallBack);
					}
				}
			AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CreaDeckPanel.DeleteDeck.@Text,sendDeleteDeck,true);
			
			var deleteDeckCallBack:Function = function(param1:Object):void {
				var tempDecks:Vector.<DeckModel> = PlayerData.getInstance().decks;
				for (var i:String in tempDecks) {
					if (tempDecks[i].id == currentCreaDeckId) {
						tempDecks[i].cards = null;
						//playerData.recoveryDeckCard(currentCreaDeckId);
						//tempDecks[i].deckName = _deckNameText.text;//名字不还原
						break;
						}
					}
					
				_deckName.text = "";
				_heroImage.visible = false;
				
				PlayerData.getInstance().decks = tempDecks;//刷新队伍设置界面
				
				}
			}
		
		/**
		 * 编辑卡组
		 * @param	e
		 */
		private function editDeckClickHandler(e:MouseEvent):void {
			if (_crrentSelectedDeck.card == null || currentCreaDeckId == 0) {
				return;
				}
			
			SMZTUIManager.getInstance().editDeckPandl.oldDeckSoldiers = _crrentSelectedDeck.arms;
			SMZTUIManager.getInstance().editDeckPandl.deckId = currentCreaDeckId;
			SMZTUIManager.getInstance().editDeckPandl.show(true);
			}
		/**
		 * 数据更新
		 * @param	e
		 */
		private function onPlayerDataRefresh(e:SMZTDataChangeEvent):void {
			if (e.dataType == CLASS_NAME) {
				updataUI();
				}
			
			}
		
		private function rollOverHandler(e:MouseEvent):void {
			(e.currentTarget as Card).selected = true;
			}
		private function rollOutHandler(e:MouseEvent):void {
			(e.currentTarget as Card).selected = false;
			}
		//--------------------------------------------------------
		//显示
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
				//MouseWheelEnabler.enable(true);
				
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - _spriteInstance.width) / 2;
                this.y =-40;
                if (this.showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				if (_scroll) {
					_scroll.setLocationByRate();
					}
					
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
					
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					NewBieControler.getInstance().nextStep();
					}
				//--------------------end--------------------
            }
            this.playShowSound();
            return;
        }// end function
		//--------------------------------------------------------
		
		//刷新UI
		private function updataUI():void {
			_heroImage.visible = true;
			
			var oneflag:Boolean = true;//显示增加按钮
			var oneUnlockflag:Boolean = true;//显示解锁按钮，水晶数
			//清空之前的
			_gridContainer.removeAll();
			if (_totalDeckHeroCardArr.length > 0) {
				for (var j:String in _totalDeckHeroCardArr) {
					if ((_totalDeckHeroCardArr[j] as AddDeckCell).hasEventListener(MouseEvent.CLICK)) {
						(_totalDeckHeroCardArr[j] as AddDeckCell).removeEventListener(MouseEvent.CLICK, selectedDeck);
						}
					}
				}
			_totalDeckHeroCardArr = new Array();
			
			//var addNum:int = Math.ceil((playerData.decks.length+1) / 4) * 4;
			//addNum = MAX_DECK;// (addNum < 8)?8:addNum;//最少八个框
			////trace("addNum=" + addNum)
			
			//findUsedDecks();
			for (var i:uint = 0; i <MAX_DECK; i++ ) {
				var tempCell:AddDeckCell = new AddDeckCell();
				////trace("playerData.decks[i].id="+playerData.decks[i].id)
				tempCell.deckId = playerData.decks[i].id;
				tempCell.cards = playerData.decks[i].cards;
				tempCell.locked = playerData.decks[i].locked;
				if (tempCell.cards) {
					tempCell.addCard();
					_totalDeckHeroCardArr.push(tempCell);
					tempCell.buttonMode = true;
					tempCell.addEventListener(MouseEvent.CLICK, selectedDeck);
					
					}else {
						//在第一个没有卡的框中显示增加按钮
						if (oneflag) {
							if (tempCell.locked == 0) {
								//如果没有加锁就显示增加卡组按钮
								//oneflag = false;(有这功能就加上这个判断，现在是都显示加按钮)*******
								tempCell.showAddBt(true);
								}else {
									if (oneUnlockflag) {
										//显示解锁水晶数
										tempCell.showUnlock();
										oneUnlockflag = false;
										}else {
											//显示加锁图标
											tempCell.showLockIco();
											}
									tempCell.showAddBt(false);
									}
							
							}else {
								tempCell.showAddBt(false);
								if (tempCell.locked == 1) {
									//如果为锁状态
									if (oneUnlockflag) {
										//显示解锁水晶数
										tempCell.showUnlock();
										oneUnlockflag = false;
										}else {
											//显示加锁图标
											tempCell.showLockIco();
											}
									}
								}
					}
				_gridContainer.appendChild(tempCell);
				tempCell = null;
				}
			
			//增加滚动条控制
			if(!_scroll){
			_scroll=new MyScrollBar(_gridContainer,"L",16,0,"L",1,15,true,true,_gridContainer.width,310,176,Reflection.getClass("ScroStrye",SMZTDomainManager.getInstance().currentUIAppDomain));
			_scroll.y = 55;
			addChild(_scroll)
			}else {
				_scroll.setLocationByRate();
				}
			trace(_totalDeckHeroCardArr.length)
			
			//如果有卡组，默认选择第一个卡组
			if (_totalDeckHeroCardArr.length > 0) {
				_crrentSelectedDeck = _totalDeckHeroCardArr[0];
				selectedDeck(null);
				_heroImage.visible = true;
				_armsCotainer.visible = true;
				}else {
					currentCreaDeckId = 0;
					_heroImage.visible = false;//没有卡组时隐藏英雄大图
					_armsCotainer.visible = false;//隐藏下面的六张图
					}
			}
		//--------------------------------------------------------
		//从服务端返回的卡组数据中把有数据的卡组放到前面
		private function findUsedDecks():void {
			//var tempUsed:Vector.<DeckModel> = new Vector.<DeckModel>();
			for (var i:int=playerData.decks.length - 1; i > 0;i--) {
				if (playerData.decks[i].cards != null && playerData.decks[i].cards.length > 0) {
					//交换到第一位
					var a:DeckModel = playerData.decks[0];
					playerData.decks[0] = playerData.decks[i];
					playerData.decks[i] = a;
					}
				}
			}
			
		//--------------------------------------------------------	
		//选择卡组时，对应的显示他们所带的兵
		private function selectedDeck(e:MouseEvent):void {
			////trace("selectedDeck")
			
			if (e) {
				if (_crrentSelectedDeck) {
					if (_crrentSelectedDeck != (e.currentTarget as AddDeckCell)) {
						//当前点击不是之前的英雄
						_crrentSelectedDeck = (e.currentTarget as AddDeckCell);
						_heroImage.visible = true;
						}else {
							return;
							}
					}
			
			}
			resetHeroCardSelectState();
			_deckName.text = PlayerData.getInstance().returnDeckModelByDeckId(_crrentSelectedDeck.deckId).deckName;
			
			_heroImage.ico = _crrentSelectedDeck.card.getCardModel().charactersImage;//英雄大图像地址
			_heroImage.showBg = false;
			_heroBigImage.addChild(_heroImage);
			
			_crrentSelectedDeck.card.selected = true;
			for (var i:String in _crrentSelectedDeck.arms) {
				_sixArms[i].setCardModel(_crrentSelectedDeck.arms[i]);
				}
				
			_currentCreaDeckId = _crrentSelectedDeck.deckId;
			}
		
		//所有英雄卡未选中状态
		private function resetHeroCardSelectState():void {
			for (var i:String in _totalDeckHeroCardArr) {
				_totalDeckHeroCardArr[i].card.selected = false;
				}
			}
			
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			
		}
		
		private function configerUIInstance():void {
			_customScrollUI = getChild("customScrollUI") as Sprite;
			_heroGrid = getChild("heroGrid") as Sprite;
			_heroBigImage = getChild("heroBigImage") as Sprite;
			_editCG = getChild("editCG") as MovieClipButton;
			_cancelCG = getChild("cancelCG") as MovieClipButton;
			_deckName = getChild("deckName") as TextField;
			//置顶
			addChild(_editCG);
			_editCG.onClick = editDeckClickHandler;
			
			addChild(_cancelCG);
			_cancelCG.onClick = deleteDeckClickHandler;
			
			_cardBar = getChild("cardBar") as Sprite;
			
			_heroImage = new BaseIcoCell();
			
			}
			
		//--------------------------------------------------------
		public function get currentCreaDeckId() : int
			 {
			   return _currentCreaDeckId;
			}// end function
			
		public function set currentCreaDeckId(param1:int) : void
			{
			  _currentCreaDeckId= param1;
			  return;
			}// end function	
			
		//--------------------------------------------------------	
		
		public static function getInstance() : CreaCardGroupPane
        {
            if (_instance == null)
            {
                _instance = new CreaCardGroupPane();
            }
            return _instance;
        }// end function
	}

}