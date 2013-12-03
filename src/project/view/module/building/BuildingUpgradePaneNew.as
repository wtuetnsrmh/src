package project.view.module.building
{
    import project.config.*;
    import project.controller.*;
    import project.model.*;
    import project.model.item.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.alert.*;
    import project.view.module.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class BuildingUpgradePaneNew extends BaseTitleWindow
    {
        private var _type:int;
        public var target:SeceneBuilding;
        public var infoText1:TextField;
        private var upgradeBtn:MovieClipButton;
        private var infoText:TextField;
        private var _canUpgrade:Boolean;
        private var _needLevelStr:String;
        public var needTxt:TextField;
        public var needNumb:int;
        private static var buildingUpgradePane:BuildingUpgradePaneNew;

        public function BuildingUpgradePaneNew(param1:Boolean = true)
        {
            super(param1);
            if (buildingUpgradePane != null)
            {
                throw new Error("Error");
            }
            setSpriteInstance("BuildingUpgradePaneNew");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText1 = getChild("info1") as TextField;
            this.infoText = getChild("info") as TextField;
            (getChild("getmc") as MovieClip).buttonMode = true;
            this.needTxt = getChild("gg") as TextField;
            this.upgradeBtn = getChild("upg") as MovieClipButton;
            this.upgradeBtn.onClick = this.upgradeBuilding;
            this.upgradeBtn.active = false;
            (getChild("getmc") as MovieClip).addEventListener(MouseEvent.CLICK, this.showGet);
            return;
        }// end function

        protected function showGet(event:MouseEvent) : void
        {
            BuildingUpgradeBuyPane.getInstance().show(true);
            return;
        }// end function

        private function upgradeBuilding(event:MouseEvent) : void
        {
            SMZTController.getInstance().upgradeBuildingByZhuanTou(this._type, 3, this.onUpgradeBack);
            return;
        }// end function

        override public function show(param1:Boolean = false) : void
        {
            super.show(param1);
            SMZTController.getInstance().checkHasItem(PropConfig.ZHUAN_TOU, this.onCheckBack);
            return;
        }// end function

        private function onUpgradeBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
            AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.BuildingUpgradePane.UpgradeSuccess.@Text);
            if (this.target)
            {
                this.target.playLevelUpEffect();
            }
            this.target = null;
            hide();
            return;
        }// end function

        private function onCheckBack(param1:XML) : void
        {
            var _loc_2:ItemModel = null;
            var _loc_3:ItemModel = null;
            if (param1.hasOwnProperty("UserPackage") && param1.UserPackage.@Amount >= this.needNumb)
            {
                _loc_2 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
                if (param1.Offer.@VipSale > 0)
                {
                    _loc_2.shopDiscountRMB = param1.Offer.@VipSale;
                }
                _loc_2.sId = param1.Offer.@Id;
                _loc_2.shopPrice = param1.Offer.@Silver;
                _loc_2.shopPriceRMB = param1.Offer.@Gold;
                BuildingUpgradeBuyPane.getInstance().itemModel = _loc_2;
                this.upgradeBtn.active = true;
                this.needTxt.htmlText = "<font color = \'#FFFFFF\'>× " + int(param1.UserPackage.@Amount).toString() + " / " + this.needNumb.toString();
            }
            else
            {
                _loc_3 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
                if (param1.Offer.@VipSale > 0)
                {
                    _loc_3.shopDiscountRMB = param1.Offer.@VipSale;
                }
                _loc_3.sId = param1.Offer.@Id;
                _loc_3.shopPrice = param1.Offer.@Silver;
                _loc_3.shopPriceRMB = param1.Offer.@Gold;
                BuildingUpgradeBuyPane.getInstance().itemModel = _loc_3;
                this.upgradeBtn.active = false;
                this.needTxt.htmlText = "× " + "<font color = \'#FF0000\'>" + int(param1.UserPackage.@Amount).toString() + "</font> / " + this.needNumb.toString();
            }
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function set type(param1:int) : void
        {
            this._type = param1;
            return;
        }// end function

        public function get canUpgrade() : Boolean
        {
            return this._canUpgrade;
        }// end function

        public function set canUpgrade(param1:Boolean) : void
        {
            this._canUpgrade = param1;
            if (!this._canUpgrade)
            {
                this.infoText.htmlText = String(LocalConfig.LOCAL_LAN.BuildingUpgradePane.NeedLevel.@Text).replace("{level}", this.needLevelStr).replace("{color}", "#FF0000");
            }
            else
            {
                this.infoText.htmlText = String(LocalConfig.LOCAL_LAN.BuildingUpgradePane.NeedLevel.@Text).replace("{level}", this.needLevelStr).replace("{color}", "#FFFFFF");
            }
            return;
        }// end function

        public function get needLevelStr() : String
        {
            return this._needLevelStr;
        }// end function

        public function set needLevelStr(param1:String) : void
        {
            this._needLevelStr = param1;
            return;
        }// end function

        public static function getInstance() : BuildingUpgradePaneNew
        {
            if (buildingUpgradePane == null)
            {
                buildingUpgradePane = new BuildingUpgradePaneNew;
            }
            return buildingUpgradePane;
        }// end function

    }
}
