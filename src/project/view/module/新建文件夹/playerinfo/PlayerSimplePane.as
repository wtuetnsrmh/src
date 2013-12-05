package project.view.module.playerinfo
{
    import com.adobe.serialization.json.*;
    import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.model.*;
    import project.model.data.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.alert.*;
    import project.view.module.budoukai.*;
    import project.view.module.cell.*;
    import project.view.module.feed.*;
    import project.view.module.loading.*;
    import project.view.module.rankpane.*;
    import project.view.module.SMZTplayer.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.text.*;

    public class PlayerSimplePane extends BaseTitleWindow
    {
        private var nickText:TextField;
        private var strText:TextField;
        private var dexText:TextField;
        private var spdText:TextField;
        private var lvText:TextField;
        private var eleText:TextField;
        private var jobText:TextField;
        private var _uId:int;
        private var avatar:DisplayObject;
        private var avContianer:DisplayObjectContainer;
        private var avatarIco:BaseIcoCellLoader;
        private var vsBtn:SimpleButton;
        private var goToBtn:SimpleButton;
        private var chatBtn:MovieClipButton;
        private var naviText:TextField;
        private var strengthBar:AttributeBarSmall;
        private var agilityBar:AttributeBarSmall;
        private var speedBar:AttributeBarSmall;
        private var snsAcc:String = "";
        private static var playerSimplePane:PlayerSimplePane;

        public function PlayerSimplePane()
        {
            if (playerSimplePane != null)
            {
                throw new Error("Eroor");
            }
            setSpriteInstance("PlayerSimplePane");
            dragable = false;
            this.name = "PlayerSimplePane";
            this.configerUIInstance();
            this.avatarIco = new BaseIcoCellLoader();
            this.avatarIco.setLocation(120, 5);
            this.avatarIco.showBg = false;
            this.avatarIco.restrictHW = 50;
            addChild(this.avatarIco);
            this.avatarIco.mouseEnabled = false;
            this.avatarIco.mouseChildren = false;
            return;
        }// end function

        override public function hide(event:MouseEvent = null) : void
        {
            if (rootContainer.contains(this))
            {
                rootContainer.removeChild(this);
            }
            isOpened = false;
            isPopUP = false;
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            return;
        }// end function

        override public function show(param1:Boolean = false) : void
        {
            playUISound("UI_MOUSE_OVER");
            rootContainer.addChild(this);
            if (this.stage.mouseY < 100)
            {
                setLocation(this.stage.mouseX - 60, 0);
            }
            else if (mouseY > 500)
            {
                setLocation(this.stage.mouseX - 60, 570 - this.width);
            }
            else
            {
                setLocation(this.stage.mouseX - 60, this.stage.mouseY - 50);
            }
            isOpened = true;
            isPopUP = true;
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            spriteInstance.addEventListener(MouseEvent.ROLL_OUT, this.hide);
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.nickText = getChild("nickTxt") as TextField;
            this.strText = getChild("sTxt") as TextField;
            this.dexText = getChild("dTxt") as TextField;
            this.spdText = getChild("spdTxt") as TextField;
            this.lvText = getChild("lvTxt") as TextField;
            this.jobText = getChild("ocTxt") as TextField;
            this.naviText = getChild("rrt") as TextField;
            this.naviText.addEventListener(TextEvent.LINK, this.onTextClick);
            this.goToBtn = getChild("gogo") as SimpleButton;
            this.vsBtn = getChild("vs") as SimpleButton;
            this.nickText.mouseEnabled = false;
            this.strText.mouseEnabled = false;
            this.dexText.mouseEnabled = false;
            this.spdText.mouseEnabled = false;
            this.lvText.mouseEnabled = false;
            this.jobText.mouseEnabled = false;
            this.avContianer = getChild("gl") as DisplayObjectContainer;
            this.avContianer.mouseEnabled = false;
            this.avContianer.mouseChildren = false;
            this.goToBtn.addEventListener(MouseEvent.CLICK, this.goToFriendsHome);
            this.vsBtn.addEventListener(MouseEvent.CLICK, this.vsClick);
            this.strengthBar = new AttributeBarSmall();
            this.agilityBar = new AttributeBarSmall();
            this.speedBar = new AttributeBarSmall();
            this.strengthBar.x = 122.1;
            this.strengthBar.y = 102.1;
            this.agilityBar.x = 122.1;
            this.agilityBar.y = 119.95;
            this.speedBar.x = 122.1;
            this.speedBar.y = 139.35;
            addChild(this.strengthBar);
            addChild(this.agilityBar);
            addChild(this.speedBar);
            this.strengthBar.mouseEnabled = false;
            this.strengthBar.mouseChildren = false;
            this.agilityBar.mouseEnabled = false;
            this.agilityBar.mouseChildren = false;
            this.speedBar.mouseEnabled = false;
            this.speedBar.mouseChildren = false;
            this.strengthBar.addEventListener(MouseEvent.ROLL_OVER, this.shoAttrText);
            this.agilityBar.addEventListener(MouseEvent.ROLL_OVER, this.shoAttrText);
            this.speedBar.addEventListener(MouseEvent.ROLL_OVER, this.shoAttrText);
            this.strengthBar.addEventListener(MouseEvent.ROLL_OUT, this.shoAttrText);
            this.agilityBar.addEventListener(MouseEvent.ROLL_OUT, this.shoAttrText);
            this.speedBar.addEventListener(MouseEvent.ROLL_OUT, this.shoAttrText);
            this.chatBtn = getChild("chamm") as MovieClipButton;
            this.chatBtn.onClick = this.sendPrivateMessage;
            (getChild("sv") as MovieClip).visible = false;
            if (getChild("qqlaizi") as MovieClip)
            {
                (getChild("qqlaizi") as MovieClip).visible = ModelLocator.getInstance().isQQRelated();
            }
            return;
        }// end function

        private function sendPrivateMessage(event:MouseEvent) : void
        {
            ChatController.getInstance().addPrivateChat(this.nickText.text, this._uId);
            return;
        }// end function

        private function shoAttrText(event:MouseEvent) : void
        {
            if (event.type == MouseEvent.ROLL_OVER)
            {
                this.strengthBar.showText();
                this.agilityBar.showText();
                this.speedBar.showText();
            }
            else if (event.type == MouseEvent.ROLL_OUT)
            {
                this.strengthBar.showCollumn();
                this.agilityBar.showCollumn();
                this.speedBar.showCollumn();
            }
            return;
        }// end function

        private function vsClick(event:MouseEvent) : void
        {
            playUISound("UI_MOUSE_CLICK");
            AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.RankIcoBox.FreePKConfirm.@Text, this.onSelect);
            return;
        }// end function

        private function onSelect(param1:String) : void
        {
            if (param1 == AlertSelectPane.ALERT_YES)
            {
                SMZTController.getInstance().setFreePK(this.uId, this.onVSBack);
            }
            return;
        }// end function

        private function onTextClick(event:TextEvent) : void
        {
            var _loc_2:Object = null;
            if (ApplicationConfig.mainConfig.snsUserPage.@method == "JS")
            {
                if (ModelLocator.getInstance().isQQRelated())
                {
                    _loc_2 = new Object();
                    _loc_2.openid = this.snsAcc;
                    ExternalInterface.call(ApplicationConfig.mainConfig.snsUserPage, JSON.encode(_loc_2));
                }
                else
                {
                    ExternalInterface.call(ApplicationConfig.mainConfig.snsUserPage, this.snsAcc);
                }
            }
            else
            {
                navigateToURL(new URLRequest(String(ApplicationConfig.mainConfig.snsUserPage).replace("{acc}", this.snsAcc)), ApplicationConfig.mainConfig.snsUserPage.@target);
            }
            return;
        }// end function

        private function onVSBack(param1:XML) : void
        {
            if (ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId)
            {
                PlayerData.getInstance().foo = PlayerData.getInstance().foo - 10;
            }
            this.hide();
            SMZTUIManager.getInstance().mainPane.switchToPlayerMode();
            SMZTPlayer.getInstance().show(true);
            var _loc_2:* = ModelLocator.getInstance().staticURL + "singleplayer_pve.xml";
            var _loc_3:* = ModelLocator.getInstance().dynamicURL + ServerParse.FIGHT_HISTORY + "?id=" + param1.FightHistory;
            var _loc_4:* = ModelLocator.getInstance().staticURL + "crossdomain.xml";
            trace(_loc_3);
            SMZTPlayer.getInstance().playerFight(param1.FightHistory, ModelLocator.getInstance().staticURL + "singleplayer_pve.xml", _loc_3, _loc_4, "", 2, 2);
            return;
        }// end function

        private function goToFriendsHome(event:MouseEvent) : void
        {
            ModelLocator.getInstance().currentUId = this._uId;
            SMZTUIManager.getInstance().mainPane.returnMainScene();
            SMZTController.getInstance().initPlayerInfo(this._uId, this.onInitBack);
            LockScreen.getInstance().show(true);
            return;
        }// end function

        private function onInitBack(param1:XML) : void
        {
            FeedPane.getInstance().hide();
            this.hide();
            LockScreen.getInstance().hide();
            if (BudoukaiPane.getInstance().isOpened)
            {
                BudoukaiPane.getInstance().hide();
            }
            if (RankPane.getInstance().isOpened)
            {
                RankPane.getInstance().hide();
            }
            SMZTUIManager.getInstance().mainScene.reCheckEvent();
            return;
        }// end function

        public function setTipData(param1:int) : void
        {
            this._uId = param1;
            if (!ModelLocator.getInstance().isQQRelated() && ModelLocator.getInstance().snsType != ModelLocator.SNS_MIXI && ModelLocator.getInstance().snsType != ModelLocator.SNS_HE_KR)
            {
                this.naviText.htmlText = "<u><a href=\'event:" + this._uId + "\'>" + LocalConfig.LOCAL_LAN.PlayerSimplePane.Visit.@Text + "</a></u>";
            }
            SMZTController.getInstance().initOtherInfo(this._uId, this.onLoad);
            return;
        }// end function

        private function onLoad(param1:XML) : void
        {
            while (this.avContianer.numChildren > 0)
            {
                
                this.avContianer.removeChildAt(0);
            }
            this.nickText.text = param1.User.Name;
            this.lvText.text = String(LocalConfig.LOCAL_LAN.PlayerSimplePane.Job.@Text).replace("{level}", param1.UserDynamic.Level).replace("{job}", LocalConfig.LOCAL_LAN.Characters["Job" + param1.UserDynamic.Job].@Text);
            this.jobText.text = param1.UserDynamic.HP;
            var _loc_2:* = param1.UserDynamic.Job;
            if (param1.hasOwnProperty("UserAvatar"))
            {
                _loc_2 = param1.UserAvatar.@AvatarId;
            }
            var _loc_3:* = SMZTResourceManager.getInstance().loadAssets(ModelLocator.getInstance().staticURL + ApplicationConfig.mainConfig.imgSrc + "characters/Job_" + _loc_2 + ".swf");
            this.avContianer.addChild(_loc_3);
            this.strengthBar.setValue(param1.UserDynamic.Strength);
            this.agilityBar.setValue(param1.UserDynamic.Dexterity);
            this.speedBar.setValue(param1.UserDynamic.Speed);
            this.snsAcc = param1.User.SNSAcc;
            (getChild("sv") as MovieClip).visible = param1.User.SNSVip > 0 && ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA;
            if (param1.User.SNSVip > 0)
            {
                (getChild("sv") as MovieClip).gotoAndStop(param1.User.SNSVip);
            }
            var _loc_4:* = String(param1.User.Avatar);
            if (String(param1.User.Avatar).indexOf("http://img.kaixin001.com.cn/") > -1)
            {
                _loc_4 = ModelLocator.getInstance().staticURL + "game/" + ApplicationConfig.VERSION + "/assets/images/kx_men.gif";
            }
            else
            {
                _loc_4 = param1.User.Avatar;
            }
            this.avatarIco.ico = _loc_4;
            if (getChild("qqlaizi") as MovieClip)
            {
                (getChild("qqlaizi") as MovieClip).visible = ModelLocator.getInstance().isQQRelated();
            }
            if (ModelLocator.getInstance().isQQRelated())
            {
                switch(String(param1.User.SNSName))
                {
                    case "qzone":
                    {
                        (getChild("qqlaizi") as MovieClip).gotoAndStop(2);
                        break;
                    }
                    case "pengyou":
                    {
                        (getChild("qqlaizi") as MovieClip).gotoAndStop(1);
                        break;
                    }
                    case "tapp":
                    {
                        (getChild("qqlaizi") as MovieClip).gotoAndStop(3);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
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

        public static function getInstance() : PlayerSimplePane
        {
            if (playerSimplePane == null)
            {
                playerSimplePane = new PlayerSimplePane;
            }
            return playerSimplePane;
        }// end function

    }
}
