package project.view.module.helppane
{
	/*
	* 描述：帮助面板
	* 
	*/
    import project.view.base.BaseSpritePane;

    public class HelpPane extends BaseSpritePane
    {
        private static var helpPane:HelpPane;

        public function HelpPane()
        {
            if (helpPane != null)
            {
                throw new Error("Error");
            }
            return;
        }// end function

        public function playInstance(param1:String) : void
        {
            setSpriteInstance(param1);
            this.show();//再触发就HIDE
            return;
        }// end function

        override public function show(param1:Boolean = false) : void
        {
            if (_isOpened)
            {
                hide();
            }
            else if (_rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                _rootContainer.addChild(this);
                _isOpened = true;
            }
            return;
        }// end function

        public static function getInstance() : HelpPane
        {
            if (helpPane == null)
            {
                helpPane = new HelpPane;
            }
            return helpPane;
        }// end function

    }
}
