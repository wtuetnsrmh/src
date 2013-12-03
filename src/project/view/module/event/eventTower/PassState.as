package project.view.module.event.eventTower 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import project.view.base.BaseSprite;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class PassState extends BaseSprite 
	{
		public static const passName:Array = ["左脚", "右脚", "左腿", "右腿", "腹部", "左手", "右手", "胸部", "肩膀", "头部"];
		private var _ui:DisplayObject;
		private var _stateMc:MovieClip;
		private var _idText:TextField;
		private var _selected:Boolean;
		private var _id:int;
		private var _filter:GlowFilter;
		public function PassState(ui:DisplayObject) 
		{
			_filter = new GlowFilter();
			_filter.color = 0x1106f9;
			_filter.alpha = 1;
			_filter.blurX = 2;
			_filter.blurY = 2;
			_filter.quality =BitmapFilterQuality.LOW;
			_filter.strength = 5;
			
			_ui = ui;
			_idText = ui["idText"] as TextField;
			_idText.filters = [_filter];
			_stateMc = ui["stateMc"] as MovieClip;
		}
		
		public function setState(value:int = 1):void {
			if (value == 3) {
				_filter.color = 0xf90617;
				_idText.filters = [_filter];
				}else {
					_filter.color = 0x1106f9;
					_idText.filters = [_filter];
					}
			_stateMc.gotoAndStop(value);
			}
		
		public function get stateMc():MovieClip 
		{
			return _stateMc;
		}
		
		public function set stateMc(value:MovieClip):void 
		{
			_stateMc = value;
		}
		
		public function get idText():TextField 
		{
			return _idText;
		}
		
		public function set idText(value:TextField):void 
		{
			_idText = value;
		}
		
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			/*if (value) {
				_stateMc.gotoAndStop(2);
				}else {
					_stateMc.gotoAndStop(1);
					}*/
			_selected = value;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_idText.text = passName[value];
			_id = value;
		}
		
	}

}