package project.view.module.shop 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * 价格类型
	 * @author bbjxl 2013
	 */
	public class PriceTypeItem extends BaseSpriteSetUI 
	{
		public static const GOLD:int = 2;
		public static const Q_POINT:int = 3;
		public static const YELLOW:int = 4;
		
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _icoMc:MovieClip;
		private var _priceText:TextField;
		//-----------------------数据---------------------------------
		private var _type:int;
		private var _price:int;
		//-----------------------事件--------------------------------
		public function PriceTypeItem() 
		{
			setSpriteInstance("priceTypeUI");
			configinstance();
		}
		
		private function configinstance():void 
		{
			_icoMc = getChild("icoMc") as MovieClip;
			_priceText = getChild("priceText") as TextField;
			
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
			_icoMc.gotoAndStop(value)
		}
		
		public function get price():int 
		{
			return _price;
		}
		
		public function set price(value:int):void 
		{
			_price = value;
			_priceText.text = value.toString();
		}
		
	}

}