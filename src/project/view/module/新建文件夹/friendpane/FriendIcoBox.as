package project.view.module.friendpane
{
    import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.events.*;
    import project.model.*;
    import project.model.data.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.controls.*;
    import project.view.module.alert.*;
    import project.view.module.cell.*;
    import project.view.module.loading.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class FriendIcoBox extends BaseSpritePane
    {
        private var _friendEachData:Object;
        private var avIco:BaseIcoCellLoader;
        private var _uId:int;
        private var nameText:TextField;
        private var lvText:TextField;
        private var _canTease:int;
        private var vsBtn:SimpleButton;
        private var teaseBtn:SimpleButton;
        private var tt:ToolTip;
        private var canVs:Boolean = false;
        private var vipText:TextField;
        private var vipMc:MovieClip;
        private var _isSelected:Boolean = false;
        private var affiliateGoldMc:MovieClipButton;
        private var affiliateSilverMc:MovieClipButton;
        private var expBar:MovieClip;
        private var _fMode:int = 0;
        private var needFeed:Boolean = false;
        private var bId:String = "";

        public function FriendIcoBox()
        {
            setSpriteInstance("FriendIcoBox");
            (spriteInstance as MovieClip).gotoAndStop(1);
            this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.8;
            this.tt.cornerRadius = 12;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 16762389;
            this.tt.borderSize = 1;
            var _loc_1:* = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_1;
            this.affiliateSilverMc = getChild("gfs") as MovieClipButton;
            this.affiliateGoldMc = getChild("gfg") as MovieClipButton;
            this.affiliateSilverMc.visible = false;
            this.affiliateGoldMc.visible = false;
            this.affiliateGoldMc.onClick = this.getAffiliateGold;
            this.affiliateSilverMc.onClick = this.getAffiliateSilver;
            this.expBar = getChild("fxp") as MovieClip;
            this.expBar.visible = false;
            this.expBar.gotoAndStop(1);
            this.vipMc = getChild("vsg") as MovieClip;
            this.vipMc.visible = false;
            this.vipText = getChild("vip") as TextField;
            this.nameText = getChild("nt") as TextField;
            this.lvText = getChild("lv") as TextField;
            this.vsBtn = getChild("vs") as SimpleButton;
            this.teaseBtn = getChild("qqb") as SimpleButton;
            this.nameText.mouseEnabled = false;
            this.lvText.mouseEnabled = false;
            this.vsBtn.visible = false;
            this.teaseBtn.visible = false;
            this.avIco = new BaseIcoCellLoader();
            this.avIco.showBg = false;
            this.avIco.restrictHW = 32;
            var _loc_3:int = 1;
            this.avIco.y = 1;
            this.avIco.x = _loc_3;
            addChild(this.avIco);
            this.avIco.buttonMode = true;
            var _loc_2:* = new Loader();
            _loc_2.load(new URLRequest(ModelLocator.getInstance().staticURL + "game/" + ApplicationConfig.VERSION + "/assets/images/kx_men.gif"));
            _loc_2.scaleX = 0.65;
            _loc_2.scaleY = 0.65;
            this.avIco.imageLayer.addChild(_loc_2);
            (getChild("ggr") as SimpleButton).addEventListener(MouseEvent.CLICK, this.goToFriendsHome);
            this.avIco.addEventListener(MouseEvent.CLICK, this.goToFriendsHome);
            this.vsBtn.addEventListener(MouseEvent.CLICK, this.vsClick);
            this.teaseBtn.addEventListener(MouseEvent.CLICK, this.teaseClick);
            this.vsBtn.addEventListener(MouseEvent.MOUSE_OVER, this.showVsTip);
            this.teaseBtn.addEventListener(MouseEvent.MOUSE_OVER, this.showTeaseTip);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            (getChild("sv") as MovieClip).visible = false;
            return;
        }// end function

        private function getAffiliateGold(event:MouseEvent) : void
        {
            var getAffBackG:Function;
            var event:* = event;
            getAffBackG = function (param1:XML) : void
            {
                ItemUseCallBackController.onGetAffliateSilverBack(friendEachData.affGold, 1);
                return;
            }// end function
            ;
            SMZTController.getInstance().getAffliate(this.uId, 1, getAffBackG);
            return;
        }// end function

        private function getAffiliateSilver(event:MouseEvent) : void
        {
            var getAffBackS:Function;
            var event:* = event;
            getAffBackS = function (param1:XML) : void
            {
                ItemUseCallBackController.onGetAffliateSilverBack(friendEachData.affSilver, 0);
                return;
            }// end function
            ;
            SMZTController.getInstance().getAffliate(this.uId, 0, getAffBackS);
            return;
        }// end function

        private function showVsTip(event:MouseEvent) : void
        {
            this.tt.show(this.vsBtn, "", LocalConfig.LOCAL_LAN.FriendIcoBox.FriendVs.@Text);
            return;
        }// end function

        private function showTeaseTip(event:MouseEvent) : void
        {
            this.tt.show(this.teaseBtn, "", LocalConfig.LOCAL_LAN.FriendIcoBox.FriendTease.@Text);
            return;
        }// end function

        private function vsClick(event:MouseEvent) : void
        {
            var onChoose:Function;
            var event:* = event;
            onChoose = function (param1:String) : void
            {
                if (param1 == AlertSelectPane.ALERT_YES)
                {
                    if (canVs)
                    {
                        SMZTController.getInstance().setFriendPK(uId, onVSBack);
                    }
                    else
                    {
                        SMZTController.getInstance().setFreePK(uId, onVSBack);
                        if (ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId)
                        {
                            PlayerData.getInstance().foo = PlayerData.getInstance().foo - 10;
                        }
                    }
                }
                return;
            }// end function
            ;
            if (this.canVs)
            {
                AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.FriendIcoBox.FriendVsConfirm.@Text, onChoose);
            }
            else
            {
                AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.FriendIcoBox.FriendFressVsConfirm.@Text, onChoose);
            }
            return;
        }// end function

        private function onVSBack(param1:XML) : void
        {
            SMZTUIManager.getInstance().mainPane.switchToPlayerMode();
            SMZTPlayer.getInstance().show(true);
            var _loc_2:* = ModelLocator.getInstance().staticURL + "singleplayer_pve.xml";
            var _loc_3:* = ModelLocator.getInstance().dynamicURL + ServerParse.FIGHT_HISTORY + "?id=" + param1.FightHistory;
            var _loc_4:* = ModelLocator.getInstance().staticURL + "crossdomain.xml";
            trace(_loc_3);
            SMZTPlayer.getInstance().playerFight(param1.FightHistory, ModelLocator.getInstance().staticURL + "singleplayer_pve.xml", _loc_3, _loc_4, "", 2, 2);
            this.bId = param1.FightHistory;
            SMZTPlayer.getInstance().addEventListener(Event.COMPLETE, this.onFightOver);
            this.needFeed = true;
            return;
        }// end function

        protected function onFightOver(event:Event) : void
        {
            if (this.needFeed && this.bId != null && this.bId != "")
            {
                this.needFeed = false;
                this.sendSNSFeed(this.bId);
            }
            return;
        }// end function

        private function sendSNSFeed(param1:String) : void
        {
            var _loc_2:String = null;
            var _loc_3:* = "?" + ModelLocator.getInstance().tokenStr + "&";
            switch(ModelLocator.getInstance().snsType)
            {
                case ModelLocator.SNS_51:
                {
                    _loc_2 = ServerParse.SHARE_SNS_51 + _loc_3;
                    break;
                }
                case ModelLocator.SNS_KX:
                {
                    _loc_2 = ServerParse.SHARE_SNS_KX + _loc_3;
                    break;
                }
                case ModelLocator.SNS_RR:
                {
                    _loc_2 = ServerParse.SHARE_SNS_RR + _loc_3;
                    break;
                }
                case ModelLocator.SNS_REAL_WORD_JP:
                {
                    _loc_2 = ServerParse.SHARE_SNS_REALWORLD + _loc_3;
                    break;
                }
                case ModelLocator.SNS_GUMMY:
                {
                    _loc_2 = ServerParse.SHARE_GUMMY + _loc_3;
                    break;
                }
                case ModelLocator.SNS_QD:
                {
                    _loc_2 = ServerParse.SHARE_QD + _loc_3;
                    break;
                }
                case ModelLocator.SNS_FACEBOOK:
                {
                    _loc_2 = ServerParse.SHARE_FACEBOOK + _loc_3;
                    break;
                }
                case ModelLocator.SNS_SINA:
                {
                    _loc_2 = ServerParse.SHARE_SINA + _loc_3;
                    break;
                }
                case ModelLocator.SNS_QQ:
                {
                    _loc_2 = ServerParse.SHARE_SNS_QQ_PENGYOU + _loc_3;
                    break;
                }
                case ModelLocator.SNS_QZONE:
                {
                    _loc_2 = ServerParse.SHARE_SNS_QQ + _loc_3;
                    break;
                }
                case ModelLocator.SNS_MIXI:
                {
                    _loc_2 = ServerParse.SHARE_MIXI + _loc_3;
                    break;
                }
                case ModelLocator.SNS_HE_KR:
                {
                    _loc_2 = ServerParse.SHARE_MIXI + _loc_3;
                    break;
                }
                case ModelLocator.SNS_MINIK:
                {
                    _loc_2 = ServerParse.SHARE_MINIK + _loc_3;
                }
                default:
                {
                    break;
                }
            }
            SMZTController.getInstance().publishNSNBattleAnnouncement(param1, _loc_2, this.onBack);
            return;
        }// end function

        private function onBack(param1:XML) : void
        {
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_51)
            {
                AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.ShareSelectPane.ShareSuccess.@Text);
            }
            return;
        }// end function

        private function teaseClick(event:MouseEvent) : void
        {
            var onLoadBack:Function;
            var event:* = event;
            onLoadBack = function (param1:XML) : void
            {
                LockScreen.getInstance().hide();
                SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_OFFICER_SCENE);
                return;
            }// end function
            ;
            ModelLocator.getInstance().currentUId = this._uId;
            SMZTController.getInstance().initPlayerInfo(this._uId, onLoadBack);
            LockScreen.getInstance().show(true);
            return;
        }// end function

        private function goToFriendsHome(event:MouseEvent) : void
        {
            if (this._friendEachData)
            {
                ModelLocator.getInstance().currentUId = this._uId;
                SMZTController.getInstance().initPlayerInfo(ModelLocator.getInstance().currentUId, this.onInitBack);
                LockScreen.getInstance().show(true);
            }
            return;
        }// end function

        private function onInitBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
            SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
            SMZTUIManager.getInstance().mainScene.reCheckEvent();
            SMZTUIManager.getInstance().blessScene.refreshData();
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            this.setOnChoose(true);
            return;
        }// end function

        private function onMouseOut(event:MouseEvent) : void
        {
            this.setOnChoose(false);
            return;
        }// end function

        public function setOnChoose(param1:Boolean) : void
        {
            if (param1)
            {
                (spriteInstance as MovieClip).gotoAndStop(2);
            }
            else if (!this._isSelected)
            {
                (spriteInstance as MovieClip).gotoAndStop(1);
            }
            return;
        }// end function

        public function clearStatus() : void
        {
            this.vipText.text = "";
            this._friendEachData = null;
            this.nameText.text = "";
            this.lvText.text = "";
            this.avIco.item = null;
            this._uId = 0;
            this.vsBtn.visible = false;
            this.canVs = false;
            this.teaseBtn.visible = false;
            this.vipMc.visible = false;
            this._isSelected = false;
            this.expBar.visible = false;
            this.affiliateGoldMc.visible = false;
            this.affiliateSilverMc.visible = false;
            (getChild("sv") as MovieClip).visible = false;
            return;
        }// end function

        public function setData(param1:Object) : void
        {
            if (param1.snsvip > 0 && ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA)
            {
                (getChild("sv") as MovieClip).visible = true;
                (getChild("sv") as MovieClip).gotoAndStop(param1.snsvip);
            }
            this.friendEachData = param1;
            this.nameText.htmlText = param1.nick;
            this.lvText.text = "Lv" + param1.level;
            var _loc_2:* = param1.avatar;
            this.avIco.ico = _loc_2;
            this._uId = param1.uId;
            switch(this._fMode)
            {
                case 0:
                {
                    this.vsBtn.visible = true;
                    this.canVs = param1.pvf == 1;
                    this.teaseBtn.visible = param1.canTease == 1;
                    this._canTease = param1.canTease;
                    this.vipMc.visible = param1.vip >= 1;
                    break;
                }
                case 1:
                {
                    this.affiliateGoldMc.visible = param1.affGold >= 1;
                    this.affiliateSilverMc.visible = param1.affSilver >= 1;
                    this.expBar.visible = true;
                    this.expBar.gotoAndStop(param1.expPercent);
                    this.affiliateSilverMc.toolTip = String(LocalConfig.LOCAL_LAN.FriendIcoBox.GetSilver.@Text).replace("{amount}", this.friendEachData.affSilver);
                    this.affiliateGoldMc.toolTip = String(LocalConfig.LOCAL_LAN.FriendIcoBox.GetGold.@Text).replace("{amount}", this.friendEachData.affGold);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get friendEachData() : Object
        {
            return this._friendEachData;
        }// end function

        public function set friendEachData(param1:Object) : void
        {
            this._friendEachData = param1;
            return;
        }// end function

        public function get uId() : int
        {
            return this._uId;
        }// end function

        public function set uId(param1:int) : void
        {
            this._uId = param1;
            return;
        }// end function

        public function get canTease() : int
        {
            return this._canTease;
        }// end function

        public function set canTease(param1:int) : void
        {
            this._canTease = param1;
            return;
        }// end function

        public function get isSelected() : Boolean
        {
            return this._isSelected;
        }// end function

        public function set isSelected(param1:Boolean) : void
        {
            this._isSelected = param1;
            return;
        }// end function

        public function get fMode() : int
        {
            return this._fMode;
        }// end function

        public function set fMode(param1:int) : void
        {
            this._fMode = param1;
            return;
        }// end function

    }
}
