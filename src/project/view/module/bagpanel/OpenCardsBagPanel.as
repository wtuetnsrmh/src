package project.view.module.bagpanel 
{
	/*开包界面*/
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.model.data.BagData;
	import project.model.item.CardModel;
	import project.model.item.ItemModel;
	import project.utils.CardFactary;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.layout.BaseGridContainer;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.cell.Card;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class OpenCardsBagPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var _nameText:TextField;
		private var _againBt:MovieClipButton;
		private var _image:BaseIcoCellLoader;
		//-----------------------数据---------------------------------
		private var _cards:Vector.<Card>;
		private var _currentItem:ItemModel;
		//-----------------------事件--------------------------------
		
		private static var _instance:OpenCardsBagPanel;
		public function OpenCardsBagPanel() 
		{
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("openCardsBagPanel");
			configerUIInstance();
			
			_grid = new BaseGridContainer(1, 4, 10, ApplicationConfig.CARD_WIDTH >> 1, ApplicationConfig.CARD_HEIGHT >> 1);
			_grid.setLocation(40.75,167);
			addChild(_grid);
			_cards = new Vector.<Card>();
			for (var i:uint = 0; i < 6; i++ ) {
				var tempArm:Card = new Card();
				tempArm.showTip = true;
				tempArm._currentCardTye = 1;
				tempArm.hideAll();
				tempArm.showMask();
				
				//_grid.appendChild(tempArm);
				_cards.push(tempArm);
				tempArm = null;
				}
		}
		/**
		 * 
		 * @param	value 开出的卡
		 * @param	item　用的卡包道具
		 */
		public function showCards(value:Array, item:ItemModel):void {
			//如果有数量大于１的则要拆分
			var decodeArr:Array = new Array();
			for (var j:String in value) {
				for (var n:uint = 0; n < value[j].number; n++ ) {
					decodeArr.push(value[j]);
					}
				}
				
			_nameText.text = item.name;
			_againBt.clickEnable = true;
			
			_currentItem = item;
					
			_grid.removeAll();
			for (var i:String in _cards) {
				if(decodeArr[i]!=null){
				_cards[i].setCardModel(new CardModel(decodeArr[i].id));
				_cards[i].visible = true;
				_grid.appendChild(_cards[i]);
				}else {
					_cards[i].visible = false;
					}
				}
			var temp:int = decodeArr.length;
			var tempW:Number = (487 - (96 * temp + (temp - 1) * 10)) >> 1;
			_grid.setLocation(tempW, 167);
			_image.ico = item.ico;
			judgeAgainClickenable();
			show(true);
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
                this.x = (ApplicationConfig.STAGE_WIDTH - 487) / 2;
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
		private function configerUIInstance():void 
		{
			_nameText = getChild("nameText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			_againBt = getChild("againBt") as MovieClipButton;
			_image = new BaseIcoCellLoader();
			_image.restrictHW = 51;
			_image.setLocation(206, 91.75);
			_image.showBg = false;
			addChild(_image);
			_againBt.onClick = againBtClick;
		}
		
		/**
		 * 判断再开一包是否可点
		 * @param	e
		 */
		public function judgeAgainClickenable():void {
			if (_currentItem && _currentItem.number > 1) {
				_againBt.clickEnable = true;
				_againBt.visible = true;
				}else {
					UseItemControler.judgestExistAtShop(_currentItem.itemId, function(value:Boolean):void {
						if (value) {
							_againBt.clickEnable = true;
							_againBt.visible = true;
							}else {
								//如果商场中没有物品
								_againBt.clickEnable = false;
								_againBt.visible = false;
								}
						})
					}
			}
		
		
		
		
		private function againBtClick(e:MouseEvent):void 
		{
			/*
			if (_currentItem && _currentItem.number > 0) {
				_againBt.clickEnable = true;
				}else {
					_againBt.clickEnable = false;
					}*/
			_againBt.clickEnable = false;
			UseItemControler.userItemNew(_currentItem.itemId, function():void {
				_currentItem.number--;
				_againBt.clickEnable = true;
				judgeAgainClickenable();
				});
		}
		//--------------------------------------------------------
		public static function getInstance() : OpenCardsBagPanel
		{
			if (_instance == null)
			{
			  _instance = new OpenCardsBagPanel;
			}
			return _instance; 
		}// end function
	}

}