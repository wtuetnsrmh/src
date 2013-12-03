package project.view.module.enhance
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.events.*;
    import project.model.*;
    import project.model.data.*;
    
    import project.model.item.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.controls.*;
    import project.view.module.alert.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    import flashx.textLayout.formats.*;

    public class StoneBagPane extends BaseTitleWindow
    {
        private var _tab:int = -1;
        private var _isSynthing:Boolean = false;
        private var _stoneVector:Vector.<ItemModel>;
        private var _stoneI:Vector.<ItemModel>;
        private var _stoneII:Vector.<ItemModel>;
        private var _stoneIII:Vector.<ItemModel>;
        private var _stoneIV:Vector.<ItemModel>;
        private var _stoneV:Vector.<ItemModel>;
        private var _scrollVector:Vector.<ItemModel>;
        private var togo:Vector.<ItemModel>;
        private var _boxVector:Vector.<BaseSpritePane>;
        private var _mode:int = 0;
        public var sysBtn:MovieClipButton;
        public var mosaicBtn:MovieClipButton;
        private var _weapon:EquipItem;
        public var mosaicPane:MovieClip;
        public var sythesisPane:MovieClip;
        public var sythNum:int = 0;
        public var putBtn:MovieClipButton;
        private var currentSelectBagIndex:int = -1;
        private var currentSelectSynIndex:int = -1;
        private var currentSelectMosaicIndex:int = -1;
        private var togoStoneModel:ItemModel;
        private var _currentSynthModel:ItemModel;
        public var hTimer:Timer;
        public var remianSec:int = 0;
        public var synFailedBtn:MovieClipButton;
        public var synSuccessBtn:MovieClipButton;
        public var doneImediateBtn:MovieClipButton;
        public var doneImediateBtnQ:MovieClipButton;
        public var digBtn:MovieClipButton;
        public var discardBtn:MovieClipButton;
        private static var eb:StoneBagPane;

        public function StoneBagPane(param1:Boolean = true)
        {
            this._stoneVector = new Vector.<ItemModel>;
            this._stoneI = new Vector.<ItemModel>;
            this._stoneII = new Vector.<ItemModel>;
            this._stoneIII = new Vector.<ItemModel>;
            this._stoneIV = new Vector.<ItemModel>;
            this._stoneV = new Vector.<ItemModel>;
            this._scrollVector = new Vector.<ItemModel>;
            this.togo = new Vector.<ItemModel>;
            this._boxVector = new Vector.<BaseSpritePane>;
            this.hTimer = new Timer(1000);
            super(param1);
            if (eb)
            {
                throw new Error("Error");
            }
            setSpriteInstance("StoneBagPane");
            this.configureUIInstance();
            this.drawBox();
            (getChild("hecheng") as MovieClipButton).onClick = this.hechengClick;
            (getChild("xiangqian") as MovieClipButton).onClick = this.xiangqianClick;
            this.mode = 1;
            this.hTimer.addEventListener(TimerEvent.TIMER, this.onTimer);
            WeaponData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onWeaponData);
            return;
        }// end function

        protected function onTimer(event:TimerEvent) : void
        {
            var t:Timer;
            var a:Array;
            var i:int;
            var event:* = event;
            if (this.remianSec > 0)
            {
                var _loc_3:String = this;
                var _loc_4:* = this.remianSec - 1;
                _loc_3.remianSec = _loc_4;
                var _loc_3:* = LocalConfig.LOCAL_LAN.SynthesisPane.SynProgress.@Text + formatSecondToDateHour(this.remianSec);
                StoneBagPane.getInstance().sythesisPane.timet.text = LocalConfig.LOCAL_LAN.SynthesisPane.SynProgress.@Text + formatSecondToDateHour(this.remianSec);
                (getChild("sp") as MovieClip)["timet"].text = _loc_3;
            }
            else
            {
                var gogo:* = function (event:TimerEvent) : void
            {
                sythesisPane["g0"].visible = true;
                t.stop();
                return;
            }// end function
            ;
                t = new Timer(2600);
                t.addEventListener(TimerEvent.TIMER, gogo);
                t.start();
                this.sythesisPane["g0"].visible = false;
                a;
                i;
                while (i < 5)
                {
                    
                    if (this.sythesisPane["s" + i.toString()].numChildren > 0)
                    {
                        a[i] = 1;
                    }
                    i = (i + 1);
                }
                this.sythesisPane.fuckmc.arr = a;
                this.sythesisPane.fuckmc.gotoAndPlay(2);
                this.hTimer.stop();
                MosaicController.getInstance().refreshSynthOnly();
            }
            return;
        }// end function

        public function setData(param1:Vector.<ItemModel>) : void
        {
            var _loc_2:ItemModel = null;
            this._stoneVector = param1;
            this._stoneI.length = 0;
            this._stoneII.length = 0;
            this._stoneIII.length = 0;
            this._stoneIV.length = 0;
            this._stoneV.length = 0;
            this._scrollVector.length = 0;
            for each (_loc_2 in this._stoneVector)
            {
                
                if (_loc_2.itemId < 1000)
                {
                    this._scrollVector.push(_loc_2);
                    continue;
                }
                if (_loc_2.level == 1)
                {
                    this._stoneI.push(_loc_2);
                    continue;
                }
                if (_loc_2.level == 2)
                {
                    this._stoneII.push(_loc_2);
                    continue;
                }
                if (_loc_2.level == 3)
                {
                    this._stoneIII.push(_loc_2);
                    continue;
                }
                if (_loc_2.level == 4)
                {
                    this._stoneIV.push(_loc_2);
                    continue;
                }
                if (_loc_2.level == 5)
                {
                    this._stoneV.push(_loc_2);
                }
            }
            this.tab = this.tab;
            return;
        }// end function

        public function clearStatus() : void
        {
            this.resetSynthStatus();
            this.resetMosaicStatus();
            return;
        }// end function

        private function xiangqianClick(event:MouseEvent) : void
        {
            MosaicController.getInstance().showMosaic();
            this.clearStatus();
            return;
        }// end function

        private function hechengClick(event:MouseEvent) : void
        {
            MosaicController.getInstance().showSynthesis();
            this.clearStatus();
            return;
        }// end function

        private function drawBox() : void
        {
            var _loc_3:BaseSpritePane = null;
            var _loc_4:MovieClip = null;
            var _loc_1:* = getChild("av");
            _loc_1.verticalGap = 3;
            _loc_1.horizontalGap = 3;
            _loc_1.horizontalAlign = "center";
            _loc_1.verticalAlign = "middle";
            var _loc_5:int = 45;
            _loc_1.tileWidth = 45;
            _loc_1.tileHeight = _loc_5;
            var _loc_2:int = 0;
            while (_loc_2 < 25)
            {
                
                _loc_3 = new BaseSpritePane();
                _loc_3.setSpriteInstance("stoneicobg");
                _loc_3.spriteInstance["sele"].visible = false;
                _loc_4 = new MovieClip();
                _loc_4.name = "av";
                _loc_3.spriteInstance.addChild(_loc_4);
                _loc_1.addChild(_loc_3);
                this._boxVector.push(_loc_3);
                _loc_3.name = "s" + _loc_2.toString();
                _loc_2++;
            }
            return;
        }// end function

        private function configureUIInstance() : void
        {
            (getChild("tab0") as MovieClip).buttonMode = true;
            (getChild("tab1") as MovieClip).buttonMode = true;
            (getChild("tab2") as MovieClip).buttonMode = true;
            (getChild("tab3") as MovieClip).buttonMode = true;
            (getChild("tab4") as MovieClip).buttonMode = true;
            (getChild("tab5") as MovieClip).buttonMode = true;
            (getChild("tab0") as MovieClip).addEventListener(MouseEvent.CLICK, this.tabClick);
            (getChild("tab1") as MovieClip).addEventListener(MouseEvent.CLICK, this.tabClick);
            (getChild("tab2") as MovieClip).addEventListener(MouseEvent.CLICK, this.tabClick);
            (getChild("tab3") as MovieClip).addEventListener(MouseEvent.CLICK, this.tabClick);
            (getChild("tab4") as MovieClip).addEventListener(MouseEvent.CLICK, this.tabClick);
            (getChild("tab5") as MovieClip).addEventListener(MouseEvent.CLICK, this.tabClick);
            (getChild("tab0") as MovieClip)["txt"].mouseEnabled = false;
            (getChild("tab1") as MovieClip)["txt"].mouseEnabled = false;
            (getChild("tab2") as MovieClip)["txt"].mouseEnabled = false;
            (getChild("tab3") as MovieClip)["txt"].mouseEnabled = false;
            (getChild("tab4") as MovieClip)["txt"].mouseEnabled = false;
            (getChild("tab5") as MovieClip)["txt"].mouseEnabled = false;
            (getChild("tab0") as MovieClip)["txt"].text = "Lv1";
            (getChild("tab1") as MovieClip)["txt"].text = "Lv2";
            (getChild("tab2") as MovieClip)["txt"].text = "Lv3";
            (getChild("tab3") as MovieClip)["txt"].text = "Lv4";
            (getChild("tab4") as MovieClip)["txt"].text = "Lv5";
            (getChild("tab5") as MovieClip)["txt"].text = LocalConfig.LOCAL_LAN.Characters.Other.@Text;
            this.putBtn = getChild("fangru") as MovieClipButton;
            this.putBtn.onClick = this.putIntoSyn;
            this.putBtn.active = false;
            this.sythesisPane = getChild("sp") as MovieClip;
            this.sysBtn = (getChild("sp") as MovieClip)["synb"] as MovieClipButton;
            this.sysBtn.onClick = this.synClick;
            this.synFailedBtn = (getChild("sp") as MovieClip)["jixu"] as MovieClipButton;
            this.synSuccessBtn = (getChild("sp") as MovieClip)["succ"] as MovieClipButton;
            this.doneImediateBtn = (getChild("sp") as MovieClip)["donein"] as MovieClipButton;
            this.doneImediateBtnQ = (getChild("sp") as MovieClip)["doneinq"] as MovieClipButton;
            this.synFailedBtn.onClick = this.submitSynf;
            this.synSuccessBtn.onClick = this.submitSyn;
            this.doneImediateBtn.onClick = this.doneGo;
            this.doneImediateBtnQ.onClick = this.doneGo;
            this.resetSynthStatus();
            this.mosaicPane = getChild("mp") as MovieClip;
            this.mosaicBtn = this.mosaicPane["mocb"] as MovieClipButton;
            this.mosaicBtn.onClick = this.mosaicClick;
            this.digBtn = this.mosaicPane.digb;
            this.discardBtn = this.mosaicPane.disb;
            this.digBtn.onClick = this.digHole;
            this.discardBtn.onClick = this.unMosaic;
            this.resetMosaicStatus();
            this.tab = 0;
            return;
        }// end function

        private function unMosaic(event:MouseEvent) : void
        {
            DigStonePane.getInstance().weapon = this._weapon;
            DigStonePane.getInstance().index = this.currentSelectMosaicIndex;
            DigStonePane.getInstance().show(true);
            return;
        }// end function

        private function digHole(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            trace(this._weapon.name);
            if (this._weapon)
            {
                _loc_2 = 610 + this._weapon.mosaicNum + 1;
                SMZTController.getInstance().checkHasItem(_loc_2, this.onCheckBack);
            }
            return;
        }// end function

        private function onCheckBack(param1:XML) : void
        {
            var _loc_2:ItemModel = null;
            var _loc_3:ItemModel = null;
            var _loc_4:int = 0;
            var _loc_5:ItemModel = null;
            if (param1.hasOwnProperty("UserPackage"))
            {
                _loc_2 = ItemBuilder.createItem(ItemCategory.ITEM, param1.UserPackage.@ItemId, 0, param1.UserPackage.@ItemId);
                _loc_2.itemId = param1.UserPackage.@ItemId;
                _loc_2.sId = param1.UserPackage.@Id;
                QuickPurchasePane.getInstance().mode = 1;
                QuickPurchasePane.getInstance().itemModel = _loc_2;
                QuickPurchasePane.getInstance().targetId = this._weapon.sId.toString();
                QuickPurchasePane.getInstance().show(true);
            }
            else if (param1.hasOwnProperty("Offer"))
            {
                _loc_3 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
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
            else
            {
                _loc_4 = 611 + this._weapon.mosaicNum;
                _loc_5 = ItemBuilder.createItem(ItemCategory.ITEM, _loc_4, _loc_4);
                QuickPurchasePane.getInstance().targetId = this._weapon.sId.toString();
                QuickPurchasePane.getInstance().mode = 2;
                QuickPurchasePane.getInstance().itemModel = _loc_5;
                QuickPurchasePane.getInstance().show(true);
            }
            return;
        }// end function

        private function onWeaponData(event:SMZTDataChangeEvent) : void
        {
            var _loc_2:EquipItem = null;
            if (this._weapon)
            {
                for each (_loc_2 in WeaponData.getInstance().holeWeapon)
                {
                    
                    if (this._weapon.sId == _loc_2.sId)
                    {
                        this.weapon = _loc_2;
                        break;
                    }
                }
            }
            return;
        }// end function

        private function doneGo(event:MouseEvent) : void
        {
            MosaicController.getInstance().doneGo();
            return;
        }// end function

        private function submitSynf(event:MouseEvent) : void
        {
            SMZTController.getInstance().submitSyntn();
            return;
        }// end function

        private function submitSyn(event:MouseEvent) : void
        {
            SMZTController.getInstance().submitSyntn(this.onSub);
            return;
        }// end function

        private function onSub(param1:XML) : void
        {
            this.sythesisPane["naa"].gotoAndPlay(2);
            return;
        }// end function

        private function putIntoSyn(event:MouseEvent) : void
        {
            var _loc_3:DisplayObject = null;
            var _loc_4:int = 0;
            var _loc_2:* = this.togo[this.currentSelectBagIndex];
            if (this.togoStoneModel)
            {
                if (this.togoStoneModel.itemId != _loc_2.itemId)
                {
                    return;
                }
            }
            if (this.isSynthing)
            {
                return;
            }
            if (_loc_2.itemId > 50005 && _loc_2.itemId % 10 == 5 || _loc_2.itemId == 618)
            {
                return;
            }
            if (this.sythNum < 5)
            {
                if (this.sythNum == 0)
                {
                    this.togoStoneModel = _loc_2;
                }
                if (this.sythNum >= this.togoStoneModel.number)
                {
                    return;
                }
                _loc_3 = SMZTResourceManager.getInstance().loadAssets(_loc_2.icoBigImage);
                var _loc_5:Number = 0.56;
                _loc_3.scaleY = 0.56;
                _loc_3.scaleX = _loc_5;
                _loc_4 = 0;
                while (_loc_4 < 5)
                {
                    
                    if ((this.sythesisPane["s" + _loc_4.toString()] as MovieClip).numChildren == 0)
                    {
                        (this.sythesisPane["s" + _loc_4.toString()] as MovieClip).addChild(_loc_3);
                        (this.sythesisPane["fa" + _loc_4.toString()] as MovieClip).gotoAndPlay(2);
                        (this.sythesisPane["sc" + _loc_4.toString()] as MovieClip).visible = true;
                        (getChild("sp") as MovieClip)["yizhi" + _loc_4.toString()].visible = true;
                        sythNum++;
                        break;
                    }
                    _loc_4++;
                }
            }
            this.updateButtonStatus();
            return;
        }// end function

        private function removeFromeSyn(event:MouseEvent) : void
        {
            if (this.togoStoneModel)
            {
                if (this.sythNum > 0)
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.sythNum - 1;
                    _loc_2.sythNum = _loc_3;
                    (this.sythesisPane["s" + int(String(event.currentTarget.name).replace("sc", "")).toString()] as MovieClip).removeChildAt(0);
                    (this.sythesisPane["sc" + int(String(event.currentTarget.name).replace("sc", "")).toString()] as MovieClip).visible = false;
                    (getChild("sp") as MovieClip)["yizhi" + int(String(event.currentTarget.name).replace("sc", "")).toString()].visible = false;
                    (this.sythesisPane["na" + int(String(event.currentTarget.name).replace("sc", "")).toString()] as MovieClip).gotoAndPlay(2);
                    if (this.sythNum == 0)
                    {
                        this.togoStoneModel = null;
                    }
                }
            }
            this.updateButtonStatus();
            return;
        }// end function

        private function mosaicClick(event:MouseEvent) : void
        {
            trace(this.togo[this.currentSelectBagIndex].name);
            SMZTController.getInstance().mosaicWeapon(this._weapon, this.togo[this.currentSelectBagIndex], this.onMosaicBack);
            return;
        }// end function

        private function onMosaicBack(param1:XML) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < 8)
            {
                
                if ((this.mosaicPane["s" + _loc_2.toString()] as MovieClip).currentFrame == 3 && this.mosaicPane["s" + _loc_2.toString()].av.numChildren == 0)
                {
                    (this.mosaicPane["f" + _loc_2.toString()] as MovieClip).gotoAndPlay(2);
                    this.playMoOver();
                    break;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function playMoOver() : void
        {
            var t:Timer;
            var gogo:Function;
            gogo = function (event:TimerEvent) : void
            {
                t.stop();
                t.removeEventListener(TimerEvent.TIMER, gogo);
                t = null;
                mosaicPane.mbover.gotoAndPlay(2);
                return;
            }// end function
            ;
            t = new Timer(1100);
            t.addEventListener(TimerEvent.TIMER, gogo);
            t.start();
            return;
        }// end function

        private function clearAllSelection() : void
        {
            var _loc_1:DisplayObject = null;
            var _loc_2:int = 0;
            this.currentSelectBagIndex = -1;
            this.currentSelectSynIndex = -1;
            this.currentSelectMosaicIndex = -1;
            for each (_loc_1 in this._boxVector)
            {
                
                _loc_1.filters = null;
                (_loc_1 as BaseSpritePane).spriteInstance["sele"].visible = false;
            }
            _loc_2 = 0;
            while (_loc_2 < 8)
            {
                
                (getChild("mp") as MovieClip)["s" + _loc_2.toString()].filters = null;
                (getChild("mp") as MovieClip)["s" + _loc_2.toString()].sele.visible = false;
                _loc_2++;
            }
            this.putBtn.active = false;
            this.sysBtn.active = false;
            this.mosaicBtn.active = false;
            return;
        }// end function

        private function updateButtonStatus() : void
        {
            var _loc_1:int = 0;
            this.sysBtn.active = false;
            this.mosaicBtn.active = false;
            this.putBtn.active = false;
            this.digBtn.active = false;
            this.discardBtn.active = false;
            if (this.isSynthing && this.mode == 1)
            {
                return;
            }
            if (this.mode == 1)
            {
                if (this.currentSelectBagIndex >= 0)
                {
                    this.putBtn.active = true;
                    if (this.sythNum > 1)
                    {
                        (getChild("sp") as MovieClip)["pert"].text = LocalConfig.LOCAL_LAN.SynthesisPane.Per.@Text + (this.sythNum - 1) * 25 + "%";
                        this.sysBtn.active = true;
                    }
                    else if (this.sythNum == 0)
                    {
                        (getChild("sp") as MovieClip)["pert"].text = "";
                    }
                    else
                    {
                        (getChild("sp") as MovieClip)["pert"].text = LocalConfig.LOCAL_LAN.SynthesisPane.Per.@Text + "0%";
                        this.sysBtn.active = false;
                    }
                }
            }
            else
            {
                if (this.currentSelectMosaicIndex >= 0)
                {
                    //trace("武器孔" + this.currentSelectMosaicIndex);
                    if (this._weapon)
                    {
                        if (this._weapon.mosaicNum < 8)
                        {
                            if (this.mosaicPane["s" + this.currentSelectMosaicIndex.toString()].currentFrame == 2)
                            {
                                this.digBtn.active = true;
                            }
                        }
                        if (this._weapon.mosaic[this.currentSelectMosaicIndex] != 0)
                        {
                            this.discardBtn.active = true;
                        }
                    }
                }
                if (this.currentSelectBagIndex >= 0 && this.tab != 5 && this._weapon)
                {
                    if (this._weapon.mosaicNum > 0)
                    {
                        _loc_1 = 0;
                        while (_loc_1 < this._weapon.mosaicNum)
                        {
                            
                            if (this._weapon.mosaic[_loc_1] == 0)
                            {
                                this.mosaicBtn.active = true;
                                break;
                            }
                            _loc_1++;
                        }
                    }
                }
            }
            return;
        }// end function

        protected function chooseClick(event:MouseEvent) : void
        {
            MosaicController.getInstance().chooseWeapon();
            return;
        }// end function

        private function synClick(event:MouseEvent) : void
        {
            var onChoosed:Function;
            var fee:int;
            var event:* = event;
            onChoosed = function (param1:String) : void
            {
                if (param1 == AlertSelectPane.ALERT_YES)
                {
                    SMZTController.getInstance().synthStone(togoStoneModel, sythNum, onSynthBack);
                }
                return;
            }// end function
            ;
            if (this.togoStoneModel)
            {
                fee = this.togoStoneModel.level * 25;
                if (this.togoStoneModel.itemId > 50000 && this.togoStoneModel.itemId < 51000)
                {
                    fee = this.togoStoneModel.level * 25;
                }
                else
                {
                    fee = (this.togoStoneModel.level + 1) * 25;
                }
                AlertSelectPane.getInstance().showMessage(String(LocalConfig.LOCAL_LAN.SynthesisPane.SynFee.@Text).replace("{amount}", fee.toString()), onChoosed);
            }
            return;
        }// end function

        private function onSynthBack(param1:XML) : void
        {
            this.sythNum = 0;
            this.togoStoneModel = null;
            MosaicController.getInstance().refreshSynthOnly();
            return;
        }// end function

        override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = 41.3;
                this.y = 15.85;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:35.85});
                }
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            }
            playShowSound();
            return;
        }// end function

        private function onMOver(event:MouseEvent) : void
        {
            if (!this._weapon)
            {
                return;
            }
            var _loc_2:* = event.currentTarget as MovieClip;
            var _loc_3:* = int(_loc_2.name.replace("s", "")) + 1;
            var _loc_4:String = "";
            if (_loc_2.currentFrame != 4 && _loc_2.currentFrame != 3)
            {
                if (_loc_2.currentFrame == 1)
                {
                    if (_loc_3 >= 3)
                    {
                        _loc_4 = String(LocalConfig.LOCAL_LAN.SynthesisPane.NeedMS.@Text).replace("{level}", _loc_3.toString());
                    }
                    if (_loc_3 <= 2 && _loc_3 >= 0)
                    {
                        _loc_4 = String(LocalConfig.LOCAL_LAN.SynthesisPane.NeedM.@Text).replace("{level}", _loc_3.toString());
                    }
                }
                if (_loc_2.currentFrame == 2)
                {
                    _loc_4 = String(LocalConfig.LOCAL_LAN.SynthesisPane.Dig.@Text).replace("{level}", _loc_3.toString());
                }
                ToolTip.getInstance().show(_loc_2, "", _loc_4);
            }
            return;
        }// end function

        public function resetMosaicStatus() : void
        {
            this.digBtn.active = false;
            this.discardBtn.active = false;
            var _loc_1:int = 0;
            while (_loc_1 < 8)
            {
                
                (getChild("mp") as MovieClip)["s" + _loc_1.toString()].gotoAndStop(1);
                while ((getChild("mp") as MovieClip)["s" + _loc_1.toString()].av.numChildren > 0)
                {
                    
                    (getChild("mp") as MovieClip)["s" + _loc_1.toString()].av.removeChildAt(0);
                }
                (getChild("mp") as MovieClip)["s" + _loc_1.toString()].addEventListener(MouseEvent.CLICK, this.onMIcoClick);
                (getChild("mp") as MovieClip)["s" + _loc_1.toString()].addEventListener(MouseEvent.MOUSE_OVER, this.onMOver);
                _loc_1++;
            }
            (getChild("mp") as MovieClip)["emc"].gotoAndStop(1);
            (getChild("mp") as MovieClip)["chos"].alpha = 1;
            (getChild("mp") as MovieClip)["chos"].buttonMode = true;
            (getChild("mp") as MovieClip)["chos"].addEventListener(MouseEvent.CLICK, this.chooseClick);
            while ((getChild("mp") as MovieClip)["wav"].numChildren > 0)
            {
                
                (getChild("mp") as MovieClip)["wav"].removeChildAt(0);
            }
            (getChild("mp") as MovieClip)["lvtext"].text = "";
            this._weapon = null;
            this.mosaicBtn.active = false;
            this.hTimer.stop();
            return;
        }// end function

        private function onMIcoClick(event:MouseEvent) : void
        {
            if ((event.currentTarget as MovieClip).currentFrame == 1)
            {
                return;
            }
            this.clearAllSelection();
            (event.currentTarget as MovieClip)["sele"].visible = true;
            this.currentSelectMosaicIndex = int(String(event.currentTarget.name).replace("s", ""));
            this.updateButtonStatus();
            return;
        }// end function

        public function resetSynthStatus() : void
        {
            (getChild("sp") as MovieClip)["yizhia"].visible = false;
            this.sythesisPane.sfail.visible = false;
            this.sythesisPane.ssucc.visible = false;
            var _loc_1:int = 0;
            while (_loc_1 < 5)
            {
                
                (getChild("sp") as MovieClip)["sc" + _loc_1.toString()].visible = false;
                (getChild("sp") as MovieClip)["yizhi" + _loc_1.toString()].visible = false;
                ((getChild("sp") as MovieClip)["sc" + _loc_1.toString()] as MovieClipButton).onClick = this.removeFromeSyn;
                while ((getChild("sp") as MovieClip)["s" + _loc_1.toString()].numChildren > 0)
                {
                    
                    (getChild("sp") as MovieClip)["s" + _loc_1.toString()].removeChildAt(0);
                }
                _loc_1++;
            }
            while ((getChild("sp") as MovieClip)["g0"].numChildren > 0)
            {
                
                (getChild("sp") as MovieClip)["g0"].removeChildAt(0);
            }
            (getChild("sp") as MovieClip)["pert"].text = "";
            this.sysBtn.active = false;
            (getChild("sp") as MovieClip)["timet"].text = "";
            (getChild("sp") as MovieClip)["permc"].visible = false;
            this.sythNum = 0;
            this.sysBtn.active = false;
            this.synFailedBtn.visible = false;
            this.synSuccessBtn.visible = false;
            this.doneImediateBtn.visible = this.isSynthing && !ModelLocator.getInstance().isQQRelated();
            this.doneImediateBtnQ.visible = this.isSynthing && ModelLocator.getInstance().isQQRelated();
            this.currentSynthModel = null;
            this.togoStoneModel = null;
            return;
        }// end function

        protected function tabClick(event:MouseEvent) : void
        {
            this.tab = int(String(event.currentTarget.name).replace("tab", ""));
            return;
        }// end function

        public function set tab(param1:int) : void
        {
            this._tab = param1;
            (getChild("tab0") as MovieClip).gotoAndStop(1);
            (getChild("tab1") as MovieClip).gotoAndStop(1);
            (getChild("tab2") as MovieClip).gotoAndStop(1);
            (getChild("tab3") as MovieClip).gotoAndStop(1);
            (getChild("tab4") as MovieClip).gotoAndStop(1);
            (getChild("tab5") as MovieClip).gotoAndStop(1);
            (getChild("tab" + this._tab.toString()) as MovieClip).gotoAndStop(2);
            this.refreshData();
            return;
        }// end function

        private function refreshData() : void
        {
            var _loc_1:BaseSpritePane = null;
            var _loc_3:DisplayObject = null;
            var _loc_4:TextField = null;
            var _loc_5:TextFormat = null;
            this.clearAllSelection();
            for each (_loc_1 in this._boxVector)
            {
                
                while (MovieClip((_loc_1.spriteInstance as MovieClip).getChildByName("av")).numChildren > 0)
                {
                    
                    MovieClip((_loc_1.spriteInstance as MovieClip).getChildByName("av")).removeChildAt(0);
                }
                _loc_1.toolTipStr = "";
                _loc_1.buttonMode = false;
                if (_loc_1.hasEventListener(MouseEvent.CLICK))
                {
                    _loc_1.removeEventListener(MouseEvent.CLICK, this.boxClick);
                }
            }
            switch(this.tab)
            {
                case 0:
                {
                    this.togo = this._stoneI;
                    break;
                }
                case 1:
                {
                    this.togo = this._stoneII;
                    break;
                }
                case 2:
                {
                    this.togo = this._stoneIII;
                    break;
                }
                case 3:
                {
                    this.togo = this._stoneIV;
                    break;
                }
                case 4:
                {
                    this.togo = this._stoneV;
                    break;
                }
                case 5:
                {
                    this.togo = this._scrollVector;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_2:int = 0;
            while (_loc_2 < this.togo.length)
            {
                
                _loc_3 = SMZTResourceManager.getInstance().loadAssets(this.togo[_loc_2].icoCardImage);
                var _loc_6:Number = 0.67;
                _loc_3.scaleY = 0.67;
                _loc_3.scaleX = _loc_6;
                MovieClip((this._boxVector[_loc_2].spriteInstance as MovieClip).getChildByName("av")).addChild(_loc_3);
                if (this.togo[_loc_2].number > 1)
                {
                    _loc_4 = new TextField();
                    _loc_5 = new TextFormat();
                    _loc_5.color = 16777215;
                    _loc_5.align = TextAlign.RIGHT;
                    _loc_5.size = 12;
                    _loc_4.defaultTextFormat = _loc_5;
                    _loc_4.x = 15;
                    _loc_4.y = 23;
                    _loc_4.text = this.togo[_loc_2].number.toString();
                    _loc_4.width = 28;
                    _loc_4.height = _loc_4.textHeight + 3;
                    _loc_4.mouseEnabled = false;
                    _loc_4.selectable = false;
                    MovieClip((this._boxVector[_loc_2].spriteInstance as MovieClip).getChildByName("av")).addChild(_loc_4);
                }
                this._boxVector[_loc_2].toolTipStr = this.togo[_loc_2].getToolTipStr();
                this._boxVector[_loc_2].buttonMode = true;
                this._boxVector[_loc_2].addEventListener(MouseEvent.CLICK, this.boxClick);
                _loc_2++;
            }
            return;
        }// end function

        private function boxClick(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            while (_loc_3 < 5)
            {
                
                if ((this.sythesisPane["s" + _loc_3.toString()] as MovieClip).numChildren > 0)
                {
                    _loc_2++;
                    break;
                }
                _loc_3++;
            }
            if (_loc_2 > 0 && this.mode == 1)
            {
                return;
            }
            this.clearAllSelection();
            (event.currentTarget as BaseSpritePane).spriteInstance["sele"].visible = true;
            this.currentSelectBagIndex = int(String(event.currentTarget.name).replace("s", ""));
            var _loc_4:* = this.togo[this.currentSelectBagIndex];
            this.updateButtonStatus();
            return;
        }// end function

        public function get tab() : int
        {
            return this._tab;
        }// end function

        public function get mode() : int
        {
            return this._mode;
        }// end function

        public function set mode(param1:int) : void
        {
            this._mode = param1;
            if (this._mode == 0)
            {
                this.sythesisPane.visible = false;
                this.mosaicPane.visible = true;
                (getChild("toptab") as MovieClip).gotoAndStop(1);
                this.putBtn.visible = false;
            }
            else
            {
                this.sythesisPane.visible = true;
                this.mosaicPane.visible = false;
                (getChild("toptab") as MovieClip).gotoAndStop(2);
                this.putBtn.visible = true;
            }
            return;
        }// end function

        public function get weapon() : EquipItem
        {
            return this._weapon;
        }// end function

        public function set weapon(param1:EquipItem) : void
        {
            var img:Loader;
            var onLoadAssets:Function;
            var g1f:GlowFilter;
            var gf:GlowFilter;
            var g2f:GlowFilter;
            var g3f:GlowFilter;
            var sm:ItemModel;
            var smg:DisplayObject;
            var cd:BaseSpritePane;
            var value:* = param1;
            onLoadAssets = function (event:Event) : void
            {
                ((img.content as MovieClip).getChildAt(0) as MovieClip).gotoAndStop((_weapon.level + 1));
                return;
            }// end function
            ;
            this._weapon = value;
            this.clearAllSelection();
            this.updateButtonStatus();
            while ((this.mosaicPane["wav"] as MovieClip).numChildren > 0)
            {
                
                (this.mosaicPane["wav"] as MovieClip).removeChildAt(0);
            }
            (this.mosaicPane["lvtext"] as TextField).text = "";
            var c:* = new BaseSpritePane();
            c.toolTipStr = this._weapon.getToolTipStr();
            (this.mosaicPane["emc"] as MovieClip).gotoAndStop((this._weapon.quality + 1));
            if (this._weapon.level > 0)
            {
                (this.mosaicPane["lvtext"] as TextField).text = "+" + this._weapon.level;
            }
            img = new Loader();
            img.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadAssets);
            img.load(new URLRequest(this._weapon.icoBigImage));
            var _loc_3:Number = 1.6;
            img.scaleY = 1.6;
            img.scaleX = _loc_3;
            if (this._weapon.quality > 0)
            {
                g1f = new GlowFilter(0, 1, 4, 4, 1);
                gf = new GlowFilter(this._weapon.levelColor, 0.62, 50, 50, 6);
                img.filters = [g1f, gf];
            }
            else
            {
                g2f = new GlowFilter(0, 1, 4, 4, 1);
                g3f = new GlowFilter(16777215, 0.22, 10, 10, 3);
                img.filters = [g2f, g3f];
            }
            (this.mosaicPane["wav"] as MovieClip).addChild(c.addChild(img));
            (this.mosaicPane["chos"] as MovieClip).addEventListener(MouseEvent.MOUSE_OVER, this.showWt);
            (this.mosaicPane["chos"] as MovieClip).alpha = 0;
            var i:int;
            while (i < 8)
            {
                
                (getChild("mp") as MovieClip)["s" + i.toString()].gotoAndStop(1);
                while ((getChild("mp") as MovieClip)["s" + i.toString()].av.numChildren > 0)
                {
                    
                    (getChild("mp") as MovieClip)["s" + i.toString()].av.removeChildAt(0);
                }
                i = (i + 1);
            }
            var x:int;
            while (x < this._weapon.mosaicNum)
            {
                
                (getChild("mp") as MovieClip)["s" + x.toString()].gotoAndStop(3);
                x = (x + 1);
            }
            if (this._weapon.mosaicNum < 8 && this._weapon.quality > 0)
            {
                if (this._weapon.quality >= 2)
                {
                    (getChild("mp") as MovieClip)["s" + this._weapon.mosaicNum.toString()].gotoAndStop(2);
                }
                else if (this._weapon.mosaicNum < 2)
                {
                    (getChild("mp") as MovieClip)["s" + this._weapon.mosaicNum.toString()].gotoAndStop(2);
                }
            }
            var t:int;
            while (t < this._weapon.mosaic.length)
            {
                
                if (this._weapon.mosaic[t] != 0)
                {
                    sm = ItemBuilder.createItem(ItemCategory.ITEM, this._weapon.mosaic[t]);
                    smg = SMZTResourceManager.getInstance().loadAssets(sm.icoCardImage);
                    var _loc_3:Number = 0.67;
                    smg.scaleY = 0.67;
                    smg.scaleX = _loc_3;
                    cd = new BaseSpritePane();
                    cd.toolTipStr = sm.getToolTipStr();
                    cd.addChild(smg);
                    (getChild("mp") as MovieClip)["s" + t.toString()].av.addChild(cd);
                    (getChild("mp") as MovieClip)["s" + t.toString()].gotoAndStop(4);
                }
                t = (t + 1);
            }
            return;
        }// end function

        public function playDigAnime() : void
        {
            if (this._weapon)
            {
                this.mosaicPane["digte" + this._weapon.mosaicNum].gotoAndPlay(2);
            }
            return;
        }// end function

        protected function showWt(event:MouseEvent) : void
        {
            if (this._weapon)
            {
                ToolTip.getInstance().show(event.currentTarget as DisplayObject, "", this._weapon.getToolTipStr());
            }
            return;
        }// end function

        public function get isSynthing() : Boolean
        {
            return this._isSynthing;
        }// end function

        public function set isSynthing(param1:Boolean) : void
        {
            this._isSynthing = param1;
            return;
        }// end function

        public function get currentSynthModel() : ItemModel
        {
            return this._currentSynthModel;
        }// end function

        public function set currentSynthModel(param1:ItemModel) : void
        {
            this._currentSynthModel = param1;
            return;
        }// end function

        public static function formatSecondToDateHour(param1:uint) : String
        {
            var _loc_2:* = Math.floor(param1 / (24 * 3600));
            param1 = param1 % (24 * 3600);
            var _loc_3:* = Math.floor(param1 / 3600);
            var _loc_4:* = param1 % 3600;
            var _loc_5:* = Math.floor(_loc_4 / 60);
            param1 = param1 - _loc_3 * 3600 - _loc_5 * 60;
            var _loc_6:String = "";
            var _loc_7:String = "";
            var _loc_8:String = "";
            if (_loc_3 < 10)
            {
                _loc_6 = "0" + _loc_3.toString();
            }
            else
            {
                _loc_6 = _loc_3.toString();
            }
            if (_loc_5 < 10)
            {
                _loc_7 = "0" + _loc_5.toString();
            }
            else
            {
                _loc_7 = _loc_5.toString();
            }
            if (param1 < 10)
            {
                _loc_8 = "0" + param1.toString();
            }
            else
            {
                _loc_8 = param1.toString();
            }
            return _loc_7 + ":" + _loc_8;
        }// end function

        public static function getInstance() : StoneBagPane
        {
            if (!eb)
            {
                eb = new StoneBagPane;
            }
            return eb;
        }// end function

    }
}
