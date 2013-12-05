package project.view.module.event
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.debug.Debug;
	import project.model.data.DataModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButtonNoSound;
	//import project.model.event.FirstFlushEvent;
	import project.model.event.FriendInvitationGoods;
	import flash.system.Security;
	/**
	 * 邀请活动面板
	 * @author bbjxl 2013
	 */
	public class InviteEventPanel extends EventBase
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _ui:Sprite;
		private var _rechargeBt:MovieClipButtonNoSound;
		private var _numText:TextField;//当前好友数
		//-----------------------数据---------------------------------
		private var _goods:Vector.<FriendInvitationGoods>;
		private var _callbackObj:*;
		private var _getBtArr:Array;//领取
		private var _getedArr:Array;//已领取
		private var _prog:int;//已邀请好友并达到条件的个数
		private var _levelArr:Array = [1,2,3,4,5,6,7,8,9];
		//-----------------------事件--------------------------------
		public function InviteEventPanel()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//this.addEventListener(Event.ADDED_TO_STAGE, addtoStage);
			init();
		}
		private function addtoStage(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, addtoStage);
			//init();
		}
		private function init():void
		{
			
			_ui = new inviteEventPanelUI();
			addChild(_ui);
			
			_numText = _ui["numText"] as TextField;
			_numText.mouseEnabled = false;
			
			
			_getedArr = new Array();
			_getBtArr = new Array();
			for (var i:int = 0; i < 9; i++ ) {
				(_ui["getBt" + i] as MovieClipButtonNoSound).index = i;
				(_ui["getBt" + i] as MovieClipButtonNoSound).onClick = clickHandler;
				_getBtArr.push(_ui["getBt" + i] as MovieClipButtonNoSound);
				(_ui["geted" + i] as MovieClipButtonNoSound).clickEnable = false;
				(_ui["geted" + i] as MovieClipButtonNoSound).mouseEnabled = false;
				(_ui["geted" + i] as MovieClipButtonNoSound).mouseChildren = false;
				_getedArr.push(_ui["geted" + i] as MovieClipButtonNoSound);
				}
			
			
			_rechargeBt = _ui["rechargeBt"] as MovieClipButtonNoSound;
			_rechargeBt.onClick = rechargeClick;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var temp:int = (e.currentTarget as MovieClipButtonNoSound).index;
			_callbackObj.getAward(_goods[temp].id, refresh);
			
		}
		
		/**
		 * 充值
		 * @param	e
		 */
		private function rechargeClick(e:MouseEvent):void
		{
			//navigateToURL(new URLRequest(ApplicationConfig.mainConfig.chargeURL), ApplicationConfig.mainConfig.chargeURL.@method);
			
			////trace("ExternalInterface:openInvitationDlg");
            if (ExternalInterface.available)
            {
				Debug.log("ExternalInterface:openInvitationDlg");
                ExternalInterface.call("openInvitationDlg");
            }
		}
		
		
		/**
		 * 传入接口对象
		 * @return
		 */
		override public function setData(value:*):void
		{
			_callbackObj = value;
			//获取首冲活动信息
			
			refresh();
		}
		
		private function updataUI(param:Object):void
		{
			_prog = param.prog;
			_numText.text = _prog.toString();
			
			_goods = new Vector.<FriendInvitationGoods>();
			//Debug.log("param="+param)
			for (var i:int = 0; i < param.goods.length; i++)
			{
				var temp:FriendInvitationGoods = new FriendInvitationGoods();
				//Debug.log("temp="+temp)
				temp.setData(param.goods[i]);
				_goods.push(temp);
				if (temp.earned) {
					//显示已领取
					_getedArr[i].visible = true;
					_getBtArr[i].visible = false;
					}else {
						_getedArr[i].visible = false;
						_getBtArr[i].visible = true;
						}
						
				if (_prog < _levelArr[i]) {
					_getBtArr[i].clickEnable = false;
					}else {
						_getBtArr[i].clickEnable = true;
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
		

	}

}