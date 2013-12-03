package project.view.module.friendpane
{
    import com.adobe.net.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import project.config.*;
    import project.controller.*;
    import project.events.*;
    import project.model.data.*;
    import project.view.artplug.*;
    import project.view.base.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import mx.utils.*;

    public class FriendPane extends BaseSpritePane
    {
        private var _isOpend:Boolean = false;
        private var _totalPage:int = 0;
        private var _currentPage:int = 1;
        private var numPerPage:int = 8;
        private var prePageBtn:MovieClipButton;
        private var nextPageBtn:MovieClipButton;
        private var serchBtn:SimpleButton;
        private var lastBtn:MovieClipButton;
        private var firstBtn:MovieClipButton;
        private var refreshBtn:MovieClipButton;
        private var pageText:TextField;
        private var serchInputText:TextField;
        private var friendContainer:FriendListContainer;
        private var friendData:FriendData;
        private var _activate:Boolean = true;
        private var _fakeBtn:MovieClip;
        private var cancelSeachBtn:MovieClipButton;
        private var currentArr:Array;
        private var friendSwitchTab:MovieClip;
        private var inviteFriendBtn:MovieClipButton;
        private var fMode:int = 0;

        public function FriendPane()
        {
            setSpriteInstance("FriendPane");
            this.configerUIInstance();
            setLocation(722, 60);
            this.friendContainer = new FriendListContainer();
            addChild(this.friendContainer);
            this.friendData = FriendData.getInstance();
            dataModel = this.friendData;
            return;
        }// end function

        public function onClose(event:MouseEvent = null) : void
        {
            if (this._isOpend)
            {
                TweenLite.to(this, 0.5, {x:722, ease:Back.easeOut});
                this._isOpend = false;
                (getChild("arrow") as MovieClip).gotoAndStop(2);
                playUISound("UI_FRIEND_CLOSE");
                this.friendSwitchTab.gotoAndStop(1);
                this.friendContainer.switchFriendMode();
                this.fMode = 0;
            }
            else
            {
                TweenLite.to(this, 0.5, {x:510, ease:Back.easeOut});
                this._isOpend = true;
                (getChild("arrow") as MovieClip).gotoAndStop(1);
                playUISound("UI_FRIEND_OPEN");
                SMZTController.getInstance().initFriendList(this.currentPage);
            }
            return;
        }// end function

        public function closeHellFuck() : void
        {
            TweenLite.to(this, 0.5, {x:722, ease:Back.easeOut});
            this._isOpend = false;
            (getChild("arrow") as MovieClip).gotoAndStop(2);
            this.friendSwitchTab.gotoAndStop(1);
            this.friendContainer.switchFriendMode();
            this.fMode = 0;
            return;
        }// end function

        private function configerUIInstance() : void
        {
            (getChild("arrow") as MovieClip).addEventListener(MouseEvent.CLICK, this.onClose);
            (getChild("arrow") as MovieClip).gotoAndStop(2);
            (getChild("arrow") as MovieClip).buttonMode = true;
            this.friendSwitchTab = getChild("fwt") as MovieClip;
            this.friendSwitchTab.addEventListener(MouseEvent.CLICK, this.friendSwitchClick);
            this.friendSwitchTab.gotoAndStop(1);
            this._fakeBtn = getChild("fake") as MovieClip;
            this._fakeBtn.visible = false;
            this.pageText = getChild("page") as TextField;
            this.inviteFriendBtn = getChild("invite") as MovieClipButton;
            var _loc_1:* = ApplicationConfig.mainConfig.appName;
            this.inviteFriendBtn.toolTip = String(LocalConfig.LOCAL_LAN.FriendPane.Invite.@Text).replace("{app}", _loc_1);
            this.inviteFriendBtn.addEventListener(MouseEvent.CLICK, this.inviteFrClick);
            this.serchBtn = getChild("find") as SimpleButton;
            this.serchBtn.addEventListener(MouseEvent.CLICK, this.searchFriends);
            this.serchInputText = getChild("sgTxt") as TextField;
            this.serchInputText.maxChars = 10;
            this.serchInputText.multiline = false;
            this.serchInputText.antiAliasType = AntiAliasType.ADVANCED;
            this.serchInputText.addEventListener(TextEvent.TEXT_INPUT, this.onTextInput);
            this.serchInputText.addEventListener(Event.CHANGE, this.onTextChange);
            this.prePageBtn = getChild("pre") as MovieClipButton;
            this.nextPageBtn = getChild("next") as MovieClipButton;
            this.cancelSeachBtn = getChild("csb") as MovieClipButton;
            this.lastBtn = getChild("last") as MovieClipButton;
            this.firstBtn = getChild("first") as MovieClipButton;
            this.refreshBtn = getChild("ref") as MovieClipButton;
            this.prePageBtn.addEventListener(MouseEvent.CLICK, this.goPrev);
            this.nextPageBtn.addEventListener(MouseEvent.CLICK, this.goNext);
            this.lastBtn.addEventListener(MouseEvent.CLICK, this.goLast);
            this.firstBtn.addEventListener(MouseEvent.CLICK, this.goFirst);
            this.refreshBtn.addEventListener(MouseEvent.CLICK, this.refreshFriendList);
            this.cancelSeachBtn.addEventListener(MouseEvent.CLICK, this.cancelSearch);
            this.cancelSeachBtn.visible = false;
            return;
        }// end function

        private function friendSwitchClick(event:MouseEvent) : void
        {
            this.currentPage = 1;
            switch(event.target.name)
            {
                case "fft":
                {
                    this.fMode = 0;
                    this.friendSwitchTab.gotoAndStop(1);
                    this.friendContainer.switchFriendMode();
                    this.refreshFriendList();
                    break;
                }
                case "ttt":
                {
                    this.fMode = 1;
                    this.friendSwitchTab.gotoAndStop(2);
                    this.friendContainer.switchAffiliateMode();
                    this.refreshFriendList();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function inviteFrClick(event:MouseEvent) : void
        {
            GetStudentPane.getInstance().show(true);
            return;
        }// end function

        override protected function onUIdChange(event:SMZTDataChangeEvent) : void
        {
            return;
        }// end function

        override public function showHelp(event:MouseEvent = null) : void
        {
            if (this.fMode == 0)
            {
                HelpPane.getInstance().playInstance("NEWBIE_SHOW_FRIEND_HELP");
            }
            else
            {
                HelpPane.getInstance().playInstance("NEWBIE_SHOW_AFFILIATE_HELP");
            }
            if (HelpPane.getInstance().isOpened)
            {
                helpBtn.gotoAndPlay(2);
            }
            else
            {
                helpBtn.gotoAndStop(1);
            }
            return;
        }// end function

        private function onTextChange(event:Event) : void
        {
            //trace("TextChange : " + this.serchInputText.text);
            if (StringUtil.trim(this.serchInputText.text) == "")
            {
                this.currentPage = 1;
                this.currentArr = this.friendData.friendArr;
                this.refreshFriendList();
                this.cancelSeachBtn.visible = false;
            }
            else
            {
                this.cancelSeachBtn.visible = true;
                this.serchByName(this.serchInputText.text);
            }
            return;
        }// end function

        private function cancelSearch(event:MouseEvent = null) : void
        {
            this.serchInputText.text = "";
            this.cancelSeachBtn.visible = false;
            this.currentArr = this.friendData.friendArr;
            this.totalPage = this.friendData.friendArr.length % FriendListContainer.CAPACITY_NUM == 0 ? (this.friendData.friendArr.length / FriendListContainer.CAPACITY_NUM) : (Math.floor(this.friendData.friendArr.length / FriendListContainer.CAPACITY_NUM + 1));
            if (this.totalPage == 0)
            {
                this.totalPage = 1;
            }
            this.pageText.text = this.currentPage.toString() + "/" + this.totalPage;
            this.friendContainer.refreshFriendData(this.currentArr);
            return;
        }// end function

        private function onTextInput(event:TextEvent) : void
        {
            return;
        }// end function

        private function searchFriends(event:MouseEvent) : void
        {
            if (StringUtil.trim(this.serchInputText.text) != "")
            {
                this.serchByName(this.serchInputText.text);
            }
            else
            {
                this.currentArr = this.friendData.friendArr;
                this.friendContainer.refreshFriendData(this.currentArr);
            }
            return;
        }// end function

        private function serchByName(param1:String) : void
        {
            if (this.fMode == 0)
            {
                SMZTController.getInstance().initFriendList(this.currentPage, URI.escapeChars(StringUtil.trim(param1)));
            }
            else
            {
                SMZTController.getInstance().initAffiliateList(this.currentPage, URI.escapeChars(StringUtil.trim(param1)));
            }
            return;
        }// end function

        public function refreshFriendList(event:MouseEvent = null) : void
        {
            if (this.fMode == 0)
            {
                SMZTController.getInstance().initFriendList(this.currentPage);
            }
            else
            {
                SMZTController.getInstance().initAffiliateList(this.currentPage);
            }
            return;
        }// end function

        private function goFirst(event:MouseEvent) : void
        {
            this.currentPage = 1;
            this.refreshFriendList();
            this.cancelSeachBtn.visible = false;
            return;
        }// end function

        private function goLast(event:MouseEvent) : void
        {
            this.currentPage = this.totalPage;
            this.refreshFriendList();
            this.cancelSeachBtn.visible = false;
            return;
        }// end function

        private function goPrev(event:MouseEvent) : void
        {
            if (this.currentPage <= 1)
            {
                return;
            }
            (this.currentPage - 1);
            this.refreshFriendList();
            return;
        }// end function

        private function goNext(event:MouseEvent) : void
        {
            if (this.currentPage >= this.totalPage)
            {
                return;
            }
            (this.currentPage + 1);
            this.refreshFriendList();
            return;
        }// end function

        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            if (this.friendData.friendArr.length < 1)
            {
                this.currentPage = 1;
                this.totalPage = 1;
            }
            else
            {
                this.currentPage = this.friendData.friendArr[0].currentPage;
                this.totalPage = this.friendData.friendArr[0].totalPage;
            }
            this.currentArr = this.friendData.friendArr;
            this.friendContainer.refreshFriendData(this.currentArr);
            this.pageText.text = this.currentPage.toString() + "/" + this.totalPage;
            return;
        }// end function

        public function get activate() : Boolean
        {
            return this._activate;
        }// end function

        public function set activate(param1:Boolean) : void
        {
            this._activate = param1;
            this._fakeBtn.visible = !param1;
            return;
        }// end function

        public function get totalPage() : int
        {
            return this._totalPage;
        }// end function

        public function set totalPage(param1:int) : void
        {
            this._totalPage = param1;
            return;
        }// end function

        public function get currentPage() : int
        {
            return this._currentPage;
        }// end function

        public function set currentPage(param1:int) : void
        {
            this._currentPage = param1;
            return;
        }// end function

    }
}
