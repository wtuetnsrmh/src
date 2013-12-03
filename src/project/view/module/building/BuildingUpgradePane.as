package project.view.module.building
{
    import project.config.*;
    import project.controller.*;
    import project.model.*;
    import project.utils.*;
    import project.view.base.*;
    import project.view.module.alert.*;
    import project.view.module.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class BuildingUpgradePane extends BaseTitleWindow
    {
        private var _infoText:TextField;
        private var _infoText1:TextField;
        private var upgradeBtn:SimpleButton;
        private var cancelBtn:SimpleButton;
        private var payByMoney:MovieClip;
        private var payByGold:MovieClip;
        public var needLevelStr:String;
        private var _target:SeceneBuilding;
        private var _moneyText:TextField;
        private var _goldText:TextField;
        private var _type:int;
        private var _payMode:int = 0;
        private var _canUpgrade:Boolean;
        private static var buildingUpgradePane:BuildingUpgradePane;

        public function BuildingUpgradePane()
        {
            if (buildingUpgradePane != null)
            {
                throw new Error("Error");
            }
            setSpriteInstance("BuildingUpgradePane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText = getChild("info") as TextField;
            this._infoText1 = getChild("info1") as TextField;
            this.upgradeBtn = getChild("upg") as SimpleButton;
            this.payByMoney = getChild("pm") as MovieClip;
            this.payByGold = getChild("pg") as MovieClip;
            this.moneyText = getChild("mm") as TextField;
            this.goldText = getChild("gg") as TextField;
            this.infoText.mouseEnabled = false;
            this.goldText.mouseEnabled = false;
            this.moneyText.mouseEnabled = false;
            this.upgradeBtn.addEventListener(MouseEvent.CLICK, this.upgradeBuilding);
            this.payByMoney.gotoAndStop(2);
            this.payByGold.gotoAndStop(1);
            this.payByMoney.buttonMode = true;
            this.payByGold.buttonMode = true;
            this.payByMoney.addEventListener(MouseEvent.CLICK, this.onPayClick);
            this.payByGold.addEventListener(MouseEvent.CLICK, this.onPayClick);
            return;
        }// end function

        private function onPayClick(event:MouseEvent) : void
        {
            if (this.payByMoney.currentFrame == 3 || this.payByGold.currentFrame == 3)
            {
                return;
            }
            if (event.currentTarget == this.payByMoney)
            {
                this.payByMoney.gotoAndStop(2);
                this.payByGold.gotoAndStop(1);
            }
            else
            {
                this.payByMoney.gotoAndStop(1);
                this.payByGold.gotoAndStop(2);
            }
            return;
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
            this.payByMoney.gotoAndStop(2);
            this.payByGold.gotoAndStop(1);
            return;
        }// end function

        private function upgradeBuilding(event:MouseEvent) : void
        {
            if (!this.canUpgrade)
            {
                return;
            }
            var _loc_2:int = 0;
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_QQ || ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA || ModelLocator.getInstance().snsType == ModelLocator.SNS_FACEBOOK || ModelLocator.getInstance().snsType == ModelLocator.SNS_360)
            {
            }
            else
            {
                if (this.payByGold.currentFrame == 2)
                {
                    _loc_2 = 1;
                }
                LockScreen.getInstance().show(true);
                SMZTController.getInstance().upgradeBuilding(this._type, _loc_2, this.onUpgradeBack);
            }
            return;
        }// end function

        private function onUpgradeBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
            AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.BuildingUpgradePane.UpgradeSuccess.@Text);
            if (this._target)
            {
                this._target.playLevelUpEffect();
            }
            this._target = null;
            hide();
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

        public function get moneyText() : TextField
        {
            return this._moneyText;
        }// end function

        public function set moneyText(param1:TextField) : void
        {
            this._moneyText = param1;
            return;
        }// end function

        public function get goldText() : TextField
        {
            return this._goldText;
        }// end function

        public function set goldText(param1:TextField) : void
        {
            this._goldText = param1;
            return;
        }// end function

        public function get infoText() : TextField
        {
            return this._infoText;
        }// end function

        public function set infoText(param1:TextField) : void
        {
            this._infoText = param1;
            return;
        }// end function

        public function get infoText1() : TextField
        {
            return this._infoText1;
        }// end function

        public function set infoText1(param1:TextField) : void
        {
            this._infoText1 = param1;
            return;
        }// end function

        public function get target() : SeceneBuilding
        {
            return this._target;
        }// end function

        public function set target(param1:SeceneBuilding) : void
        {
            this._target = param1;
            return;
        }// end function

        public function get payMode() : int
        {
            return this._payMode;
        }// end function

        public function set payMode(param1:int) : void
        {
            this._payMode = param1;
            if (this._payMode == 1)
            {
                this.payByMoney.gotoAndStop(3);
                this.payByMoney.buttonMode = false;
                this.payByGold.gotoAndStop(2);
                this._moneyText.htmlText = LocalConfig.LOCAL_LAN.BuildingUpgradePane.UpgradeUnavailable.@Text;
            }
            else
            {
                this.payByMoney.gotoAndStop(2);
                this.payByGold.gotoAndStop(1);
                this.payByMoney.buttonMode = true;
                this.payByGold.buttonMode = true;
            }
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
                XColor.removeColor(this.upgradeBtn);
                this.upgradeBtn.addEventListener(MouseEvent.MOUSE_OVER, this.showTip);
            }
            else
            {
                this.upgradeBtn.filters = null;
                if (this.upgradeBtn.hasEventListener(MouseEvent.MOUSE_OVER))
                {
                    this.upgradeBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.showTip);
                }
            }
            return;
        }// end function

        private function showTip(event:MouseEvent) : void
        {
            toolTip.show(this.upgradeBtn, "", "<font color=\'#FFFFFF\'>" + String(LocalConfig.LOCAL_LAN.BuildingUpgradePane.NeedLevel.@Text).replace("{level}", this.needLevelStr) + "</font>");
            return;
        }// end function

        public static function getInstance() : BuildingUpgradePane
        {
            if (buildingUpgradePane == null)
            {
                buildingUpgradePane = new BuildingUpgradePane;
            }
            return buildingUpgradePane;
        }// end function

    }
}
