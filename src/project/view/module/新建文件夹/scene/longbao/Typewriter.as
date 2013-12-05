package project.view.module.scene.longbao 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
		
	/** 文字显示完毕后调度 */
	[Event(name="complete", type="flash.events.Event")]
	
	/** 
	 * 打字机文本框
	 * @author S_eVent
	 * <br>创建时间：Mar 15, 2012 5:57:11 PM 
	 * <br>备注：
	 * <br>此类中的文本框预设以下属性：
	 * <br>autoSize = TextFieldAutoSize.LEFT;
	 * <br>this.multiline = true;
	 *	<br>	this.wordWrap = true;
	 * <br>
	 *<br> Copyright 2010 KingNet Technology All rights reserved.
	 */ 
	public class Typewriter extends Sprite 
	{ 
		/** 打印文字的时间间隔时间（单位：毫秒）
		 * @default 100 */
		public var writeDelay:Number = 100;
		
		private var _duration:Number = 0;
		
		private var _text:String;
		private var _running:Boolean = false;
		private var _lastTime:int;
		private var _passedTime:Number;
		private var _writeDelay:Number;
		private var _textfield:TextField;
		private var _textContainer:Sprite;
		private var _mask:Shape;
		private var _filter:GlowFilter;
		
		public function Typewriter()
		{
			super();
			
			_textfield = new TextField();
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.multiline = true;
			_textfield.wordWrap = true;
			_filter = new GlowFilter();
			_filter.color = 0x000000;
			_filter.alpha = 1;
			_filter.blurX = 3;
			_filter.blurY = 3;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			_textfield.filters = [_filter];
			
			_textContainer = new Sprite();
			_textContainer.mouseChildren = false;
			_textContainer.addChild(_textfield);
			addChild(_textContainer);
			_mask = new Shape();
			addChild(_mask);
			_textContainer.mask = _mask;
		} 
		
		/** 开始显示文字 */
		public function startWriting():void
		{
			if( _text && !_running )
			{
				trace("开始说话")
				_mask.graphics.clear();
				_running = true;
				
				_passedTime = 0;
				_writeDelay = 100;// duration / _text.length;
				duration = _text.length * _writeDelay;
				_lastTime = getTimer();
				addEventListener(Event.ENTER_FRAME, onEF);
				/*if( duration == 0 )
				{
					stopWriting(true);
				}
				else
				{
					_passedTime = 0;
					_writeDelay = 100;// duration / _text.length;

					_lastTime = getTimer();
					addEventListener(Event.ENTER_FRAME, onEF);
				}*/
			}
		}
		
		/** 停止显示文字 
		 * @param showAllText	是否在停止时把剩下的文字一次性显示出来*/
		public function stopWriting(showAllText:Boolean=false):void
		{
			if( _running )
			{
				removeEventListener(Event.ENTER_FRAME, onEF);
				_running = false;
				
				if( showAllText )
				{
					showText();
					this.dispatchEvent( new Event(Event.COMPLETE) );
				}
			}
		}
		
		/** 显示全部文字 */
		public function showText():void
		{
			drawMask(0, 0, _textfield.width, _textfield.height);
		}
		
		private function onEF( e:Event ):void
		{
			var crtTime:int = getTimer();
			var psTime:int = crtTime - _lastTime;
			_passedTime += psTime;
			
			if( _passedTime >= _duration )
			{
				trace("说明时长到,说话结束")
				stopWriting(true);
			}
			else
			{
				var charNum:int = _passedTime / _writeDelay;
				if( charNum > 0 )
				{
					var showRect:Rectangle;
					for(var i:int=0; i<charNum; i++)
					{
						if(i<_textfield.length){
						showRect = _textfield.getCharBoundaries(i); 
						drawMask(showRect.x-1, showRect.y-1, showRect.width+1, showRect.height +2, false);
						}
					}
				}
			}
			_lastTime = crtTime;
		}
		
		private function drawMask(x:Number, y:Number, w:Number, h:Number, clear:Boolean=true):void
		{
			if( clear )
				_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(x,y,w,h);
			_mask.graphics.endFill();
		}
		
		/** 设置将打印出的文字。可以是htmlText形式 */
		public function set text(value:String):void
		{
			drawMask(0,0,0,0);
			_textfield.htmlText = value;
			_text = _textfield.text;
		}

		/** 显示文字的时间。若为0则一次性全部出现。若为负数则会按照writeDelay属性
		 * 的值自动计算duration。默认值为0*/
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			if( _duration != value )
			{
				_duration = value;
			}
		}

		/** 是否正在运作 */
		public function get running():Boolean
		{
			return _running;
		}

		override public function set width(value:Number):void
		{
			_textfield.width = value;
		}
		
		public function get textfield():TextField
		{
			return _textfield;
		}
	} 
	
	
} 