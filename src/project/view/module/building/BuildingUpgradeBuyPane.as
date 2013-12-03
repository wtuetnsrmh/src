package project.view.module.building
{
    import project.config.*;
    import project.model.*;
    import project.model.item.*;
    import project.view.artplug.*;
    import project.view.base.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;

    public class BuildingUpgradeBuyPane extends BaseTitleWindow
    {
        public var itemModel:ItemModel;
        public var mode:int;
        private static var instance:BuildingUpgradeBuyPane;

        public function BuildingUpgradeBuyPane(param1:Boolean = true)
        {
            super(param1);
            setSpriteInstance("BuildingUpgradeBuyPane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            (getChild("invite") as MovieClipButton).onClick = this.invite;
            (getChild("bbt") as MovieClipButton).onClick = this.buyZhuan;
            (getChild("bg") as MovieClip).gotoAndStop(1);
            if (ModelLocator.getInstance().isQQRelated())
            {
                (getChild("bg") as MovieClip).gotoAndStop(2);
            }
            return;
        }// end function

        private function buyZhuan(event:MouseEvent) : void
        {
            ShopPurchasePane.getInstance().itemModel = this.itemModel;
            ShopPurchasePane.getInstance().show(true);
            hide();
            return;
        }// end function

        private function invite(event:MouseEvent) : void
        {
            var _loc_2:* = ApplicationConfig.mainConfig.invite.@method;
            trace(_loc_2);
            switch(_loc_2)
            {
                case "JS":
                {
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call(ApplicationConfig.mainConfig.invite, "1");
                    }
                    break;
                }
                case "HTTP":
                {
                    navigateToURL(new URLRequest(ApplicationConfig.mainConfig.invite), ApplicationConfig.mainConfig.invite.@target);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public static function getInstance() : BuildingUpgradeBuyPane
        {
            if (instance == null)
            {
                instance = new BuildingUpgradeBuyPane;
            }
            return instance;
        }// end function

    }
}
