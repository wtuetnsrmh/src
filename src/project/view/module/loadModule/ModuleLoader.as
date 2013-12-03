package project.view.module.loadModule
{
	/**
	 * 加载外部模块
	 */
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import project.config.ApplicationConfig;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.model.ModelLocator;

    public class ModuleLoader extends Sprite
    {
        private var _rootContainer:DisplayObjectContainer;
        private var _loadingMc:DisplayObject;
        private var loader:Loader;
        public var instance:MovieClip;
        private var modal:Sprite;
        private static const MODULE_UNLOAD:String = "MODULE_UNLOAD";

        public function ModuleLoader()
        {
            this._rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
            this._loadingMc = SMZTResourceManager.getInstance().getRes("LockScreen");
            this._loadingMc.x = (ApplicationConfig.STAGE_WIDTH - this._loadingMc.width) / 2;
            this._loadingMc.y = (ApplicationConfig.STAGE_HEIGHT - this._loadingMc.height) / 2 -100;
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
            this._loadingMc["pt"].text = "数据加载中...";// +_loc_2.toString() + "%";
            return;
        }// end function

        private function onModuleComplete(event:Event) : void
        {
            this.instance = MovieClip(event.currentTarget.content);
            this.addModuleListener();
            removeChild(this._loadingMc);
            this._loadingMc = null;
            addChild(this.instance);
            dispatchEvent(new Event("MODULE_LOAD", true));
            return;
        }// end function

        protected function addModuleListener() : void
        {
            this.instance.addEventListener("MODULE_UNLOAD", this.hide);
            return;
        }// end function


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
				//var _loc_2:LoaderContext = new LoaderContext(false, SMZTDomainManager.getInstance().currentUIAppDomain);// ApplicationDomain.currentDomain);
                this.loader.load(new URLRequest(ModelLocator.getInstance().staticURL + source));
            }
            catch (e:Error)
            {
                Debug.log(e.toString());
            }
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
			
			loader.unload();
            /*var _loc_2:* = "vip" + new Date().fullYear + new Date().month + new Date().date;
            if (FlashCookie.getCookie(_loc_2, "vip") == "1")
            {
            }
            else
            {
                FlashCookie.setCookie(_loc_2, "vip", "1");
            }*/
            return;
        }// end function

        protected function drawModalRect() : void
        {
            if (this.modal == null)
            {
                this.modal = new Sprite();
            }
            this.modal.graphics.beginFill(2061, 0.1);
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
