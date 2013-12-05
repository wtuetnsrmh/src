package project.view.module.playerinfo
{
	/*
	* 描述：弹出的个人信息面板
	* 
	*/
	import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.ModelLocator;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.controls.ToolTip;
	import project.view.module.bagpane.BagIcoBox;
	import project.view.module.cell.BaseIcoCellLoader;
	import com.greensock.*;
    /*import com.adobe.serialization.json.*;
    import com.greensock.*;
    import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.events.*;
    import project.model.*;
    import project.model.data.*;
    import project.model.equip.*;
    import project.model.item.*;
    import project.model.jewelry.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.controls.*;
    import project.view.module.bagpane.*;
    import project.view.module.cell.*;
    import project.view.module.newbie.*;
    import project.view.module.shop.*;
    import project.view.module.suit.*;*/
    

    public class PlayerAttrInfoPane extends BaseTitleWindow
    {
        private var playerData:PlayerData;
        private var lvText:TextField;
        private var elMc:MovieClip;
        private var nickText:TextField;
        private var ocText:TextField;
        private var elText:TextField;
        private var sgText:TextField;
        private var hText:TextField;
        private var sText:TextField;
        private var dText:TextField;
        private var spdText:TextField;
        private var vgText:TextField;
        private var pointText:TextField;
        private var officerCellBox:BagIcoBox;
        private var officerCellBox1:BagIcoBox;
        private var wp1:BagIcoBox;
        private var wp2:BagIcoBox;
        private var wp3:BagIcoBox;
        private var strPlusBtnL:MovieClipButton;
        private var dexPlusBtn:MovieClipButton;
        private var spdPlusBtn:MovieClipButton;
        private var strMinusBtn:MovieClipButton;
        private var dexMinusBtn:MovieClipButton;
        private var spdMinusBtn:MovieClipButton;
        private var refreshBtn:MovieClipButton;
        private var modifyElBtn:MovieClipButton;
        private var confirmBtn:MovieClipButton;
        private var remainPoint:int;
        private var editSignBtn:MovieClipButton;
        private var editVictoryBtn:MovieClipButton;
        private var editS:MovieClipButton;
        private var editV:MovieClipButton;
        private var strengthBar:AttributeBar;
        private var agilityBar:AttributeBar;
        private var speedBar:AttributeBar;
        private var strengthPlus:int = 0;
        private var speedPlus:int = 0;
        private var agilityPlus:int = 0;
        private var remainMc:MovieClip;
        private var lockSign:MovieClip;
        private var _mode:int = 0;
        private var avatarIco:BaseIcoCellLoader;//头像
        private var timer:Timer;
        private var timerAttr:Timer;
        private var attrBtnTarget:MovieClipButton;
        private var tt:ToolTip;
        private var emc1:MovieClip;
        private var emc2:MovieClip;
        private var emc3:MovieClip;
        private var olevelText1:TextField;
        private var olevelText2:TextField;
        private var wlevelText1:TextField;
        private var wlevelText2:TextField;
        private var wlevelText3:TextField;
        private var visitBtn:MovieClipButton;
        private var unknownMc:MovieClip;
        private var tzmc:JewelryBox;
        private var ehmc1:JewelryBox;
        private var ehmc2:JewelryBox;
        private var xlmc:JewelryBox;
        private var ypmc:JewelryBox;
        private var hwmc1:JewelryBox;
        private var hwmc2:JewelryBox;
        private var jzmc1:JewelryBox;
        private var jzmc2:JewelryBox;
        private static var playerAttrInfoPane:PlayerAttrInfoPane;

        public function PlayerAttrInfoPane()
        {
            this.timer = new Timer(1100, 1);
            this.timerAttr = new Timer(500);
            this.tzmc = new JewelryBox();//饰品图标
            this.ehmc1 = new JewelryBox();
            this.ehmc2 = new JewelryBox();
            this.xlmc = new JewelryBox();
            this.ypmc = new JewelryBox();
            this.hwmc1 = new JewelryBox();
            this.hwmc2 = new JewelryBox();
            this.jzmc1 = new JewelryBox();
            this.jzmc2 = new JewelryBox();
            if (playerAttrInfoPane != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
            setSpriteInstance("PlayerAttrInfoPane");
            this.configerUIInstance();
			
			//------------------初始数据模型 ---------------------------------
            this.playerData = PlayerData.getInstance();
            dataModel = this.playerData;
			
			//加载头像
            this.avatarIco = new BaseIcoCellLoader();
            this.avatarIco.showBg = false;
            this.avatarIco.restrictHW = 50;
            this.avatarIco.setLocation(58.05, 19.5);
            var _loc_1:Loader= new Loader();
            _loc_1.load(new URLRequest(ModelLocator.getInstance().staticURL + ApplicationConfig.VERSION + "/assets/images/kx_men.jpg"));
            //this.avatarIco.imageLayer.addChild(_loc_1);
            addChild(this.avatarIco);
			avatarIco.ico = ModelLocator.getInstance().staticURL + ApplicationConfig.VERSION + "/assets/images/kx_men.jpg";
			
            this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.88;
            this.tt.cornerRadius = 12;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 16762389;
            this.tt.borderSize = 1;
            var _loc_2:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_2;
            dragable = false;
            //this.remainMc.gotoAndStop(1);
            return;
        }// end function

        override protected function onAddToStage(event:Event) : void
        {
            return;
        }// end function

        private function configerUIInstance() : void
        {
			
            (getChild("er1") as MovieClip).addChild(this.ehmc1);
            (getChild("er2") as MovieClip).addChild(this.ehmc2);
            (getChild("xl") as MovieClip).addChild(this.xlmc);
            (getChild("yp") as MovieClip).addChild(this.ypmc);
            (getChild("hw1") as MovieClip).addChild(this.hwmc1);
            (getChild("hw2") as MovieClip).addChild(this.hwmc2);
            (getChild("jz1") as MovieClip).addChild(this.jzmc1);
            (getChild("jz2") as MovieClip).addChild(this.jzmc2);
            if (int(ApplicationConfig.mainConfig.suit) == 1)
            {
                (getChild("tzd") as MovieClip).addChild(this.tzmc);
            }
            (getChild("tzd") as MovieClip).visible = int(ApplicationConfig.mainConfig.suit) == 1;
            if (ApplicationConfig.mainConfig.convoy == 0)
            {
                (getChild("er1") as MovieClip).visible = false;
                (getChild("er2") as MovieClip).visible = false;
                (getChild("xl") as MovieClip).visible = false;
                (getChild("yp") as MovieClip).visible = false;
                (getChild("hw1") as MovieClip).visible = false;
                (getChild("hw2") as MovieClip).visible = false;
                (getChild("jz1") as MovieClip).visible = false;
                (getChild("jz2") as MovieClip).visible = false;
            }
            this.ehmc1.setBg(3);
            this.ehmc2.setBg(4);
            this.xlmc.setBg(1);
            this.ypmc.setBg(2);
            this.hwmc1.setBg(5);
            this.hwmc2.setBg(6);
            this.jzmc1.setBg(7);
            this.jzmc2.setBg(8);
            this.tzmc.setBg(9);
            this.ehmc1.buttonMode = true;
            this.ehmc2.buttonMode = true;
            this.xlmc.buttonMode = true;
            this.ypmc.buttonMode = true;
            this.hwmc1.buttonMode = true;
            this.hwmc2.buttonMode = true;
            this.jzmc1.buttonMode = true;
            this.jzmc2.buttonMode = true;
            this.tzmc.buttonMode = true;
            this.ehmc1.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.ehmc2.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.xlmc.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.ypmc.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.hwmc1.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.hwmc2.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.jzmc1.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
            this.jzmc2.addEventListener(MouseEvent.CLICK, this.onJewelryClick);
              //this.tzmc.addEventListener(MouseEvent.CLICK, this.onSuitClick);
			this.ehmc1.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Ear.@Text;
            this.ehmc2.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Ear.@Text;
            this.xlmc.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Neck.@Text;
            this.ypmc.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Jade.@Text;
            this.hwmc1.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Wrist.@Text;
            this.hwmc2.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Wrist.@Text;
            this.jzmc1.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Ring.@Text;
            this.jzmc2.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Ring.@Text;
            this.tzmc.emptyName = LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Suit.@Text;
           /* this.unknownMc = getChild("unk") as MovieClip;
            this.unknownMc.mouseEnabled = false;
            this.unknownMc.mouseChildren = false;
            this.unknownMc.visible = false;
            this.lockSign = getChild("lock") as MovieClip;
            this.olevelText1 = getChild("olvt1") as TextField;
            this.olevelText2 = getChild("olvt2") as TextField;
            this.wlevelText1 = getChild("wlvt1") as TextField;
            this.wlevelText2 = getChild("wlvt2") as TextField;
            this.wlevelText3 = getChild("wlvt3") as TextField;
            this.olevelText1.mouseEnabled = false;
            this.olevelText2.mouseEnabled = false;
            this.wlevelText1.mouseEnabled = false;
            this.wlevelText2.mouseEnabled = false;
            this.wlevelText3.mouseEnabled = false;
            this.lockSign.addEventListener(MouseEvent.MOUSE_OVER, this.showLockTip);
            this.wp1 = new BagIcoBox();
            this.wp1.x = 274;
            this.wp1.y = 349;
            this.wp2 = new BagIcoBox();
            this.wp2.x = 318;
            this.wp2.y = 349;
            this.wp3 = new BagIcoBox();
            this.wp3.x = 363;
            this.wp3.y = 349;
            this.officerCellBox = new BagIcoBox();
            this.officerCellBox.x = 86.95;
            this.officerCellBox.y = 338;
            this.officerCellBox1 = new BagIcoBox();
            this.officerCellBox1.x = 148.65;
            this.officerCellBox1.y = 338;
            this.officerCellBox.addEventListener(MouseEvent.CLICK, this.cellClick);
            this.officerCellBox.buttonMode = true;
            this.officerCellBox.imgScale = 0.66;
            this.officerCellBox.showBg = false;
            this.officerCellBox1.addEventListener(MouseEvent.CLICK, this.cellClick);
            this.officerCellBox1.buttonMode = true;
            this.officerCellBox1.imgScale = 0.66;
            this.officerCellBox1.showBg = false;
            (getChild("icol") as MovieClip).addChild(this.wp1);
            (getChild("icol") as MovieClip).addChild(this.wp2);
            (getChild("icol") as MovieClip).addChild(this.wp3);
            this.wp1.addEventListener(MouseEvent.CLICK, this.cellClick);
            this.wp2.addEventListener(MouseEvent.CLICK, this.cellClick);
            this.wp3.addEventListener(MouseEvent.CLICK, this.cellClick);
            this.wp1.imgMode = 0;
            this.wp2.imgMode = 0;
            this.wp3.imgMode = 0;
            this.wp1.showBg = false;
            this.wp2.showBg = false;
            this.wp3.showBg = false;
            this.wp1.buttonMode = true;
            this.wp2.buttonMode = true;
            this.wp3.buttonMode = true;
            (getChild("icol") as MovieClip).addChild(this.officerCellBox);
            (getChild("icol") as MovieClip).addChild(this.officerCellBox1);
            this.remainMc = getChild("ar") as MovieClip;
            this.nickText = getChild("nickTxt") as TextField;
            this.ocText = getChild("ocTxt") as TextField;
            this.elText = getChild("elTxt") as TextField;
            this.sgText = getChild("sgTxt") as TextField;
            this.hText = getChild("hTxt") as TextField;
            this.sText = getChild("sTxt") as TextField;
            this.dText = getChild("dTxt") as TextField;
            this.spdText = getChild("spdTxt") as TextField;
            this.vgText = getChild("vgTxt") as TextField;
            this.lvText = getChild("lvTxt") as TextField;
            this.elText.visible = false;
            this.elMc = getChild("ec") as MovieClip;
            this.elMc.gotoAndStop(6);
            this.confirmBtn = getChild("attrCBtn") as MovieClipButton;
            this.modifyElBtn = getChild("mm") as MovieClipButton;
            this.refreshBtn = getChild("resBtn") as MovieClipButton;
            this.confirmBtn.addEventListener(MouseEvent.CLICK, this.onConfirmClick);
            this.refreshBtn.addEventListener(MouseEvent.CLICK, this.onRefreshClick);
            this.modifyElBtn.addEventListener(MouseEvent.CLICK, this.onRefreshElClick);
            this.strPlusBtn = getChild("sPlus") as MovieClipButton;
            this.dexPlusBtn = getChild("dexPlus") as MovieClipButton;
            this.spdPlusBtn = getChild("spdPlus") as MovieClipButton;
            this.strMinusBtn = getChild("sMinus") as MovieClipButton;
            this.dexMinusBtn = getChild("dexMinus") as MovieClipButton;
            this.spdMinusBtn = getChild("spdMinus") as MovieClipButton;
            this.emc1 = getChild("pp1") as MovieClip;
            this.emc2 = getChild("pp2") as MovieClip;
            this.emc3 = getChild("pp3") as MovieClip;
            this.emc1.gotoAndStop(1);
            this.emc2.gotoAndStop(1);
            this.emc3.gotoAndStop(1);
            (getChild("pp0") as MovieClip).buttonMode = true;
            (getChild("pp1") as MovieClip).buttonMode = true;
            (getChild("pp2") as MovieClip).buttonMode = true;
            (getChild("pp3") as MovieClip).buttonMode = true;
            (getChild("pp4") as MovieClip).buttonMode = true;
            (getChild("pp0") as MovieClip).addEventListener(MouseEvent.CLICK, this.glassClick);
            (getChild("pp1") as MovieClip).addEventListener(MouseEvent.CLICK, this.glassClick);
            (getChild("pp2") as MovieClip).addEventListener(MouseEvent.CLICK, this.glassClick);
            (getChild("pp3") as MovieClip).addEventListener(MouseEvent.CLICK, this.glassClick);
            (getChild("pp4") as MovieClip).addEventListener(MouseEvent.CLICK, this.glassClick);
            this.editSignBtn = getChild("edsBtn") as MovieClipButton;
            this.editVictoryBtn = getChild("edvBtn") as MovieClipButton;
            this.editS = getChild("eds") as MovieClipButton;
            this.editV = getChild("edv") as MovieClipButton;
            this.pointText = getChild("ar")["av"]["pointTxt"] as TextField;
            this.visitBtn = getChild("qutajia") as MovieClipButton;
            this.visitBtn.visible = false;
            this.visitBtn.onClick = this.vistFriend;
            this.strPlusBtn.addEventListener(MouseEvent.CLICK, this.attrClick);
            this.dexPlusBtn.addEventListener(MouseEvent.CLICK, this.attrClick);
            this.spdPlusBtn.addEventListener(MouseEvent.CLICK, this.attrClick);
            this.strMinusBtn.addEventListener(MouseEvent.CLICK, this.attrClick);
            this.dexMinusBtn.addEventListener(MouseEvent.CLICK, this.attrClick);
            this.spdMinusBtn.addEventListener(MouseEvent.CLICK, this.attrClick);
            this.strPlusBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.attrDown);
            this.dexPlusBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.attrDown);
            this.spdPlusBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.attrDown);
            this.strMinusBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.attrDown);
            this.dexMinusBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.attrDown);
            this.spdMinusBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.attrDown);
            this.strPlusBtn.addEventListener(MouseEvent.MOUSE_UP, this.attrUp);
            this.dexPlusBtn.addEventListener(MouseEvent.MOUSE_UP, this.attrUp);
            this.spdPlusBtn.addEventListener(MouseEvent.MOUSE_UP, this.attrUp);
            this.strMinusBtn.addEventListener(MouseEvent.MOUSE_UP, this.attrUp);
            this.dexMinusBtn.addEventListener(MouseEvent.MOUSE_UP, this.attrUp);
            this.spdMinusBtn.addEventListener(MouseEvent.MOUSE_UP, this.attrUp);
            this.strPlusBtn.addEventListener(MouseEvent.MOUSE_OUT, this.attrUp);
            this.dexPlusBtn.addEventListener(MouseEvent.MOUSE_OUT, this.attrUp);
            this.spdPlusBtn.addEventListener(MouseEvent.MOUSE_OUT, this.attrUp);
            this.strMinusBtn.addEventListener(MouseEvent.MOUSE_OUT, this.attrUp);
            this.dexMinusBtn.addEventListener(MouseEvent.MOUSE_OUT, this.attrUp);
            this.spdMinusBtn.addEventListener(MouseEvent.MOUSE_OUT, this.attrUp);
            this.strPlusBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.dexPlusBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.spdPlusBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.strMinusBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.dexMinusBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.spdMinusBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.sgText.addEventListener(MouseEvent.CLICK, this.onSelectTextField);
            this.sgText.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this.vgText.addEventListener(MouseEvent.CLICK, this.onSelectTextField);
            this.vgText.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this.vgText.type = TextFieldType.DYNAMIC;
            this.sgText.type = TextFieldType.DYNAMIC;
            this.vgText.maxChars = 16;
            this.sgText.maxChars = 16;
            this.editSignBtn.visible = false;
            this.editVictoryBtn.visible = false;
            this.editS.visible = true;
            this.editV.visible = true;
            this.editSignBtn.addEventListener(MouseEvent.CLICK, this.setSign);
            this.editVictoryBtn.addEventListener(MouseEvent.CLICK, this.setVictory);
            this.editS.addEventListener(MouseEvent.CLICK, this.setSign);
            this.editV.addEventListener(MouseEvent.CLICK, this.setVictory);
            this.strengthBar = new AttributeBar();
            this.agilityBar = new AttributeBar();
            this.speedBar = new AttributeBar();
            this.strengthBar.x = 281;
            this.strengthBar.y = 210;
            this.agilityBar.x = 281;
            this.agilityBar.y = 235;
            this.speedBar.x = 281;
            this.speedBar.y = 260;
            addChild(this.strengthBar);
            addChild(this.agilityBar);
            addChild(this.speedBar);
            this.strengthBar.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.agilityBar.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            this.speedBar.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrOver);
            if (getChild("flbtn") as MovieClipButton)
            {
                (getChild("flbtn") as MovieClipButton).onClick = this.follow;
            }
            (getChild("sv") as MovieClip).visible = false;
            this.remainMc.gotoAndStop(1);
            this.nickText.addEventListener(MouseEvent.MOUSE_OVER, this.showName);
            return;*/
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
           /* if (int(PlayerData.getInstance().playerLevel) < 4)
            {
                SMZTController.getInstance().initPlayerInfo();
            }*/
            return;
        }// end function

        private function follow(event:MouseEvent) : void
        {
            //SMZTController.getInstance().followWeibo(PlayerData.getInstance().snsAcc);
            return;
        }// end function

        /*private function onSelectTextField(event:Event) : void
        {
            if (ModelLocator.getInstance().uId != ModelLocator.getInstance().currentUId)
            {
                return;
            }
            if (event.currentTarget == this.sgText)
            {
                this.sgText.type = TextFieldType.INPUT;
                this.editSignBtn.visible = true;
                this.editS.visible = false;
            }
            else
            {
                this.vgText.type = TextFieldType.INPUT;
                this.editVictoryBtn.visible = true;
                this.editV.visible = false;
            }
            return;
        }// end function

        private function onSuitClick(event:MouseEvent) : void
        {
            if (ModelLocator.getInstance().uId != ModelLocator.getInstance().currentUId)
            {
                return;
            }
            SuitSelectPane.getInstance().show(true);
            SMZTController.getInstance().getSuitData(this.onSuitLoad);
            return;
        }// end function

        private function onSuitLoad(param1:XML) : void
        {
            SuitSelectPane.getInstance().setAllData(ServerDataTranslator.translateSuitData(param1));
            return;
        }// end function*/

		//饰品点击
        private function onJewelryClick(event:MouseEvent) : void
        {
            if (ModelLocator.getInstance().uId != ModelLocator.getInstance().currentUId)
            {
                return;
            }
            var _loc_2:int = -1;
            var _loc_3:int = 0;
            switch(event.currentTarget)
            {
                case this.ehmc1:
                {
                    _loc_2 = 2;
                    _loc_3 = 3;
                    break;
                }
                case this.ehmc2:
                {
                    _loc_2 = 2;
                    _loc_3 = 4;
                    break;
                }
                case this.xlmc:
                {
                    _loc_2 = 5;
                    _loc_3 = 1;
                    break;
                }
                case this.ypmc:
                {
                    _loc_2 = 4;
                    _loc_3 = 2;
                    break;
                }
                case this.hwmc1:
                {
                    _loc_3 = 5;
                    _loc_2 = 3;
                    break;
                }
                case this.hwmc2:
                {
                    _loc_3 = 6;
                    _loc_2 = 3;
                    break;
                }
                case this.jzmc1:
                {
                    _loc_3 = 7;
                    _loc_2 = 1;
                    break;
                }
                case this.jzmc2:
                {
                    _loc_3 = 8;
                    _loc_2 = 1;
                    break;
                }
                default:
                {
                    break;
                }
            }
			//显示饰品面板
            JewelrySelectPane.getInstance().show(true);
            JewelrySelectPane.getInstance().type = _loc_2;
            JewelrySelectPane.getInstance().toEquipIndex = _loc_3;
			//从服务器获取饰品信息
            //SMZTController.getInstance().getJewelryData(_loc_2, this.onLoad);
            return;
        }// end function

        /*private function onLoad(param1:XML) : void
        {
			//设置饰品面板数据
            JewelrySelectPane.getInstance().setAllData(ServerDataTranslator.translateJewelryData(param1));
            return;
        }// end function*/

       /* private function vistFriend(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (ApplicationConfig.mainConfig.snsUserPage.@method == "JS")
            {
                if (ModelLocator.getInstance().isQQRelated())
                {
                    _loc_2 = new Object();
                    _loc_2.openid = PlayerData.getInstance().snsAcc;
                    ExternalInterface.call(ApplicationConfig.mainConfig.snsUserPage, JSON.encode(_loc_2));
                }
                else
                {
                    ExternalInterface.call(ApplicationConfig.mainConfig.snsUserPage, PlayerData.getInstance().snsAcc);
                }
            }
            else
            {
                navigateToURL(new URLRequest(String(ApplicationConfig.mainConfig.snsUserPage).replace("{acc}", PlayerData.getInstance().snsAcc)), ApplicationConfig.mainConfig.snsUserPage.@target);
            }
            return;
        }// end function*/

        override public function showHelp(event:MouseEvent = null) : void
        {
            /*HelpPane.getInstance().playInstance("NEWBIE_SHOW_PLAYER_ATTR_HELP");
            if (HelpPane.getInstance().isOpened)
            {
                (getChild("helpb") as MovieClip).gotoAndPlay(2);
            }
            else
            {
                (getChild("helpb") as MovieClip).gotoAndStop(1);
            }
            return;*/
        }// end function

        /*private function showLockTip(event:MouseEvent) : void
        {
            this.tt.show(this.lockSign, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.EquipTwoOfficerTip.@Text + "</font>");
            return;
        }// end function

        private function shoRemainT(event:MouseEvent) : void
        {
            this.tt.show(this.remainMc, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.AddPoint2.@Text + "</font>");
            return;
        }// end function

        private function onAttrOver(event:MouseEvent) : void
        {
            switch(event.currentTarget)
            {
                case this.strPlusBtn:
                {
                    this.tt.show(this.strPlusBtn, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.StrengthAttrTip.@Text + "</font>");
                    break;
                }
                case this.dexPlusBtn:
                {
                    this.tt.show(this.dexPlusBtn, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.AgilityAttrTip.@Text + "</font>");
                    break;
                }
                case this.spdPlusBtn:
                {
                    this.tt.show(this.spdPlusBtn, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.SpeedAttrTip.@Text + "</font>");
                    break;
                }
                case this.strMinusBtn:
                {
                    this.tt.show(this.strMinusBtn, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.StrengthAttrTip.@Text + "</font>");
                    break;
                }
                case this.dexMinusBtn:
                {
                    this.tt.show(this.dexMinusBtn, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.AgilityAttrTip.@Text + "</font>");
                    break;
                }
                case this.spdMinusBtn:
                {
                    this.tt.show(this.spdMinusBtn, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.SpeedAttrTip.@Text + "</font>");
                    break;
                }
                case this.strengthBar:
                {
                    this.tt.show(this.strengthBar, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.StrengthAttrTip.@Text + "</font>");
                    break;
                }
                case this.agilityBar:
                {
                    this.tt.show(this.agilityBar, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.AgilityAttrTip.@Text + "</font>");
                    break;
                }
                case this.speedBar:
                {
                    this.tt.show(this.speedBar, "", "<font color = \'#FFFFFF\'>" + LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.SpeedAttrTip.@Text + "</font>");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function cellClick(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as BagIcoBox;
            if (_loc_2 == this.officerCellBox || _loc_2 == this.officerCellBox1)
            {
                if (PlayerData.getInstance().officerBuildingLv > -1)
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_OFFICER_SCENE);
                    hide();
                }
            }
            else if (PlayerData.getInstance().weaponBuildingLv > -1)
            {
                SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_WEAPON_SCENE);
                hide();
            }
            return;
        }// end function

        private function glassClick(event:MouseEvent) : void
        {
            if (event.currentTarget.name == "pp0" || event.currentTarget.name == "pp4")
            {
                if (PlayerData.getInstance().officerBuildingLv > -1)
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_OFFICER_SCENE);
                    hide();
                }
            }
            else if (PlayerData.getInstance().weaponBuildingLv > -1)
            {
                SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_WEAPON_SCENE);
                hide();
            }
            return;
        }// end function

        private function onKeyDown(event:KeyboardEvent) : void
        {
            if (ModelLocator.getInstance().uId != ModelLocator.getInstance().currentUId)
            {
                return;
            }
            if (event.keyCode == 13 && (event.currentTarget as TextField).type == TextFieldType.INPUT)
            {
                if (event.currentTarget == this.sgText)
                {
                    this.sgText.type = TextFieldType.DYNAMIC;
                    this.editSignBtn.visible = false;
                    this.editS.visible = true;
                    UserActionController.getInstance().modifyPS(this.sgText.text, this.onSetSgBack);
                }
                else
                {
                    this.vgText.type = TextFieldType.DYNAMIC;
                    this.editVictoryBtn.visible = false;
                    this.editV.visible = true;
                    UserActionController.getInstance().setVictoryPS(this.vgText.text, this.onSetVgBack);
                }
            }
            return;
        }// end function

        private function setSign(event:MouseEvent) : void
        {
            if (ModelLocator.getInstance().uId != ModelLocator.getInstance().currentUId)
            {
                return;
            }
            if (event.currentTarget == this.editSignBtn)
            {
                this.sgText.type = TextFieldType.DYNAMIC;
                this.editSignBtn.visible = false;
                this.editS.visible = true;
                UserActionController.getInstance().modifyPS(this.sgText.text, this.onSetSgBack);
            }
            else
            {
                this.sgText.type = TextFieldType.INPUT;
                this.editSignBtn.visible = true;
                this.editS.visible = false;
                this.stage.focus = this.sgText;
                this.sgText.setSelection(0, this.sgText.text.length);
            }
            return;
        }// end function

        private function onSetSgBack(param1:XML) : void
        {
            this.sgText.text = param1.UserDynamic.PersonalSignature;
            return;
        }// end function

        private function setVictory(event:MouseEvent) : void
        {
            if (ModelLocator.getInstance().uId != ModelLocator.getInstance().uId)
            {
                return;
            }
            if (event.currentTarget == this.editVictoryBtn)
            {
                this.vgText.type = TextFieldType.DYNAMIC;
                this.editVictoryBtn.visible = false;
                this.editV.visible = true;
                UserActionController.getInstance().setVictoryPS(this.vgText.text, this.onSetVgBack);
            }
            else
            {
                this.vgText.type = TextFieldType.INPUT;
                this.editVictoryBtn.visible = true;
                this.editV.visible = false;
                this.stage.focus = this.vgText;
                this.vgText.setSelection(0, this.vgText.text.length);
            }
            return;
        }// end function

        private function onSetVgBack(param1:XML) : void
        {
            this.vgText.text = param1.UserDynamic.VictoryDeclare;
            return;
        }// end function

        private function attrUp(event:MouseEvent) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onAttrTimer);
            this.timer.stop();
            this.timer.reset();
            return;
        }// end function

        private function attrDown(event:MouseEvent) : void
        {
            var evente:* = event;
            this.attrBtnTarget = evente.currentTarget as MovieClipButton;
            if (evente.type == MouseEvent.MOUSE_DOWN)
            {
                var onTimer:* = function (event:TimerEvent) : void
            {
                addEventListener(Event.ENTER_FRAME, onAttrTimer);
                return;
            }// end function
            ;
                this.timer.addEventListener(TimerEvent.TIMER, onTimer);
                this.timer.start();
            }
            return;
        }// end function

        private function onAttrTimer(event:Event) : void
        {
            if (this.attrBtnTarget != null)
            {
                switch(this.attrBtnTarget)
                {
                    case this.strPlusBtn:
                    {
                        this.plusStrength();
                        break;
                    }
                    case this.dexPlusBtn:
                    {
                        this.plusDex();
                        break;
                    }
                    case this.spdPlusBtn:
                    {
                        this.plusSpeed();
                        break;
                    }
                    case this.strMinusBtn:
                    {
                        this.minusStrength();
                        break;
                    }
                    case this.dexMinusBtn:
                    {
                        this.minusDex();
                        break;
                    }
                    case this.spdMinusBtn:
                    {
                        this.minusSpeed();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this.setBarStatus();
                this.checkColumnDisplayStatus();
            }
            return;
        }// end function

        private function attrClick(event:MouseEvent) : void
        {
            switch(event.currentTarget)
            {
                case this.strPlusBtn:
                {
                    this.plusStrength();
                    break;
                }
                case this.dexPlusBtn:
                {
                    this.plusDex();
                    break;
                }
                case this.spdPlusBtn:
                {
                    this.plusSpeed();
                    break;
                }
                case this.strMinusBtn:
                {
                    this.minusStrength();
                    break;
                }
                case this.dexMinusBtn:
                {
                    this.minusDex();
                    break;
                }
                case this.spdMinusBtn:
                {
                    this.minusSpeed();
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.setBarStatus();
            this.checkColumnDisplayStatus();
            return;
        }// end function

        private function plusStrength() : void
        {
            if (this.remainPoint > 0)
            {
                var _loc_1:* = this.playerData;
                var _loc_2:* = this.playerData.strength + 1;
                _loc_1.strength = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.strengthPlus + 1;
                _loc_1.strengthPlus = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.remainPoint - 1;
                _loc_1.remainPoint = _loc_2;
                this.confirmBtn.show = true;
                this.refreshBtn.show = false;
            }
            return;
        }// end function

        private function plusDex() : void
        {
            if (this.remainPoint > 0)
            {
                var _loc_1:* = this.playerData;
                var _loc_2:* = this.playerData.agility + 1;
                _loc_1.agility = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.agilityPlus + 1;
                _loc_1.agilityPlus = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.remainPoint - 1;
                _loc_1.remainPoint = _loc_2;
                this.confirmBtn.show = true;
                this.refreshBtn.show = false;
            }
            return;
        }// end function

        private function plusSpeed() : void
        {
            if (this.remainPoint > 0)
            {
                var _loc_1:* = this.playerData;
                var _loc_2:* = this.playerData.speed + 1;
                _loc_1.speed = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.speedPlus + 1;
                _loc_1.speedPlus = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.remainPoint - 1;
                _loc_1.remainPoint = _loc_2;
                this.confirmBtn.show = true;
                this.refreshBtn.show = false;
            }
            return;
        }// end function

        private function minusStrength() : void
        {
            if (this.strengthPlus > 0)
            {
                var _loc_1:* = this.playerData;
                var _loc_2:* = this.playerData.strength - 1;
                _loc_1.strength = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.strengthPlus - 1;
                _loc_1.strengthPlus = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.remainPoint + 1;
                _loc_1.remainPoint = _loc_2;
                this.confirmBtn.show = true;
                this.refreshBtn.show = false;
            }
            return;
        }// end function

        private function minusDex() : void
        {
            if (this.agilityPlus > 0)
            {
                var _loc_1:* = this.playerData;
                var _loc_2:* = this.playerData.agility - 1;
                _loc_1.agility = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.agilityPlus - 1;
                _loc_1.agilityPlus = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.remainPoint + 1;
                _loc_1.remainPoint = _loc_2;
                this.confirmBtn.show = true;
                this.refreshBtn.show = false;
            }
            return;
        }// end function

        private function minusSpeed() : void
        {
            if (this.speedPlus > 0)
            {
                var _loc_1:* = this.playerData;
                var _loc_2:* = this.playerData.speed - 1;
                _loc_1.speed = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.speedPlus - 1;
                _loc_1.speedPlus = _loc_2;
                var _loc_1:String = this;
                var _loc_2:* = this.remainPoint + 1;
                _loc_1.remainPoint = _loc_2;
                this.confirmBtn.show = true;
                this.refreshBtn.show = false;
            }
            return;
        }// end function

        private function onConfirmClick(event:MouseEvent) : void
        {
            this.confirmBtn.show = false;
            UserActionController.getInstance().addAttrPoint(this.playerData.strength, this.playerData.agility, this.playerData.speed, this.remainPoint, this.onAddPointBack);
            return;
        }// end function

        private function onAddPointBack(param1:XML) : void
        {
            return;
        }// end function

        private function onRefreshElClick(event:MouseEvent) : void
        {
            ModifyElementPane.getInstance().show(true);
            return;
        }// end function

        private function onRefreshClick(event:MouseEvent) : void
        {
            SMZTController.getInstance().checkHasItem(PropConfig.REFRESH_POINT_ITEM, this.onCheckBack);
            return;
        }// end function

        private function callBack(event:MouseEvent) : void
        {
            if (event.target.label == "确定")
            {
            }
            return;
        }// end function

        private function onCheckBack(param1:XML) : void
        {
            var _loc_2:ItemModel = null;
            var _loc_3:ItemModel = null;
            if (param1.hasOwnProperty("UserPackage"))
            {
                _loc_2 = ItemBuilder.createItem(ItemCategory.ITEM, param1.UserPackage.@ItemId, 0, param1.UserPackage.@ItemId);
                _loc_2.itemId = param1.UserPackage.@ItemId;
                _loc_2.sId = param1.UserPackage.@Id;
                QuickPurchasePane.getInstance().mode = 1;
                QuickPurchasePane.getInstance().itemModel = _loc_2;
                QuickPurchasePane.getInstance().show(true);
            }
            else
            {
                _loc_3 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
                _loc_3.itemId = param1.Offer.@PropId;
                _loc_3.sId = param1.Offer.@Id;
                _loc_3.shopPrice = param1.Offer.@Silver;
                _loc_3.shopPriceRMB = param1.Offer.@Gold;
                if (param1.Offer.@VipSale > 0)
                {
                    _loc_3.shopDiscountRMB = param1.Offer.@VipSale;
                }
                QuickPurchasePane.getInstance().mode = 0;
                QuickPurchasePane.getInstance().itemModel = _loc_3;
                QuickPurchasePane.getInstance().show(true);
            }
            return;
        }// end function

        private function checkAddPointStatus() : void
        {
            if (this.playerData.attrPoint > 0)
            {
                this.strPlusBtn.show = true;
                this.dexPlusBtn.show = true;
                this.spdPlusBtn.show = true;
                this.strMinusBtn.show = true;
                this.dexMinusBtn.show = true;
                this.spdMinusBtn.show = true;
                this.confirmBtn.show = false;
                this.refreshBtn.show = true;
                this.remainMc.visible = true;
                this.pointText.visible = true;
            }
            else
            {
                this.strPlusBtn.show = false;
                this.dexPlusBtn.show = false;
                this.spdPlusBtn.show = false;
                this.strMinusBtn.show = false;
                this.dexMinusBtn.show = false;
                this.spdMinusBtn.show = false;
                this.confirmBtn.show = false;
                this.refreshBtn.show = true;
                this.remainMc.visible = true;
                this.pointText.visible = true;
            }
            if (this.playerData.agility + this.playerData.strength + this.playerData.speed < 10)
            {
                this.confirmBtn.show = false;
                this.refreshBtn.show = false;
            }
            else
            {
                this.confirmBtn.show = false;
                this.refreshBtn.show = true;
            }
            return;
        }// end function

        private function checkColumnDisplayStatus() : void
        {
            if (this.strengthPlus > 0)
            {
                this.strengthBar.showText();
            }
            else
            {
                this.strengthBar.showCollumn();
            }
            if (this.agilityPlus > 0)
            {
                this.agilityBar.showText();
            }
            else
            {
                this.agilityBar.showCollumn();
            }
            if (this.speedPlus > 0)
            {
                this.speedBar.showText();
            }
            else
            {
                this.speedBar.showCollumn();
            }
            return;
        }// end function

        private function updateUI() : void
        {
            this.checkAddPointStatus();
            this.setBarStatus();
            this.checkColumnDisplayStatus();
            this.checkHomeStatus();
            return;
        }// end function

        private function checkHomeStatus() : void
        {
            if (ModelLocator.getInstance().currentUId == ModelLocator.getInstance().uId)
            {
                this.visitBtn.visible = false;
                this.modifyElBtn.visible = true;
                this.editS.visible = true;
                this.editSignBtn.visible = false;
                this.editV.visible = true;
                this.editVictoryBtn.visible = false;
                this.refreshBtn.show = true;
                this.unknownMc.visible = false;
            }
            else
            {
                this.unknownMc.visible = true;
                if (!ModelLocator.getInstance().isQQRelated() && ModelLocator.getInstance().snsType != ModelLocator.SNS_MIXI && ModelLocator.getInstance().snsType != ModelLocator.SNS_HE_KR)
                {
                    this.visitBtn.visible = true;
                }
                this.modifyElBtn.visible = false;
                this.editS.visible = false;
                this.editSignBtn.visible = false;
                this.editV.visible = false;
                this.editVictoryBtn.visible = false;
                this.refreshBtn.show = false;
                this.remainMc.visible = false;
                this.pointText.text = "";
                this.strPlusBtn.show = false;
                this.dexPlusBtn.show = false;
                this.spdPlusBtn.show = false;
                this.strMinusBtn.show = false;
                this.dexMinusBtn.show = false;
                this.spdMinusBtn.show = false;
                this.confirmBtn.show = false;
                this.elMc.gotoAndStop(6);
            }
            return;
        }// end function

        private function setBarStatus() : void
        {
            this.strengthBar.setCaoNiMaFuck(this.playerData.strength);
            this.agilityBar.setCaoNiMaFuck(this.playerData.agility);
            this.speedBar.setCaoNiMaFuck(this.playerData.speed);
            this.strengthBar.setValue(this.playerData.strength + this.playerData.strengthPlus);
            this.strengthBar.setPlus(this.playerData.strengthPlus);
            this.agilityBar.setValue(this.playerData.agility + this.playerData.agilityPlus);
            this.agilityBar.setPlus(this.playerData.agilityPlus);
            this.speedBar.setValue(this.playerData.speed + this.playerData.speedPlus);
            this.speedBar.setPlus(this.playerData.speedPlus);
            this.pointText.text = this.remainPoint.toString();
            return;
        }// end function

        private function clearJewelryAvatar() : void
        {
            this.ehmc1.item = null;
            this.ehmc2.item = null;
            this.xlmc.item = null;
            this.ypmc.item = null;
            this.hwmc1.item = null;
            this.hwmc2.item = null;
            this.jzmc1.item = null;
            this.jzmc2.item = null;
            return;
        }// end function

        private function showName(event:MouseEvent) : void
        {
            if (this.playerData)
            {
                ToolTip.getInstance().show(event.currentTarget as DisplayObject, "", "<font color=\'#ffffff\'>" + this.playerData.nick + "</font>");
            }
            return;
        }// end function*/

        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            /*var _loc_2:JewelryItem = null;
            //trace("PlayerData Changed");
            this.tzmc.item = null;
            if (this.playerData.suitItem)
            {
                this.tzmc.item = this.playerData.suitItem;
            }
            this.clearJewelryAvatar();
            for each (_loc_2 in this.playerData.jewelryVector)
            {
                
                switch(_loc_2.attrPaneIndex)
                {
                    case 3:
                    {
                        this.ehmc1.item = _loc_2;
                        break;
                    }
                    case 4:
                    {
                        this.ehmc2.item = _loc_2;
                        break;
                    }
                    case 1:
                    {
                        this.xlmc.item = _loc_2;
                        break;
                    }
                    case 2:
                    {
                        this.ypmc.item = _loc_2;
                        break;
                    }
                    case 5:
                    {
                        this.hwmc1.item = _loc_2;
                        break;
                    }
                    case 6:
                    {
                        this.hwmc2.item = _loc_2;
                        break;
                    }
                    case 7:
                    {
                        this.jzmc1.item = _loc_2;
                        break;
                    }
                    case 8:
                    {
                        this.jzmc2.item = _loc_2;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            this.lockSign.visible = int(this.playerData.playerLevel) < 10;
            this.strengthPlus = 0;
            this.agilityPlus = 0;
            this.speedPlus = 0;
            this.lvText.text = String(LocalConfig.LOCAL_LAN.PlayerAttrInfoPane.Job.@Text).replace("{level}", this.playerData.playerLevel);
            this.nickText.text = this.playerData.nick;
            this.ocText.text = this.playerData.occupation;
            this.elText.text = this.playerData.elementStr;
            this.elMc.gotoAndStop((this.playerData.element + 1));
            this.sgText.text = this.playerData.sign;
            this.vgText.text = this.playerData.winSign;
            this.hText.text = this.playerData.health.toString();
            this.pointText.text = this.playerData.attrPoint.toString();
            this.remainPoint = this.playerData.attrPoint;
            if (this.remainPoint > 0)
            {
                this.remainMc.gotoAndPlay(2);
                this.remainMc.addEventListener(MouseEvent.MOUSE_OVER, this.shoRemainT);
            }
            else
            {
                this.remainMc.gotoAndStop(1);
                this.remainMc.removeEventListener(MouseEvent.MOUSE_OVER, this.shoRemainT);
            }
            this.strengthBar.setValue(this.playerData.strength);
            this.strengthBar.setPlus(this.playerData.strengthPlus);
            this.agilityBar.setValue(this.playerData.agility);
            this.agilityBar.setPlus(this.playerData.agilityPlus);
            this.speedBar.setValue(this.playerData.speed);
            this.speedBar.setPlus(this.playerData.speedPlus);
            (getChild("sv") as MovieClip).visible = this.playerData.sinaVip > 0 && ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA;
            if (this.playerData.sinaVip > 0)
            {
                (getChild("sv") as MovieClip).gotoAndStop(this.playerData.sinaVip);
            }
            while ((getChild("av") as MovieClip).numChildren > 0)
            {
                
                (getChild("av") as MovieClip).removeChildAt(0);
            }
            var _loc_3:* = new Loader();
            var _loc_4:* = this.playerData.occ;
            if (this.playerData.suitItem)
            {
                _loc_4 = this.playerData.suitItem.itemId;
            }
            _loc_3.load(new URLRequest(ModelLocator.getInstance().staticURL + ApplicationConfig.mainConfig.imgSrc + "characters/" + "Job_" + _loc_4 + ".swf"));
            _loc_3.scaleX = 1.3;
            _loc_3.scaleY = 1.3;
            (getChild("av") as MovieClip).addChild(_loc_3);
            this.avatarIco.ico = this.playerData.avatar;
            this.emc1.gotoAndStop(1);
            this.emc2.gotoAndStop(1);
            this.emc3.gotoAndStop(1);
            this.olevelText1.text = "";
            this.olevelText2.text = "";
            this.wlevelText1.text = "";
            this.wlevelText2.text = "";
            this.wlevelText3.text = "";
            if (this.playerData.weaponArray.length > 0)
            {
                this.wp1.item = this.playerData.weaponArray[0];
                this.emc1.gotoAndStop(((this.wp1.item as EquipItem).quality + 1));
                if (this.wp1.item.level > 0)
                {
                    this.wlevelText1.text = "+" + this.wp1.item.level.toString();
                }
            }
            else
            {
                this.wp1.item = null;
            }
            if (this.playerData.weaponArray.length > 1)
            {
                this.wp2.item = this.playerData.weaponArray[1];
                this.emc2.gotoAndStop(((this.wp2.item as EquipItem).quality + 1));
                if (this.wp2.item.level > 0)
                {
                    this.wlevelText2.text = "+" + this.wp2.item.level.toString();
                }
            }
            else
            {
                this.wp2.item = null;
            }
            if (this.playerData.weaponArray.length > 2)
            {
                this.wp3.item = this.playerData.weaponArray[2];
                this.emc3.gotoAndStop(((this.wp3.item as EquipItem).quality + 1));
                if (this.wp3.item.level > 0)
                {
                    this.wlevelText3.text = "+" + this.wp3.item.level.toString();
                }
            }
            else
            {
                this.wp3.item = null;
            }
            this.officerCellBox.item = null;
            this.officerCellBox1.item = null;
            if (this.playerData.officerArray.length > 0)
            {
                this.officerCellBox.item = this.playerData.officerArray[0];
                if (this.officerCellBox.item.level > 0)
                {
                    this.olevelText1.text = "+" + this.officerCellBox.item.level.toString();
                }
                if (this.playerData.officerArray.length > 1)
                {
                    this.officerCellBox1.item = this.playerData.officerArray[1];
                    if (this.officerCellBox1.item.level > 0)
                    {
                        this.olevelText2.text = "+" + this.officerCellBox1.item.level.toString();
                    }
                }
            }
            else
            {
                this.officerCellBox.item = null;
                this.officerCellBox1.item = null;
            }
            (getChild("helpb") as MovieClip).visible = ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId;
            this.updateUI();
            return;*/
        }// end function

        public function get mode() : int
        {
            return this._mode;
        }// end function

        public function set mode(param1:int) : void
        {
            this._mode = param1;
            if (this._mode == 1)
            {
            }
            return;
        }// end function

        override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else
            {
                /*if (NewbiePane.getInstance().isOpened)
                {
                    NewbiePane.getInstance().hide();
                }
                if (PlayerData.getInstance().currentNewbieQuest.taskName == "StatusPoint")
                {
                    SMZTController.getInstance().submitNewbieTask(PlayerData.getInstance().currentNewbieQuest.questId);
                }*/
                if (rootContainer)
                {
                    if (param1)
                    {
                        drawModalRect();
                    }
                    rootContainer.addChild(this);
                    this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                    this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
                    if (showEffect)
                    {
                        this.alpha = 0.5;
                        TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                    }
                    isOpened = true;
                    isPopUP = true;
                    this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                }
            }
            playShowSound();
            return;
        }// end function

        public static function getInstance() : PlayerAttrInfoPane
        {
            if (playerAttrInfoPane == null)
            {
                playerAttrInfoPane = new PlayerAttrInfoPane;
            }
            return playerAttrInfoPane;
        }// end function

    }
}
