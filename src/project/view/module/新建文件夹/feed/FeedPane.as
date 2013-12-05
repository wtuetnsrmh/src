package project.view.module.feed
{
    import project.config.*;
    import project.events.*;
    import project.model.data.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import flash.events.*;

    public class FeedPane extends BaseTitleWindow
    {
        private var feedTabBar:FeedTabBar;
        private var feedData:FeedData;
        private var feedContainer:FeedContainer;
        private var totalPage:int = 0;
        private var currentPage:int = 1;
        private var numPerPage:int = 5;
        private var prePageBtn:MovieClipButton;
        private var nextPageBtn:MovieClipButton;
        private static var feedPane:FeedPane;
        public static const NUM_PER_PAGE:int = 5;

        public function FeedPane()
        {
            if (feedPane != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
            setSpriteInstance("FeedPane");
            this.feedData = FeedData.getInstance();
            dataModel = this.feedData;
            this.feedTabBar = new FeedTabBar();
            this.feedContainer = new FeedContainer();
            this.feedContainer.y = 98;
            this.feedContainer.x = 53;
            dragable = false;
            this.configerUIInstance();
            this.draw();
            this.feedTabBar.addEventListener(MouseEvent.CLICK, this.tabClick);
            return;
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
            this.currentPage = 1;
            return;
        }// end function

        private function tabClick(event:MouseEvent) : void
        {
            this.currentPage = 1;
            switch(event.target.name)
            {
                case "all":
                {
                    this.totalPage = this.feedData.feedArr.length % 5 == 0 ? (this.feedData.feedArr.length / 5) : (Math.floor(this.feedData.feedArr.length / 5 + 1));
                    this.feedContainer.refreshFeedData(0, this.feedData.feedArr);
                    break;
                }
                case "character":
                {
                    this.totalPage = this.feedData.characterArr.length % 5 == 0 ? (this.feedData.characterArr.length / 5) : (Math.floor(this.feedData.characterArr.length / 5 + 1));
                    this.feedContainer.refreshFeedData(0, this.feedData.characterArr);
                    break;
                }
                case "budoukai":
                {
                    this.totalPage = this.feedData.budoukaiArr.length % 5 == 0 ? (this.feedData.budoukaiArr.length / 5) : (Math.floor(this.feedData.budoukaiArr.length / 5 + 1));
                    this.feedContainer.refreshFeedData(0, this.feedData.budoukaiArr);
                    break;
                }
                case "friend":
                {
                    this.totalPage = this.feedData.friendArr.length % 5 == 0 ? (this.feedData.friendArr.length / 5) : (Math.floor(this.feedData.friendArr.length / 5 + 1));
                    this.feedContainer.refreshFeedData(0, this.feedData.friendArr);
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.totalPage == 0)
            {
                this.totalPage = 1;
            }
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
            this.feedContainer.refreshFeedData((this.currentPage - 1) * this.numPerPage - this.numPerPage, this.getCurrentFeedData());
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
            this.feedContainer.refreshFeedData((this.currentPage + 1) * this.numPerPage - this.numPerPage, this.getCurrentFeedData());
            var _loc_2:String = this;
            var _loc_3:* = this.currentPage + 1;
            _loc_2.currentPage = _loc_3;
            return;
        }// end function

        public function getCurrentFeedData() : Array
        {
            switch(this.feedTabBar.currentSelectedIndex)
            {
                case 1:
                {
                    return this.feedData.feedArr;
                }
                case 2:
                {
                    return this.feedData.characterArr;
                }
                case 3:
                {
                    return this.feedData.budoukaiArr;
                }
                case 4:
                {
                    return this.feedData.friendArr;
                }
                default:
                {
                    return this.feedData.feedArr;
                    break;
                }
            }
        }// end function

        private function draw() : void
        {
            addChild(this.feedTabBar);
            addChild(this.feedContainer);
            return;
        }// end function

        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            this.totalPage = this.feedData.feedArr.length % 5 == 0 ? (this.feedData.feedArr.length / 5) : (Math.floor(this.feedData.feedArr.length / 5 + 1));
            if (this.totalPage == 0)
            {
                this.totalPage = 1;
            }
            this.feedContainer.refreshFeedData(this.currentPage * this.numPerPage - this.numPerPage, this.feedData.feedArr);
            return;
        }// end function

        public static function getInstance() : FeedPane
        {
            if (feedPane == null)
            {
                feedPane = new FeedPane;
            }
            return feedPane;
        }// end function

    }
}
