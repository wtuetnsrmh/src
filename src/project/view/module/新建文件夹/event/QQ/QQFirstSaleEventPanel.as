package project.view.module.event.QQ
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.debug.Debug;
	import project.model.data.DataModel;
	import project.model.shop.GoodsModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButtonNoSound;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.event.EventBase;
	//import project.view.controls.ToolTip;
	import project.model.event.OnSaleFirstTimeGoods;
	import flash.system.Security;
	/**
	 * 腾讯首冲活动面板
	 * @author bbjxl 2013
	 */
	public class QQFirstSaleEventPanel extends EventBase
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _showDesc0:MovieClipButtonNoSound; //查看套餐
		private var _showDesc1:MovieClipButtonNoSound;
		private var _showDesc2:MovieClipButtonNoSound;
		private var _buy0:MovieClipButtonNoSound;
		private var _buy1:MovieClipButtonNoSound;
		private var _buy2:MovieClipButtonNoSound;
		private var _rechargeBt:MovieClipButtonNoSound;
		private var _goodsImages:Vector.<BaseIcoCellLoader>;
		private var _ui:Sprite;
		//private var tp:ToolTip;
		//-----------------------数据---------------------------------
		private static var _firstSaleEventPanel:QQFirstSaleEventPanel;
		private var _goods:Vector.<*>;
		private var _callbackObj:*;
		private var _showDescArr:Array;
		private var _buyBtArr:Array;
		private var _goodsModel:Vector.<GoodsModel>;
		//-----------------------事件--------------------------------
		public function QQFirstSaleEventPanel()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE, addtoStage);
			
		}
		private function addtoStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addtoStage);
			init();
		}
		private function init():void
		{
			
			
			_ui = new QQFirstSaleEventPanelUI();
			addChild(_ui);
			_showDesc0 = _ui["showDesc0"] as MovieClipButtonNoSound;
			_showDesc1 = _ui["showDesc1"] as MovieClipButtonNoSound;
			_showDesc2 = _ui["showDesc2"] as MovieClipButtonNoSound;
			
			_showDescArr = new Array();
			_showDescArr.push(_showDesc0);
			_showDescArr.push(_showDesc1);
			_showDescArr.push(_showDesc2);
			_buy0 = _ui["buy0"] as MovieClipButtonNoSound;
			_buy1 = _ui["buy1"] as MovieClipButtonNoSound;
			_buy2 = _ui["buy2"] as MovieClipButtonNoSound;
			//Debug.log("_buy0 is MovieClipButtonNoSound:"+(_buy0 is MovieClipButtonNoSound))
			_rechargeBt = _ui["rechargeBt"] as MovieClipButtonNoSound;
			_buy0.onClick = buyClick;
			_buy1.onClick = buyClick;
			_buy2.onClick = buyClick;
			_buyBtArr = new Array();
			_buyBtArr.push(_buy0);
			_buyBtArr.push(_buy1);
			_buyBtArr.push(_buy2);
			_rechargeBt.onClick = rechargeClick;
			
			
			
			//_image.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
		}
		
		
		/*//鼠标移上物品显示提示面板
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
		}*/
		
		/**
		 * 充值
		 * @param	e
		 */
		private function rechargeClick(e:MouseEvent):void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
            if (ExternalInterface.available)
            {
				Debug.log("调用ＪＳ的charge");
                ExternalInterface.call("recharge");
            }
		}
		
		/**
		 * Q点支付调用JS
		 * @param	param
		 */
		private function buyItem(param:int,qty:int=1) : void
        {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
            if (ExternalInterface.available)
            {
				Debug.log("调用ＪＳ的buyItem");
                ExternalInterface.call("buyItem",param,qty);
            }
            return;
        }// end function
		
		private function buyClick(e:MouseEvent):void
		{
			
			switch (e.currentTarget)
			{
				case _buy0: 
					buyItem(_goodsModel[0].id);
					break;
				case _buy1: 
					buyItem(_goodsModel[1].id);
					break;
				case _buy2: 
					buyItem(_goodsModel[2].id);
					break;
			}
		}
		
		/**
		 * 传入接口对象
		 * @return
		 */
		override public function setData(value:*):void
		{
			Debug.log("setData")
			_callbackObj = value;
			//获取首冲活动信息
			
			refresh();
		}
		
		
		/**
		 * 刷新
		 */
		private function refresh():void
		{
			_callbackObj.getEventInfor(updataUI);
		}
		
		
		private function updataUI(param:Array):void
		{
			/*if (_goodsImages == null) {
				_goodsImages = new Vector.<BaseIcoCellLoader>();
				for (var j:int = 0; j < param.length; j++ ) {
					var _image:BaseIcoCellLoader = new BaseIcoCellLoader();
					_image.showBg = false;
					_image.restrictHW = 51;
					_image.setLocation(j * 51, 25);
					_image.tf=tp;
					addChild(_image);
					_goodsImages.push(_image);
					}
				}*/
				
			_goodsModel = new Vector.<GoodsModel>();
			for (var i:String in param) {
				var temp:GoodsModel = new GoodsModel(param[i]);
				if (_showDescArr[i] != null)
				{
					(_showDescArr[i] as MovieClipButtonNoSound).toolTip = "<font color='#ffffff'>"+temp.des+"</font>";
					_ui["price" + i].text = temp.crystal.toString();
				}
				//_goodsImages[i].ico = temp.imageUrl;
				//_goodsImages[i].toolTipStr = "<font color='#ffffff'>" + temp.des + "</font>";
				_goodsModel.push(temp);
				temp = null;
				}
			
			
		}
		
		public static function getInstance():QQFirstSaleEventPanel
		{
			if (_firstSaleEventPanel == null)
			{
				_firstSaleEventPanel = new QQFirstSaleEventPanel;
			}
			return _firstSaleEventPanel;
		} // end function
	}

}