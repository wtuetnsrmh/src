package project.view.module.alert
{
	/**
	*描述：确认按钮，分享按钮
	*
	*/
    import project.config.ApplicationConfig;
    import project.view.artplug.MovieClipButton;
    import project.view.base.BaseTitleWindow;
    import flash.events.*;
    import flash.text.*;

    public class AlertSharePane extends BaseTitleWindow
    {
        private var infoText:TextField;
        private var yesBtn:MovieClipButton;
        private var noBtn:MovieClipButton;
        private var callBackFunction:Function;
        private static var alertSharePane:AlertSharePane;
        public static const ALERT_YES:String = "ALERT_YES";
        public static const ALERT_NO:String = "ALERT_NO";

        public function AlertSharePane()
        {
            if (alertSharePane != null)
            {
                throw new Error("Error");
            }
            showEffect = false;
            setSpriteInstance("AlertSharePane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText = getChild("txt") as TextField;
            this.yesBtn = getChild("yes") as MovieClipButton;
            this.noBtn = getChild("no") as MovieClipButton;
            this.yesBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.noBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            if (event.currentTarget == this.yesBtn)
            {
                ShareSelectPane.getInstance().type = 0;
                ShareSelectPane.getInstance().show(true);
                hide();
            }
            else
            {
                hide();
            }
            return;
        }// end function

        public function showMessage(param1:String, param2:Function = null, param3:Boolean = true) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param3)
                {
                    drawModalRect();
                }
                this.callBackFunction = param2;
                rootContainer.addChild(this);
                this.infoText.text = param1;
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            }
            return;
        }// end function

        public static function getInstance() : AlertSharePane
        {
            if (alertSharePane == null)
            {
                alertSharePane = new AlertSharePane;
            }
            return alertSharePane;
        }// end function

    }
}
