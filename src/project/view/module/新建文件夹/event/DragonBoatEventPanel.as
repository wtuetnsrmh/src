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
	import flash.system.Security;
	import project.view.artplug.MovieClipButtonNoSound;
	/**
	 * 端午活动面板
	 * @author bbjxl 2013
	 */
	public class DragonBoatEventPanel extends EventBase
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _rechargeBt:MovieClipButtonNoSound;
		private var _ui:Sprite;
		//-----------------------数据---------------------------------
		private static var _firstSaleEventPanel:DragonBoatEventPanel;
		private var _callbackObj:*;
		//-----------------------事件--------------------------------
		public function DragonBoatEventPanel()
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
			_ui = new dragonBoastEventPanelUI();
			addChild(_ui);
			
			_rechargeBt = _ui["rechargeBt"] as MovieClipButtonNoSound;
			_rechargeBt.onClick = rechargeClick;
		}
		
		/**
		 * 打开商场/充值
		 * @param	e
		 */
		private function rechargeClick(e:MouseEvent):void
		{
			_callbackObj.openShop();
			//navigateToURL(new URLRequest("pay.aspx"), "_self");
		}
		
		/**
		 * 传入接口对象
		 * @return
		 */
		override public function setData(value:*):void
		{
			_callbackObj = value;
		}
		
		
		public static function getInstance():DragonBoatEventPanel
		{
			if (_firstSaleEventPanel == null)
			{
				_firstSaleEventPanel = new DragonBoatEventPanel;
			}
			return _firstSaleEventPanel;
		} // end function
	}

}