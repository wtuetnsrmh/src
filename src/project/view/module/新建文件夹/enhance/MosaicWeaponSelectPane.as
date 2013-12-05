package project.view.module.enhance
{
	/*
	* 描述：武器选择面板
	* 
	*/
    import __AS3__.vec.*;
    import project.config.*;
    import project.core.*;
    import project.events.*;
    import project.model.data.*;
    
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.bagpane.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    public class MosaicWeaponSelectPane extends BaseTitleWindow
    {
        private var totalPage:int = 0;
        private var currentPage:int = 1;
        private var numPerPage:int = 5;
        private var prePageBtn:MovieClipButton;
        private var nextPageBtn:MovieClipButton;
        private var icoVector:Vector.<BagIcoBox>;
        private var emcVector:Vector.<MovieClip>;
        private var posArr:Array;
        private var dataArr:Vector.<EquipItem>;
        private var _formalSelectedIcoBox:BagIcoBox;
        private var _currentSelectedIcoBox:BagIcoBox;
        private static var upgrageWeaponSelectPane:MosaicWeaponSelectPane;

        public function MosaicWeaponSelectPane()
        {
            this.posArr = [[52, 38], [118.95, 38], [185.5, 38], [252.45, 38], [320.55, 38]];
            if (upgrageWeaponSelectPane != null)
            {
                throw new Error("Error");
            }
            setSpriteInstance("MosaicWeaponSelectPane");
            dataModel = WeaponData.getInstance();
            this.configerUIInstance();
            this.icoVector = new Vector.<BagIcoBox>;
            this.emcVector = new Vector.<MovieClip>;
            this.draw();
            return;
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
            this.clearStatus();
            return;
        }// end function

        private function onBoxClick(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as BagIcoBox;
            _loc_2.tf.hide();
            if (_loc_2.item == null)
            {
                return;
            }
            if (this.currentSelectedIcoBox == null)
            {
                this.currentSelectedIcoBox = _loc_2;
                this.currentSelectedIcoBox.setOnChoose(true);
            }
            if (this.currentSelectedIcoBox != _loc_2 && this.currentSelectedIcoBox != null)
            {
                this.formalSelectedIcoBox = this.currentSelectedIcoBox;
                this.formalSelectedIcoBox.setOnChoose(false);
                this.currentSelectedIcoBox = _loc_2;
                this.currentSelectedIcoBox.setOnChoose(true);
            }
            StoneBagPane.getInstance().weapon = this.currentSelectedIcoBox.item as EquipItem;
            hide();
            return;
        }// end function

        public function clearStatus() : void
        {
            var _loc_1:BagIcoBox = null;
            var _loc_2:MovieClip = null;
            for each (_loc_1 in this.icoVector)
            {
                
                _loc_1.item = null;
            }
            for each (_loc_2 in this.emcVector)
            {
                
                _loc_2.gotoAndStop(1);
            }
            if (this.formalSelectedIcoBox)
            {
                this.formalSelectedIcoBox.setOnChoose(false);
                this.formalSelectedIcoBox = null;
            }
            if (this.currentSelectedIcoBox)
            {
                this.currentSelectedIcoBox.setOnChoose(false);
                this.currentSelectedIcoBox = null;
            }
            return;
        }// end function

        private function draw() : void
        {
            var _loc_2:BagIcoBox = null;
            var _loc_3:MovieClip = null;
            var _loc_1:int = 0;
            while (_loc_1 < 5)
            {
                
                _loc_2 = new BagIcoBox();
                this.icoVector.push(_loc_2);
                _loc_2.addEventListener(MouseEvent.CLICK, this.onBoxClick);
                _loc_2.index = _loc_1;
                _loc_3 = SMZTResourceManager.getInstance().getRes("WeaponBoxBgMc") as MovieClip;
                _loc_3.gotoAndStop(1);
                this.emcVector.push(_loc_3);
                _loc_3.x = this.posArr[_loc_1][0] + 1;
                _loc_3.y = this.posArr[_loc_1][1] + 1;
                _loc_3.scaleX = 0.98;
                _loc_3.scaleY = 0.98;
                _loc_3.mouseEnabled = false;
                _loc_3.mouseChildren = false;
                _loc_2.setLocation(this.posArr[_loc_1][0], this.posArr[_loc_1][1]);
                addChild(_loc_2);
                addChild(_loc_3);
                _loc_1++;
            }
            return;
        }// end function

        private function setIcoBoxData(param1:int, param2:Vector.<EquipItem>) : void
        {
            var _loc_4:int = 0;
            var _loc_5:TextFormat = null;
            var _loc_6:TextField = null;
            var _loc_7:GlowFilter = null;
            this.clearStatus();
            var _loc_3:* = param1;
            while (_loc_3 < param1 + 5)
            {
                
                if (_loc_3 > (param2.length - 1))
                {
                    return;
                }
                this.icoVector[_loc_3 - param1].item = param2[_loc_3];
                if (param2[_loc_3].level > 0)
                {
                    _loc_5 = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR, true);
                    _loc_6 = new TextField();
                    _loc_6.defaultTextFormat = _loc_5;
                    _loc_6.text = "+" + param2[_loc_3].level;
                    _loc_6.selectable = false;
                    _loc_6.x = 40;
                    _loc_6.y = 40;
                    _loc_7 = new GlowFilter();
                    _loc_7.color = 0;
                    _loc_7.alpha = 1;
                    _loc_7.blurX = 2;
                    _loc_7.blurY = 2;
                    _loc_7.quality = BitmapFilterQuality.MEDIUM;
                    _loc_7.strength = 500;
                    _loc_6.filters = [_loc_7];
                    this.icoVector[_loc_3 - param1].txtLayer.addChild(_loc_6);
                }
                _loc_4 = param2[_loc_3].quality + 1;
                this.emcVector[_loc_3 - param1].gotoAndStop(_loc_4);
                if ((param2[_loc_3] as EquipItem).isOrange())
                {
                    this.emcVector[_loc_3 - param1].gotoAndStop(4);
                }
                _loc_3++;
            }
            return;
        }// end function

        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            var _loc_2:EquipItem = null;
            this.currentPage = 1;
            this.dataArr = new Vector.<EquipItem>;
            for each (_loc_2 in WeaponData.getInstance().holeWeapon)
            {
                
                if (_loc_2.quality > 0)
                {
                    this.dataArr.push(_loc_2);
                }
            }
            if (this.currentPage == 0)
            {
                this.currentPage = 1;
            }
            this.totalPage = this.dataArr.length % this.numPerPage == 0 ? (this.dataArr.length / this.numPerPage) : (Math.floor(this.dataArr.length / this.numPerPage + 1));
            if (this.totalPage == 0)
            {
                this.totalPage = 1;
            }
            if (this.currentPage > this.totalPage)
            {
                this.currentPage = this.totalPage;
            }
            this.setIcoBoxData(0, this.dataArr);
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.prePageBtn = getChild("pre") as MovieClipButton;
            this.nextPageBtn = getChild("next") as MovieClipButton;
            this.prePageBtn.addEventListener(MouseEvent.CLICK, this.goPrev);
            this.nextPageBtn.addEventListener(MouseEvent.CLICK, this.goNext);
            return;
        }// end function

        private function goPrev(event:MouseEvent) : void
        {
            if (this.currentPage <= 1)
            {
                return;
            }
            this.setIcoBoxData((this.currentPage - 1) * this.numPerPage - this.numPerPage, this.dataArr);
            var _loc_2:String = this;
            var _loc_3:* = this.currentPage - 1;
            _loc_2.currentPage = _loc_3;
            return;
        }// end function

        private function goNext(event:MouseEvent) : void
        {
            if (this.currentPage >= this.totalPage)
            {
                return;
            }
            this.setIcoBoxData((this.currentPage + 1) * this.numPerPage - this.numPerPage, this.dataArr);
            var _loc_2:String = this;
            var _loc_3:* = this.currentPage + 1;
            _loc_2.currentPage = _loc_3;
            return;
        }// end function

        public function get formalSelectedIcoBox() : BagIcoBox
        {
            return this._formalSelectedIcoBox;
        }// end function

        public function set formalSelectedIcoBox(param1:BagIcoBox) : void
        {
            this._formalSelectedIcoBox = param1;
            return;
        }// end function

        public function get currentSelectedIcoBox() : BagIcoBox
        {
            return this._currentSelectedIcoBox;
        }// end function

        public function set currentSelectedIcoBox(param1:BagIcoBox) : void
        {
            this._currentSelectedIcoBox = param1;
            return;
        }// end function

        public static function getInstance() : MosaicWeaponSelectPane
        {
            if (upgrageWeaponSelectPane == null)
            {
                upgrageWeaponSelectPane = new MosaicWeaponSelectPane;
            }
            return upgrageWeaponSelectPane;
        }// end function

    }
}
