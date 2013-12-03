package project.view.module.alert
{
	/**
	 *
	 * 可以显示的内容多
	 *描述：只有一个提示的文本框和一个确定的按钮
	 *点确定后回调方法
	 */
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import flash.display.*;
	import flash.text.*;
	
	public class AlertMasterPane extends BaseTitleWindow
	{
		private var infoText:TextField;
		private var callBackFunction:Function; //回调方法
		private static var alertConfirmPane:AlertMasterPane;
		public static const ALERT_YES:String = "ALERT_YES";
		private var yesBtn:MovieClipButton; //确定
		private var _initY:Number = 45.45;
		private var _initHeight:Number = 103.5;
		private var _initWidth:Number = 288.05;
		
		public function AlertMasterPane(param1:Boolean = true)
		{
			super(param1);
			if (alertConfirmPane != null)
			{
				throw new Error("Error");
			}
			this.showEffect = false;
			setSpriteInstance("AlertMasterPane");
			this.configerUIInstance();
			return;
		} // end function
		
		private function configerUIInstance():void
		{
			this.infoText = getChild("txt") as TextField;
			infoText.autoSize = TextFieldAutoSize.LEFT;
			infoText.width = _initWidth;
			infoText.y = _initY;
			
			yesBtn = (getChild("yes") as MovieClipButton);
			yesBtn.onClick = clickHandler;
			
			return;
		} // end function
		
		private function clickHandler(event:MouseEvent):void
		{
			if (callBackFunction != null)
			{
				this.callBackFunction.call(null);
				hide();
			}
			else
			{
				//如果没有回调方法直接关闭窗口
				yesBtn.onClick = hide;
			}
			
			return;
		} // end function
		
		/**
		 * 显示提示信息
		 * @param	param1显示的内容
		 * @param	param2点确定后回调的方法
		 * @param	param3是否屏敝场景
		 */
		public function showMessage(param1:String, param2:Function = null, param3:Boolean = true):void
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
				this.infoText.htmlText = param1;
				if (this.infoText.textWidth < 250)
				{
					this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'CENTER\'><FONT FACE=\'Microsoft YaHei\' SIZE=\'14\' COLOR=\'#ffffff\' LETTERSPACING=\'0\' KERNING=\'0\'>" + param1 + "</FONT></P></TEXTFORMAT>";
				}
				else
				{
					this.infoText.htmlText = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'LEFT\'><FONT FACE=\'Microsoft YaHei\' SIZE=\'14\' COLOR=\'#ffffff\' LETTERSPACING=\'0\' KERNING=\'0\'>      " + param1 + "</FONT></P></TEXTFORMAT>";
				}
				
				infoText.y = _initY + (_initHeight - infoText.textHeight) >> 1;
				
				this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
				this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
				isOpened = true;
				isPopUP = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			return;
		} // end function
		
		public static function getInstance():AlertMasterPane
		{
			if (alertConfirmPane == null)
			{
				alertConfirmPane = new AlertMasterPane;
			}
			return alertConfirmPane;
		} // end function
	
	}
}
