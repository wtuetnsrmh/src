package project.view.module.friendpane
{
    import __AS3__.vec.*;
    import project.view.base.*;
    import project.view.layout.*;
    import flash.events.*;

    public class FriendListContainer extends BaseSpritePane
    {
        private var container:BaseGridContainer;
        private var boxVector:Vector.<FriendIcoBox>;
        private var _formalSelectedIcoBox:FriendIcoBox;
        private var _currentSelectedIcoBox:FriendIcoBox;
        private var posArr:Array;
        public static const CAPACITY_NUM:int = 8;

        public function FriendListContainer()
        {
            this.posArr = [[65, 65], [65, 103], [65, 139], [65, 176], [65, 213], [65, 250], [65, 288], [65, 324]];
            this.container = new BaseGridContainer(8, 1, 0.5, 165, 35);
            addChild(this.container);
            setLocation(65, 74);
            this.boxVector = new Vector.<FriendIcoBox>;
            this.draw();
            return;
        }// end function

        private function draw() : void
        {
            var _loc_2:FriendIcoBox = null;
            var _loc_1:int = 0;
            while (_loc_1 < CAPACITY_NUM)
            {
                
                _loc_2 = new FriendIcoBox();
                _loc_2.name = "fbx" + _loc_1;
                this.boxVector.push(_loc_2);
                _loc_2.addEventListener(MouseEvent.CLICK, this.onBoxClick);
                this.container.appendChild(_loc_2);
                _loc_1++;
            }
            return;
        }// end function

        public function switchAffiliateMode() : void
        {
            var _loc_1:FriendIcoBox = null;
            for each (_loc_1 in this.boxVector)
            {
                
                _loc_1.fMode = 1;
            }
            return;
        }// end function

        public function switchFriendMode() : void
        {
            var _loc_1:FriendIcoBox = null;
            for each (_loc_1 in this.boxVector)
            {
                
                _loc_1.fMode = 0;
            }
            return;
        }// end function

        private function onBoxClick(event:MouseEvent) : void
        {
            playUISound("UI_MOUSE_CLICK");
            var _loc_2:* = event.currentTarget as FriendIcoBox;
            if (_loc_2.friendEachData == null)
            {
            }
            if (this.currentSelectedIcoBox == null)
            {
                this.currentSelectedIcoBox = _loc_2;
                this.currentSelectedIcoBox.isSelected = true;
                this.currentSelectedIcoBox.setOnChoose(true);
            }
            if (this.currentSelectedIcoBox != _loc_2 && this.currentSelectedIcoBox != null)
            {
                this.formalSelectedIcoBox = this.currentSelectedIcoBox;
                this.formalSelectedIcoBox.isSelected = false;
                this.formalSelectedIcoBox.setOnChoose(false);
                this.currentSelectedIcoBox = _loc_2;
                this.currentSelectedIcoBox.isSelected = true;
                this.currentSelectedIcoBox.setOnChoose(true);
            }
            return;
        }// end function

        public function refreshFriendData(param1:Array) : void
        {
            var _loc_3:Object = null;
            this.clearStatus();
            var _loc_2:int = 0;
            while (_loc_2 < CAPACITY_NUM)
            {
                
                _loc_3 = param1[_loc_2];
                if (_loc_3)
                {
                    this.boxVector[_loc_2].setData(_loc_3);
                }
                _loc_2++;
            }
            return;
        }// end function

        public function clearStatus() : void
        {
            var _loc_1:FriendIcoBox = null;
            for each (_loc_1 in this.boxVector)
            {
                
                _loc_1.clearStatus();
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

        public function get formalSelectedIcoBox() : FriendIcoBox
        {
            return this._formalSelectedIcoBox;
        }// end function

        public function set formalSelectedIcoBox(param1:FriendIcoBox) : void
        {
            this._formalSelectedIcoBox = param1;
            return;
        }// end function

        public function get currentSelectedIcoBox() : FriendIcoBox
        {
            return this._currentSelectedIcoBox;
        }// end function

        public function set currentSelectedIcoBox(param1:FriendIcoBox) : void
        {
            this._currentSelectedIcoBox = param1;
            return;
        }// end function

    }
}
