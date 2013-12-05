package project.view.module.scene.statue
{
	import flash.events.MouseEvent;
	import project.view.controls.ToolTip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.model.statue.AwardBoxModel;
	
	/**
	 * 活跃度的宝箱基类
	 * @author bbjxl 2013
	 */
	public class AwardBox extends Sprite
	{
		public static const OPENED:String = "opened"; //已打开
		public static const CANOPEND:String = "canOpen"; //可以打开
		public static const NOACTIVITY:String = "NoActivity"; //未激活
		private var _state:String = "NoActivity";
		private var _filter:GlowFilter;
		private var _text:TextField;
		private var _openPoint:int = 0; //要打开箱子需要的分数
		private var _index:int = 0; //宝箱模型在ＸＭＬ中的索引
		private var _dataModel:AwardBoxModel;
		private var _ui:MovieClip;
		private var _tp:ToolTip;
		
		public function AwardBox()
		{
			_filter = new GlowFilter();
			_filter.color = 0xFFFF00;
			_filter.alpha = 1;
			_filter.blurX = 15;
			_filter.blurY = 15;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 2;
			
			_tp = ToolTip.getInstance();
			
			_dataModel = new AwardBoxModel();
		}
		
		public function setUI(ui:DisplayObject):void
		{
			_ui = ui as MovieClip;
			_ui.gotoAndStop(1);
			_text = _ui.getChildByName("stateText") as TextField;
			_text.autoSize = TextFieldAutoSize.CENTER;
			addChild(_ui);
			_text.x = _ui.x + (_ui.width - _text.textWidth >> 1);
			_text.y = _ui.y + _ui.height - _text.height-5;
			addChild(_text);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		}
		
		private function mouseOverHandler(e:MouseEvent):void 
		{
			_tp.autoSize = true;
			_tp.show(this, _dataModel.name, _dataModel.des);
		}
		
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			switch (value)
			{
				case OPENED: 
					_ui.gotoAndStop(2);
					this.buttonMode = false;
					_text.htmlText =  "<font color='#ffff00'>" + openPoint.toString() + "分开启</font>";
					_ui.filters = null;
					break;
				case CANOPEND: 
					this.buttonMode = true;
					_ui.gotoAndStop(1);
					_text.htmlText = "<font color='#ffff00'>" + openPoint.toString() + "分开启</font>";
					_ui.filters = [_filter];
					break;
				case NOACTIVITY: 
					this.buttonMode = false;
					_ui.gotoAndStop(1);
					_text.htmlText = "<font color='#ffff00'>" + openPoint.toString() + "分开启</font>";
					_ui.filters = null;
					break;
			}
		}
		
		public function get openPoint():int
		{
			return _openPoint;
		}
		
		public function set openPoint(value:int):void
		{
			_openPoint = value;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
			_dataModel.index = value;
			_openPoint = _dataModel.point;
			
			
		}
		
		public function get dataModel():AwardBoxModel
		{
			return _dataModel;
		}
		
		public function set dataModel(value:AwardBoxModel):void
		{
			_dataModel = value;
		}
	
	}

}