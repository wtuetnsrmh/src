package project.view.module.cell
{
	/*
	* 描述：图标单元基类
	* 用资源池加载
	*/
	import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;
	import project.config.ApplicationConfig;
	import project.core.SMZTResourceManager;
	import project.model.item.ItemModel;
	import project.view.base.BaseSpritePane;
	import project.view.controls.ToolTip;
    /*import project.config.*;
    import project.core.*;
    import project.model.*;
    import project.model.item.*;
    import project.view.base.*;
    import project.view.controls.*;
    import project.view.module.suit.*;*/
    

    public class BaseIcoCell extends BaseSpritePane
    {
        private var _restrictHW:uint = 0;
		
        protected var _item:ItemModel;
        protected var _ico:Object;
        protected var _icoImg:DisplayObject;
        protected var _loader:Loader;
        protected var _imageLayer:Sprite;
		
        private var _txtLayer:Sprite;
        private var _tf:ToolTip;
        private var _showBg:Boolean = true;
        private var _imgMode:int;
        private var _imgScale:Number = 1;
        private var _toolTipEnabled:Boolean = true;
        private var lc:LoaderContext;
        public var disPlaySuit:Boolean = false;

        public function BaseIcoCell()
        {
            setSpriteInstance("IcoBg");
            this._tf = ToolTip.getInstance();
            /*this._tf.bgAlpha = 0.88;
            this._tf.cornerRadius = 12;
            this._tf.colors = [1642254, 1642254];
            this._tf.border = 16762389;
            this._tf.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(ApplicationConfig.FONT, 12, ApplicationConfig.FONT_COLOR);
            this._tf.contentFormat = _loc_1;*/
            this._imageLayer = new Sprite();
            this._txtLayer = new Sprite();
            addChild(this._imageLayer);
            addChild(this._txtLayer);
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onlaod);
            this.lc = new LoaderContext(false, null, null);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            return;
        }// end function

		//根据不同的情况判断提示文字显示内容
        protected function onMouseOver(event:MouseEvent) : void
        {
            if (this.item != null && this._toolTipEnabled)
            {
                //trace(this.name);
                if (this.item.itemId < 60000)
                {
                    //this.tf.show(this, "", this.item.getToolTipStr());
                }
                else if (this.disPlaySuit)
                {
                    //SuitTipPane.getInstance().show(true);
                    //SuitTipPane.getInstance().suit = ItemBuilder.createItem(ItemCategory.ITEM, this.item.itemId, this.item.itemId) as ItemModel;
                }
                else
                {
                    this.tf.show(this, "", this.item.getToolTipStr());
                }
            }
            return;
        }// end function

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

		/*加载完后设置宽高
		* @ param
		* @ param
		*/
        protected function onAssetsLoad(param1:Loader,url:String="") : void
        {
            if (this._restrictHW != 0)
            {
               
                this.height = this._restrictHW;
                this.width = this._restrictHW;
            }
            return;
        }// end function

		/*清除图标
		* @ param
		* @ param
		*/
        protected function clearImgIco() : void
        {
            while (this._imageLayer.numChildren > 0)
            {
                
                this._imageLayer.removeChildAt(0);
                this._imageLayer.filters = null;
            }
            this.imageLayer.filters = null;
            return;
        }// end function

        private function mouseDown(event:MouseEvent) : void
        {
            return;
        }// end function

        public function setAcceptDrag(param1:Boolean) : void
        {
            return;
        }// end function

        public function get ico()
        {
            return this._ico;
        }// end function

		//设置图标
        public function set ico(param1) : void
        {
            var ico:* = param1;
            if (!ico)
            {
				return;
            }
            if (ico is String && ico!="")
            {
				//是加载地址
                try
                {
                    this.setImgIco(SMZTResourceManager.getInstance().loadAssets(ico, this.onAssetsLoad));//资源池来加载图标
                    this._icoImg = this._loader;
                }
                catch (e:Error)
                {
                }
            }
            else if (ico is DisplayObject)
            {
                this.setImgIco(ico);
                this._icoImg = ico;
            }
            return;
        }// end function

        private function onlaod(event:Event) : void
        {
            //trace(this.ico);
            this.setImgIco(this._loader);
            this._icoImg = this._loader;
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

        public function set item(param1:ItemModel) : void
        {
            if (param1)
            {
                this._item = param1;
                if (this._imgMode == 1)
                {
                    this.ico = param1.icoImage;
                }
                else if (this._imgMode == 2)
                {
                    this.ico = param1.icoBigImage;
                }
                else if (this._imgMode == 99)
                {
					//出售面板中时用99
                    this.ico = param1.icoCardImage;
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

    }
}
