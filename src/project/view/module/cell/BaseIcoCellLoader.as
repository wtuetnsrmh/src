package project.view.module.cell
{
	/*
	* 描述：加载的图标基类
	* 没用资源池的图标
	*/
	import project.config.ApplicationConfig;
	import project.debug.Debug;
	import project.view.base.BaseSpritePane;
	import project.model.item.ItemModel;
	import project.view.controls.ToolTip;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;

    public class BaseIcoCellLoader extends BaseSpritePane
    {
        private var _restrictHW:uint = 0;//宽高，如果不为0则宽高为此值
		
        protected var _item:ItemModel;
        protected var _ico:Object;
        protected var _icoImg:DisplayObject;
        protected var _loader:Loader;
        protected var _imageLayer:Sprite;//图片层
		
        private var _txtLayer:Sprite;//文字层
        private var _tf:ToolTip;
        private var _showBg:Boolean = true;
        private var _imgMode:int;//1：2： 99：
        private var _imgScale:Number = 1;
        private var _toolTipEnabled:Boolean = true;//是否显示提示文字
        private var lc:LoaderContext;
        private var _icoUri:String = "";
		public var _callBack:Function;
		public var _progressFun:Function;

        public function BaseIcoCellLoader()
        {
            setSpriteInstance("IcoBg");//方格背景
			
            this._tf = ToolTip.getInstance();
            this._tf.bgAlpha = 0.7;
            this._tf.cornerRadius = 0;
            this._tf.colors = [1642254, 1642254];
            this._tf.border = 4211070;
            this._tf.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this._tf.contentFormat = _loc_1;
            this._imageLayer = new Sprite();
            this._txtLayer = new Sprite();
            addChild(this._imageLayer);
            addChild(this._txtLayer);
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onlaod);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            this.lc = new LoaderContext(true, null, null);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            return;
        }// end function
		

		
		private function progressHandler(e:ProgressEvent):void 
		{
			if (_progressFun != null) {
				_progressFun.call(this,e);
				}
			//trace(e.bytesLoaded / e.bytesTotal);
			//trace("num"+_imageLayer.numChildren)
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			Debug.log("图片地址加载出错ioError");
		}

		//鼠标移上
        private function onMouseOver(event:MouseEvent) : void
        {
            if (this.item != null && this._toolTipEnabled)
            {
                trace(this.name);
                this.tf.show(this, "", this.item.getToolTipStr());
            }
            return;
        }// end function

		//设置图标
        protected function setImgIco(param1:DisplayObject) : void
        {
            if (!param1)
            {
                return;
            }
            this.clearImgIco();
            param1.scaleX = this._imgScale;
            param1.scaleY = this._imgScale;
            this._imageLayer.addChild(param1);
            if (this._restrictHW != 0)
            {
               
                this.height = this._restrictHW;
                this.width = this._restrictHW;
            }
            return;
        }// end function

        protected function onAssetsLoad(param1:Loader) : void
        {
            if (this._restrictHW != 0)
            {
               
                this.height = this._restrictHW;
                this.width = this._restrictHW;
            }
            return;
        }// end function

		//清除图标
        public function clearImgIco() : void
        {
            while (this._imageLayer.numChildren > 0)
            {
                
                this._imageLayer.removeChildAt(0);
                this._imageLayer.filters = null;
                this.icoUri = "";
            }
            return;
        }// end function

        private function mouseDown(event:MouseEvent) : void
        {
            return;
        }// end function

		//是否接受拖动（待扩展）
        public function setAcceptDrag(param1:Boolean) : void
        {
            return;
        }// end function

        public function get ico()
        {
            return this._ico;
        }// end function

		//设置图标，如果是地址就加载，如果是显示对象就显示
        public function set ico(param1) : void
        {
			//trace(param1)
            var ico:* = param1;
            if (!ico)
            {
				return;
            }
            if (param1 is String)
            {
                try
                {
                    if (this.icoUri == param1)
                    {
                        return;
                    }
                    this._loader.load(new URLRequest(param1), lc);
					
                }
                catch (e:IOErrorEvent)
                {
					//trace("BaseIcoCellLoader:"+e)
                }
            }
            else if (param1 is DisplayObject)
            {
                this.setImgIco(param1);
                this._icoImg = param1;
            }
            return;
        }// end function

		//加载完成
        private function onlaod(event:Event) : void
        {
            //trace("finish");
			
           /* this.setImgIco(this._loader.content);
            this._icoImg = this._loader.content;*/
			 this.setImgIco(this._loader);
            this._icoImg = this._loader;
			
			if (_callBack != null)_callBack.call(null);
            return;
        }// end function

        public function get icoImg() : DisplayObject
        {
            return this._icoImg;
        }// end function

        public function set icoImg(param1:DisplayObject) : void
        {
            this._icoImg = param1;
            return;
        }// end function

        public function get item() : ItemModel
        {
            return this._item;
        }// end function

		//背包图标时，根据数据模型加载图标
        public function set item(param1:ItemModel) : void
        {
            if (param1)
            {
                this._item = param1;
                if (this._imgMode == 1)
                {
                    this.ico = param1.icoImage;//正常大小图标
                }
                else if (this._imgMode == 2)
                {
                    this.ico = param1.icoBigImage;//大图标地址
                }
                else if (this._imgMode == 99)
                {
                    this.ico = param1.icoCardImage;//卡图标地址
                }
                else
                {
                    this.ico = param1.ico;
                }
            }
            else
            {
                this._item = null;
                this.ico = null;
                this.clearImgIco();
            }
            return;
        }// end function

        public function get showBg() : Boolean
        {
            return this._showBg;
        }// end function

        public function set showBg(param1:Boolean) : void
        {
            this._showBg = param1;
            spriteInstance.visible = this._showBg;
            return;
        }// end function

        public function get imageLayer() : Sprite
        {
            return this._imageLayer;
        }// end function

        public function set imageLayer(param1:Sprite) : void
        {
            this._imageLayer = param1;
            return;
        }// end function

        public function get tf() : ToolTip
        {
            return this._tf;
        }// end function

        public function set tf(param1:ToolTip) : void
        {
            this._tf = param1;
            return;
        }// end function

        public function get imgMode() : int
        {
            return this._imgMode;
        }// end function

        public function set imgMode(param1:int) : void
        {
            this._imgMode = param1;
            return;
        }// end function

        public function get imgScale() : Number
        {
            return this._imgScale;
        }// end function

        public function set imgScale(param1:Number) : void
        {
            this._imgScale = param1;
            return;
        }// end function

        public function get toolTipEnabled() : Boolean
        {
            return this._toolTipEnabled;
        }// end function

        public function set toolTipEnabled(param1:Boolean) : void
        {
            this._toolTipEnabled = param1;
            return;
        }// end function

        public function get restrictHW() : uint
        {
            return this._restrictHW;
        }// end function

        public function set restrictHW(param1:uint) : void
        {
            this._restrictHW = param1;
            return;
        }// end function

        public function get txtLayer() : Sprite
        {
            return this._txtLayer;
        }// end function

        public function set txtLayer(param1:Sprite) : void
        {
            this._txtLayer = param1;
            return;
        }// end function
		
		public function get icoUri():String 
		{
			return _icoUri;
		}
		
		public function set icoUri(value:String):void 
		{
			_icoUri = value;
		}
		override public function dispose():void {
			if (_loader) {
				try{
				if (_loader.content is Bitmap) {
					(_loader.content as Bitmap).bitmapData.dispose();
					}
				}catch (e:SecurityError) {
					_loader.unload();
					trace(Debug.log("安全沙箱错误！"));
					}
				}
			}
    }
}
