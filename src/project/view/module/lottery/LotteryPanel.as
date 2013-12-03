package project.view.module.lottery
{
	import com.adobe.serialization.json.JSON;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.BagData;
	import project.model.item.ItemModel;
	import project.model.log.EventLogModel;
	import project.model.lottery.LotteryModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.layout.BaseGridContainer;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.attack.AttackPanel;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.log.LogPanel;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class LotteryPanel extends BaseTitleWindow
	{
		//----------------------容器---------------------------------
		private var _girdContainer:BaseGridContainer;
		//-----------------------UI---------------------------------
		public static const TRAINING:String = "training";//战争学院后的抽奖
		public static const STATUE_SIGN:String = "sign";//每日签到的抽奖
		public static const LOG:String = "log";//日志的抽奖
		
		private var _goldHand:MovieClipButton;//金手指
		private var _numText:TextField; //去掉要花费的数量
		private var _buyBy:MovieClipButton; //购买
		private var _immediatelyBt:MovieClipButton; //立即抽奖
		private var _laterBt:MovieClipButton; //稍后抽奖
		private var _getBt:MovieClipButton; //直接获得
		private var _bagBt:MovieClipButton; //放入包裹
		//-----------------------数据---------------------------------
		private var _lotteryModel:LotteryModel;
		private var _slots:Array;
		private var _discards:Array; //丢弃的卡（数组下标）
		private var _enoughItem:Boolean = true; //是否有足够的金手指
		private var _timer:Timer = new Timer(2000); //2秒后请求获取物品
		private var _scrolTimer:Timer = new Timer(100); //随机滚动显示选中物品
		private var _state:String = "training";//当前所属状态
		//-----------------------事件--------------------------------
		
		private static var _lotteryPanel:LotteryPanel;
		
		public function LotteryPanel()
		{
			if (_lotteryPanel != null)
			{
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
			}
			
			setSpriteInstance("LotteryPanel");
			configUiInstance();
			_lotteryModel = LotteryModel.getInstance();
			dataModel = _lotteryModel;
		}
		
		private function configUiInstance():void
		{
			_girdContainer = new BaseGridContainer(1, 5, 12, 64.55, 88.5);
			addChild(_girdContainer);
			_girdContainer.setLocation(68.85, 107.2);
			_slots = new Array();
			for (var i:int = 0; i < 5; i++)
			{
				var tempSlot:RemoveLotterySlot = new RemoveLotterySlot();
				_girdContainer.appendChild(tempSlot);
				_slots.push(tempSlot);
				tempSlot = null;
			}
			
			_immediatelyBt = getChild("immediatelyBt") as MovieClipButton;
			_goldHand = getChild("goldHand") as MovieClipButton;
			_goldHand.toolTip = LocalConfig.LOCAL_LAN.LotteryPanel.GoldItemTip.@Text;//金手指提示
			_goldHand.buttonMode = false;
			
			_getBt = getChild("getBt") as MovieClipButton;
			_bagBt = getChild("bagBt") as MovieClipButton;
			_bagBt.visible = false;
			_getBt.visible = false;
			_buyBy = getChild("buyBy") as MovieClipButton;
			_laterBt = getChild("laterBt") as MovieClipButton;
			_numText = getChild("numText") as TextField;
			_immediatelyBt.onClick = onclickHandler;
			_laterBt.onClick = onclickHandler;
			_bagBt.onClick = onclickHandler;
			_buyBy.onClick = onclickHandler;
			_getBt.onClick = onclickHandler;
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_scrolTimer.addEventListener(TimerEvent.TIMER, scrolTimerHandler);
		}
		
		//请求获得的物品
		private function timerHandler(e:TimerEvent = null):void
		{
			_timer.stop();
			var tempArr:Array = new Array();
			for (var i:int = 0; i < _slots.length; i++)
			{
				if ((_slots[i] as RemoveLotterySlot).discardFlag)
				{
					tempArr.push(i);
				}
			}
			SMZTController.getInstance().startLottery(_lotteryModel.currentLotteryId, JSON.encode(tempArr), function(param:Object):void
				{
					_scrolTimer.stop();
					for (var i:String in _slots)
					{
						_slots[i].selected(false); //都为未选中状态
						if ((_slots[i] as RemoveLotterySlot).item.itemId == param.id)
						{
							_slots[i].selected(true); //显示最终的物品
							_bagBt.visible = true;
							
							//更新背包
							SMZTController.getInstance().getBagData(false);
						}
					}
				});
			tempArr = null;
		}
		
		//随机显示物品
		private function scrolTimerHandler(e:TimerEvent):void
		{
			var tempArr:Array = new Array();
			for (var i:String in _slots)
			{
				if (!_slots[i].discardFlag)
				{
					//把没去掉的槽下标放入临时数组
					tempArr.push(i);
				}
				_slots[i].selected(false); //都为未选中状态
			}
			_slots[tempArr[Math.floor(Math.random() * tempArr.length)]].selected(true); //随机显示一个槽
		}
		
		private function onclickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case _laterBt: 
					LotteryModel.getInstance().lotteryIdArr.unshift(LotteryModel.getInstance().currentLotteryId); //保存抽奖ID
					AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.LotteryPanel.LaterTip.@Text);
					hide();
					break;
				case _immediatelyBt: 
					if (_enoughItem)
					{
						startLottery();
						setClickenable(false);
					}
					else
					{
						//金手指不够
						showNoEnoughItem();
					}
					break;
				case _buyBy:
					UseItemControler.showBuyWin(SpecialItemIdConfig.GOLD_FINGER);
					break;
				case _bagBt:
					//放入包裹
					if (LogPanel.getInstance().isOpened) {
						//如果日志面板打开则更新
						SMZTController.getInstance().getLogListData(function (param:Object):void {
							EventLogModel.getInstance().setData(param);
							});
						}
					hide();
					break;
				case _getBt: 
					if (_enoughItem)
					{
						_timer.stop();
						timerHandler();
						setClickenable(false);
					}
					else
					{
						//金手指不够
						showNoEnoughItem();
					}
					break;
			}
		}
		
		
		/**
		 * 提示金手指不够是否要购买
		 */
		private function showNoEnoughItem():void {
			AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.LotteryPanel.BugItemTip.@Text, function (param:String):void {
				switch(param) {
					case AlertSelectPane.ALERT_YES:
						UseItemControler.showBuyWin(SpecialItemIdConfig.GOLD_FINGER);
						break;
					}
					AlertSelectPane.getInstance().hide();
				} );
			}
		
		/**
		 * 开始抽奖
		 */
		private function startLottery():void
		{
			_timer.reset();
			_timer.start();
			_scrolTimer.reset();
			_scrolTimer.start();
		}
		
		/**
		 * 更新当前的各按钮是否可点击，当前要花费的金手指数量
		 * @param	event
		 */
		public function updataUI():void
		{
			var totalDiscardNum:uint = 0; //当前总丢弃的卡数
			var totalItemNum:uint = 0; //当前总花费的金手指数
			_discards = new Array();
			for (var i:int = 0; i < 5; i++)
			{
				if ((_slots[i] as RemoveLotterySlot).discardFlag)
				{
					totalDiscardNum++;
					_discards.push(i);
				}
			}
			
			for (var j:int = 0; j < 5; j++)
			{
				if (totalDiscardNum == 4)
				{
					if (!(_slots[j] as RemoveLotterySlot).discardFlag)
					{
						(_slots[j] as RemoveLotterySlot).removeBt.visible = false;
					}
					_getBt.visible = true;
					_immediatelyBt.visible = false;
				}
				else
				{
					if (!(_slots[j] as RemoveLotterySlot).discardFlag)
					{
						(_slots[j] as RemoveLotterySlot).removeBt.visible = true;
					}
					_getBt.visible = false;
					_immediatelyBt.visible = true;
				}
			}
			
			totalItemNum = returnItemNumByDiscardNum(totalDiscardNum);
			//根据要去掉所花的金手指是否足够如果不够颜色显示为红色
			if (BagData.getInstance().bagExistItem(SpecialItemIdConfig.GOLD_FINGER, totalItemNum) || totalItemNum == 0)
			{
				//金手指的ID为15
				_numText.htmlText = "<font color='#ffffff'>X" + totalItemNum.toString() + "</font>";
				_enoughItem = true;
				_buyBy.visible = false;
			}
			else
			{
				_numText.htmlText = "<font color='#fe0701'>X" + totalItemNum.toString() + "</font>";
				_enoughItem = false;
				_buyBy.visible = true;
			}
		
		}
		
		/**
		 * 根据丢弃的卡数算出要花费的金手指数
		 * @param	event
		 */
		private function returnItemNumByDiscardNum(value:uint):uint
		{
			var temp:uint = value;
			var returnNum:uint = 0;
			while (temp > 0)
			{
				returnNum += temp;
				temp--;
			}
			return returnNum;
		}
		
		/**
		 * 设置稍后抽奖按钮是否显示（每日签到的抽奖不显示）
		 * @param	event
		 */
		public function setLateBtVisible(value:Boolean = false):void {
			_laterBt.visible = value;
			}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			for (var i:int = 0; i < 5; i++)
			{
				(_slots[i] as RemoveLotterySlot).id = i;
				(_slots[i] as RemoveLotterySlot).selected();
				(_slots[i] as RemoveLotterySlot).item = _lotteryModel.items[i];
			}
			setClickenable(true);
			_bagBt.visible = false;
			updataUI();
			
			return;
		} // end function
		
		/**
		 * 设置相应按钮是否可点击
		 * @param	event
		 */
		private function setClickenable(value:Boolean = true):void
		{
			for (var i:int = 0; i < 5; i++)
			{
				(_slots[i] as RemoveLotterySlot).removeBt.clickEnable = value;
				(_slots[i] as RemoveLotterySlot).resetBt.clickEnable = value;
			}
			_immediatelyBt.clickEnable = value;
			_getBt.clickEnable = value;
			_laterBt.clickEnable = value;
			_buyBy.clickEnable = value;
			
		}
		
		//关闭时检查战斗界面是否打开，如果打开则回收战斗界面中的资源并关闭
		override public function hide(event:MouseEvent = null):void
		{
			if (rootContainer)
			{
				if (modal != null && rootContainer.contains(modal))
				{
					rootContainer.removeChild(modal);
					modal = null;
				}
				if (showEffect)
				{
					TweenLite.to(this, 0.3, {alpha: 0.2, y: this.y - 40, onComplete: this.onTweenClose});
				}
				else
				{
					if (rootContainer.contains(this))
					{
						rootContainer.removeChild(this);
					}
					this.isOpened = false;
					this.isPopUP = false;
				}
				//回收资源
				if(AttackPanel.getInstance().isOpened){
				var attackPanel:AttackPanel = AttackPanel.getInstance();
				attackPanel.hide();
				attackPanel._attackPlayer.restart();
				attackPanel.changePlayBtnStatus(1);
				attackPanel.disposeData();
				attackPanel = null;
				}
				SMZTUIManager.getInstance().mainPane.refreshCurrentScene(); //刷新当前场景
				//抽奖界面一关闭就要设为false
				_lotteryModel.showAfterBattle = false;
			}
			playUISound("UI_WINDOW_CLOSE");
			return;
		} // end function
		
		public static function getInstance():LotteryPanel
		{
			if (_lotteryPanel == null)
			{
				_lotteryPanel = new LotteryPanel;
			}
			return _lotteryPanel;
		} // end function
		
		public function get state():String 
		{
			return _state;
		}
		
		/**
		 * 根据状态设置是否显示稍后抽奖
		 */
		public function set state(value:String):void 
		{
			_state = value;
			switch(value) {
				case TRAINING:
					setLateBtVisible(true);
					break;
				case LOG:
					setLateBtVisible(true);
					break;
				case STATUE_SIGN:
					setLateBtVisible();
					break;
				}
		}
	
	}

}