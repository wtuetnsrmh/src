package project.view.scene.soldierLib
{
	/**
	 *佣兵团
	 */
	import flash.display3D.textures.Texture;
	import flash.system.System;
	import project.config.LocalConfig;
	import project.model.data.DeckModel;
	import project.model.data.PlayerData;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.DeckPane.AddDeckCell;
	
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import khaos.view.ViewType;
	
	import lzm.starling.display.ScrollContainer;
	
	import project.Cellcard.Card;
	import project.model.item.CardModel;
	import project.utils.CardFactary;
	import project.view.bottonBar.BottonBar;
	import project.view.common.LogicView;
	import project.view.common.MyButton;
	import project.view.layout.BaseGridContainer;
	import project.view.scene.IScene;
	import project.view.scene.editDeckPanel.DeckItem;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class SoldierLibScene extends LogicView implements IScene
	{
		private var _bgLayer:Sprite;
		private var _cardList:Vector.<Card>;
		private var _cardDecBg:Image;
		private var _editDeckBt:MyButton;
		private var _deleteDeckBt:MyButton;
		private var _returnBt:MyButton;
		private var _deckName:TextField;
		private var _totalDeckHeroCardArr:Vector.<AddDeckCell>;//所有的卡组英雄
		
		private var _deckgrid:BaseGridContainer;
		private var _grid:BaseGridContainer;
		private var _scrollCont:ScrollContainer;
		
		private var playerData:PlayerData;
		private var _crrentSelectedDeck:AddDeckCell; //当前选中的卡组
		private var _sixArms:Vector.<Card>; //六个兵
		private var _currentCreaDeckId:int = 0; //当前要创建的卡组ID
		private static const MAX_DECK:int = 8; //总共20个槽
		
		public function SoldierLibScene()
		{
			super(ViewType.MULTI_DIALOG);
		}
		
		public function updata():void
		{
		}
		
		/**
		 *只建立公共材质里有的UI界面 -初始化时调用，早于show()
		 *
		 */
		override public function initUI():void
		{
			this.playerData = PlayerData.getInstance();
			
			_bgLayer = new Sprite();
			addChild(_bgLayer);
			
			var bg:Scale9Image = ApplictionConfig.createS9Image(855.95, 640, 1);
			_bgLayer.addChild(bg);
			creadBarbg(593.9, 268.05, 57.05, 122.95);
			creadBarbg(213, 48.35, 271.95, 62.75);
			creadBarbg(807.2, 191.5, 28.45, 404.7);
			
			_returnBt = new MyButton("returnBt");
			_returnBt.x = 721.95;
			_returnBt.y = 0;
			_bgLayer.addChild(_returnBt);
			_returnBt.addEventListener(Event.TRIGGERED, backClick);
			
			_editDeckBt = new MyButton("buttonBg", "编辑卡组");
			_editDeckBt.x = 662;
			_editDeckBt.y = 201.55;
			_bgLayer.addChild(_editDeckBt);
			
			_deleteDeckBt = new MyButton("buttonBg", "解散卡组");
			_deleteDeckBt.x = 662;
			_deleteDeckBt.y = 303.55;
			_bgLayer.addChild(_deleteDeckBt);
			
			_bgLayer.flatten();
			
			_deckName = ApplictionConfig.creaText(100, 20, "");
			_deckName.y = 300;
			addChild(_deckName);
			_crrentSelectedDeck = new AddDeckCell();
			
			this.x = ApplictionConfig.STAGE_WIDTH - this.width >> 1;
			this.y = ApplictionConfig.STAGE_HEIGHT - this.height >> 1;
		}
		
		/**
		 * 解散卡组
		 * @param	e
		 */
		private function deleteDeckClickHandler(e:Event):void
		{
			if (_crrentSelectedDeck.card == null || currentCreaDeckId == 0)
			{
				_deckName.text = "";
				//_heroImage.visible = false;
				return;
			}
			
			var sendDeleteDeck:Function = function(okOrCancel:String):void
			{
				if (okOrCancel == AlertSelectPane.ALERT_YES)
				{
					SMZTController.getInstance().DeleteDeck(currentCreaDeckId, deleteDeckCallBack);
				}
			}
			AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CreaDeckPanel.DeleteDeck.@Text, sendDeleteDeck, true);
			
			var deleteDeckCallBack:Function = function(param1:Object):void
			{
				var tempDecks:Vector.<DeckModel> = PlayerData.getInstance().decks;
				for (var i:String in tempDecks)
				{
					if (tempDecks[i].id == currentCreaDeckId)
					{
						tempDecks[i].cards = null;
						//playerData.recoveryDeckCard(currentCreaDeckId);
						//tempDecks[i].deckName = _deckNameText.text;//名字不还原
						break;
					}
				}
				
				_deckName.text = "";
				//_heroImage.visible = false;
				
				PlayerData.getInstance().decks = tempDecks; //刷新队伍设置界面
				internalHide();//相当于刷新当前界面
				internalShow();
			}
		}
		
		/**
		 * 编辑卡组
		 * @param	e
		 */
		private function editDeckClickHandler(e:Event):void
		{
			if (_crrentSelectedDeck.card == null || currentCreaDeckId == 0)
			{
				return;
			}
			
			SMZTUIManager.getInstance().editDeckPandl.oldDeckSoldiers = _crrentSelectedDeck.arms;
			SMZTUIManager.getInstance().editDeckPandl.deckId = currentCreaDeckId;
			SMZTUIManager.getInstance().editDeckPandl.show(true);
		}
		
		//--------------------------------------------------------
		//从服务端返回的卡组数据中把有数据的卡组放到前面
		private function findUsedDecks():void
		{
			//var tempUsed:Vector.<DeckModel> = new Vector.<DeckModel>();
			for (var i:int = playerData.decks.length - 1; i > 0; i--)
			{
				if (playerData.decks[i].cards != null && playerData.decks[i].cards.length > 0)
				{
					//交换到第一位
					var a:DeckModel = playerData.decks[0];
					playerData.decks[0] = playerData.decks[i];
					playerData.decks[i] = a;
				}
			}
		}
		
		//--------------------------------------------------------	
		//选择卡组时，对应的显示他们所带的兵
		private function selectedDeck(e:Event):void
		{
			////trace("selectedDeck")
			
			if (e)
			{
				if (_crrentSelectedDeck)
				{
					if (_crrentSelectedDeck != (e.currentTarget as AddDeckCell))
					{
						//当前点击不是之前的英雄
						_crrentSelectedDeck = (e.currentTarget as AddDeckCell);
						//_heroImage.visible = true;
					}
					else
					{
						return;
					}
				}
				
			}
			resetHeroCardSelectState();
			_deckName.text = PlayerData.getInstance().returnDeckModelByDeckId(_crrentSelectedDeck.deckId).deckName;
			
			//_heroImage.ico = _crrentSelectedDeck.card.getCardModel().charactersImage; //英雄大图像地址
			//_heroImage.showBg = false;
			//_heroBigImage.addChild(_heroImage);
			
			_crrentSelectedDeck.card.selected = true;
			for (var i:String in _crrentSelectedDeck.arms)
			{
				_sixArms[i].setCardModel(_crrentSelectedDeck.arms[i]);
			}
			
			_currentCreaDeckId = _crrentSelectedDeck.deckId;
		}
		
		//所有英雄卡未选中状态
		private function resetHeroCardSelectState():void
		{
			for (var i:String in _totalDeckHeroCardArr)
			{
				_totalDeckHeroCardArr[i].card.selected = false;
			}
		}
		
		//--------------------------------------------------------
		public function get currentCreaDeckId():int
		{
			return _currentCreaDeckId;
		} // end function
		
		public function set currentCreaDeckId(param1:int):void
		{
			_currentCreaDeckId = param1;
			return;
		} // end function	
		
		//--------------------------------------------------------	
		private function backClick(e:Event):void
		{
			if (BottonBar._sceneList.length > 0)
			{
				(Root.vmgr.getView(BottonBar) as BottonBar).showScene(BottonBar._sceneList.pop());
				
			}
		}
		
		private function creadBarbg(w:Number, h:Number, _x:Number, _y:Number):void
		{
			var barbg:Scale9Image = ApplictionConfig.createS9Image(w, h, 2);
			barbg.x = _x;
			barbg.y = _y;
			_bgLayer.addChild(barbg);
		}
		
		override protected function internalHide():void
		{
			//删除UI层以外的对象
			if (this.visible)
			{
				//清空之前的
				for (var i:String in _totalDeckHeroCardArr)
				{
					_totalDeckHeroCardArr[i].removeFromParent(true);
				}
				_totalDeckHeroCardArr = null;
				_deckgrid.removeAll(true);
				_deckgrid.dispose();
				_deckgrid = null;
				
				for (var j:int = 0; j < _cardList.length; j++)
				{
					_cardList[j].dispose();
				}
				_cardList = null;
				_grid.removeAll(true);
				_grid.dispose();
				_grid = null;
			}
		
		}
		
		override protected function internalShow():void
		{
			if (this.visible)
			{
				System.gc();
				_cardList = new Vector.<Card>();
				_grid = new BaseGridContainer(1, 6, 10, ApplictionConfig.MIDDLE_CARD_WIDTH, ApplictionConfig.MIDDLE_CARD_HEIGHT);
				if (!this.contains(_grid))
				{
					_grid.x = 41.05;
					_grid.y = 414.6;
					addChild(_grid);
				}
				for (var i:int = 0; i < 6; i++)
				{
					var tempCard:Card = CardFactary.creaCard(i + 10);
					_cardList.push(tempCard);
					_grid.appendChild(tempCard);
				}
				
				var oneflag:Boolean = true; //显示增加按钮
				var oneUnlockflag:Boolean = true; //显示解锁按钮，水晶数
				
				_totalDeckHeroCardArr = new Vector.<AddDeckCell>();
				_deckgrid = new BaseGridContainer(2, 4, 10, 100, 100);
				/*for (var i:int = 0; i < 8; i++)
				{
					var tempDeckItem:AddDeckCell = new AddDeckCell();
					_deckgrid.appendChild(tempDeckItem);
					tempDeckItem = null;
				}
					_totalDeckHeroCardArr.push(tempDeckItem);
				addChild(_deckgrid);*/
				
				for (var i:uint = 0; i < MAX_DECK; i++)
				{
					var tempCell:AddDeckCell = new AddDeckCell();
					tempCell.deckId = playerData.decks[i].id;
					tempCell.cards = playerData.decks[i].cards;
					tempCell.locked = playerData.decks[i].locked;
					if (tempCell.cards)
					{
						tempCell.addCard();
						_totalDeckHeroCardArr.push(tempCell);
						tempCell.addEventListener(Event.TRIGGERED,selectedDeck);
						
					}
					else
					{
						//在第一个没有卡的框中显示增加按钮
						if (oneflag)
						{
							if (tempCell.locked == 0)
							{
								//如果没有加锁就显示增加卡组按钮
								//oneflag = false;(有这功能就加上这个判断，现在是都显示加按钮)*******
								tempCell.showAddBt(true);
							}
							else
							{
								if (oneUnlockflag)
								{
									//显示解锁水晶数
									tempCell.showUnlock();
									oneUnlockflag = false;
								}
								else
								{
									//显示加锁图标
									tempCell.showLockIco();
								}
								tempCell.showAddBt(false);
							}
							
						}
						else
						{
							tempCell.showAddBt(false);
							if (tempCell.locked == 1)
							{
								//如果为锁状态
								if (oneUnlockflag)
								{
									//显示解锁水晶数
									tempCell.showUnlock();
									oneUnlockflag = false;
								}
								else
								{
									//显示加锁图标
									tempCell.showLockIco();
								}
							}
						}
					}
					_deckgrid.appendChild(tempCell);
					tempCell = null;
				}
				//如果有卡组，默认选择第一个卡组
				if (_totalDeckHeroCardArr.length > 0)
				{
					_crrentSelectedDeck = _totalDeckHeroCardArr[0];
					selectedDeck(null);
					//_heroImage.visible = true;
					_grid.visible = true;
				}
				else
				{
					currentCreaDeckId = 0;
					//_heroImage.visible = false; //没有卡组时隐藏英雄大图
					_grid.visible = false; //隐藏下面的六张图
				}
				
				
			}
		
		}
	}
}