package project.view.module.alert
{
	/*
	* 描述：弹出确认，取消面板
	* 
	*/
    
    import flash.events.*;
    import flash.text.*;
	import project.config.ApplicationConfig;
	import project.controller.ApplicationController;
	import project.model.ModelLocator;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
    public class AlertSelectPane extends BaseTitleWindow
    {
        private var infoText:TextField;//显示信息
        private var yesBtn:MovieClipButton;//确定
        private var noBtn:MovieClipButton;//取消
        private var callBackFunction:Function;//回调方法
        private static var alertSelectPane:AlertSelectPane;
        public static const ALERT_YES:String = "ALERT_YES";
        public static const ALERT_NO:String = "ALERT_NO";
		
		private var _initY:Number = 36.45;
		private var _initHeight:Number = 103.5;
		private var _initWidth:Number = 288.05;

        public function AlertSelectPane()
        {
            if (alertSelectPane != null)
            {
                throw new Error("Error");
            }
            showEffect = false;
            setSpriteInstance("AlertSelectPane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText = getChild("txt") as TextField;
            this.infoText.antiAliasType = AntiAliasType.ADVANCED;
			infoText.autoSize = TextFieldAutoSize.LEFT;
			infoText.width = _initWidth;
			infoText.y = _initY;
			
            this.yesBtn = getChild("yes") as MovieClipButton;
            this.noBtn = getChild("no") as MovieClipButton;
            this.yesBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            this.noBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function
		
		override public function hide(event:MouseEvent = null) : void
        {
            if (rootContainer)
            {
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
                if (showEffect)
                {
                    TweenLite.to(this, 0.3, {alpha:0.2, y:this.y - 40, onComplete:this.onTweenClose});
                }
                else
                {
                    if (rootContainer.contains(this))
                    {
                        rootContainer.removeChild(this);
                    }
                    this.isOpened = false;
                    this.isPopUP = false;
                }
				
				if (noBtn) {
					ApplicationController.removeAtWin(this);
					}
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
        private function clickHandler(event:MouseEvent) : void
        {
            if (this.callBackFunction != null)
            {
                if (event.currentTarget == this.yesBtn)
                {
					hide();
                    this.callBackFunction.call(null, ALERT_YES);
                    
                }
                else
                {
					hide();
                    this.callBackFunction.call(null, ALERT_NO);
                    
                }
            }
            return;
        }// end function

		/**
		 * 
		* @param 显示的内容
		* @param 回调方法
		* @param 是否屏蔽下面的内容的鼠标响应
		*/
        public function showMessage(param1:String, param2:Function = null, param3:Boolean = true) : void
        {
            if (isOpened)
            {
                hide();
            }
            else if (rootContainer)
            {
                if (param3)
                {
                    drawModalRect();
                }
				
				
                this.callBackFunction = param2;
                rootContainer.addChild(this);
                this.infoText.htmlText = param1;
                if (this.infoText.textWidth < 250)
                {
                    this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'CENTER\'><FONT FACE=\'" + ApplicationConfig.mainConfig.appFont + "\' SIZE=\'13\' COLOR=\'#ffffff\' LETTERSPACING=\'0\' KERNING=\'0\'>" + param1 + "</FONT></P></TEXTFORMAT>";
                }
                else if (ModelLocator.getInstance().snsType == ModelLocator.SNS_MIXI)
                {
                    this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'LEFT\'><FONT FACE=\'" + ApplicationConfig.mainConfig.appFont + "\' SIZE=\'13\' COLOR=\'#ffffff\' LETTERSPACING=\'0\' KERNING=\'0\'>" + param1 + "</FONT></P></TEXTFORMAT>";
                }
                else
                {
                    this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'LEFT\'><FONT FACE=\'" + ApplicationConfig.mainConfig.appFont + "\' SIZE=\'13\' COLOR=\'#ffffff\' LETTERSPACING=\'0\' KERNING=\'0\'>      " + param1 + "</FONT></P></TEXTFORMAT>";
                }
				
				infoText.y = _initY + (_initHeight - infoText.textHeight) >> 1;
				
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (noBtn) {
					ApplicationController.pushWin(this);
					}
            }
            return;
        }// end function

        public static function getInstance() : AlertSelectPane
        {
            if (alertSelectPane == null)
            {
                alertSelectPane = new AlertSelectPane;
            }
            return alertSelectPane;
        }// end function

    }
}
