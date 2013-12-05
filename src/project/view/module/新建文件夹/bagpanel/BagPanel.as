package project.view.module.bagpanel 
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import project.config.ErrorZhCn;
	import project.config.ItemCategory;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.BagData;
	import project.model.item.ItemModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.DepthManager;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.controls.TabNavigator;
	import project.view.common.FriendsControlPage;
	import project.view.layout.BaseGridContainer;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import project.view.module.cell.BaseIcoCell;
	/**
	 * 背包界面
	 * @author bbjxl 2012
	 */
	public class BagPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _bagGridContainer:BaseGridContainer;
		//-----------------------UI---------------------------------
		//private var _batUseBt:MovieClipButton;//批量使用
		private var _cardsBt:MovieClipButton;//卡包按钮 
		private var _itemBt:MovieClipButton;//道具按钮
		private var _otherBt:MovieClipButton;//其他按钮
		private var tabNvigator:TabNavigator;//分页导航
		
		private var _controlPage:FriendsControlPage;//分页控件
		//-----------------------数据---------------------------------
		
		private var _currentSelectedType:int = ItemCategory.CARDS;//当前选中的选项
		private var _currentSelectedTypeItemModle:Vector.<ItemModel>;//当前选项对应的数据
		private var _totalBagIcoBox:Array;
		private var _bagDataModel:BagData;
		private static var PAGE_NUM:int = 45;//5行9列
		private var _currentPage:int = 1;//当前页
		private var _currentItem:BagIcoBox;//当前点击的物品
		private var _oldItem:BagIcoBox;//之前点击的物品
		private var _currentOverItem:BagIcoBox;//当前鼠标移上去的物品
		//private var _timer:Timer = new Timer(500);//鼠标移上去多久才显示窗口
		//-----------------------事件--------------------------------
		
		private static var _instance:BagPanel;
		
		public function BagPanel() 
		{
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("BagPanel");
			configerUIInstance();
			_bagGridContainer = new BaseGridContainer(5, 9, 2, 51, 51.7);
			_bagGridContainer.setLocation(46.05, 200.2);
			addChild(_bagGridContainer);
			_totalBagIcoBox = new Array();
			for (var i:int = 0; i < PAGE_NUM; i++ ) {
				var tempIco:BagIcoBox = new BagIcoBox();
				_bagGridContainer.appendChild(tempIco);
				_totalBagIcoBox.push(tempIco);
				tempIco = null;
				}
			_bagDataModel = BagData.getInstance();
			dataModel = _bagDataModel;
			
		}
		//--------------------------------------------------------
		private function configerUIInstance():void 
		{
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(226.55, 505.2);
			addChild(_controlPage);
			_controlPage.updatLoc = updatLoc;
			//_batUseBt = getChild("batUseBt") as MovieClipButton;
			_cardsBt = getChild("cardsBt") as MovieClipButton;
			_itemBt = getChild("itemBt") as MovieClipButton;
			_otherBt = getChild("otherBt") as MovieClipButton;
			//_batUseBt.onClick=batUserClick;
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_cardsBt, _itemBt,_otherBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			//_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		/**
		 * 批量实用
		 */
		private function batUserClick(e:MouseEvent):void 
		{
			UseItemControler.batUserItem(_currentItem.item,0, function():void {
				//trace("更新背包数据1")
				//更新个货币数量
				SMZTUIManager.getInstance().mainPane.refreshSelfData();
				//更新背包数据
				SMZTController.getInstance().getBagData(true);
				});
		}
		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			_controlPage.setLocation(this.width - _controlPage.width >> 1, 505.2);
		}
		
		//关闭
        override public function hide(event:MouseEvent = null) : void
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
                    TweenLite.to(this, 0.3, {alpha:0.2, y:this.y - 40, onComplete:this.onTweenClose});
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
				
				if (closeButton) {
					ApplicationController.removeAtWin(this);
					}
					
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					NewBieControler.getInstance().nextStep();
					}
				//--------------------end--------------------
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			_currentPage = 1;
			switch(e.dataObject) {
				case _cardsBt:
					_currentSelectedType = ItemCategory.CARDS;
					break;
				case _itemBt:
					_currentSelectedType = ItemCategory.PROPS;
					
					//-------------------新手引导用-----首次打开背包提示使用道具------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
					
					break;
				case _otherBt:
					_currentSelectedType = ItemCategory.OTHERS;
					break;
				}
			onDataChange(null);
		} 
		public function removeValueFromArray(arr:Vector.<ItemModel>):void
		{
			var len:uint = arr.length;
			
			for (var i:Number = len; i > -1; i--)
			{
				arr.splice(i, 1);
			}
		}
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			/*if (_currentSelectedTypeItemModle) {
				removeValueFromArray(_currentSelectedTypeItemModle);
				}*/
			_currentSelectedTypeItemModle = null;
            switch(_currentSelectedType) {
				case ItemCategory.CARDS:
					_controlPage.starComputeNoInit(PAGE_NUM, (_bagDataModel.cards.length>0)?Math.ceil(_bagDataModel.cards.length / PAGE_NUM):1, updataUI);
					_currentSelectedTypeItemModle = _bagDataModel.cards;
					break;
				case ItemCategory.PROPS:
					_controlPage.starComputeNoInit(PAGE_NUM,(_bagDataModel.props.length>0)?Math.ceil(_bagDataModel.props.length / PAGE_NUM):1, updataUI);
					_currentSelectedTypeItemModle = _bagDataModel.props;
					break;
				case ItemCategory.OTHERS:
					_controlPage.starComputeNoInit(PAGE_NUM, (_bagDataModel.others.length>0)?Math.ceil(_bagDataModel.others.length / PAGE_NUM):1, updataUI);
					_currentSelectedTypeItemModle = _bagDataModel.others;
					break;
				}
			if (_currentPage > _controlPage.totalPageNum) {
				//当前页码比总页码还大时，当前页为总页
				_currentPage = _controlPage.totalPageNum;
				}
				_controlPage.currentPageNum = _currentPage;
            return;
        }// end function
		
		private function updataUI():void 
		{
			/*if (_currentItem) {
				_currentItem.setOnChoose(false);
				}
			if (_oldItem) {
				_oldItem.setOnChoose(false);
				}*/
			
			_currentPage = _controlPage.currentPageNum;
			for (var i:int; i < _totalBagIcoBox.length;i++) {
				var tempIco:BagIcoBox = (_totalBagIcoBox[i] as BagIcoBox);
				var tempIndex:int = ((_currentPage-1) * PAGE_NUM + i);
				if ( tempIndex< _currentSelectedTypeItemModle.length) {
					if (_currentSelectedTypeItemModle[tempIndex]) {
						tempIco.item = _currentSelectedTypeItemModle[tempIndex];
						tempIco.buttonMode = true;
						if (!tempIco.hasEventListener(MouseEvent.CLICK)) {
							tempIco.addEventListener(MouseEvent.CLICK, bagIcoBoxClick);
							}
						if (!tempIco.hasEventListener(MouseEvent.ROLL_OVER)) {
							tempIco.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
							tempIco.addEventListener(MouseEvent.MOUSE_OVER, bagIcoBoxRollOver);
							}
						}else {
							tempIco.item = null;
							tempIco.buttonMode = false;
							if (tempIco.hasEventListener(MouseEvent.CLICK)) {
								tempIco.removeEventListener(MouseEvent.CLICK, bagIcoBoxClick);
								}
							if (!tempIco.hasEventListener(MouseEvent.ROLL_OVER)) {
								tempIco.removeEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
								tempIco.removeEventListener(MouseEvent.MOUSE_OVER, bagIcoBoxRollOver);
								}
							}
					}else {
						tempIco.buttonMode = false;
						tempIco.item = null;
						if (tempIco.hasEventListener(MouseEvent.CLICK)) {
							tempIco.removeEventListener(MouseEvent.CLICK, bagIcoBoxClick);
							}
						if (tempIco.hasEventListener(MouseEvent.ROLL_OVER)) {
							tempIco.removeEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
							tempIco.removeEventListener(MouseEvent.MOUSE_OVER, bagIcoBoxRollOver);
							}
						}
				
				tempIco = null;
				}
			
		}
		
		private function bagIcoBoxRollOver(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			_currentOverItem = e.currentTarget as BagIcoBox;
			_currentOverItem.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			DepthManager.bringToTop(_currentOverItem);
			var temp:Point = new Point(_currentOverItem.x-100, _currentOverItem.y+59);
			//trace(temp);
			//trace(_bagGridContainer.localToGlobal(temp).y)
			SMZTUIManager.getInstance().bagPopPanel.setData(_currentOverItem.item, _bagGridContainer.localToGlobal(temp));
			SMZTUIManager.getInstance().bagPopPanel.show(false);
			(e.currentTarget as BagIcoBox).setOnChoose(true);
			//_timer.start();
		}
		
		private function rollOutHandler(e:MouseEvent):void 
		{
			//trace("out")
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
			//e.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, bagIcoBoxRollOver);
			(e.currentTarget as BagIcoBox).setOnChoose(false);
			SMZTUIManager.getInstance().bagPopPanel.hide();
			(e.currentTarget as BagIcoBox).closeUseAndSell();
			_currentOverItem = null;
			//_timer.stop();
		}
		
		/*private function timerHandler(e:TimerEvent):void 
		{
			if (_currentOverItem == null) return;
			if (_currentItem) {
				_oldItem = _currentItem;
				_currentItem = _currentOverItem;
				}else {
					_currentItem = _currentOverItem;
					}
			if (_oldItem) {
				_oldItem.setOnChoose(false);
				}
			_currentItem.setOnChoose(true);
			DepthManager.bringToTop(_currentItem);
			SMZTUIManager.getInstance().bagPopPanel.show(false);
			SMZTUIManager.getInstance().bagPopPanel.setData(_currentItem.item);
		}*/
		
		/**
		 * 物品点击显示相应的提示框
		 * @param	e
		 */
		private function bagIcoBoxClick(e:MouseEvent):void 
		{
			//trace("物品点击");
			
			/*if (_currentItem) {
				_oldItem = _currentItem;
				_currentItem = (e.currentTarget as BagIcoBox);
				}else {
					_currentItem = (e.currentTarget as BagIcoBox);
					}
			if (_oldItem) {
				_oldItem.setOnChoose(false);
				}
			_currentItem.setOnChoose(true);*/
			
			_currentItem = (e.currentTarget as BagIcoBox);
			
			(e.currentTarget as BagIcoBox).openUseAndSell();
			DepthManager.bringToTop((e.currentTarget as BagIcoBox));
			//SMZTUIManager.getInstance().bagPopPanel.show(false);
			//SMZTUIManager.getInstance().bagPopPanel.setData(_currentItem.item);
		}
		

		//--------------------------------------------------------
		public static function getInstance() : BagPanel
		{
			if (_instance == null)
			{
			  _instance = new BagPanel;
			}
			return _instance; 
		}// end function
	}

}