package project.view.module.event.eventTower 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.event.eventTower.EventTowerModel;
	import project.model.event.eventTower.ExchangeGoods;
	import project.model.friends.BonusModel;
	import project.model.item.CardModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.cell.Card;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class ExchangeGoodPanleUI extends BaseSpritePane 
	{
		private var _card:Card;
		private var _exchangeGoodsModel:ExchangeGoods;
		private var _numText:TextField;
		private var _exchangBt:MovieClipButton;
		private var _type:int = 1;
		public function ExchangeGoodPanleUI(type:int=1) 
		{
			setSpriteInstance("exchangeGoodPanleUI");
			
			
			_numText = getChild("numText") as TextField;
			_exchangBt = getChild("exchangeBt") as MovieClipButton;
			_exchangBt.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_card = new Card();
			_type = type;
			if (_type == 1) {
				_card._currentCardTye = 0;
				_numText.x = 229.35;
				_numText.y = 223.2;
				_exchangBt.x =200.2;
				_exchangBt.y = 250.15;
				}else {
					_card._currentCardTye = 2;
					_numText.x = 29.75;
					_numText.y = 86.6;
					_exchangBt.x =0.6;
					_exchangBt.y = 113.55;
					_card.setLocation(11.25,10.2);
					}
			
			_card.showTip = true;
			addChild(_card);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			SMZTController.getInstance().exchengeGood(_exchangeGoodsModel.id, function(param:Object):void {
				EventTowerModel.getInstance().ticket -= _exchangeGoodsModel.price;
				EventShopPanel.getInstance().updata();
				//把奖品放入奖品显示队列显示在舞台中间
				var temp:BonusModel = new BonusModel();
				temp.setData(param);
				SMZTUIManager.getInstance().manageShowBonus.showBonus(temp);
				temp = null;
				});
		}
		public function updata(cardid:int=0):void {
			_numText.text = _exchangeGoodsModel.price.toString();
			_card.setCardModel(new CardModel(_exchangeGoodsModel.bonus.cards[0].id));
			}
		
		public function get exchangeGoodsModel():ExchangeGoods 
		{
			return _exchangeGoodsModel;
		}
		
		public function set exchangeGoodsModel(value:ExchangeGoods):void 
		{
			_exchangeGoodsModel = value;
			
		}
		
	}

}