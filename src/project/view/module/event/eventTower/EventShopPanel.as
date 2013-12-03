package project.view.module.event.eventTower
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.event.eventTower.EventTowerModel;
	import project.model.event.eventTower.ExchangeGoods;
	import project.view.base.BaseTitleWindow;
	import project.view.common.FriendsControlPage;
	import project.view.layout.BaseGridContainer;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * 军需处
	 * @author bbjxl 2013
	 */
	public class EventShopPanel extends BaseTitleWindow
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;
		private var _goodsGridContainer:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var _cards:Vector.<ExchangeGoodPanleUI>;
		private var _controlPage:FriendsControlPage;//分页控件
		private var _ticketText:TextField;
		//-----------------------数据---------------------------------
		private var _currentPage:int=1;//当前页
		private static var PAGE_NUM:int = 3//1行3列
		private var _exchangeGoodsCard:Vector.<ExchangeGoods>;
		private var _exchangeGoodsItem:Vector.<ExchangeGoods>;
		private var _totalGoodsBox:Array;
		//-----------------------事件--------------------------------
		private static var _eventShopPanel:EventShopPanel;
		
		public function EventShopPanel()
		{
			if (_eventShopPanel != null)
			{
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
			}
			setSpriteInstance("exchangeGoodsUI");
			this.rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
			configinstance();
		}
		
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2+40;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2+20;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y +40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
            }
            this.playShowSound();
            return;
        }// end function
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
				
				SMZTUIManager.getInstance().mainPane.refreshCurrentScene();//刷新当前场景
				
				if (closeButton) {
					ApplicationController.removeAtWin(this);
					}
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		private function configinstance():void
		{
			_ticketText = getChild("ticketText") as TextField;
			_ticketText.text = EventTowerModel.getInstance().ticket.toString();
			
			_grid = new BaseGridContainer(1, 2, 18.75, 85.25, 51.2);
			_grid.setLocation(25,401.5);
			addChild(_grid);
			
			_cards = new Vector.<ExchangeGoodPanleUI>();
			var temp:ExchangeGoodPanleUI = new ExchangeGoodPanleUI(1);
			addChild(temp);
			temp.setLocation(31.7,111);
			_cards.push(temp);
			for (var i:int = 0; i < 2; i++ ) {
				temp= new ExchangeGoodPanleUI(2);
				_grid.appendChild(temp);
				_cards.push(temp);
				}
			temp = null;
			
			_goodsGridContainer = new BaseGridContainer(1, 3, 14, 93, 141.4);
			_goodsGridContainer.setLocation(233.4, 401.5);
			addChild(_goodsGridContainer);	
			_totalGoodsBox = new Array();
			for (var i:int = 0; i < PAGE_NUM; i++ ) {
				 var tempIco:ExchangeItems= new ExchangeItems();
				_goodsGridContainer.appendChild(tempIco);
				_totalGoodsBox.push(tempIco);
				tempIco = null;
				}
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(230, 558);
			addChild(_controlPage);
			_controlPage.visible = false;
			_controlPage.updatLoc = updatLoc;
		}
		
		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			_controlPage.setLocation(this.width - _controlPage.width >> 1, 558);
		}
		
		public function updata():void
		{
			_ticketText.text = EventTowerModel.getInstance().ticket.toString();
			
			SMZTController.getInstance().getExchangeGoods(function(param:Object):void
				{
					_exchangeGoodsCard = new Vector.<ExchangeGoods>();
					_exchangeGoodsItem = new Vector.<ExchangeGoods>();
					for (var i:String in param)
					{
						var temp:ExchangeGoods = new ExchangeGoods(param[i]);
						if (temp.isCard)
						{
							_exchangeGoodsCard.push(temp);
						}
						else
						{
							_exchangeGoodsItem.push(temp);
						}
						temp = null;
					}
					updataUI();
				});
		}
		
		private function updataUI():void
		{
			for (var i:int = 0; i < _cards.length; i++ ) {
				if (i < _exchangeGoodsCard.length) {
					_cards[i].exchangeGoodsModel = _exchangeGoodsCard[i];
					_cards[i].updata();
					_cards[i].visible = true;
					}else {
						_cards[i].visible = false;
						}
				}
				
			_controlPage.starComputeNoInit(PAGE_NUM, (_exchangeGoodsItem.length > 0)?Math.ceil(_exchangeGoodsItem.length / PAGE_NUM):1, updataItemUI);
			_controlPage.currentPageNum = _currentPage;
		}
		
		/**
		 * 更新下面的物品
		 */
		private function updataItemUI():void 
		{
			_currentPage = _controlPage.currentPageNum;
			var tempIco:ExchangeItems;
			for (var i:int; i < _totalGoodsBox.length;i++) {
				tempIco= (_totalGoodsBox[i] as ExchangeItems);
				var tempIndex:int = ((_currentPage-1) * PAGE_NUM + i);
				if ( tempIndex< _exchangeGoodsItem.length) {
					if (_exchangeGoodsItem[tempIndex]) {
						tempIco.dataModel = _exchangeGoodsItem[tempIndex];
						tempIco.updataUI();
						tempIco.visible = true;
						}else {
							tempIco.visible = false;
							}
					}else {
						
						tempIco.visible = false;
						
						}
				
				tempIco = null;
				}
			
		}
		
		public static function getInstance():EventShopPanel
		{
			if (_eventShopPanel == null)
			{
				_eventShopPanel = new EventShopPanel;
			}
			return _eventShopPanel;
		} // end function
	}

}