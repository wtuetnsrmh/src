package project.view.module.vip
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.friends.BonusModel;
	import project.model.item.ItemModel;
	import project.view.artplug.MovieClipButton;
	import project.view.layout.BaseGridContainer;
	import project.utils.ControlPageNoView;
	//import project.model.vip.VipState;
	
	/**
	 * VIP界面
	 * @author bbjxl 2013
	 */
	public class VipPanel extends MovieClip
	{
		private var _dataModel:*;
		private static const CLOSE:String = "MODULE_UNLOAD";
		private var _dialyBt:MovieClipButton; //每日领取
		private var _closeBt:MovieClipButton; //关闭按钮
		private var _vipBt:MovieClipButton; //充值
		private var _onceBt:MovieClipButton; //礼包领取按钮
		private var _vipBts:Array;
		private var _callBack:Function;
		private var _currentSelectedOption:int = 0; //当前选中的选项
		private var _vipTypeIcoMc:MovieClip; //当前自己的vip等级
		private var _progressBar:MovieClip; //当前进度条
		private var _progressText:TextField; //当前经验/下一等级经验
		private var _vipLevelMc0:MovieClip;
		private var _vipLevelMc1:MovieClip;
		private var _vipLevelMc3:MovieClip;
		private var _bagPopPanel:*;
		private var _dailyItemGrid:BaseGridContainer;
		private var _dailyItemArr:Vector.<VipItemIco>;
		private var _onceItemGrid:Sprite;
		private var _onceItemArr:Vector.<VipItemIco>;
		private var _nextBt:MovieClipButton;
		private var _preBt:MovieClipButton;
		private var _currentSeletedPage:int = 0;//当前每日领取物品页数
		private var _dialyItemData:Array;//每日领取物品数据
		private var _controlPage:ControlPageNoView;//分布控制
		private var _cardsContainer:Sprite;//卡的容器
		private var _honorText:TextField;//荣誉
		private var _glodText:TextField;//金币
		private var _tipText:TextField;//提示
		private var _staticURL:String;//资源相对路径
		private var _appTextFormat:TextFormat = new TextFormat("微软雅黑");
		public function VipPanel()
		{
			_cardsContainer = new Sprite();
			_cardsContainer.x = 151.5;
			_cardsContainer.y = 442;
			addChild(_cardsContainer);
			
			_tipText = this["tipText"] as TextField;
			_tipText.mouseEnabled = false;
			_tipText.autoSize=TextFieldAutoSize.LEFT;
			_honorText = this["honorText"] as TextField;
			_glodText = this["glodText"] as TextField;
			_honorText.mouseEnabled = false;
			_honorText.autoSize = TextFieldAutoSize.LEFT;
			_glodText.autoSize = TextFieldAutoSize.LEFT;
			_glodText.mouseEnabled = false;
			
			_preBt = this["preBt"] as MovieClipButton;
			_nextBt = this["nextBt"] as MovieClipButton;
			_controlPage = new ControlPageNoView(_nextBt, _preBt);
			
			_progressText = this["progressText"] as TextField;
			_progressText.mouseEnabled = false;
			_progressText.mouseWheelEnabled = false;
			_vipLevelMc0 = this["vipLevelMc0"] as MovieClip;
			_vipLevelMc1 = this["vipLevelMc1"] as MovieClip;
			_vipLevelMc3 = this["vipLevelMc3"] as MovieClip;
			_progressBar = this["progressBar"] as MovieClip;
			_vipTypeIcoMc = this["vipTypeIcoMc"] as MovieClip;
			_vipBt = this["vipBt"] as MovieClipButton;
			_vipBt.onClick = vipClick;
			_onceBt = this["onceBt"] as MovieClipButton;
			_dialyBt = this["dialyBt"] as MovieClipButton;
			_dialyBt.onClick = dialyClickHandler;
			_closeBt = this["closeBt"] as MovieClipButton;
			_closeBt.onClick = closeHandler;
			_onceBt.onClick = clickHandler;
			_vipBts = new Array();
			
			_onceItemGrid = new Sprite();// new BaseGridContainer(2, 4, 16.8, 43, 45);
			_onceItemArr = new Vector.<VipItemIco>();
			_dailyItemGrid =  new BaseGridContainer(1, 8, 16, 43, 43);
			_dailyItemArr = new Vector.<VipItemIco>();
			for (var j:int = 0; j < 8; j++ ) {
				var item:VipItemIco = new VipItemIco();
				item.showBg = false;
				item.restrictHW = 43.25;
				item.toolTipEnabled = false;
				_dailyItemGrid.appendChild(item);
				_dailyItemArr.push(item);
				item = null;
				}
			var xyPoint:Array=[{"x":396.75,"y":476.2},{"x":455,"y":476.2},{"x":514,"y":476.2},{"x":571.75,"y":476.2},{"x":396.75,"y":533.2},{"x":572.75,"y":533.2}]
			for (var n:int = 0; n < 6; n++ ) {
				var _baseItem:VipItemIco = new VipItemIco();
				_baseItem.showBg = false;
				_baseItem.restrictHW = 43.25;
				_baseItem.toolTipEnabled = false;
				_onceItemGrid.addChild(_baseItem);
				_onceItemArr.push(_baseItem);
				_baseItem.x = xyPoint[n].x;
				_baseItem.y = xyPoint[n].y;
				_baseItem = null;
				}
			addChild(_onceItemGrid);
			addChild(_dailyItemGrid);
			_dailyItemGrid.setLocation(157.5, 331.5);
			/*_onceItemGrid.x=393.5;
			_onceItemGrid.y=476.2;*/
			
			for (var i:int = 0; i < 7; i++)
			{
				_vipBts.push(this["vipOption" + i]);
				(this["vipOption" + i] as VipOptoin).index = i;
				(this["vipOption" + i] as VipOptoin).clickEnable = true;
				(this["vipOption" + i] as VipOptoin).onClick = optoinClickHandler;
			}
		}
		
		
		private function optoinClickHandler(e:MouseEvent):void
		{
			currentSelectedOption = (e.currentTarget as VipOptoin).index;
			updataUIafterOptionClick();
		}
		
		/**
		 * 选项切换后更新每日跟礼包的界面
		 */
		private function updataUIafterOptionClick():void
		{
			if (_callBack != null)
			{
				Debug.log("4---------------updataUIafterOptionClick")
				updataDailyUI(_dataModel.returnDialyBonus(_currentSelectedOption + 1));
				updataOnceUI(_dataModel.returnDialyBonus(_currentSelectedOption + 1, "OnceBonus"));
			}
		}
		
		/**
		 * 更新每日礼包界面
		 * @param	object 　这里是bonusModel
		 * bm.exp
		   bm.gold
		   bm.honor
		   bm.crystal
		   bm.items
		   bm.cards
		 */
		private function updataDailyUI(object:Object):void
		{
			
			_vipLevelMc0.gotoAndStop(_currentSelectedOption + 1);
			if (_currentSelectedOption != _dataModel.lv - 1)
			{
				_dialyBt.visible = false;
			}
			else
			{
				_dialyBt.visible = true;
			}
			//Debug.log(object.items[0].id)
			_dialyItemData = object.items;
			
			_controlPage.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, changePage);
			_controlPage.initData(_dialyItemData, 8);
			
			
		}
		/**
		 * 页数改变
		 * @param	e
		 */
		private function changePage(e:SMZTDataChangeEvent):void 
		{
			for (var i:int = 0; i < _dailyItemArr.length; i++ ) {
				if (e.dataObject[i] != null) {
					_dailyItemArr[i].visible = true;
					var tempItemModel:ItemModel = new ItemModel({"item": e.dataObject[i].id,"stack":e.dataObject[i].number});
					_dailyItemArr[i].imgMode = -1; //图片ＵＲＬ为ＩＣＯ
					_dailyItemArr[i].item =  tempItemModel;// e.dataObject[i].item;
					_dailyItemArr[i].addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
					}else {
						_dailyItemArr[i].clearIco();
						_dailyItemArr[i].removeEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
						}
				}
		}
		
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			var _item:VipItemIco = e.currentTarget;
			_item.setOnChoose(true);
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point=new Point(_item.x - (251-_item.width)/2, _item.y - 125);
			_bagPopPanel.setData(_item.item, _item.parent.localToGlobal(temp));
			
			
			_bagPopPanel.show(false);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			e.currentTarget.setOnChoose(false);
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
			_bagPopPanel.hide();
		}
		
		public function setAppTextFormat(... arg):void {
			/*var tf:TextFormat = new TextFormat("微软雅黑");
			_timeText.setTextFormat(tf);
			_descText.setTextFormat(tf);*/
			for (var i:String in arg) {
				if(arg[i]!=null)
				arg[i].setTextFormat(_appTextFormat);
				}
			//Debug.log("setAppTextFormat");
			}
		
		/**
		 * 更新礼包界面
		 * @param	object 　这里是bonusModel
		 * bm.exp
		   bm.gold
		   bm.honor
		   bm.crystal
		   bm.items
		   bm.cards
		 */
		private function updataOnceUI(object:Object):void
		{
			_glodText.text = object.gold.toString();
			_honorText.text = object.honor.toString();
			setAppTextFormat(_glodText,_honorText);
			
			_vipLevelMc1.gotoAndStop(_currentSelectedOption + 1);
			_onceBt.clickEnable = returnOnceGet(_currentSelectedOption + 1);
			
			//刷新卡
			while (_cardsContainer.numChildren > 0) {
				_cardsContainer.removeChildAt(0);
				}
			for (var j:int = 0; j < 2; j++ ) {
				
				if (object.cards == null || object.cards[j] == null ) continue;
				
				if (object.cards[j].card != null) {
					object.cards[j].card.x = j * ApplicationConfig.CARD_WIDTH / 2 + j * 15;
					_cardsContainer.addChild(object.cards[j].card);
					}
				}
			
			//刷新物品
			for (var i:int = 0; i < _onceItemArr.length; i++ ) {
				if (object.items!=null && object.items[i] != null) {
					_onceItemArr[i].visible = true;
					var tempItemModel:ItemModel = new ItemModel({"item": object.items[i].id,"stack":object.items[i].number});
					_onceItemArr[i].imgMode = -1; //图片ＵＲＬ为ＩＣＯ
					_onceItemArr[i].item = tempItemModel;
					_onceItemArr[i].addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
					}else {
						_onceItemArr[i].clearIco();
						_onceItemArr[i].removeEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
						}
				}
		}
		
		/**
		 * 链接到充值界面
		 * @param	e
		 */
		private function vipClick(e:MouseEvent):void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			Debug.log("ExternalInterface.available="+ExternalInterface.available)
            if (ExternalInterface.available)
            {
				Debug.log("调用ＪＳ的charge");
                ExternalInterface.call("recharge");
            }
			//navigateToURL(new URLRequest(_dataModel._payUrlXML.chargeURL), _dataModel._payUrlXML.chargeURL.@method);
		}
		
		/**
		 * 所有选项为未选中状态
		 */
		private function resetBt():void
		{
			for (var i:String in _vipBts)
			{
				_vipBts[i].selected = false;
			}
		}
		
		/**
		 * 每日领取
		 * @param	e
		 */
		private function dialyClickHandler(e:MouseEvent):void
		{
			_dialyBt.clickEnable = false;
			if (_callBack != null)
			{
				_callBack(_dataModel.returnDialyBonus(_dataModel.lv), 1);
			}
		}
		
		/**
		 * 礼包领取
		 * @param	e
		 */
		private function clickHandler(e:MouseEvent):void
		{
			
			if (_callBack != null)
			{
				Debug.log("1-------------------_currentSelectedOption="+(_currentSelectedOption+1))
				_callBack(_dataModel.returnDialyBonus(_currentSelectedOption+1, "OnceBonus"), 2, _currentSelectedOption+1);
			}
		
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			_dataModel = null;
			dispatchEvent(new Event(CLOSE));
		}
		
		/**
		 * 刷新
		 * @param	param
		 */
		public function refresh(e:SMZTDataChangeEvent):void
		{
			Debug.log("2-------------refresh");
			_dataModel = e.dataObject;
			
			_dialyBt.clickEnable = _dataModel.dialy;
			Debug.log("3---------------_dataModel.dialy=" + _dataModel.dialy);
			
			updataUIafterOptionClick();
			
			for (var j:String in _vipBts)
			{
				_vipBts[j].canGet = false;
				
			}
			Debug.log("_dataModel.once=" + _dataModel.once)
			/*for (var j:String in _vipBts)
			{
				if (_dataModel.once[j] != null) {
					_vipBts[_dataModel.once[i] - 1].canGet = true;
					}else {
						
						}
				_vipBts[j].canGet = false;
			}*/
			
			if (_dataModel.once != null && _dataModel.once.length > 0)
			{
				for (var i:String in _dataModel.once)
				{
					Debug.log("5---------------i=" + _vipBts[_dataModel.once[i] - 1].canGet);
					_vipBts[_dataModel.once[i] - 1].canGet = true;
				}
			}
		
		}
		
		/**
		 * 返回指定ＶＩＰ等级的一次礼包是否已经领取
		 * @param	param
		 * @param	cb
		 */
		public function returnOnceGet(viplevel:int):Boolean
		{
			if (_dataModel.once != null && _dataModel.once.length > 0)
			{
				for (var i:String in _dataModel.once)
				{
					if (_dataModel.once[i] == viplevel)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 *
		 * @param	param
		 * @param	cb
		 * @param	bagPopPanel 物品提示框
		 */
		public function showModel(param:*, cb:Function = null, bagPopPanel:* = null,staticURL:String=""):void
		{
			Debug.log("ＶＩＰshowModel");
			_staticURL = staticURL;
			
			_bagPopPanel = bagPopPanel;
			
			_callBack = cb;
			
			_dataModel = param;
			
			_vipTypeIcoMc.gotoAndStop(_dataModel.lv + 1);
			var nextLevelExp:int = _dataModel.returnLevelExp(_dataModel.lv + 1);
			if (nextLevelExp == 0)
			{
				nextLevelExp = _dataModel.returnLevelExp(_dataModel.lv);
			}
			else if (nextLevelExp == -1)
			{
				Debug.log("ＶＩＰ配置出错");
			}
			if (_dataModel.lv< 7) {
				_tipText.htmlText = "只要您再消费<font color='#f4091f'>" + (nextLevelExp - _dataModel.exp) + "Q点</font>就能成为";
				_vipLevelMc3.gotoAndStop(_dataModel.lv + 1);
				_vipLevelMc3.x = _tipText.x + _tipText.textWidth + 10;
				_vipLevelMc3.visible = true;
				}else {
					_tipText.htmlText = "";
					_vipLevelMc3.visible = false;
					}
			
			_progressBar.gotoAndStop(int(_dataModel.exp / nextLevelExp * 100));
			if (_dataModel.exp > nextLevelExp) {
				_progressText.text = nextLevelExp + "/" + nextLevelExp;
				}else {
					_progressText.text = _dataModel.exp + "/" + nextLevelExp;
					}
			
			
			//设置各等级选项是否有可领取的礼包，有则显示可领取的状态
			_dialyBt.clickEnable = _dataModel.dialy;
			if (_dataModel.once != null && _dataModel.once.length > 0)
			{
				for (var i:String in _dataModel.once)
				{
					_vipBts[_dataModel.once[i] - 1].canGet = true;
				}
			}
			
			//如果是非ＶＩＰ默认选项为vip1
			if (_dataModel.lv == 0)
			{
				currentSelectedOption = 0;
			}
			else
			{
				currentSelectedOption = _dataModel.lv - 1;
			}
			updataUIafterOptionClick();
			setAppTextFormat(_progressText,_tipText);
			
			//设置各级的经验值
			for (var j:int = 0; j < _vipBts.length; j++)
			{
				_vipBts[j].number = _dataModel.returnLevelExp(j + 1);
			}
			
			//Debug.log("vip:" + _dataModel.lv);
			if (!_dataModel.hasEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH))
			{
				_dataModel.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, refresh);
			}
		}
		
		public function get currentSelectedOption():int
		{
			return _currentSelectedOption;
		}
		
		public function set currentSelectedOption(value:int):void
		{
			_currentSelectedOption = value;
			resetBt();
			_vipBts[value].selected = true;
		}
		
		public function get currentSeletedPage():int 
		{
			return _currentSeletedPage;
		}
		
		public function set currentSeletedPage(value:int):void 
		{
			if (_currentSeletedPage != value) {
				
				}
			_currentSeletedPage = value;
		}
	}

}