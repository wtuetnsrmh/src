package project.view.module.event 
{
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	//import project.controller.EventController;
	import project.events.SMZTDataChangeEvent;
	//import project.model.data.DataModel;
	//import project.model.event.IEventModel;
	//import project.utils.Reflection;
	import project.view.artplug.MovieClipButtonNoSound;
	import project.view.layout.BaseGridContainer;
	import project.view.controls.TabNavigator;
	import project.debug.Debug;
	import flash.system.Security;
	import com.greensock.*;
	/**
	 * 活动界面
	 * @author bbjxl 2013
	 */
	public class EventMain extends MovieClip 
	{
		private static const CLOSE:String = "MODULE_UNLOAD";
		
		private var _callbacks:Vector.<*>;//总的活动回调方法列表
		//private var _useEventList:Vector.<DataModel>;//当前要用的活动列表
		private var _totalEventList:Array;//所有活动的界面
		private static var eventList:Array = new Array();// [0];//活动依次增加--------------增加活动时，改
		private var _optionsGird:BaseGridContainer;
		private var tabNvigator:TabNavigator;//分页导航
		private var _optionsArr:Array;
		private var _closeBt:MovieClipButtonNoSound;//关闭按钮
		private var _contain:Sprite;//内容容器
		private var _loader:Loader;
		private var _currentSelectedIndex:int = -1;
		private var _EventLockScreen:Sprite;//loading
		private var _mask:Sprite;
		private var _loading:*;
		private var _relavtive:String;
		private var _contentArr:Array;//加载的模块数组
		private var _timer:Timer = new Timer(7000);//每7秒切换
		private var _loadedUrl:Array = new Array();
		private var _contentdic:Dictionary = new Dictionary();
		private var _currentURL:String;
		private var _config:XMLList;
		
		public function EventMain() 
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			this.addEventListener(Event.ADDED_TO_STAGE,addtoSatge);
			
			//showActive()
			//init();
		}
		
		private function addtoSatge(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, addtoSatge);
			//init();
		}
		
		public static function createInstance(param1:String, param2:ApplicationDomain = null):*
        {
            var _loc_3:Class = getClass(param1, param2);
            if (_loc_3 != null)
            {
                return new _loc_3;
            }
            return null;
        }// end function

		/*生成类
		* @ param1 类名
		* @ param2 域
		*/
        public static function getClass(param1:String, param2:ApplicationDomain = null) : Class
        {
            var _loc_3:Class = null;
            if (param2 == null)
            {
                param2 = ApplicationDomain.currentDomain;
            }
            if (param2.hasDefinition(param1))
            {
                _loc_3 = param2.getDefinition(param1) as Class;
            }
            return _loc_3;
        }// end function
		
		private function init():void {
			
			_contentArr = new Array();
			
			_mask = new Sprite();
			
			_contain = new Sprite();
			_contain.x = 72;
			_contain.y = 92.95;
			addChild(_contain);
			_totalEventList = new Array();
			
			Debug.log("_relavtive==" + _relavtive);
			var tempXML:XML;
			for each(tempXML in _config.url) {
				//Debug.log("tempXML=" + tempXML);
				_totalEventList.push(tempXML);
				}
			//_totalEventList = ["http://121.199.43.137/assets/Libs/7/event2.swf?v=19"];// , "http://121.199.43.137/assets/Libs/7/event2.swf", "TestDB/assets/Libs/7/event4.swf"];// FirstSaleEventPanel.getInstance() , new TestEvent()];//--------------增加活动时，改
			
			tabNvigator = new TabNavigator();
			
			if (_optionsGird == null) {
				_optionsGird = new BaseGridContainer(eventList.length, 1, 10, 83, 28);
				addChild(_optionsGird);
				_optionsGird.setLocation(26,156);
				}
			_optionsArr = new Array();
			for (var i:int = 0; i < eventList.length; i++ ) {
				var tempClass:Class = getDefinitionByName("eventOption" + eventList[i]) as Class;
				var tempOptin:MovieClipButtonNoSound = new tempClass();
				_optionsGird.appendChild(tempOptin);
				_optionsArr.push(tempOptin);
				tempOptin = null;
				}
			
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			tabNvigator.setTabArr(_optionsArr);
			_closeBt = this["closeBt"] as MovieClipButtonNoSound;
			
			_closeBt.onClick = closeHandler;
			addChild(_closeBt);
			
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			}
			/**
			 * 时间到切换下一活动
			 * @param	e
			 */
		private function timerHandler(e:TimerEvent):void 
		{
			return;
			/*var tempSelected:int = 0;
			if (_currentSelectedIndex < eventList.length - 1) {
				tempSelected=_currentSelectedIndex+1;
				}else {
					tempSelected = 0;
					}
			tabNvigator.EventSelectedByIndex(tempSelected);*/
		}
		/**
		 * 选项切换
		 * @param	e
		 */
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			if (_loader != null) _loader.unload();
			//Debug.log("_currentSelectedIndex=" + _currentSelectedIndex);
			//Debug.log("int(e.dataObject)=" + int(e.dataObject));
			if (_currentSelectedIndex == int(e.dataObject)) return;
			
			//if (_timer) { _timer.reset(); }
			_currentSelectedIndex = int(e.dataObject);
			showSecen(_totalEventList[eventList[_currentSelectedIndex]]);
		}
		
		
		public function showSecen(param1:String, param2:Function = null) : void
        {
			_currentURL = param1;
			//Debug.log("_currentURL=" + _currentURL);
			if (_loader != null) _loader.unload();
			
			if (_contentdic[_currentURL] != null) {
				//Debug.log("_contentdic=" + _contentdic[_currentURL]);
				//所有活动都加载过
				if (_loading) _loading.hide();
				while (_contain.numChildren > 0) {
					_contain.removeChildAt(0);
					
					}
				_contain.addChild(_contentdic[_currentURL]);
				TweenLite.from(_contentdic[_currentURL], .5, { alpha:0 } );
				if (_timer) { _timer.reset(); _timer.start(); }
				return;
				}
			/*if (_loadedUrl.indexOf(param1) == -1) {
				_loadedUrl.push(param1);
				}*/
				
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, projgresseHandler);
			//var _loc_2:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			_loader.load(new URLRequest(param1));
			
            return;
        }// end function
		
		private function projgresseHandler(e:ProgressEvent):void 
		{
			if (_loading) _loading.show(true);
		}
		
		private function completeHandler(e:Event):void 
		{
			//Debug.log("completeHandler_currentURL=" + _currentURL);
			_contentdic[_currentURL] = e.currentTarget.content;
			
			_contentArr.push(e.currentTarget.content);
			
			if (_loading) _loading.hide();
			while (_contain.numChildren > 0) {
				_contain.removeChildAt(0);
				}
			_contain.addChild(e.currentTarget.content);
			TweenLite.from(e.currentTarget.content, .5, { alpha:0} );
			
			if (_callbacks == null) { Debug.log("_callbacks为null"); return; }
			e.currentTarget.content["setData"](_callbacks[_currentSelectedIndex]);
			
			e.currentTarget.content.addEventListener("STOP_TIMER", stopTimerHandler);
			e.currentTarget.content.addEventListener("START_TIMER", startTimerHandler);
			/**
			 * 如果没有计时则开始计时
			 */
			if (_timer) { _timer.reset(); _timer.start(); }
		}
		
		private function startTimerHandler(e:Event):void 
		{
			//Debug.log("start")
			if (_timer) {_timer.start(); }
		}
		
		private function stopTimerHandler(e:Event):void 
		{
			//Debug.log("stop")
			if (_timer) { _timer.stop();  }
		}
		
		/*public function showSecen(param1:DisplayObject, param2:Function = null) : void
        {
			while (_contain.numChildren > 0) {
				_contain.removeChildAt(0);
				}
			
			if (!contains(param1)) {
				_contain.addChild(param1);
				
				}
            //TweenLite.to(param1, 0, {transformAroundCenter:{scaleX:0.3, scaleY:0.3}});
            //TweenLite.to(param1, 0.3, {transformAroundCenter:{scaleX:1, scaleY:1}, ease:Back.easeOut, onComplete:param2});
            return;
        }// end function*/
		
		/**
		 * 关闭
		 * @param	e
		 */
		private function closeHandler(e:MouseEvent):void 
		{
			_contentArr = null;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer = null;
			dispatchEvent(new Event(CLOSE));
		}
		
		/**
		 * 显示活动界面
		 * 动态地址
		 * 用户ＩＤ
		 */
		public function showActive(callbacks:Vector.<*> ,relavtive:String, uid:int, loading:*, config:XMLList):void {
			_relavtive = relavtive;
			
			_config = config;
			eventList = String(_config.@subList).split(",");
			var dataList:Array=String(_config.@dataList).split(",");
			init();
			
			//Debug.log("_config=" + _config.toXMLString());
			Debug.log("活动=" + relavtive);
			
			_loading = loading;
			if (_loading) _loading.show(true);
			
			
			_callbacks = new Vector.<*>();
			for (var i:String in dataList) {
				if (dataList[i] == "null") {
					_callbacks.push(null);
					}else {
						Debug.log("int(dataList[i])=" + int(dataList[i]));
						_callbacks.push(callbacks[int(dataList[i])]);
						//_callbacks[int(dataList[i])]=callbacks[int(dataList[i])];
						}
				}
			//_callbacks =  callbacks.slice(1, 2);
			
			Debug.log("_callbacks"+_callbacks.length)
			//-----------------端午---------------------------------------
			//添加一个没有回调函数的方法(端午)
			//_callbacks.push(null);
			//-------------------充值排名-------------------------------------
			
			//--------------------------------------------------------
			
			
			
			tabNvigator.EventSelectedByIndex(0);
			}
	}

}