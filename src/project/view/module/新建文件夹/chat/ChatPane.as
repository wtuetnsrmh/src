package project.view.module.chat
{
	import com.adobe.serialization.json.JSON;
	import com.riaidea.text.RichTextField;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import project.config.SpecialItemIdConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTDomainManager;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.chat.ChatChannel;
	import project.model.chat.ChatMessage;
	import project.model.chat.ChatModle;
	import project.model.chat.HrefInfo;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.item.ItemModel;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.model.shop.ShopModel;
	import project.utils.Browser;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.component.comboBox.MyComboBox;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import project.view.MainPane;
	import project.view.module.shop.PurchasePanel;
	import project.view.ui.MyScrollBar;
	
	import project.view.layout.BaseGridContainer;
	
	/*
	 * 描述：聊天面板
	 *
	 */
	
	public class ChatPane extends BaseSpritePane
	{
		//----------------------容器---------------------------------
		private var _smileyContainer:Sprite;
		private var _grid:BaseGridContainer;
		//-----------------------UI---------------------------------
		//private var _upBt:MovieClipButton;
		//private var _downBt:MovieClipButton;
		private var _scroll:MyScrollBar; //滚动条类
		private var _privateScroll:MyScrollBar; //私聊滚动条类
		private var _customScrollUI:Sprite; //滚动条
		
		private var _BigHonr:RichTextField; //大喇叭-超级喇叭
		private var _private:RichTextField; //私聊
		private var _output:RichTextField; //综合
		private var _input:TextField;
		
		private var _worldBt:MovieClipButton;
		//private var _guildBt:MovieClipButton;
		private var _privateBt:MovieClipButton;
		private var _faceBt:MovieClipButton;
		private var _sendBt:MovieClipButton;
		
		private var _chatObjNameText:TextField; //聊天对象名字
		private var _comboBox:MyComboBox; // 
		
		private var _openBt:MovieClip; //展开合上按钮
		//-----------------------数据---------------------------------
		private var _currentEndRow:int = 0;//当前显示的最后一行
		//private var _timer:Timer = new Timer(8000); //每8秒去掉一个超级号角
		private var _bigHornRec:Rectangle; //超级号角遮罩
		private var _bigHornScorllGap:int = 18;
		
		private var _filter:GlowFilter;
		private var _loc_2:GlowFilter;
		private var _currentOpened:Boolean = false; //当前聊天窗口是否已经打开
		private var _currentPrivateChatUserId:int; //当前私聊对象的ID
		private var _currentPrivateChatUserName:String = "点TA"; //当前私聊对象的名称
		private var _currentSelectedBt:int = 0; //当前选中的状态
		private var maxRow:int = 30; //号角最多30条
		private var bigHornMaxRow:int = 1; //超级号角最多１条
		private var _maxLength:int = 50; //最多50个字符
		private var _chatModel:ChatModle;
		
		private var shortcuts:Array;
		
		private var _recordArr:Array;
		private var _bigHonrrecordArr:Array; //大喇叭缓存记录数组
		private var _privaterecordArr:Array;
		
		private var _smileys:Array = [Face0, Face1, Face2, Face3, Face4, Face5, Face6, Face7, Face8, Face9, Face10, Face11, Face12, Face13, Face14, Face15, Face16, Face17, Face18, Face19];
		//-----------------------事件--------------------------------
		
		private static var cp:ChatPane;
		
		public function ChatPane()
		{
			if (cp)
			{
				throw new Error("Error");
			}
			setSpriteInstance("chatUI");
			this.configerUIInstance();
			
			_recordArr = new Array();
			_bigHonrrecordArr = new Array();
			_privaterecordArr = new Array();
			
			setLocation(0, 351);
			_chatModel = ChatModle.getInstance();
			dataModel = _chatModel;
			
			if (stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
			}
			
			return;
		} // end function
		
		private function addToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			init();
		}
		
		override public function show(param1:Boolean = false):void
		{
			_rootContainer.addChild(this);
			return;
		} // end function
		
		private function init():void
		{
			_filter = new GlowFilter();
			_filter.color = 0x040404;
			_filter.alpha = 1;
			_filter.blurX = 2;
			_filter.blurY = 2;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			
			_loc_2 = new GlowFilter();
			_loc_2.color = 0xFFFFff;
			_loc_2.alpha = .5;
			_loc_2.blurX = 1;
			_loc_2.blurY = 1;
			_loc_2.quality = BitmapFilterQuality.MEDIUM;
			_loc_2.strength = 10;
			
			var txtFormat:TextFormat = new TextFormat("宋体", 12, 0xFFFFFF, false, false, false);
			txtFormat.leading = 5;
			//output rtf
			_output = new RichTextField();
			_output.x = 8;
			_output.y = 0;
			_output.setSize(325, 153);
			_output.type = RichTextField.DYNAMIC;
			_output.defaultTextFormat = txtFormat;
			_output.autoScroll = true;
			_output.name = "output";
			_spriteInstance.addChild(_output);
			_output.textfield.filters = [_filter];
			
			//some text for demo
			_output.html = true;
			_output.textRenderer.selectable = false;
			_output.textRenderer.mouseWheelEnabled = false;
			
			//--------------------------------------------------------
			
			_BigHonr = new RichTextField();
			_BigHonr.x =8;
			_BigHonr.y =37;
			_BigHonr.setSize(325, 43);
			_BigHonr.type = RichTextField.DYNAMIC;
			_BigHonr.defaultTextFormat = txtFormat;
			_BigHonr.autoScroll = true;
			_BigHonr.name = "BigHonr";
			_BigHonr.html = true;
			addChild(_BigHonr);
			_BigHonr.textRenderer.selectable = false;
			_BigHonr.textRenderer.mouseWheelEnabled = false;
			_BigHonr.textfield.filters = [_filter];
			
			//addChild(_upBt);
			//addChild(_downBt);
			//_upBt.x = 4;
			//--------------------------------------------------------
			_private = new RichTextField();
			_private.x = 8;
			_private.y = 0;
			_private.setSize(325, 153);
			_private.type = RichTextField.DYNAMIC;
			_private.defaultTextFormat = txtFormat;
			_private.autoScroll = true;
			_private.name = "privatechat";
			_spriteInstance.addChild(_private);
			_private.html = true;
			_private.textRenderer.selectable = false;
			_private.textRenderer.mouseWheelEnabled = false;
			_private.textfield.filters = [_filter];
			
			_output.addEventListener(TextEvent.LINK, linkListener, true, 0, true);
			_private.addEventListener(TextEvent.LINK, linkListener, true, 0, true);
			_BigHonr.addEventListener(TextEvent.LINK, linkListener, true, 0, true);
			//增加滚动条控制
			if (!_scroll)
			{
				_scroll = new MyScrollBar(_output, "R", 0, 10, "L", 1, 5, true, true, _output.viewWidth, _output.viewHeight, 0, Reflection.getClass("ChatScroStrye", SMZTDomainManager.getInstance().currentUIAppDomain), false, 0);
				_privateScroll = new MyScrollBar(_private, "R", 0, 10, "L", 1, 5, true, true, _private.viewWidth, _private.viewHeight, 0, Reflection.getClass("ChatScroStrye", SMZTDomainManager.getInstance().currentUIAppDomain), false, 0);
				
				_scroll.y = 70;
				_privateScroll.y = 70;
				_spriteInstance.addChild(_privateScroll)
				_spriteInstance.addChild(_scroll)
			}
			else
			{
				_scroll.myScroll.refresh();
				_privateScroll.myScroll.refresh();
			}
			/*_outputScrollBar = getUIScrollBar();
			   _outputScrollBar.setScrollProperties(250, 0,_output.viewHeight-250, 30);
			   _outputScrollBar.x = _output.x + _output.width;
			   _outputScrollBar.y = _output.y;
			   _outputScrollBar.height = 100;// _output.viewHeight;
			   addChild(_outputScrollBar);
			   _outputScrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			   function onScroll(event:ScrollEvent):void
			   {
			   _output.y = 60- event.position;
			 } */
			//input rtf			
			_input = new TextField();
			_input.x = 116.05;
			_input.y = 247.75;
			//_input.setSize(100, 50);
			_input.type = RichTextField.INPUT;
			_input.defaultTextFormat = txtFormat;
			//_input.name = "input";
			//_input.autoWordWrap = false;
			_input.width = 173.5;
			_input.height = 20;
			//_input.autoSize = "left";
			_input.multiline = false;
			_input.maxChars = _maxLength;
			_input.text = "";
			_input.addEventListener(FocusEvent.FOCUS_IN, focusinHandler);
			_input.addEventListener(FocusEvent.FOCUS_OUT, focusoutHandler);
			
			_spriteInstance.addChild(_input);
			
			//add smileys
			_smileyContainer = new Sprite();
			
			_spriteInstance.addChild(_smileyContainer);
			_smileyContainer.x = 255.95;
			_smileyContainer.y = 167.85;
			
			shortcuts = [{shortcut: "/:a", src: _smileys[0]}, {shortcut: "/:b", src: _smileys[1]}, {shortcut: "/:c", src: _smileys[2]}, {shortcut: "/:d", src: _smileys[3]}, {shortcut: "/:e", src: _smileys[4]}, {shortcut: "/:f", src: _smileys[5]}, {shortcut: "/:g", src: _smileys[6]}, {shortcut: "/:h", src: _smileys[7]}, {shortcut: "/:i", src: _smileys[8]}, {shortcut: "/:j", src: _smileys[9]}, {shortcut: "/:k", src: _smileys[10]}, {shortcut: "/:l", src: _smileys[11]}, {shortcut: "/:m", src: _smileys[12]}, {shortcut: "/:n", src: _smileys[13]}, {shortcut: "/:o", src: _smileys[14]}, {shortcut: "/:p", src: _smileys[15]}, {shortcut: "/:q", src: _smileys[16]}, {shortcut: "/:r", src: _smileys[17]}, {shortcut: "/:s", src: _smileys[18]}, {shortcut: "/:t", src: _smileys[19]}];
			createSmileys();
			_grid.visible = false;
			//_grid.addEventListener(FocusEvent.FOCUS_OUT, focusoutHandler);
			
			//correct focus
			//stage.focus = _input;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownhandler);
			
			currentSelectedBt = 0; //默认选择综合
			currentOpened = true;
			_worldBt.setSelected(true);
			setChatObjName("所有人");
			
			//_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			refreshBigHornScrol();
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			deleteOldBidHonr();
			refreshBigHornScrol();
		}
		
		/**
		 * 隐藏显示超级号角
		 * @param	e
		 */
		public function BigHonrShow(param:Boolean = false):void
		{
			if (_BigHonr)
			{
				_BigHonr.visible = param;
				/*if (param)
				{
					if (_BigHonr.textfield.textHeight > _bigHornRec.height)
					{
						showBigScrolBt(true);
					}
					else
					{
						showBigScrolBt();
					}
					return;
				}
				showBigScrolBt(param);*/
			}
		}
		
		/**
		 * 链接事件
		 * @param	e
		 */
		private function linkListener(e:TextEvent):void
		{
			e.stopImmediatePropagation();
			var temp:HrefInfo = new HrefInfo();
			temp.decode(e.text);
			
			if (temp.type == HrefInfo.PLAYER)
			{
				//不能对自己私聊
				if (temp.userId == PlayerData.getInstance().userId)
					return;
				ManagerPopMenu.getInstance().showMenu(temp);
					//stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			}
			else if (temp.type == HrefInfo.CARD)
			{
				//trace(temp.cardId);
				ClickPopCard.getInstance().currentCardId = temp.cardId;
				ClickPopCard.getInstance().show(true);
			}
		
		}
		
		/**
		 * 冻-解输入框
		 * @param	e
		 */ /*private function inputEnabel(value=false):void {
		   if (value) {
		   _input.selectable = true;
		   }else {
		   _input.selectable = false;
		   }
		 }*/
		
		private function focusoutHandler(e:FocusEvent):void
		{
			switch (e.currentTarget)
			{
				case _grid: 
					_grid.visible = false;
					break;
				case _input: 
					if (_input.text == "")
					{
						_input.text = "";
					}
					break;
			}
		}
		
		//移入焦点后文本为空
		private function focusinHandler(e:FocusEvent):void
		{
			if (_input.text == "")
			{
				_input.text = "";
			}
		}
		
		private function onKeyDownhandler(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER && _input.length > 0)
			{
				sendMessage();
			}
		}
		
		//返回相应的表情类名
		private function findFaceClass(value:String):Object
		{
			for (var i:int = 0; i < shortcuts.length; i++)
			{
				if (shortcuts[i].shortcut == value)
				{
					return shortcuts[i].src;
				}
			}
			return "";
		}
		
		/**
		 * 如果当前是号角或是超级号角，则检测是否有道具，没有则提示购买
		 * @param	value
		 */
		private function judgestHavedItem():Boolean
		{
			
			var tempItem:ItemModel;
			var temp:PurchasePanel;
			var tempGoodModel:GoodsModel;
			
			switch ((_comboBox.currentIndex + 1))
			{
				case ChatChannel.S_HORN: 
					//使用号角
					tempItem = BagData.getInstance().findBagItemById(SpecialItemIdConfig.SMALL_HORN);
					if (tempItem == null)
					{
						//如果商场中没有数据则先加载商场数据
						temp = PurchasePanel.getInstance();
						
						if (!ShopModel.getInstance().list.length > 0)
						{
							SMZTController.getInstance().getShopGoods(function():void
								{
									//背包中没有号角时提示购买
									temp.show(true);
									tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(SpecialItemIdConfig.SMALL_HORN);
									tempGoodModel.autoSetPriceType();
									temp.goodModel = tempGoodModel;
									temp = null;
									tempGoodModel = null;
								}, true);
						}
						else
						{
							temp.show(true);
							tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(SpecialItemIdConfig.SMALL_HORN);
							tempGoodModel.autoSetPriceType();
							temp.goodModel = tempGoodModel;
							temp = null;
							tempGoodModel = null;
						}
						return false;
					}
					else
					{
						BagData.getInstance().itemUsedReduceNum(SpecialItemIdConfig.SMALL_HORN);
						return true;
					}
					break;
				case ChatChannel.B_HORN: 
					//使用超级号角
					tempItem = BagData.getInstance().findBagItemById(SpecialItemIdConfig.BIG_HORN);
					if (tempItem == null)
					{
						//如果商场中没有数据则先加载商场数据
						temp = PurchasePanel.getInstance();
						if (!ShopModel.getInstance().list.length > 0)
						{
							SMZTController.getInstance().getShopGoods(function():void
								{
									//背包中没有超级号角时提示购买
									tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(SpecialItemIdConfig.BIG_HORN);
									tempGoodModel.autoSetPriceType();
									if (tempGoodModel.priceType == PurchaseType.CRYSTAL) {
										//是水晶则直接调JS
										Browser.buyItem(tempGoodModel.id);
										
										}else {
											temp.show(true);
											temp.goodModel = tempGoodModel;
											temp = null;
											tempGoodModel = null;
											}
								}, true);
						}
						else
						{
							
							tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(SpecialItemIdConfig.BIG_HORN);
							tempGoodModel.autoSetPriceType();
							if (tempGoodModel.priceType == PurchaseType.CRYSTAL) {
								//是水晶则直接调JS
								Browser.buyItem(tempGoodModel.id);
								
								}else {
									temp.show(true);
									temp.goodModel = tempGoodModel;
									temp = null;
									tempGoodModel = null;
									}
						}
						
						return false;
					}
					else
					{
						BagData.getInstance().itemUsedReduceNum(SpecialItemIdConfig.BIG_HORN);
						return true;
					}
					break;
				default: 
					return true;
					break;
			}
			
			return false;
		}
		
		/**
		 * 发送一张卡牌信息
		 * @param	evt
		 */
		public function sendCardInfo(value:String):void
		{
			if (!judgestHavedItem())
				return;
			
			//如果是私聊判断是否有聊天对象
			if ((_comboBox.currentIndex + 1) == ChatChannel.PRIVATE && _currentPrivateChatUserId == 0)
			{
				return;
			}
			
			//发送信息到服务端
			var tempMsgObj:Object = new Object();
			tempMsgObj.userId = PlayerData.getInstance().userId;
			tempMsgObj.userName = PlayerData.getInstance().nick;
			tempMsgObj.channel = _comboBox.currentIndex + 1;
			tempMsgObj.title = PlayerData.getInstance().title;
			tempMsgObj.msg = value;
			var tempChatMessage:ChatMessage = new ChatMessage(tempMsgObj);
			(tempMsgObj.channel == ChatChannel.PRIVATE) ? tempChatMessage.toUserId = _currentPrivateChatUserId : tempChatMessage.toUserId = 0;
			tempMsgObj = null;
			sendOneMes(tempChatMessage);
			
			//tempChatMessage.msg = value;
			showOneMes(tempChatMessage, true);
		}
		
		private function sendMessage(evt:MouseEvent = null):void
		{
			if (_input.text == "")
			{
				_input.text = "";
				return;
			}
			else
			{
				stage.focus = _input;
			}
			
			if (_input.text.length == 0)
				return;
			
			//判断是否有道具
			if (!judgestHavedItem())
				return;
			
			//如果是私聊判断是否有聊天对象
			if ((_comboBox.currentIndex + 1) == ChatChannel.PRIVATE && (_currentPrivateChatUserId == 0 || _currentPrivateChatUserId==PlayerData.getInstance().userId))
			{
				return;
			}
			
			//发送信息到服务端
			var tempMsgObj:Object = new Object();
			tempMsgObj.userId = PlayerData.getInstance().userId;
			tempMsgObj.userName = PlayerData.getInstance().nick;
			tempMsgObj.channel = _comboBox.currentIndex + 1;
			tempMsgObj.title = PlayerData.getInstance().title;
			tempMsgObj.msg = _input.text.replace(/>/g, "&gt;").replace(/</g, "&lt;");
			var tempChatMessage:ChatMessage = new ChatMessage(tempMsgObj);
			(tempMsgObj.channel == ChatChannel.PRIVATE) ? tempChatMessage.toUserId = _currentPrivateChatUserId : tempChatMessage.toUserId = 0;
			tempMsgObj = null;
			sendOneMes(tempChatMessage);
			
			//tempChatMessage.msg = _input.text;
			showOneMes(tempChatMessage, true);
			_input.text = "";
		
			//_scroll.setLocationByRate(0);
			//_outputScrollBar.scrollPosition = _outputScrollBar.maxScrollPosition;
		}
		
		/**
		 * 发送一条消息
		 * @param	msg
		 * @param	toUserId 发送目标玩家编号
		 */
		private function sendOneMes(msg:ChatMessage):void
		{
			SMZTController.getInstance().sendMessage(msg.channel, msg.msg, msg.toUserId);
		}
		
		/**
		 * 显示一条信息
		 * @msg 信息
		 * @selfSend 是否是自己发送的内容，如果是私聊时设置相应的显示名字
		 */
		private function showOneMes(msg:ChatMessage, selfSend:Boolean = false):void
		{
			//如果有聊天且聊天框关闭时给出提示
			if (!_currentOpened) {
				_openBt.gotoAndStop(3);
				}
			
			var faceArr:Array = new Array();
			var price:RegExp = /\/:[a-t]{1}/g
			
			var returnStr:String = returnHtmlText(msg, selfSend);
			var temText:TextField = new TextField();
			temText.htmlText = returnStr;
			//记录表情索引
			var replacedStr:String = temText.text;
			temText.text = (temText.text.replace(price, usdToEuro1));
			temText = null;
			
			//usdToEuro1(temText.text);
			function usdToEuro1(value:String):String
			{
				var s:String
				//trace(arguments.length)
				////trace("index=" + arguments[1])
				////trace("replacestr=" + arguments[0])
				////trace("str=" + arguments[2])
				var tempObj:Object = new Object();
				//tempObj.index = arguments[1] - (faceArr.length * 3); //依次减3*长度
				//trace(arguments[2].search(arguments[0]));
				
				tempObj.index = replacedStr.indexOf(arguments[0]) - (faceArr.length * 3); //依次减3*长度
				replacedStr = replacedByValue(arguments[0]);
				////trace("replacedStr=" + replacedStr)
				tempObj.src = findFaceClass(arguments[0]);
				faceArr.push(tempObj);
				tempObj = null;
				return "";
			}
			/**
			 * 返回去掉指定字符的字符
			 */
			function replacedByValue(param:String):String
			{
				
				return replacedStr.replace(param, "︻﹃﹁");
			}
			
			msg.msg = returnStr;
			//替换表情特定字符
			msg.msg = (msg.msg.replace(price, usdToEuro));
			function usdToEuro():String
			{
				//trace(arguments.length)
				/*//trace("index=" + arguments[1])
				   //trace("replacestr=" + arguments[0])
				   var tempObj:Object = new Object();
				   tempObj.index = arguments[1] - (faceArr.length * 3); //依次减3*长度
				   tempObj.src = findFaceClass(arguments[0]);
				   faceArr.push(tempObj);
				 tempObj = null;*/
				return "";
			}
			
			var recordObj:Object = new Object();
			switch (msg.channel)
			{
				case ChatChannel.S_HORN: 
					//号角
					_output.append(msg.msg, faceArr, true);
					recordObj.startIndex = _output.oldLength;
					////trace("recordObj.startIndex="+recordObj.startIndex)
					recordObj.endIndex = _output.textRenderer.length;
					////trace("recordObj.endIndex="+recordObj.endIndex)
					recordObj.faces = faceArr;
					_recordArr.push(recordObj);
					
					_scroll.setMaxY();
					break;
				case ChatChannel.PRIVATE: 
					_output.append(msg.msg, faceArr, true);
					recordObj.startIndex = _output.oldLength;
					////trace("recordObj.startIndex="+recordObj.startIndex)
					recordObj.endIndex = _output.textRenderer.length;
					////trace("recordObj.endIndex="+recordObj.endIndex)
					recordObj.faces = faceArr;
					_recordArr.push(recordObj);
					recordObj = null;
					
					recordObj = new Object();
					_private.append(msg.msg, faceArr, true);
					recordObj.startIndex = _private.oldLength;
					recordObj.endIndex = _private.textRenderer.length;
					recordObj.faces = faceArr;
					_privaterecordArr.push(recordObj);
					
					_scroll.setMaxY();
					_privateScroll.setMaxY();
					break;
				case ChatChannel.B_HORN: 
					//超级号角
					_BigHonr.append(msg.msg, faceArr, true);
					recordObj.startIndex = _BigHonr.oldLength;
					////trace("recordObj.startIndex="+recordObj.startIndex)
					recordObj.endIndex = _BigHonr.textRenderer.length;
					////trace("recordObj.endIndex="+recordObj.endIndex)
					recordObj.faces = faceArr;
					_bigHonrrecordArr.push(recordObj);
					recordObj = null;
					judgestFull(msg.channel);
					refreshBigHornScrol();
					/*if (!_timer.running)
					{
						_timer.start();
					}*/
					
					_currentEndRow = _BigHonr.textfield.numLines-1;
					//trace("_currentEndRow=" + _currentEndRow);
					break;
			}
			
			faceArr = null;
			recordObj = null;
			judgestFull(msg.channel);
		
		}
		
		/**
		 * 刷新超级号角位置
		 */
		private function refreshBigHornScrol():void
		{
			/*if (_BigHonr.textfield.textHeight > _bigHornRec.height)
			{
				if (SMZTUIManager.getInstance().mainPane.currentSceneId == 0 || _currentOpened) {
					//是主场景或是聊天打开状态时
					showBigScrolBt(true);
					}else {
						showBigScrolBt(false);
						}
				
				_bigHornRec.y = _BigHonr.textfield.textHeight - _bigHornRec.height + 5;
			}
			else
			{
				//showBigScrolBt();
				_bigHornRec.y = 0;
			}*/
			var metrics1:TextLineMetrics = _BigHonr.textfield.getLineMetrics(_BigHonr.textfield.numLines-1);
			_BigHonr.y = 53.55 - _BigHonr.textfield.textHeight;// + metrics1.height;
			//_BigHonr.scrollRect = _bigHornRec;
		}
		
		/**
		 * 显示/隐藏上下滚动按钮
		 */
		private function showBigScrolBt(param:Boolean = false):void
		{
			//_upBt.visible = param;
			//_downBt.visible = param;
			if (param) {
				_BigHonr.x = 23;
				}else {
					_BigHonr.x = 8;
					}
			
		}
		
		/**
		 * 根据频道返回相应的HTMLTEXT
		 * @param	msg
		 * 0x709979,0x6B67C1,0xCA77C5];
		 */
		private function returnHtmlText(msg:ChatMessage, selfSend:Boolean = false):String
		{
			var str:String = msg.msg;
			var temp:Object = new Object();
			switch (msg.channel)
			{
				
				case ChatChannel.S_HORN: 
					//号角
					//"<a href=\"event:track1.mp3\">Track 1</a>"
					
					temp.type = HrefInfo.PLAYER;
					temp.userId = msg.userId;
					temp.userName = msg.userName;
					if (msg.title == "无") {
						str = "<font color='#09a8fa'><a href='event:" + returnSplitString(temp) + "'>" + msg.userName + "</a> :</font><font color='#09fde9'>" + msg.realMsg + "</font>";
						}else {
							str = "<font color='#d36c03'>["+msg.title+"]</font><font color='#09a8fa'><a href='event:" + returnSplitString(temp) + "'>" + msg.userName + "</a> :</font><font color='#09fde9'>" + msg.realMsg + "</font>";
							}
					
					return str;
					break;
				case ChatChannel.PRIVATE: 
					if (selfSend)
					{
						//自己发送
						temp.type = HrefInfo.PLAYER;
						temp.userId = msg.userId
						temp.userName = msg.userName;
						var tempMe:String = returnSplitString(temp);
						
						temp = new Object();
						temp.type = HrefInfo.PLAYER;
						temp.userId = _currentPrivateChatUserId;
						temp.userName = _chatObjNameText.text;
						var tempTo:String = returnSplitString(temp);
						str = "<font color='#c25edf'>[私聊]</font> <font color='#1481fb'><a href='event:" + tempMe + "'>" + "你" + "</a></font><font color='#c865e5'> 对</font><font color='#1481fb'> <a href='event:" + tempTo + "'>" + _chatObjNameText.text + "</a></font> :<font color='#d063ef'>" + msg.realMsg + "</font>";
					}
					else
					{
						//收到别人给我的私聊
						temp.type = HrefInfo.PLAYER;
						temp.userId = msg.userId
						temp.userName = msg.userName;
						var tempMe:String = returnSplitString(temp);
						
						temp = new Object();
						temp.type = HrefInfo.PLAYER;
						temp.userId = PlayerData.getInstance().userId;
						temp.userName = PlayerData.getInstance().nick;
						var tempTo:String = returnSplitString(temp);
						str = "<font color='#c25edf'>[私聊]</font><font color='#1481fb'> <a href='event:" + tempMe + "'>" + msg.userName + "</a></font><font color='#c865e5'> 对</font><font color='#1481fb'> <a href='event:" + tempTo + "'>" + "你" + "</a></font> :<font color='#d063ef'>" + msg.realMsg + "</font>";
						/*str = "<font color='#c25edf'>[私聊][<a href='event:" + tempMe + "'>" + msg.userName + "</a>]对[<a href='event:" + tempTo + "'>" + PlayerData.getInstance().nick + "</a>]说:" + msg.realMsg + "</font>";*/
					}
					temp = null;
					
					break;
				case ChatChannel.B_HORN: 
					//超级号角
					temp.type = HrefInfo.PLAYER;
					temp.userId = msg.userId
					temp.userName = msg.userName;
					if (msg.title == "无") {
						str = "<font color='#09a8fa'><a href='event:" + returnSplitString(temp) + "'>" + msg.userName + "</a> :</font><font color='#f7fafa'>" + msg.realMsg + "</font>";
						}else {
							str = "<font color='#d36c03'>["+msg.title+"]</font><font color='#09a8fa'><a href='event:" + returnSplitString(temp) + "'>" + msg.userName + "</a> :</font><font color='#f7fafa'>" + msg.realMsg + "</font>";
							}
					
					//str = "<font color='#24fcff'>["+msg.title+"][<a href='event:" + returnSplitString(temp) + "'>" + msg.userName + "</a>]说:" + msg.realMsg + "</font>";
					break;
			}
			return str;
		}
		
		/**
		 * 以_分割对象
		 * @param	channel
		 */
		private function returnSplitString(temp:Object, type:int = 1):String
		{
			var str:String;
			switch (type)
			{
				case 1: 
					str = temp.type + "_" + temp.userId + "_" + temp.userName;
					break;
				case 2: 
					str = temp.type + "_" + temp.cardId;
					break;
			}
			return str;
		}
		
		//是否超过30条，超级号角2条
		private function judgestFull(channel:int):void
		{
			var tempObj:Object;
			switch (channel)
			{
				case ChatChannel.S_HORN: 
					//号角
					if (_recordArr.length > maxRow)
					{
						tempObj = _recordArr.shift();
						if (tempObj.faces.length > 0)
						{
							for (var i:String in tempObj.faces)
							{
								_output.spriteRenderer.removeSprite(tempObj.faces[i].index);
							}
						}
						
						_output.replace(tempObj.startIndex, tempObj.endIndex, "");
						resetArr(_recordArr, tempObj.endIndex - tempObj.startIndex);
					}
					break;
				case ChatChannel.PRIVATE: 
					if (_recordArr.length > maxRow)
					{
						tempObj = _recordArr.shift();
						if (tempObj.faces.length > 0)
						{
							for (var i:String in tempObj.faces)
							{
								_output.spriteRenderer.removeSprite(tempObj.faces[i].index);
							}
						}
						
						_output.replace(tempObj.startIndex, tempObj.endIndex, "");
						resetArr(_recordArr, tempObj.endIndex - tempObj.startIndex);
					}
					
					if (_privaterecordArr.length > maxRow)
					{
						tempObj = _privaterecordArr.shift();
						if (tempObj.faces.length > 0)
						{
							for (var i:String in tempObj.faces)
							{
								_private.spriteRenderer.removeSprite(tempObj.faces[i].index);
							}
						}
						
						_private.replace(tempObj.startIndex, tempObj.endIndex, "");
						resetArr(_privaterecordArr, tempObj.endIndex - tempObj.startIndex);
					}
					break;
				case ChatChannel.B_HORN: 
					//超级号角最多显示1条
					if (_bigHonrrecordArr.length > bigHornMaxRow)
					{
						deleteOldBidHonr();
						/*tempObj = _bigHonrrecordArr.shift();
						   if (tempObj.faces.length > 0)
						   {
						   for (var i:String in tempObj.faces)
						   {
						   _BigHonr.spriteRenderer.removeSprite(tempObj.faces[i].index);
						   }
						   }
						
						   _BigHonr.replace(tempObj.startIndex, tempObj.endIndex, "");
						 resetArr(_bigHonrrecordArr, tempObj.endIndex - tempObj.startIndex);*/
					}
					break;
			}
			tempObj = null;
		}
		
		/**
		 * 删除一条超级号角
		 * @param	arr
		 * @param	value
		 */
		private function deleteOldBidHonr():void
		{
			
			var tempObj:Object = new Object();
			tempObj = _bigHonrrecordArr.shift();
			if (tempObj.faces.length > 0)
			{
				for (var i:String in tempObj.faces)
				{
					_BigHonr.spriteRenderer.removeSprite(tempObj.faces[i].index);
				}
			}
			
			_BigHonr.replace(tempObj.startIndex, tempObj.endIndex, "");
			resetArr(_bigHonrrecordArr, tempObj.endIndex - tempObj.startIndex);
			
			tempObj = null;
			
			if (_bigHonrrecordArr.length == 0)
			{
				//_timer.stop();
				return;
			}
		}
		
		//重新调整各缓存记录中的始尾索引
		private function resetArr(arr:Array, value:int):void
		{
			for (var i:String in arr)
			{
				arr[i].startIndex -= (value);
				arr[i].endIndex -= (value);
			}
		}
		
		private function insertSmiley(evt:MouseEvent):void
		{
			stage.focus = _input;
			
			var smiley:Sprite = evt.currentTarget as Sprite;
			if (_input.length >= _maxLength)
				return;
			_input.replaceText(_input.caretIndex, _input.caretIndex, shortcuts[int(smiley.name.substring(4, smiley.name.length))].shortcut);
			_input.setSelection(_input.length, _input.length);
			
			_grid.visible = false;
		}
		
		private function createSmileys():void
		{
			_grid = new BaseGridContainer(4, 5, 3, 17, 17);
			for (var i:int = 0; i < _smileys.length; i++)
			{
				var smiley:Sprite = new _smileys[i]() as Sprite;
				
				_grid.appendChild(smiley);
				/*smiley.x = (i % 8) * 35;
				 smiley.y = Math.floor(i / 8) * 30;*/
				smiley.buttonMode = true;
				smiley.name = "face" + i;
				smiley.addEventListener(MouseEvent.CLICK, insertSmiley);
			}
			_grid.graphics.lineStyle(1, 0xD8E1E0);
			_grid.graphics.beginFill(0xffffff);
			_grid.graphics.drawRect(-2, -2, 100, 80);
			_grid.graphics.endFill();
			_smileyContainer.addChild(_grid);
		}
		
		private function configerUIInstance():void
		{
			_openBt = getChild("openBt") as MovieClip;
			_openBt.buttonMode = true;
			addChild(_openBt);
			_openBt.x = 338.45;
			_openBt.y = -28;
			
			//_upBt = getChild("upBt") as MovieClipButton;
			//_downBt = getChild("downBt") as MovieClipButton;
			//_upBt.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			//_upBt.addEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
			//_upBt.addEventListener(MouseEvent.MOUSE_OUT, mouseDownHandler);
			//_downBt.addEventListener(MouseEvent.MOUSE_OUT, mouseDownHandler);
			//_downBt.addEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
			//_downBt.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			_worldBt = getChild("worldBt") as MovieClipButton;
			//_guildBt = getChild("guildBt") as MovieClipButton;
			_privateBt = getChild("privateBt") as MovieClipButton;
			_worldBt.clickEnable = true;
			_privateBt.clickEnable = true;
			_faceBt = getChild("faceBt") as MovieClipButton;
			_sendBt = getChild("sendBt") as MovieClipButton;
			_worldBt.onClick = clickHandler;
			//_guildBt.clickEnable = false;
			//_guildBt.onClick = clickHandler;//公会暂时没有
			_privateBt.onClick = clickHandler;
			_faceBt.onClick = clickHandler;
			_sendBt.onClick = sendMessage;
			
			_chatObjNameText = getChild("chatObjNameText") as TextField;
			
			_comboBox = new MyComboBox("comboBoxUI");
			_comboBox.dataModel = ["号角", "私聊", "超级号角"];
			_comboBox.y = 248;
			_spriteInstance.addChild(_comboBox);
			
			_openBt.addEventListener(MouseEvent.CLICK, openBtClickHandler);
			
			_bigHornRec = new Rectangle(0, 0, 324, 60);
			
			_spriteInstance.addChild(_worldBt);
			return;
		} // end function
		
		/*private function mouseDownHandler(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case _upBt: 
					moveTopBigHornScrol();
					break;
				case _downBt: 
					moveBottonBigHornScrol();
					break;
			}
		}*/
		
		/**
		 * 向上滚动
		 */
		private function moveTopBigHornScrol():void
		{
			
			/*if (_currentEndRow < (_BigHonr.textfield.numLines-1)) {
				_currentEndRow++;
				}else {
					_currentEndRow = _BigHonr.textfield.numLines - 1;
					}
			var metrics1:TextLineMetrics = _BigHonr.textfield.getLineMetrics(_currentEndRow);
			_bigHornScorllGap = metrics1.height;*/
			
			if ((_bigHornRec.y - _bigHornScorllGap) > 0)
			{
				_bigHornRec.y -= _bigHornScorllGap;
			}
			else
			{
				_bigHornRec.y = 0;
			}
			_BigHonr.scrollRect = _bigHornRec;
		}
		
		private function moveBottonBigHornScrol():void
		{
			/*if (_BigHonr.textfield.textHeight < _bigHornRec.height)
				return;
			
			if (_currentEndRow >0) {
				_currentEndRow--;
				}
			var metrics1:TextLineMetrics = _BigHonr.textfield.getLineMetrics(_currentEndRow);	
			_bigHornScorllGap = metrics1.height;*/
			
			if ((_bigHornRec.y + _bigHornScorllGap) < (_BigHonr.textfield.textHeight - _bigHornRec.height + 5))
			{
				_bigHornRec.y += _bigHornScorllGap;
			}
			else
			{
				_bigHornRec.y = _BigHonr.textfield.textHeight - _bigHornRec.height + 5;
			}
			_BigHonr.scrollRect = _bigHornRec;
		}
		
		/**
		 * 设置聊天对象名字
		 * @param	e
		 */
		public function setChatObjName(value:String):void
		{
			if (value != "所有人")
			{
				_chatObjNameText.text = _currentPrivateChatUserName;
				return;
			}
			_chatObjNameText.text = value;
		}
		
		/**
		 * 展开合上按钮点击事件
		 * @param	e
		 */
		public function openBtClickHandler(e:MouseEvent = null):void
		{
			if (_currentOpened)
			{
				//合上
				//屏蔽滚动条滚轮事件
				_privateScroll.myScroll.mouseWheel = false;
				_scroll.myScroll.mouseWheel = false;
				
				_spriteInstance.visible = false;
				_openBt.gotoAndStop(2);
				_openBt.x = 0;
				_openBt.y = 223;
				_currentOpened = false;
				
				ManagerPopMenu.getInstance().hideMenu();
				//_filter.strength = 5;
				_BigHonr.textfield.filters = [_filter];
				if (SMZTUIManager.getInstance().mainPane.currentSceneId != 0)
				{
					//如果不是主场合上时隐藏超级号角
					BigHonrShow();
				}
				
			}
			else
			{
				//展开
				
				_privateScroll.myScroll.mouseWheel = true;
				_scroll.myScroll.mouseWheel = true;
				
				_spriteInstance.visible = true;
				_openBt.gotoAndStop(1);
				_openBt.x = 342.45;
				_openBt.y = 40.05;
				_currentOpened = true;
				
				_filter.strength = 5;
				_BigHonr.textfield.filters = [_filter];
				BigHonrShow(true);
				//展开时判断是否要显示上下滚动按钮
				/*if (_BigHonr.textfield.textHeight > _bigHornRec.height)
				{
					showBigScrolBt(true);
				}
				else
				{
					showBigScrolBt();
				}*/
				
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			
			switch (e.currentTarget)
			{
				case _worldBt: 
					currentSelectedBt = 0;
					_worldBt.setSelected(true);
					
					_privateBt.setSelected();
					
					_scroll.setMaxY();
					break;
				/*case _guildBt: 
					currentSelectedBt = 1;
					break;*/
				case _privateBt: 
					_worldBt.setSelected();
					_privateBt.setSelected(true);
					currentSelectedBt = 2;
					
					_privateScroll.setMaxY();
					break;
				case _faceBt: 
					_grid.visible = true;
					stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
					break;
			}
		}
		
		/**
		 * 场景增加侦听，如果点击的不是聊天表情面板则关闭聊天面板
		 * @param	e
		 */
		private function stageClickHandler(e:MouseEvent):void
		{
			/*if (!(e.target is PopMenu)) {
			   //trace("popmenu");
			   ManagerPopMenu.getInstance().hideMenu();
			   stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);
			 }*/
			if (String(e.target.name).indexOf("face") < 0)
			{
				stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);
				_grid.visible = false;
			}
		}
		
		override protected function onAddToStage(event:Event):void
		{
			return;
		} // end function
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			if (_chatModel.msgs.length > 0)
			{
				showOneMes(_chatModel.msgs.shift());
			}
			return;
		} // end function
		
		public static function getInstance():ChatPane
		{
			if (!cp)
			{
				cp = new ChatPane;
			}
			return cp;
		} // end function
		
		public function get currentSelectedBt():int
		{
			return _currentSelectedBt;
		}
		
		public function set currentSelectedBt(value:int):void
		{
			_currentSelectedBt = value;
			switch (_currentSelectedBt)
			{
				case 0: 
					_scroll.visible = true;
					_privateScroll.visible = false;
					_output.visible = true;
					_private.visible = false;
					break;
				case 1: 
					Debug.log("公会不可用");
					break;
				case 2: 
					_scroll.visible = false;
					_privateScroll.visible = true;
					_output.visible = false;
					_private.visible = true;
					break;
			
			}
		}
		
		public function get currentOpened():Boolean
		{
			return _currentOpened;
		}
		
		public function set currentOpened(value:Boolean):void
		{
			_currentOpened = value;
			openBtClickHandler();
		}
		
		public function get currentPrivateChatUserId():int
		{
			return _currentPrivateChatUserId;
		}
		
		public function set currentPrivateChatUserId(value:int):void
		{
			_currentPrivateChatUserId = value;
		}
		
		public function get currentPrivateChatUserName():String
		{
			return _currentPrivateChatUserName;
		}
		
		public function set currentPrivateChatUserName(value:String):void
		{
			if ((_comboBox.currentIndex + 1) == ChatChannel.PRIVATE)
			{
				//如果当前是私聊时设置聊天对象名字
				_chatObjNameText.text = value;
			}
			_currentPrivateChatUserName = value;
		}
		
		public function get comboBox():MyComboBox
		{
			return _comboBox;
		}
		
		public function set comboBox(value:MyComboBox):void
		{
			_comboBox = value;
		}
	
	}
}
