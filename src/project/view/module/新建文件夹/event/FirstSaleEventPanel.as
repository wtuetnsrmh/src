package project.view.module.event
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.debug.Debug;
	import project.model.data.DataModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButtonNoSound;
	//import project.model.event.FirstFlushEvent;
	import project.model.event.OnSaleFirstTimeGoods;
	import flash.system.Security;
	/**
	 * 首冲活动面板
	 * @author bbjxl 2013
	 */
	public class FirstSaleEventPanel extends EventBase
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
		
		private var _ui:Sprite;
		//-----------------------数据---------------------------------
		private static var _firstSaleEventPanel:FirstSaleEventPanel;
		private var _goods:Vector.<*>;
		private var _callbackObj:*;
		private var _showDescArr:Array;
		private var _buyBtArr:Array;
		
		//-----------------------事件--------------------------------
		public function FirstSaleEventPanel()
		{
			/*if (_firstSaleEventPanel != null)
			{
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
			}*/
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
			_ui = new FirstSaleEventPanelUI();
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
		}
		
		/**
		 * 充值
		 * @param	e
		 */
		private function rechargeClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("pay.aspx"), "_self");
		}
		
		private function buyClick(e:MouseEvent):void
		{
			if (_callbackObj.buyGoodsFun == null) { Debug.log("_callbackObj.buyGoodsFun=null"); return; }
			switch (e.currentTarget)
			{
				case _buy0: 
					_callbackObj.buyGoodsFun(_goods[0].id,refresh);
					break;
				case _buy1: 
					_callbackObj.buyGoodsFun(_goods[1].id,refresh);
					break;
				case _buy2: 
					_callbackObj.buyGoodsFun(_goods[2].id,refresh);
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
		
		private function updataUI(param:Array):void
		{
			_goods = new Vector.<*>();
			//Debug.log("param="+param)
			for (var i:int = 0; i < param.length; i++)
			{
				var temp:OnSaleFirstTimeGoods = new OnSaleFirstTimeGoods();
				//Debug.log("temp="+temp)
				temp.setData(param[i]);
				_goods.push(temp);
				
				if (_showDescArr[i] != null)
				{
					(_showDescArr[i] as MovieClipButtonNoSound).toolTip = "<font color='#ffffff'>"+temp.desc+"</font>";
					(_buyBtArr[i] as MovieClipButtonNoSound).clickEnable = !temp.purchased;
				}
				temp = null;
			}
		}
		
		/**
		 * 刷新
		 */
		private function refresh():void
		{
			_callbackObj.getEventInfor(updataUI);
		}
		
		public static function getInstance():FirstSaleEventPanel
		{
			if (_firstSaleEventPanel == null)
			{
				_firstSaleEventPanel = new FirstSaleEventPanel;
			}
			return _firstSaleEventPanel;
		} // end function
	}

}