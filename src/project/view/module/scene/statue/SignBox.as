package project.view.module.scene.statue
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import project.view.base.BaseSprite;
	import project.view.base.BaseSpriteSetUI;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	/**
	 * 签到宝箱
	 * @author bbjxl 2013
	 */
	public class SignBox extends BaseSprite
	{
		public static const OPENED:String = "opened"; //已打开
		public static const CANOPEND:String = "canOpen"; //可以打开
		public static const NOACTIVITY:String = "NoActivity"; //未激活
		
		private var _ui:MovieClip;
		private var _state:String = NOACTIVITY;
		private var _filter:GlowFilter;
		
		public function SignBox()
		{
		
		}
		
		public function setUI(ui:DisplayObject):void
		{
			_ui = ui as MovieClip;
			_ui.gotoAndStop(1);
			addChild(_ui);
			_filter = new GlowFilter();
			_filter.color = 0x00ffff;
			_filter.alpha = 1;
			_filter.blurX = 22;
			_filter.blurY = 22;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 2;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			switch(value) {
				case OPENED:
					_ui.gotoAndStop(2);
					this.buttonMode = false;
					_ui.filters = null;
					break;
				case CANOPEND:
					_ui.gotoAndStop(1);
					this.buttonMode = true;
					_ui.filters = [_filter];
					break;
				case NOACTIVITY:
					this.buttonMode = false;
					_ui.gotoAndStop(1);
					_ui.filters = null;
					break;
				}
		}
	}

}