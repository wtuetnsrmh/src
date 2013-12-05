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
	 * 腾讯加群活动面板
	 * @author bbjxl 2013
	 */
	public class QQInvaitGroupEventPanel extends EventBase
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _invateGroupBt:MovieClipButtonNoSound;
		private var _addClientBt:MovieClipButtonNoSound;
		private var _getBounsBt:MovieClipButtonNoSound;
		private var _ui:Sprite;
		//private var tp:ToolTip;
		//-----------------------数据---------------------------------
		private static var _firstSaleEventPanel:QQInvaitGroupEventPanel;
		private var _callbackObj:*;
		private var _goodsModel:Vector.<GoodsModel>;
		//-----------------------事件--------------------------------
		public function QQInvaitGroupEventPanel()
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
			
			
			_ui = new QQInvateGroupPanelUI();
			addChild(_ui);
			
			_invateGroupBt = _ui["invateGroupBt"] as MovieClipButtonNoSound;
			_addClientBt = _ui["addClientBt"] as MovieClipButtonNoSound;
			_getBounsBt = _ui["getBounsBt"] as MovieClipButtonNoSound;
			_getBounsBt.visible = false;
			_invateGroupBt.visible = false;
			_invateGroupBt.onClick = buyClick;
			_addClientBt.onClick = buyClick;
			_getBounsBt.onClick = buyClick;
			
		}
		
		/**
		 * 1.	加入主面板弹框
		 * @param	e
		 */
		private function addClientPanel():void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
            if (ExternalInterface.available)
            {
				Debug.log("调用ＪＳ的addClientPanel");
                ExternalInterface.call("addClientPanel");
            }
		}
		
		/**
		 * 1.	加群弹框
		 * @param	param
		 */
		private function inviteGroup() : void
        {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
            if (ExternalInterface.available)
            {
				Debug.log("调用ＪＳ的inviteGroup");
                ExternalInterface.call("inviteGroup");
            }
            return;
        }// end function
		
		private function buyClick(e:MouseEvent):void
		{
			
			switch (e.currentTarget)
			{
				case _invateGroupBt: 
					inviteGroup();
					break;
				case _addClientBt: 
					addClientPanel();
					break;
				case _getBounsBt: 
					_callbackObj.getAward(refresh);
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
			
		}
		
		
		private function updataUI(param:Array):void
		{
			
		}
		
		public static function getInstance():QQInvaitGroupEventPanel
		{
			if (_firstSaleEventPanel == null)
			{
				_firstSaleEventPanel = new QQInvaitGroupEventPanel;
			}
			return _firstSaleEventPanel;
		} // end function
	}

}