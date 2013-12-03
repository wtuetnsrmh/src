package project.view.module.shop 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.controller.NewBieControler;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.DataModel;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.cell.BaseIcoCellLoader;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class Goods extends BaseSpritePane 
	{
		private var _nameText:TextField;
		private var _decText:TextField;
		//private var _priceText:TextField;
		private var _buyBt:MovieClipButton;
		//private var _icoMc:MovieClip;
		private var _image:BaseIcoCellLoader;
		private var _goldPriceItem:PriceTypeItem;//金币类型
		private var _Q_pointItem:PriceTypeItem;//Q点类型
		private var _yellowPriceItem:PriceTypeItem;//黄钻价类型
		
		public function Goods() 
		{
			setSpriteInstance("goodsUI");
			configerUIInstance();
		}
		
		private function configerUIInstance():void 
		{
			_goldPriceItem = new PriceTypeItem();
			addChild(_goldPriceItem);
			_goldPriceItem.setLocation(35.05, 85.3);
			_goldPriceItem.visible = false;
			_Q_pointItem = new PriceTypeItem();
			addChild(_Q_pointItem);
			_Q_pointItem.setLocation(5.8, 85.3);
			_Q_pointItem.visible = false;
			_yellowPriceItem = new PriceTypeItem();
			addChild(_yellowPriceItem);
			_yellowPriceItem.setLocation(72.8, 85.3);
			_yellowPriceItem.visible = false;
			
			_nameText = getChild("nameText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			_nameText.multiline = true;
			/*var tf:TextFormat = new TextFormat();
			tf.leading = 1;
			_nameText.setTextFormat(tf);*/
			
			_decText = getChild("decText") as TextField;
			//_priceText = getChild("priceText") as TextField;
			_buyBt = getChild("buyBt") as MovieClipButton;
			_buyBt.onClick = buyClickHandler;
			//_icoMc = getChild("icoMc")as MovieClip;
			_image = new BaseIcoCellLoader();
			_image.showBg = false;
			_image.restrictHW = 51;
			_image.setLocation(12,25);
			addChild(_image);
			
			_image.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
		}
		
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_image.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point=new Point(this.x - (251-this.width)/2, this.y-100);
			SMZTUIManager.getInstance().bagPopPanel.setDataByShop((dataModel as GoodsModel), this.parent.localToGlobal(temp));
			
			SMZTUIManager.getInstance().bagPopPanel.show(false);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_image.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
			SMZTUIManager.getInstance().bagPopPanel.hide();
		}
		
		public function updataUI() : void
        {
			if (dataModel != null) {
				_image.ico = (dataModel as GoodsModel).imageUrl;
				_nameText.htmlText = (dataModel as GoodsModel).name;
				var tempDes:String = (dataModel as GoodsModel).des;
				tempDes = (tempDes.length > 12?tempDes.substr(0, 12) + "…":tempDes);
				_decText.htmlText = tempDes;// dataModel as GoodsModel).des;
				
				//(dataModel as GoodsModel).priceType = returnPriceType();
				//_icoMc.gotoAndStop((dataModel as GoodsModel).priceType+1);
				switch((dataModel as GoodsModel).priceType) {
				case PurchaseType.CRYSTAL:
					_goldPriceItem.visible = false;
					_Q_pointItem.visible = true;
					_Q_pointItem.price = (dataModel as GoodsModel).crystal;
					_Q_pointItem.type = PriceTypeItem.Q_POINT;
					
					_yellowPriceItem.visible = true;
					_yellowPriceItem.price = Math.floor((dataModel as GoodsModel).crystal*0.8);//8折
					_yellowPriceItem.type = PriceTypeItem.YELLOW;
					//_priceText.htmlText = (dataModel as GoodsModel).crystal.toString();
					break;
				case PurchaseType.GOLD:
					_Q_pointItem.visible = false;
					_yellowPriceItem.visible = false;
					_goldPriceItem.visible = true;
					_goldPriceItem.price = (dataModel as GoodsModel).gold;
					_goldPriceItem.type = PriceTypeItem.GOLD;
					//_priceText.htmlText = (dataModel as GoodsModel).gold.toString();
					break;
				}
				
				this.visible = true;
				}else {
					this.visible = false;
					}
		}
		/*private function returnPriceType():int {
			switch(shopPanel.getInstance().currentSelectedType) {
				case shopPanel.CARDS:
					return PurchaseType.CRYSTAL;
					break;
				case shopPanel.ITEM:
					return PurchaseType.CRYSTAL;
					break;
				case shopPanel.GLOD:
					return PurchaseType.GOLD;
					break;
				case shopPanel.HONOR:
					return PurchaseType.HONOR;
					break;
				}
				return 1;
			}*/
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
		
	}

}