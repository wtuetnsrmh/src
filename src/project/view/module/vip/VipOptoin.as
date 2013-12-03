package project.view.module.vip
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import project.debug.Debug;
	
	/**
	 * vip选项
	 * @author bbjxl 2013
	 */
	public class VipOptoin extends MovieClip
	{
		private var _clickEnable:Boolean = true;
		private var _text:TextField;
		private var _number:int;
		public var onClick:Function;
		private var _index:int = 0;
		private var _canGet:Boolean;
		private var _filter:GlowFilter;
		private var _ico:Sprite;
		private var _selected:Boolean;
		private var _effect:MovieClip;
		
		public function VipOptoin()
		{
			stop();
			_ico = this["ico"] as Sprite;
			_effect = this["effect"] as MovieClip;
			_text = this["text"] as TextField;
			_text.mouseEnabled = false;
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			_filter = new GlowFilter();
			_filter.color = 0xFFFF00;
			_filter.alpha = 1;
			_filter.blurX = 3;
			_filter.blurY = 3;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			_effect.visible = false;
		}
		
		/**
		 * 选项点击
		 * @param	e
		 */
		private function clickHandler(e:MouseEvent):void
		{
			if (onClick != null)
			{
				onClick.call(null, e);
			}
		}
		
		public function get clickEnable():Boolean
		{
			return _clickEnable;
		}
		
		public function set clickEnable(value:Boolean):void
		{
			_clickEnable = value;
			if (value)
			{
				//this.gotoAndStop(3);
				this.buttonMode = true;
				this.mouseEnabled = true;
				if (!hasEventListener(MouseEvent.CLICK))
					this.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else
			{
				//this.gotoAndStop(1);
				this.buttonMode = false;
				this.mouseEnabled = false;
				this.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		public function get number():int
		{
			return _number;
		}
		
		public function set number(value:int):void
		{
			_number = value;
			_text.text = String(value);
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get canGet():Boolean 
		{
			return _canGet;
		}
		
		public function set canGet(value:Boolean):void 
		{
			_canGet = value;
			if (value) {
				//this.gotoAndStop(2);
				_effect.visible = true;
				}else {
					//this.gotoAndStop(1);
					_effect.visible = false;
					}
			Debug.log("canGet="+value)
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (value) {
				_ico.filters = [_filter];
				}else {
					_ico.filters = null;
					}
		}
	
	}

}