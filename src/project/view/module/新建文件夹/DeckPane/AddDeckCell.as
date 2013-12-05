package project.view.module.DeckPane 
{
	
	import project.Cellcard.Card;
	import project.config.ItemConfig;
	import project.config.SpecialItemIdConfig;
	//import project.controller.SMZTController;
	//import project.model.data.BagData;
	import project.model.data.DeckModel;
	import project.model.data.PlayerData;
	import project.model.item.CardModel;
	import project.utils.CardFactary;
	import project.view.common.MyButton;
	//import project.view.module.bagpanel.UseItemControler;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * 增加卡组选区
	 * @author bbjxl 2012
	 */
	public class AddDeckCell extends Sprite 
	{
		private var _ui:Sprite;//UI界面
		private var _card:Card;//英雄卡
		private var _content:Sprite;//卡牌容器
		
		//-----------------------ui---------------------------------
		private var _lockBg:Sprite;//加锁背景
		private var _unlockBt:MyButton;//解锁按钮
		private var _lockIco:Image;//加锁图标
		private var _unlockText:TextField;//解锁需要的水晶数量
		
		private var _addDeckBt:MyButton;//增加卡组按钮
		//--------------------------------------------------------
		private var _cards:Array;//该张英雄带的兵ID(包括英雄卡)
		private var _arms:Vector.<CardModel>;//所带的兵（不包括英雄卡）
		private var _deckId:int = 0;//当前的卡组ID
		private var _locked:int;//是否加锁
		
		
		public function AddDeckCell():void 
		{
			_arms = new Vector.<CardModel>();
			_cards = new Array();
			_content = new Sprite();
			addChild(_content);
			_addDeckBt = ApplictionConfig.creaMyBt("增加卡组图标");
			
			_lockBg = new Sprite();
			_unlockBt = ApplictionConfig.creaMyBt("tabBarDefault", "解锁");
			
			_lockIco= ApplictionConfig.creaImage("锁");
			_unlockText = ApplictionConfig.creaText(100, 20, "X1");
			
			addChild(_unlockBt);
			addChild(_lockIco);
			addChild(_unlockText);
			addChild(_addDeckBt);
			_addDeckBt.visible = false;
			
		}
		/**
		 * 增加卡组按钮点击
		 * @param	arg
		 */
		private function addDeckClickHandler(e:Event):void {
			SelecteRacePanel.getInstance().currentCreaDeckId = deckId;//当前要创建的卡组ID
			
			SelecteRacePanel.getInstance().show(true);
			
			//-------------------新手引导用-----------------------
			/*if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
				NewBieControler.getInstance().nextStep();
				}*/
			//--------------------end--------------------
			}
		
		
		/**
		 * 显示增加按钮
		 */
		public function showAddBt(arg:Boolean = true):void {
			_addDeckBt.visible = arg;
			if (arg)_addDeckBt.onClick = addDeckClickHandler;
			}
		
		/**
		 * 显示卡中的英雄卡
		 */
		public function addCard():void {
			for (var i:String in _cards) {
				var temp:CardModel = new CardModel(_cards[i]);
				if (temp.ally > 0) {
					//英雄
					_card = CardFactary.creaCard(_cards[i],1,1,false);
					}else {
						//佣兵
						_arms.push(temp);
						}
				}
			if(_arms.length>0){	
				sortCardModels(_arms);
				}
			_content.addChild(_card);
			}
		/**
		 * 排序：兵，装备，卷轴
		 */
		public function sortCardModels(parma:Vector.<CardModel>):void {
			var tempSolder:Vector.<CardModel>=new Vector.<CardModel>();
			var tempTail:Vector.<CardModel>=new Vector.<CardModel>();
			var tempMatic:Vector.<CardModel>=new Vector.<CardModel>();
			for (var i:String in parma) {
				if (parma[i]._Class < 12) {
					tempSolder.push(parma[i]);
					}else if (parma[i]._Class == 12) {
						tempTail.push(parma[i]);
						}else if (parma[i]._Class == 13) {
							tempMatic.push(parma[i]);
							}
				}
			_arms = tempSolder.concat(tempMatic,tempTail);
			}
		//--------------------------------------------------------
		/**
		 * 显示解锁需要的水晶数
		 */
		public function showUnlock():void {
			_lockIco.visible = false;
			_lockBg.visible = true;
			_unlockText.visible = true;
			_unlockBt.visible = true;
			
			_unlockBt.onClick = unlockClick;
			}
		/**
		 * 解锁按钮点击
		 * @param	e
		 */
		private function unlockClick(e:Event):void {
			/*if (!BagData.getInstance().bagExistItem(SpecialItemIdConfig.UNLOCK_DECK, int(ItemConfig.DECKS_CONFIG.Deck.(@ID == deckId).RequiredItem.@Amount))) {
				//物品不够时
				UseItemControler.showBuyWin(SpecialItemIdConfig.UNLOCK_DECK);
				return;
				}
			
			var unlockCallBack:Function = function(param1:Object):void {
				var tempDecks:Vector.<DeckModel> = PlayerData.getInstance().decks;
				for (var i:String in tempDecks) {
					if (tempDecks[i].id == deckId) {
						tempDecks[i].locked = 0;
						break;
						}
					}
				//刷新背景数据
				SMZTController.getInstance().getBagData(false, function():void {
					PlayerData.getInstance().decks = tempDecks;//刷新队伍设置界面
					});
				}
			
			SMZTController.getInstance().UnlockDeckItem(deckId,unlockCallBack);*/
			}
		/**
		 * 显示加锁图标
		 */
		public function showLockIco():void {
			_lockIco.visible = true;
			_lockBg.visible = true;
			_unlockText.visible = false;
			_unlockBt.visible = false;
			}
		//--------------------------------------------------------
		public function get locked() : int
		 {
		   return _locked;
		}// end function
		
		public function set locked(param1:int) : void
		{
		  _locked = param1;
		  
		  if (_locked == 0) {
			  //解锁状态
			  _lockIco.visible = false;
			  _lockBg.visible = false;
			  _unlockText.visible = false;
			  _unlockBt.visible = false;
			  }else {
				  /*_lockIco.visible = false;
				  _lockBg.visible = false;
				  _unlockText.visible = false;
				  _unlockBt.visible = false;
				  _crystalIco.visible = false;*/
				  //解锁物品ID
				  var unlockItemId:int = ItemConfig.DECKS_CONFIG.Deck.(@ID == deckId).RequiredItem.@ID;
				  _unlockText.text = "X" + ItemConfig.DECKS_CONFIG.Deck.(@ID == deckId).RequiredItem.@Amount;//解锁所需数量
				  }
		  return;
		}// end function
		public function get arms() : Vector.<CardModel>
		 {
		   return _arms;
		}// end function
		
		public function set arms(param1:Vector.<CardModel>) : void
		{
		  _arms= param1;
		  return;
		}// end function
			
		public function removeCard():void {
			_card.dispose();
			_card = null;
			}
		
		public function get deckId() : int
			 {
			   return _deckId;
			}// end function
			
		public function set deckId(param1:int) : void
			{
			  _deckId= param1;
			  return;
			}// end function	
			
		public function get cards() : Array
		 {
		   return _cards;
		}// end function
		
		public function set cards(param1:Array) : void
		{
		  _cards= param1;
		  return;
		}// end function
			
		public function get card() : Card
		 {
		   return _card;
		}// end function
		
		public function set card(param1:Card) : void
		{
		  _card = param1;
		  
		  return;
		}// end function
		
	}

}