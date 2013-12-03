package project.view.module.alert
{
    import com.adobe.net.*;
    import project.config.*;
    import project.controller.*;
    import project.model.*;
    import project.model.item.*;
    import project.view.artplug.*;
    import project.view.base.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    public class ShareSelectPane extends BaseTitleWindow
    {
        private var infoText:TextField;
        private var friendShareBtn:SimpleButton;
        private var worldShareBtn:SimpleButton;
        private var snsShareBtn:SimpleButton;
        private var _aId:String;
        private var _bId:String;
        private var callBackFunction:Function;
        private var _type:int = 0;
        private var copyClipBtn:SimpleButton;
        private var cc:MovieClipButton;
        private static var shareSelectPane:ShareSelectPane;
        public static const ALERT_YES:String = "ALERT_YES";
        public static const ALERT_NO:String = "ALERT_NO";

        public function ShareSelectPane()
        {
            if (shareSelectPane != null)
            {
                throw new Error("Error");
            }
            showEffect = false;
            setSpriteInstance("ShareSelectPane");
            this.configerUIInstance();
            return;
        }// end function

        override protected function onAddToStage(event:Event) : void
        {
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_360 || ModelLocator.getInstance().snsType == ModelLocator.SNS_FACEBOOK || ModelLocator.getInstance().snsType == ModelLocator.SNS_51 || ModelLocator.getInstance().snsType == ModelLocator.SNS_QD || ModelLocator.getInstance().snsType == ModelLocator.SNS_GUMMY || ModelLocator.getInstance().snsType == ModelLocator.SNS_MIXI || ModelLocator.getInstance().snsType == ModelLocator.SNS_HE_KR)
            {
                this.copyClipBtn.visible = false;
                this.cc.y = 200.95;
                (spriteInstance as MovieClip).gotoAndStop(1);
            }
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_360)
            {
                this.snsShareBtn.visible = false;
                getChild("rrfuck").visible = true;
            }
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText = getChild("txt") as TextField;
            this.friendShareBtn = getChild("fs") as SimpleButton;
            this.worldShareBtn = getChild("wf") as SimpleButton;
            this.snsShareBtn = getChild("ns") as SimpleButton;
            this.copyClipBtn = getChild("cpy") as SimpleButton;
            this.cc = getChild("closeBtnFuck") as MovieClipButton;
            this.cc.onClick = hide;
            this.friendShareBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.worldShareBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.snsShareBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.copyClipBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            switch(event.currentTarget)
            {
                case this.friendShareBtn:
                {
                    this.checkFriendItem(event);
                    break;
                }
                case this.worldShareBtn:
                {
                    this.checkItem(event);
                    break;
                }
                case this.snsShareBtn:
                {
                    this.sendSNSShare();
                    break;
                }
                case this.copyClipBtn:
                {
                    this.copyBattleAddr();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function sendSNSShare() : void
        {
            var _loc_1:String = null;
            var _loc_2:* = "?" + ModelLocator.getInstance().tokenStr + "&";
            switch(ModelLocator.getInstance().snsType)
            {
                case ModelLocator.SNS_51:
                {
                    _loc_1 = ServerParse.SHARE_SNS_51 + _loc_2;
                    break;
                }
                case ModelLocator.SNS_KX:
                {
                    _loc_1 = ServerParse.SHARE_SNS_KX + _loc_2;
                    break;
                }
                case ModelLocator.SNS_RR:
                {
                    _loc_1 = ServerParse.SHARE_SNS_RR + _loc_2;
                    break;
                }
                case ModelLocator.SNS_REAL_WORD_JP:
                {
                    _loc_1 = ServerParse.SHARE_SNS_REALWORLD + _loc_2;
                    break;
                }
                case ModelLocator.SNS_GUMMY:
                {
                    _loc_1 = ServerParse.SHARE_GUMMY + _loc_2;
                    break;
                }
                case ModelLocator.SNS_QD:
                {
                    _loc_1 = ServerParse.SHARE_QD + _loc_2;
                    break;
                }
                case ModelLocator.SNS_FACEBOOK:
                {
                    _loc_1 = ServerParse.SHARE_FACEBOOK + _loc_2;
                    break;
                }
                case ModelLocator.SNS_SINA:
                {
                    _loc_1 = ServerParse.SHARE_SINA + _loc_2;
                    break;
                }
                case ModelLocator.SNS_QQ:
                {
                    _loc_1 = ServerParse.SHARE_SNS_QQ_PENGYOU + _loc_2;
                    break;
                }
                case ModelLocator.SNS_QZONE:
                {
                    _loc_1 = ServerParse.SHARE_SNS_QQ + _loc_2;
                    break;
                }
                case ModelLocator.SNS_MIXI:
                {
                    _loc_1 = ServerParse.SHARE_MIXI + _loc_2;
                    break;
                }
                case ModelLocator.SNS_HE_KR:
                {
                    _loc_1 = ServerParse.SHARE_MIXI + _loc_2;
                    break;
                }
                case ModelLocator.SNS_MINIK:
                {
                    _loc_1 = ServerParse.SHARE_MINIK + _loc_2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._type == 0)
            {
                SMZTController.getInstance().publishNSNAnnouncement(this._aId, _loc_1, this.onBack1);
            }
            else
            {
                SMZTController.getInstance().publishNSNBattleAnnouncement(this._bId, _loc_1, this.onBack1);
            }
            return;
        }// end function

        private function onBack(param1:XML) : void
        {
            if (ModelLocator.getInstance().isQQRelated() || ModelLocator.getInstance().snsType == ModelLocator.SNS_51 || ModelLocator.getInstance().snsType == ModelLocator.SNS_MIXI || ModelLocator.getInstance().snsType == ModelLocator.SNS_HE_KR)
            {
                AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.ShareSelectPane.ShareSuccess.@Text);
            }
            return;
        }// end function

        private function onBack1(param1:XML) : void
        {
            return;
        }// end function

        private function copyBattleAddr() : void
        {
            var _loc_1:* = "&" + ModelLocator.getInstance().tokenStr;
            System.setClipboard(ModelLocator.getInstance().staticURL + ApplicationConfig.mainConfig.ShareURL + "?id=" + URI.escapeChars(this._bId) + URI.escapeChars(_loc_1) + "&s=" + ModelLocator.getInstance().snsType);
            AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.ShareSelectPane.CopySuccess.@Text);
            return;
        }// end function

        private function checkItem(event:MouseEvent) : void
        {
            SMZTController.getInstance().checkHasItem(PropConfig.LOUD_SPEAKER, this.onCheckBack);
            return;
        }// end function

        private function checkFriendItem(event:MouseEvent) : void
        {
            AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.ShareSelectPane.ShareConfirm.@Text, this.onSelect);
            return;
        }// end function

        private function onSelect(param1:String) : void
        {
            if (param1 == AlertSelectPane.ALERT_YES)
            {
                if (this._type == 0)
                {
                    SMZTController.getInstance().publishFriendAnnouncement(this._aId, this.onBack);
                }
                else
                {
                    SMZTController.getInstance().publishFriendBattleAnnouncement(this._bId, this.onBack);
                }
            }
            return;
        }// end function

        private function onCheckBack(param1:XML) : void
        {
            var _loc_4:ItemModel = null;
            var _loc_5:ItemModel = null;
            var _loc_2:* = this._type == 0 ? (this.aId.toString()) : (this.bId);
            var _loc_3:* = this._type == 0 ? (1) : (2);
            if (param1.hasOwnProperty("UserPackage"))
            {
                _loc_4 = ItemBuilder.createItem(ItemCategory.ITEM, param1.UserPackage.@ItemId, 0, param1.UserPackage.@ItemId);
                _loc_4.itemId = param1.UserPackage.@ItemId;
                _loc_4.sId = param1.UserPackage.@Id;
                QuickPurchasePane.getInstance().mode = 1;
                QuickPurchasePane.getInstance().itemModel = _loc_4;
                QuickPurchasePane.getInstance().type = _loc_3;
                QuickPurchasePane.getInstance().targetId = _loc_2;
                QuickPurchasePane.getInstance().show(true);
            }
            else
            {
                _loc_5 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
                _loc_5.itemId = param1.Offer.@PropId;
                _loc_5.sId = param1.Offer.@Id;
                _loc_5.shopPrice = param1.Offer.@Silver;
                _loc_5.shopPriceRMB = param1.Offer.@Gold;
                if (param1.Offer.@VipSale > 0)
                {
                    _loc_5.shopDiscountRMB = param1.Offer.@VipSale;
                }
                QuickPurchasePane.getInstance().type = _loc_3;
                QuickPurchasePane.getInstance().targetId = _loc_2;
                QuickPurchasePane.getInstance().mode = 0;
                QuickPurchasePane.getInstance().itemModel = _loc_5;
                QuickPurchasePane.getInstance().show(true);
            }
            return;
        }// end function

        public function showMessage(param1:String, param2:Function = null, param3:Boolean = true) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param3)
                {
                    drawModalRect();
                }
                this.callBackFunction = param2;
                rootContainer.addChild(this);
                this.infoText.text = param1;
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            }
            return;
        }// end function

        public function get aId() : String
        {
            return this._aId;
        }// end function

        public function set aId(param1:String) : void
        {
            this._aId = param1;
            return;
        }// end function

        public function get bId() : String
        {
            return this._bId;
        }// end function

        public function set bId(param1:String) : void
        {
            this._bId = param1;
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function set type(param1:int) : void
        {
            this._type = param1;
            (getChild("rrfuck") as MovieClip).visible = false;
            this.snsShareBtn.visible = true;
            if (this._type == 1)
            {
                this.copyClipBtn.visible = true;
                this.cc.y = 230.95;
            }
            else
            {
                this.copyClipBtn.visible = false;
                this.cc.y = 200.95;
                if (ModelLocator.getInstance().snsType != ModelLocator.SNS_51)
                {
                    (getChild("rrfuck") as MovieClip).visible = true;
                    this.snsShareBtn.visible = false;
                }
            }
            (spriteInstance as MovieClip).gotoAndStop((this._type + 1));
            return;
        }// end function

        public static function getInstance() : ShareSelectPane
        {
            if (shareSelectPane == null)
            {
                shareSelectPane = new ShareSelectPane;
            }
            return shareSelectPane;
        }// end function

    }
}
