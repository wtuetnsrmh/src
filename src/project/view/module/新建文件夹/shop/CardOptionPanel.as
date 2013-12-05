package project.view.module.shop 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * 卡包出售面板
	 * @author bbjxl 2013
	 */
	public class CardOptionPanel extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _cardTypeMc:MovieClip;
		private var _ratioText1:TextField;
		private var _ratioText2:TextField;
		private var _ratioText3:TextField;
		private var _ratioText4:TextField;
		private var _nameText:TextField;
		private var _buyBt:MovieClipButton;//购买按钮
		
		private var _goldPriceItem:PriceTypeItem;//金币类型
		private var _Q_pointItem:PriceTypeItem;//Q点类型
		private var _yellowPriceItem:PriceTypeItem;//黄钻价类型
		//-----------------------数据---------------------------------
		
		//-----------------------事件--------------------------------
		public function CardOptionPanel() 
		{
			setSpriteInstance("cardOptionUI");
			configerInstance();
		}
		
		private function configerInstance():void 
		{
			_goldPriceItem = new PriceTypeItem();
			addChild(_goldPriceItem);
			_goldPriceItem.setLocation(35.05, 206.2);
			_goldPriceItem.visible = false;
			_Q_pointItem = new PriceTypeItem();
			addChild(_Q_pointItem);
			_Q_pointItem.setLocation(5.8, 206.2);
			_Q_pointItem.visible = false;
			_yellowPriceItem = new PriceTypeItem();
			addChild(_yellowPriceItem);
			_yellowPriceItem.setLocation(72.8, 206.2);
			_yellowPriceItem.visible = false;
			
			_cardTypeMc = getChild("cardTypeMc") as MovieClip;
			_ratioText1 = getChild("ratioText1") as TextField;
			_ratioText2 = getChild("ratioText2") as TextField;
			_ratioText3 = getChild("ratioText3") as TextField;
			_ratioText4 = getChild("ratioText4") as TextField;
			_nameText = getChild("nameText") as TextField;
			_ratioText1.autoSize =TextFieldAutoSize.LEFT;
			_ratioText2.autoSize =TextFieldAutoSize.LEFT;
			_ratioText3.autoSize =TextFieldAutoSize.LEFT;
			_ratioText4.autoSize =TextFieldAutoSize.LEFT;
			_nameText.autoSize =TextFieldAutoSize.CENTER;
			_nameText.multiline = true;
			
			_buyBt = getChild("buyBt") as MovieClipButton;
			_buyBt.onClick = buyClickHandler;
		}
		
		private function buyClickHandler(e:MouseEvent):void 
		{
			if ((this.dataModel as GoodsModel).priceType == PurchaseType.CRYSTAL) {
				//是水晶支付的话调用JS
				Browser.buyItem((this.dataModel as GoodsModel).id);
				return;
				}
				
			var temp:PurchasePanel = PurchasePanel.getInstance();
			temp.goodModel = this.dataModel as GoodsModel;
			temp.show(true);
			temp = null;
		}
		
		public function updataUI(value:String):void {
			if (dataModel != null) {
				_nameText.htmlText = (dataModel as GoodsModel).name;
				var tempArr:Array = value.split("|");
				_ratioText1.htmlText = tempArr[0];
				_ratioText2.htmlText = tempArr[1];
				_ratioText3.htmlText = tempArr[2];
				_ratioText4.htmlText = tempArr[3];
				tempArr = null;
				
				switch((dataModel as GoodsModel).priceType) {
				case PurchaseType.CRYSTAL:
					_goldPriceItem.visible = false;
					_Q_pointItem.visible = true;
					_Q_pointItem.price = (dataModel as GoodsModel).crystal;
					_Q_pointItem.type = PriceTypeItem.Q_POINT;
					
					_yellowPriceItem.visible = true;
					_yellowPriceItem.price = Math.floor((dataModel as GoodsModel).crystal*0.8);//8折
					_yellowPriceItem.type = PriceTypeItem.YELLOW;
					break;
				case PurchaseType.GOLD:
					_Q_pointItem.visible = false;
					_yellowPriceItem.visible = false;
					_goldPriceItem.visible = true;
					_goldPriceItem.price = (dataModel as GoodsModel).gold;
					_goldPriceItem.type = PriceTypeItem.GOLD;
					break;
				}
				
				this.visible = true;
				}else {
					this.visible = false;
					}
			}
			
			public function get cardTypeMc():MovieClip 
			{
				return _cardTypeMc;
			}
			
			public function set cardTypeMc(value:MovieClip):void 
			{
				_cardTypeMc = value;
			}
		
	}

}