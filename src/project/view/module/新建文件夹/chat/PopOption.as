package project.view.module.chat
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.ming.utils.ScaleBitmap;
	import flash.geom.Rectangle;
	import project.config.ApplicationConfig;
	import project.utils.Reflection;
	/**
	 * 菜单选项
	 * @author bbjxl
	 */
	public class PopOption extends Sprite
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var initBg:Shape; //初始背景
		private var rollOverBg:Shape; //鼠标移上背景
		private var _text:TextField; //文字
		private var _bgBitmap:ScaleBitmap;//背景图片
		//-----------------------数据---------------------------------
		private var _textStr:String;
		private var _width:Number;
		private var _height:Number;
		private var _id:int = 0;
		//-----------------------事件--------------------------------
		public function PopOption(w:Number, h:Number)
		{
			_width = w;
			_height = h;
			initBg = creaBg(0x4D4D4D);
			addChild(initBg);
			/*_bgBitmap = new ScaleBitmap(new (Reflection.getClass("comboxBgBitmap")as Class) as BitmapData);
			_bgBitmap.setScale9Grid(new Rectangle(3, 3, _width, _height));
			addChild(_bgBitmap);*/
			
			rollOverBg = creaBg(0xcccccc);
			addChild(rollOverBg);
			rollOverBg.visible = false;
			_text = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.font = ApplicationConfig.FONT;
			tf.color = 0xFFFF00;
			_text.defaultTextFormat = tf;
			_text.autoSize = TextFieldAutoSize.CENTER;
			
			addChild(_text);
			_text.mouseEnabled = false;
			_text.filters = [new GlowFilter(0x000000, 1,2, 2,3)];
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
		}
		
		private function rollOver(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			initBg.visible = false;
			rollOverBg.visible = true;
		}
		
		private function rollOut(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			initBg.visible = true;
			rollOverBg.visible = false;
		}
		
		/**
		 * 生成底背景
		 * @param	value
		 */
		private function creaBg(color:uint = 0xffffff):Shape
		{
			var shap:Shape = new Shape();
			shap.graphics.lineStyle(1, 0x7A7B99, .8);
			shap.graphics.beginFill(color, .65);
			shap.graphics.drawRect(0, 0, _width, _height);
			shap.graphics.endFill();
			return shap;
		}
		
		public function get textStr():String
		{
			return _textStr;
		}
		
		public function set textStr(value:String):void
		{
			_textStr = value;
			_text.text = value;
			_text.x = (_width - _text.textWidth) >> 1;
			_text.y = ((_height - _text.textHeight) >> 1)-1;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
	}

}