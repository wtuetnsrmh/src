package project.view.module.scene.tower 
{
	import project.view.artplug.MovieClipButton;
	import project.core.SMZTSoundManager;
	import project.config.ApplicationConfig;
	import project.utils.XColor;
	import project.view.controls.ToolTip;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.text.*;
    import mx.utils.*;
	/**
	 * 关卡传送入口按钮
	 * @author bbjxl 2013
	 */
	public class TeleportButton extends MovieClipButton 
	{
		private var _clickEnable:Boolean = false;//是否可点击
        private var _playxa:Boolean = false;
        private var _onClick:Function;
		private var _onMouseOver:Function;
		private var _onMouseOut:Function;
        private var _active:Boolean = true;
        private var _show:Boolean = true;
        private var _toolTip:String = "";
        //private var tp:ToolTip;
        private var _mouseOverSound:String = "UI_MOUSE_OVER";
        private var _mouseClickSound:String = "UI_MOUSE_CLICK";
        private var isSoundPlaying:Boolean = false;
		
		private var _id:int = 0;//当前的关卡ＩＤ
		private var _telePortFun:Function;//传送的方法
		private var _enterBt:MovieClipButton;//进入按钮
		public function TeleportButton() 
		{
			
		}
		
		override public function set clickEnable(param1:Boolean) : void
		{
			
		  _clickEnable = param1;
		  if (!param1) {
			  //不能点,变灰
			  this.mouseEnabled = false;
			  this.mouseChildren = false;//进入按钮不可点
			  this.buttonMode = false;
			  this.gotoAndStop(1);
			  //XColor.removeColor(this);
			  XColor.setTint(this,102,102,102,50);
				this.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseHandler);
				this.removeEventListener(MouseEvent.CLICK, this.mouseHandler);
			  }else {
				  this.mouseChildren = true;
				  this.mouseEnabled = true;
				  this.buttonMode = true;
				  //this.filters = null;
				  XColor.reset(this);
				  this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
				this.addEventListener(MouseEvent.MOUSE_UP, this.mouseHandler);
				this.addEventListener(MouseEvent.CLICK, this.mouseHandler);
				  }
		  return;
		}// end function
		
		/**
		 * 显示、隐藏进入按钮
		 * @param	arg
		 */
		public function showEnterBt(value:Boolean = false):void {
			_enterBt.visible = value;
			}
		 
		//选中状态
		override public function setSelected(arg:Boolean = false):void {
			//没激活的话不执行
			if (!_clickEnable) { return; }
			
			if (arg) {
				//trace("clcik")
				this.gotoAndStop(1);
				this.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseHandler);
				this.removeEventListener(MouseEvent.CLICK, this.mouseHandler);
				}else {
					this.gotoAndStop(1);
					this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
					this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
					this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
					this.addEventListener(MouseEvent.MOUSE_UP, this.mouseHandler);
					this.addEventListener(MouseEvent.CLICK, this.mouseHandler);
					}
			}
			
			
		private function mouseHandler(event:MouseEvent) : void
        {
            if (!this.active)
            {
                return;
            }
			
            switch(event.type)
            {
                case MouseEvent.MOUSE_OVER:
                {
                    if (this.playxa)
                    {
                        SMZTSoundManager.playXiaoAo();
                    }
                    gotoAndStop(2);
                    if (StringUtil.trim(this._toolTip) != "")
                    {
                        this.tp.show(this, "", _toolTip);// "<font color='#ffffff'>" + _toolTip + "</font>");
                    }
					if (_onMouseOver != null) {
						_onMouseOver.call(null,event)
						}
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    gotoAndStop(1);
					if (_onMouseOut != null) {
						_onMouseOut.call(null, event);
						}
                    break;
                }
                case MouseEvent.MOUSE_DOWN:
                {
                    gotoAndStop(3);
                    break;
                }
                case MouseEvent.MOUSE_UP:
                {
                    gotoAndStop(1);
                    break;
                }
                case MouseEvent.CLICK:
                {
                    this.stopUISound();
                    this.playUISound(this._mouseClickSound);
                    if (this._onClick != null)
                    {
                        this._onClick.call(null, event);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
			_enterBt = getChildByName("enterBt"+_id) as MovieClipButton;
			_enterBt.visible = false;
			_enterBt.onClick = function clickHandler(e:MouseEvent):void {
				e.stopImmediatePropagation();
				_telePortFun(_id);
				};
		}
		
		public function get telePortFun():Function 
		{
			return _telePortFun;
		}
		
		public function set telePortFun(value:Function):void 
		{
			_telePortFun = value;
		}
	}

}