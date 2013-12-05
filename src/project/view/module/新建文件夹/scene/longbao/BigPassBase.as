package project.view.module.scene.longbao 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import project.events.SMZTDataChangeEvent;
	
	/**
	 * 大关卡入口基类
	 * @author bbjxl 2013
	 */
	public class BigPassBase extends MovieClip 
	{
		private var _state:int = 1;
		private var _enable:Boolean = false;
		private var _selected:Boolean = false;
		public function BigPassBase() 
		{
			stop();
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			
			enable = false;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			trace("关卡=" + int(this.name.split("pass")[1]));
			var enterPassMapEvent:SMZTDataChangeEvent = new SMZTDataChangeEvent(SMZTDataChangeEvent.ON_DATA_REFRESH);
			enterPassMapEvent.dataObject = int(this.name.split("pass")[1]);
			dispatchEvent(enterPassMapEvent);
		}
		
		private function rollOverHandler(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			if (!enable) return;
			this.addEventListener(MouseEvent.ROLL_OUT, rolloutHandler);
			state = 2;
		}
		
		private function rolloutHandler(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, rolloutHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			state = 1;
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function set state(value:int):void 
		{
			_state = value;
			this.gotoAndStop(value);
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (_enable) {
				gotoAndStop(1);
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, clickHandler);
				}else {
					gotoAndStop(4);
					this.buttonMode = false;
					this.removeEventListener(MouseEvent.CLICK, clickHandler);
					}
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			(_selected)?gotoAndStop(3):gotoAndStop(1);
		}
		
	}

}