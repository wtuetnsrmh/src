package project.view.module.shop 
{
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.ItemCategory;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.events.SMZTDataChangeEvent;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.ShopModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.component.comboBox.MyComboBox;
	import project.view.controls.TabNavigator;
	import project.view.common.FriendsControlPage;
	import project.view.layout.BaseGridContainer;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * 商城面板
	 * @author bbjxl 2013
	 */
	public class shopPanel extends BaseTitleWindow 
	{
		
		//----------------------容器---------------------------------
		private var _goodsGridContainer:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var tabNvigator:TabNavigator;//分页导航
		private var _controlPage:FriendsControlPage;//分页控件
		private var _cardsBt:MovieClipButton;
		private var _itemBt:MovieClipButton;
		private var _formulaBt:MovieClipButton;
		private var _cardPurchPanel:CardPurchasePanel;
		//-----------------------数据---------------------------------
		public static const CARDS:int = 1;
		public static const ITEM:int = 2;
		public static const FORMULA:int = 3;
		
		private static var PAGE_NUM:int = 6;//2行3列
		
		private var _currentSelectedTypeGoodModle:Vector.<GoodsModel>;//当前所选类型的所有商品数据模型列表
		private var _currentPage:int=1;//当前页
		private var _currentSelectedType:int = 1;//当前选的类型
		private var _shopDataModel:ShopModel;
		//-----------------------事件--------------------------------
		private static var _instance:shopPanel;
		private var _totalGoodsBox:Array;
		
		public function shopPanel() 
		{
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("shopPanel");
			configerUIInstance();
			
			_goodsGridContainer = new BaseGridContainer(2, 3, 33, 142, 128);
			_goodsGridContainer.setLocation(39.35, 217.3);
			addChild(_goodsGridContainer);
			_totalGoodsBox = new Array();
			//var tempIco:Goods;
			for (var i:int = 0; i < PAGE_NUM; i++ ) {
				 var tempIco:Goods= new Goods();
				_goodsGridContainer.appendChild(tempIco);
				_totalGoodsBox.push(tempIco);
				tempIco = null;
				}
				
			_shopDataModel = ShopModel.getInstance();
			dataModel = _shopDataModel;
			
		}
		private function configerUIInstance():void 
		{
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(230, 558);
			addChild(_controlPage);
			_controlPage.updatLoc = updatLoc;
			_cardsBt = getChild("cardsBt") as MovieClipButton;
			_itemBt = getChild("itemBt") as MovieClipButton;
			_formulaBt = getChild("formulaBt") as MovieClipButton;
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_cardsBt, _itemBt,_formulaBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			_cardPurchPanel = new CardPurchasePanel();
			addChild(_cardPurchPanel);
			//_timer.addEventListener(TimerEvent.TIMER, timerHandler);
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
                this.x = (ApplicationConfig.STAGE_WIDTH - _spriteInstance.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
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
				
				if (closeButton) {
					ApplicationController.removeAtWin(this);
					}

            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			_controlPage.setLocation(spriteInstance.width - _controlPage.width >> 1, 558);
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			_currentPage = 1;
			switch(e.dataObject) {
				case _cardsBt:
					_currentSelectedType = CARDS;
					break;
				case _itemBt:
					_currentSelectedType = ITEM;
					break;
				case _formulaBt:
					_currentSelectedType = FORMULA;
					break;
				}
			onDataChange(null);
		} 
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			_currentSelectedTypeGoodModle = null;
            switch(_currentSelectedType) {
				case CARDS:
					_controlPage.visible = false;
					_goodsGridContainer.visible = false;
					_cardPurchPanel.visible = true;
					_cardPurchPanel.updataUI(_shopDataModel.cards);
					/*_controlPage.starComputeNoInit(PAGE_NUM,(_shopDataModel.cards.length>0)?Math.ceil(_shopDataModel.cards.length / PAGE_NUM):1, updataUI);
					_currentSelectedTypeGoodModle = _shopDataModel.cards;*/
					break;
				case ITEM:
					_controlPage.visible = true;
					_cardPurchPanel.visible = false;
					_goodsGridContainer.visible = true;
					_controlPage.starComputeNoInit(PAGE_NUM,(_shopDataModel.items.length>0)?Math.ceil(_shopDataModel.items.length / PAGE_NUM):1, updataUI);
					_currentSelectedTypeGoodModle = _shopDataModel.items;
					
					if (_currentPage > _controlPage.totalPageNum) {
					//当前页码比总页码还大时，当前页为总页
					_currentPage = _controlPage.totalPageNum;
					}
					_controlPage.currentPageNum = _currentPage;
					break;
				case FORMULA:
					_controlPage.visible = true;
					_cardPurchPanel.visible = false;
					_goodsGridContainer.visible = true;
					_controlPage.starComputeNoInit(PAGE_NUM, (_shopDataModel.formula.length>0)?Math.ceil(_shopDataModel.formula.length / PAGE_NUM):1, updataUI);
					_currentSelectedTypeGoodModle = _shopDataModel.formula;
					
					if (_currentPage > _controlPage.totalPageNum) {
					//当前页码比总页码还大时，当前页为总页
					_currentPage = _controlPage.totalPageNum;
					}
					_controlPage.currentPageNum = _currentPage;
					break;
				}
			
            return;
        }// end function
		private function updataUI():void 
		{
			_currentPage = _controlPage.currentPageNum;
			var tempIco:Goods;
			for (var i:int; i < _totalGoodsBox.length;i++) {
				 tempIco= (_totalGoodsBox[i] as Goods);
				var tempIndex:int = ((_currentPage-1) * PAGE_NUM + i);
				if ( tempIndex< _currentSelectedTypeGoodModle.length) {
					if (_currentSelectedTypeGoodModle[tempIndex]) {
						tempIco.dataModel = _currentSelectedTypeGoodModle[tempIndex];
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
		
		//--------------------------------------------------------
		public static function getInstance() : shopPanel
		{
			if (_instance == null)
			{
			  _instance = new shopPanel;
			}
			return _instance; 
		}// end function
		
		public function get currentSelectedType():int 
		{
			return _currentSelectedType;
		}
		
		public function set currentSelectedType(value:int):void 
		{
			_currentSelectedType = value;
		}
	}

}