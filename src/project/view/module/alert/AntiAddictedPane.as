package project.view.module.alert
{
	/**
	 * 反上隐
	*描述：一个文本框，一个按钮
	*
	*/
    import project.config.*;
    import project.model.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class AntiAddictedPane extends BaseTitleWindow
    {
        private var infoText:TextField;
        private var yesBtn:MovieClipButton;
        private static var ap:AntiAddictedPane;

        public function AntiAddictedPane()
        {
            if (ap)
            {
                throw new Error("Error");
            }
            this.showEffect = false;
            setSpriteInstance("AntiAddictedPane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText = getChild("txt") as TextField;
            this.yesBtn = getChild("yes") as MovieClipButton;
            this.yesBtn.addEventListener(MouseEvent.CLICK, this.hide);
            return;
        }// end function

        override public function hide(event:MouseEvent = null) : void
        {
            super.hide(event);
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA)
            {
                navigateToURL(new URLRequest("http://game.weibo.com/home/user/authResultOk"), "_top");
            }
            return;
        }// end function

        override public function show(param1:Boolean = false) : void
        {
            if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
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
                rootContainer.addChild(this);
                this.infoText.htmlText = param1;
                if (this.infoText.textWidth < 250)
                {
                    this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'CENTER\'><FONT FACE=\'Microsoft YaHei\' SIZE=\'14\' COLOR=\'#000000\' LETTERSPACING=\'0\' KERNING=\'0\'>" + param1 + "</FONT></P></TEXTFORMAT>";
                }
                else
                {
                    this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'LEFT\'><FONT FACE=\'Microsoft YaHei\' SIZE=\'14\' COLOR=\'#000000\' LETTERSPACING=\'0\' KERNING=\'0\'>      " + param1 + "</FONT></P></TEXTFORMAT>";
                }
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            }
            return;
        }// end function

        public static function getInstance() : AntiAddictedPane
        {
            if (!ap)
            {
                ap = new AntiAddictedPane;
            }
            return ap;
        }// end function

    }
}
