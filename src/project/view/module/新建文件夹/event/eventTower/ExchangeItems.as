package project.view.module.event.eventTower 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.DataModel;
	import project.model.event.eventTower.EventTowerModel;
	import project.model.event.eventTower.ExchangeGoods;
	import project.model.friends.BonusModel;
	import project.model.item.ItemModel;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.cell.BaseIcoCellLoader;
	
	/**
	 * 单个兑换的物品框
	 * @author bbjxl 2013
	 */
	public class ExchangeItems extends BaseSpritePane 
	{
		//private var _nameText:TextField;
		//private var _decText:TextField;
		private var _priceText:TextField;
		private var _buyBt:MovieClipButton;
		//private var _icoMc:MovieClip;
		private var _image:BaseIcoCellLoader;
		private var _itemModel:ItemModel;
		public function ExchangeItems() 
		{
			setSpriteInstance("itemsUI");
			configerUIInstance();
		}
		
		private function configerUIInstance():void 
		{
			//_nameText = getChild("nameText") as TextField;
			//_nameText.autoSize = TextFieldAutoSize.CENTER;
			//_nameText.multiline = true;
			
			//_decText = getChild("decText") as TextField;
			_priceText = getChild("priceText") as TextField;
			_buyBt = getChild("buyBt") as MovieClipButton;
			_buyBt.onClick = buyClickHandler;
			//_icoMc = getChild("icoMc")as MovieClip;
			_image = new BaseIcoCellLoader();
			_image.showBg = false;
			_image.restrictHW = 51;
			_image.setLocation(19.65,16.45);
			addChild(_image);
			
			_image.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
		}
		
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_image.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point = new Point(this.x - (251 - this.width) / 2, this.y - 110);
			var tempGoodsModel:GoodsModel = new GoodsModel(null);
			tempGoodsModel.name = _itemModel.name;
			tempGoodsModel.des = _itemModel.description;
			SMZTUIManager.getInstance().bagPopPanel.setDataByShop(tempGoodsModel, this.parent.localToGlobal(temp));
			
			SMZTUIManager.getInstance().bagPopPanel.show(false);
			tempGoodsModel = null;
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
				var tempObj:Object = new Object();
				tempObj.item = (dataModel as ExchangeGoods).bonus.items[0].id;
				_itemModel = new ItemModel(tempObj);
				_image.ico = _itemModel.ico
				//_nameText.htmlText = _itemModel.name;
				//var tempDes:String = _itemModel.description;
				//tempDes = (tempDes.length > 30?tempDes.substr(0, 30) + "…":tempDes);
				//_decText.htmlText = tempDes;// dataModel as GoodsModel).des;
				
				//_icoMc.gotoAndStop(1);
				_priceText.htmlText = (dataModel as ExchangeGoods).price.toString();
				
				this.visible = true;
				}else {
					this.visible = false;
					}
		}

		/**
		 * 兑换
		 * @param	e
		 */
		private function buyClickHandler(e:MouseEvent):void 
		{
			SMZTController.getInstance().exchengeGood((dataModel as ExchangeGoods).id, function(param:Object):void {
				EventTowerModel.getInstance().ticket -= (dataModel as ExchangeGoods).price;
				EventShopPanel.getInstance().updata();
				//把奖品放入奖品显示队列显示在舞台中间
				var temp:BonusModel = new BonusModel();
				temp.setData(param);
				SMZTUIManager.getInstance().manageShowBonus.showBonus(temp);
				});
		}
		
	}

}