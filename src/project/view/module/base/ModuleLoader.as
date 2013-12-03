package project.view.module.base
{
	/*
	* 描述：加载模块
	* 
	*/
	import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
	import project.config.ApplicationConfig;
	import project.core.AnimationManager;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.model.ModelLocator;
	import project.utils.FlashCookie;
	
    /*import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.model.*;
    import project.utils.*;*/
    
    

    public class ModuleLoader extends Sprite
    {
        private var _rootContainer:DisplayObjectContainer;
        private var _loadingMc:DisplayObject;
        private var loader:Loader;
        public var instance:*;
        private var modal:Sprite;
        private static const MODULE_UNLOAD:String = "MODULE_UNLOAD";

        public function ModuleLoader()
        {
            this._rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
            this._loadingMc = SMZTResourceManager.getInstance().getRes("LockScreen");//加载进度界面
            this._loadingMc.x = (ApplicationConfig.STAGE_WIDTH - this._loadingMc.width) / 2;
            this._loadingMc.y = (ApplicationConfig.STAGE_HEIGHT - this._loadingMc.height) / 2 - 40;
            addChild(this._loadingMc);
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onModuleProgress);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onModuleComplete);
            return;
        }// end function

        protected function onModuleProgress(event:ProgressEvent) : void
        {
            ////trace("加载模块=========>" + event.bytesLoaded + "/" + event.bytesTotal);
            var _loc_2:Number = event.bytesLoaded / event.bytesTotal;
            _loc_2 = Math.round(_loc_2 * 100);
            this._loadingMc["pt"].text = _loc_2.toString() + "%";
            return;
        }// end function

        private function onModuleComplete(event:Event) : void
        {
            this.instance = this.loader.content;
            this.addModuleListener();
            removeChild(this._loadingMc);
            this._loadingMc = null;
            addChild(this.instance);
            dispatchEvent(new Event("MODULE_LOAD", true));
            return;
        }// end function

        protected function addModuleListener() : void
        {
            /*this.instance.addEventListener("MODULE_UNLOAD", this.hide);
            this.instance.addEventListener("CHECK_VIP", this.checkVip);
            this.instance.addEventListener("ONE_GOLD", this.onGold);
            this.instance.addEventListener("HZ_C", this.onHz);
            //this.instance.addEventListener("HZ_C", this.onHz);
            this.instance.addEventListener("SHOP_C", this.onShp);
            this.instance.addEventListener("QIFU", this.onQifu);*/
            return;
        }// end function

       /* private function onQifu(event:Event) : void
        {
            return;
        }// end function

        private function onHz(event:Event) : void
        {
            SMZTUIManager.getInstance().playerInfoPane.onHuangzuanTequan();
            return;
        }// end function

        private function onShp(event:Event) : void
        {
            ShopPane.getInstance().show(true);
            SMZTController.getInstance().initShopList();
            return;
        }// end function

        private function onGold(event:Event) : void
        {
            ShopPurchasePaneExchange.getInstance().show(true);
            return;
        }// end function

        private function checkVip(event:Event) : void
        {
            ItemCheckController.checkProp(PropConfig.VIP_CARD);
            return;
        }// end function*/

        public function show(param1:String, param2:Boolean = true) : void
        {
            var source:String = param1;
            var modal:Boolean = param2;
            if (modal)
            {
                this.drawModalRect();
            }
            this._rootContainer.addChild(this);
            try
            {
                this.loader.load(new URLRequest(ModelLocator.getInstance().staticURL + source));
            }
            catch (e:Error)
            {
                //trace("ModuleLoader:"+e.toString());
            }
            //trace(this.x, this.y);
            AnimationManager.transfromAroundCenter(this);
            return;
        }// end function

        public function hide(event:Event = null) : void
        {
            if (this.modal != null && this.rootContainer.contains(this.modal))
            {
                this._rootContainer.removeChild(this.modal);
                this.modal = null;
            }
            this._rootContainer.removeChild(this);
            if (this.instance.hasEventListener("MODULE_UNLOAD"))
            {
                this.instance.addEventListener("MODULE_UNLOAD", this.hide);
            }
            this.instance = null;
            var _loc_2:String = "vip" + new Date().fullYear + new Date().month + new Date().date;
            if (FlashCookie.getCookie(_loc_2, "vip") == "1")
            {
            }
            else
            {
                FlashCookie.setCookie(_loc_2, "vip", "1");
            }
            return;
        }// end function

        protected function drawModalRect() : void
        {
            if (this.modal == null)
            {
                this.modal = new Sprite();
            }
            this.modal.graphics.beginFill(2061, 0.3);
            this.modal.graphics.drawRect(0, 0, ApplicationConfig.STAGE_WIDTH, ApplicationConfig.STAGE_HEIGHT);
            this.modal.graphics.endFill();
            this._rootContainer.addChild(this.modal);
            return;
        }// end function

        public function setLoadingMcPos(param1:Point) : void
        {
            this._loadingMc.x = param1.x;
            this._loadingMc.y = param1.y;
            return;
        }// end function

        public function get rootContainer() : DisplayObjectContainer
        {
            return this._rootContainer;
        }// end function

        public function set rootContainer(param1:DisplayObjectContainer) : void
        {
            this._rootContainer = param1;
            return;
        }// end function

        public function get loadingMc() : DisplayObject
        {
            return this._loadingMc;
        }// end function

        public function set loadingMc(param1:DisplayObject) : void
        {
            this._loadingMc = param1;
            return;
        }// end function

    }
}
