package project.view.module.feed
{
    import project.view.base.*;
    import flash.display.*;
    import flash.events.*;

    public class FeedTabBar extends BaseSpritePane
    {
        private var allBtn:SimpleButton;
        private var characterBtn:SimpleButton;
        private var budoukaiBtn:SimpleButton;
        private var friendBtn:SimpleButton;
        private var _currentSelectedIndex:int = 1;

        public function FeedTabBar()
        {
            setSpriteInstance("FeedTabBar");
            setLocation(43, 48);
            this.configerUIInstance();
            (spriteInstance as MovieClip).gotoAndStop(1);
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.allBtn = getChild("all") as SimpleButton;
            this.characterBtn = getChild("character") as SimpleButton;
            this.budoukaiBtn = getChild("budoukai") as SimpleButton;
            this.friendBtn = getChild("friend") as SimpleButton;
            this.allBtn.addEventListener(MouseEvent.CLICK, this.tabClick);
            this.characterBtn.addEventListener(MouseEvent.CLICK, this.tabClick);
            this.budoukaiBtn.addEventListener(MouseEvent.CLICK, this.tabClick);
            this.friendBtn.addEventListener(MouseEvent.CLICK, this.tabClick);
            return;
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
            this._currentSelectedIndex = 1;
            (spriteInstance as MovieClip).gotoAndStop(1);
            return;
        }// end function

        private function tabClick(event:MouseEvent) : void
        {
            switch(event.currentTarget)
            {
                case this.allBtn:
                {
                    this._currentSelectedIndex = 1;
                    (spriteInstance as MovieClip).gotoAndStop(1);
                    break;
                }
                case this.characterBtn:
                {
                    this._currentSelectedIndex = 2;
                    (spriteInstance as MovieClip).gotoAndStop(2);
                    break;
                }
                case this.budoukaiBtn:
                {
                    this._currentSelectedIndex = 3;
                    (spriteInstance as MovieClip).gotoAndStop(3);
                    break;
                }
                case this.friendBtn:
                {
                    this._currentSelectedIndex = 4;
                    (spriteInstance as MovieClip).gotoAndStop(4);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get currentSelectedIndex() : int
        {
            return this._currentSelectedIndex;
        }// end function

        public function set currentSelectedIndex(param1:int) : void
        {
            this._currentSelectedIndex = param1;
            return;
        }// end function

    }
}
