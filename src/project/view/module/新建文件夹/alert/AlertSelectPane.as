package project.view.module.alert
{
	import flash.text.TextFieldAutoSize;
	import khaos.view.ViewType;
	import project.view.common.LogicView;
	import project.view.common.MyButton;
	import starling.events.Event;
	import starling.text.TextField;
	/*
	* 描述：弹出确认，取消面板
	* 
	*/
    
   
	
    public class AlertSelectPane extends LogicView
    {
        private var infoText:TextField;//显示信息
        private var yesBtn:MyButton;//确定
        private var noBtn:MyButton;//取消
        private var callBackFunction:Function;//回调方法
        public static const ALERT_YES:String = "ALERT_YES";
        public static const ALERT_NO:String = "ALERT_NO";
		
		private var _initY:Number = 36.45;
		private var _initHeight:Number = 103.5;
		private var _initWidth:Number = 288.05;
        public function AlertSelectPane()
        {
			super(ViewType.SINGLE_DIALOG);
            showEffect = false;
           
            return;
        }// end function
		
		//初始化UI
		public function initUI():void
		{
			this.infoText = ApplictionConfig.creaText(_initWidth, _initHeight, "");
			infoText.autoSize = TextFieldAutoSize.LEFT;
			infoText.y = _initY;
			
            this.yesBtn = ApplictionConfig.creaMyBt("tabBarDefault", "确定");
            this.noBtn =  ApplictionConfig.creaMyBt("tabBarDefault", "取消");
            this.yesBtn.addEventListener(Event.TRIGGERED, this.clickHandler);
            this.noBtn.addEventListener(Event.TRIGGERED, this.clickHandler);
		}
		
		//如果当前模块有单独的ui tx则这里构建此tx相关的ui界面,每次internalShow都要调用
		protected function cardTexturUI():void
		{
		
		}
		
		protected function disposeTexturUI():void
		{
		
		}
		
		protected function internalHide():void
		{
			//throw new ArgumentError("This function is not implemented!");
		}
		
		protected function internalShow():void
		{
			//throw new ArgumentError("This function is not implemented!");
		}
		
        	
        private function clickHandler(event:Event) : void
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
			show(param3);
			this.callBackFunction = param2;
			this.infoText.htmlText = param1;
			infoText.y = _initY + (_initHeight - infoText.textHeight) >> 1;
			this.x = (ApplictionConfig.STAGE_WIDTH - this.width) / 2;
            this.y = (ApplictionConfig.STAGE_HEIGHT - this.height) / 2;
			
            /*if (this.isVisible())
            {
                hide();
            }
            else
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
				
				*/
            }
            return;
        }// end function

    
		
		

    }
}
