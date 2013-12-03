package project.view.module.scene.cultivation
{
	import flash.display.Sprite;
	import project.model.data.PlayerData;
	import project.view.base.BaseSpriteSetUI;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.model.item.CardModel;
	import project.view.module.cell.Card;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	/**
	 * 合成小卡
	 * @author bbjxl 2013
	 */
	public class MixSmalCard extends BaseSpriteSetUI
	{
		private var _numText:TextField; //数量
		private var _nameText:TextField; //名字
		private var _card:Card;
		private var _smallCardContainer:Sprite;//小卡容器
		private var _filter:GlowFilter;
		
		public function MixSmalCard()
		{
			setSpriteInstance("MixSmalCardUI");
			configerInstance();
		}
		
		private function configerInstance():void
		{
			_smallCardContainer = getChild("smallCardContainer") as Sprite;
			
			_card = new Card();
			_card._currentCardTye = 2;
			_card.showTip = true;
			_smallCardContainer.addChild(_card);
			
			_nameText = new TextField();
			_numText = new TextField();
			_numText.autoSize = TextFieldAutoSize.CENTER;
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			var tf:TextFormat = new TextFormat();
			tf.font = ApplicationConfig.FONT;
			tf.color = 0xffffff;
			tf.size = 12;
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			_nameText.defaultTextFormat = tf;
			_nameText.x = (ApplicationConfig.SMALL_CARD_WH >> 1);
			_nameText.y =86.4;
			_nameText.mouseEnabled = false;
			_nameText.mouseWheelEnabled = false;
			addChild(_nameText);
			
			_filter = new GlowFilter();
			_filter.color = 0x000000;
			_filter.alpha = 1;
			_filter.blurX = 2;
			_filter.blurY = 2;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			_nameText.filters = [_filter];
			
			_numText.autoSize = TextFieldAutoSize.CENTER;
			_numText.defaultTextFormat = tf;
			_numText.x = (ApplicationConfig.SMALL_CARD_WH >> 1);
			_numText.y = 63.9;
			_numText.mouseEnabled = false;
			_numText.mouseWheelEnabled = false;
			addChild(_numText);
		}
		
		/**
		 *
		 * @param	value
		 * @param	needNum　需要的张数
		 */
		public function updataCard(value:CardModel, needNum:int):void
		{
			var haveCN:int = findCardNumByID(value.id);
			_numText.text =haveCN  + "/" + needNum;
			_nameText.text = value.name;
			_card.setCardModel(value, true);
			if (haveCN< needNum)
			{
				_card.enable = false;
			}
			else
			{
				_card.enable = true;
			}
			
			value = null;
		}
		
		/**
		 * 根据ＩＤ找到自己卡库中对应ＩＤ的卡的数量
		 */
		private function findCardNumByID(value:int):int
		{
			var returnNum:int;
			var temp:CardModel = PlayerData.getInstance().findCardById(value);
			if (temp) {
				returnNum = temp.number;
				}else {
					returnNum= 0;
					}
			temp = null;
			return returnNum;
		}
		
		override public function dispose():void
		{
			_numText.text = "";
			_nameText.text = "";
			if (_card)
			{
				_card.hideAll();
			}
		}
		
		public function get card():Card
		{
			return _card;
		}
		
		public function set card(value:Card):void
		{
			_card = value;
		}
	
	}

}