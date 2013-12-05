package project.view.module.shop 
{
	import com.bbjxl.utils.Tools;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import project.config.LocalConfig;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.utils.CustomTool;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.view.layout.BaseGridContainer;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.*;
	/**
	 * 卡包出售面板
	 * @author bbjxl 2013
	 */
	public class CardPurchasePanel extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var _prevBt:MovieClipButton;
		private var _nextBt:MovieClipButton;
		private var _maskSp:Sprite;
		//-----------------------数据---------------------------------
		private var _items:Vector.<CardOptionPanel>
		private var _currentPage:int = 0;
		private var _initX:Number = 39.6;
		private var _initY:Number = 189.35;
		//-----------------------事件--------------------------------
		public function CardPurchasePanel() 
		{
			setSpriteInstance("cardPurchasePanelUI");
			confinginstace();
		}
		
		public function updataUI(value:Vector.<GoodsModel>):void {
			if (_items == null) {
				_items = new Vector.<CardOptionPanel>();
				for (var i:int = 0; i < value.length;i++ ) {
					var temp:CardOptionPanel = new CardOptionPanel();
					_grid.appendChild(temp);
					_items.push(temp);
					temp = null;
					}
				}
			var tempXL:XMLList = LocalConfig.LOCAL_LAN.ShopScene.CardTip;
			
			for (var j:String in _items) {
				_items[j].dataModel = value[j];
				_items[j].updataUI(tempXL[j].@Text);
				_items[j].cardTypeMc.gotoAndStop(int(j) + 1);
				}
			
			updataArraw();
			}
			
		private function confinginstace():void 
		{
			_prevBt = getChild("prevBt") as MovieClipButton;
			_prevBt.clickEnable = false;
			_nextBt = getChild("nextBt") as MovieClipButton;
			_grid = new BaseGridContainer(1, 4, 30, 142, 345.35);
			_prevBt.onClick = clickHandler;
			_nextBt.onClick = clickHandler;
			_grid.setLocation(_initX,_initY);
			addChild(_grid);
			
			_maskSp = getChild("maskSp") as Sprite;
			addChild(_maskSp);
			_grid.mask = _maskSp;
			
			
		}
		
		/**
		 * 更新箭头状态
		 * @param	e
		 */
		private function updataArraw():void {
			if (_currentPage == 0) {
				_prevBt.clickEnable = false;
				}else {
					_prevBt.clickEnable = true;
					}
			if (_currentPage == _items.length - 3) {
				_nextBt.clickEnable = false;
				}else {
					_nextBt.clickEnable = true;
					}
			}
		
		private function clickHandler(e:MouseEvent):void 
		{
			_prevBt.clickEnable = false;
			_nextBt.clickEnable = false;
			switch(e.currentTarget) {
				case _prevBt:
					if (_currentPage > 0)_currentPage--;
					TweenLite.to(_grid, 0.5, {ease:Quint.easeOut, x:_initX-(_currentPage*172), y:_initY, onComplete:function ()
						{
							updataArraw();
						}})
					break;
				case _nextBt:
					if (_currentPage < _items.length - 3)_currentPage++;
					TweenLite.to(_grid, 0.5, {ease:Quint.easeOut, x:_initX-(_currentPage*172), y:_initY, onComplete:function ()
						{
							updataArraw();
						}})
					break;
				}
				
			
		}
		
	}

}