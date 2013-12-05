package project.view.module.DeckPane 
{
	//import com.bbjxl.utils.ShapeFactory;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import project.utils.XColor;
	import project.view.module.cell.Card;
	
	/**
	 * 响应拖动区域
	 * @author bbjxl 2012
	 */
	public class CanDragArea extends MovieClip 
	{
		private var _canDrag:Boolean = false;//是否响应拖动
		private var _card:Card;//小卡
		private var _selected:Boolean = false;//
		private var _selGlowFilter:GlowFilter;
		private var _cardClass:int=0;//卡的类别（装备1，神通2，兵0）
		public var _mask:Sprite;//遮罩
		private var _bg:MovieClip;//背景
		private var _index:int = 0;//序号
		
		public function CanDragArea() 
		{
			_bg = this["bg"] as MovieClip; 
			this._selGlowFilter = new GlowFilter(13408512, 1, 21, 21);
			_mask = new Sprite();
			_mask.graphics.beginFill(0xffffff,0) ;
			_mask.graphics.drawRect(0, 0, 70, 70);
			_mask.graphics.endFill();
			addChild(_mask);
			//this.mask = _mask;
		}
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		public function get selected() :Boolean
		 {
		   return _selected;
		}// end function
		
		public function set selected(param1:Boolean) : void
		{
		  _selected = param1;
		  if (param1) {
			  this.filters = [this._selGlowFilter];
			  }else {
				  if (canDrag) {
					  //如果是可以嵌入的框
					   this.filters = [];
					  }else {
						  //如果本身是不可嵌入的，就不改变（灰色）
						  return;
						  }
				 
				  }
		  
		  return;
		}// end function
		public function get card() : Card
		 {
		   return _card;
		}// end function
		
		public function set card(param1:Card) : void
		{
			
			if (_card == null) {
				_card = new Card();
				//_card.showTip = true;
				addChild(_card);
				//myDebug.//trace("11111")
				}else {
					//myDebug.//trace("2222")
					/*_card._currentCardTye = 2;
					_card.setCardModel(param1.getCardModel());*/
					if (!contains(_card)) {
						addChild(_card);
						}
					}
			_card.showTip = true;
			_card._currentCardTye = 2;
			_card.setCardModel(param1.getCardModel());
			_card.visible = true;
			_card.setLocation(2, 2);
		  return;
		}// end function
		public function get canDrag() : Boolean
		 {
		   return _canDrag;
		}// end function
		
		public function set canDrag(param1:Boolean) : void
		{
		  _canDrag = param1;
		  if (param1) {
			  this.filters = [];
			  if (_cardClass == 0) {
				  _bg.gotoAndStop(1);
				  }else {
					   _bg.gotoAndStop(cardClass+2);
					  }
			  }else {
				  //XColor.removeColor(this);
				  _bg.gotoAndStop(2);
				  }
		  return;
		}// end function
		
		public function get cardClass() : int
		 {
		   return _cardClass;
		}// end function
		
		public function set cardClass(param1:int) : void
		{
		  _cardClass= param1;
		  return;
		}// end function
		public function get index() : int
		 {
		   return _index;
		}// end function
		
		public function set index(param1:int) : void
		{
		  _index= param1;
		  return;
		}// end function
		//--------------------------------------------------------
		public function dispose():void {
			if (card) {
				card.showTip = false;
				card.dispose();
				_card.visible = false;
				_card = null;
				
				}
			}
		
		//--------------------------------------------------------
	}

}