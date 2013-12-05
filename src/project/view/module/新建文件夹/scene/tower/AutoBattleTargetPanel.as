package project.view.module.scene.tower
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.model.tower.TowerStateModle;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.view.base.BaseTitleWindow;
	import project.view.module.alert.AlertConfirmPane;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	
	/**
	 * 自动战斗的目标层数面板
	 * @author bbjxl 2013
	 */
	public class AutoBattleTargetPanel extends BaseTitleWindow
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _yes:MovieClipButton;
		private var _addBt:MovieClipButton;
		private var _reduceBt:MovieClipButton;
		private var _inputText:TextField;
		//-----------------------数据---------------------------------
		private var _callBack:Function=null;
		//-----------------------事件--------------------------------
		private static var _instance:AutoBattleTargetPanel;
		
		public function AutoBattleTargetPanel()
		{
			if (_instance != null)
			{
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
			}
			setSpriteInstance("autoBattleTargetPanel");
			configerUIInstance();
		}
		
		private function configerUIInstance():void
		{
			_inputText = getChild("inputText") as TextField;
			_inputText.type = TextFieldType.INPUT;
			_inputText.autoSize = TextFieldAutoSize.CENTER;
			_inputText.multiline = false;
			_inputText.restrict = "0-9";
			_inputText.maxChars = 3;
			_inputText.addEventListener(Event.CHANGE, changeHandler);
			_inputText.addEventListener(FocusEvent.FOCUS_IN, inputTextFocusIn);
			
			_reduceBt = getChild("reduceBt") as MovieClipButton;
			_addBt = getChild("addBt") as MovieClipButton;
			_reduceBt.visible = false;
			_addBt.visible = false;
			_yes = getChild("yes") as MovieClipButton;
			_reduceBt.onClick = clickHandler;
			_addBt.onClick = clickHandler;
			_yes.onClick = clickHandler;
		}
		
		private function inputTextFocusIn(e:FocusEvent):void
		{
			_inputText.setSelection(0, _inputText.length);
			
		}
		
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
				_inputText.text = TowerStateModle.getInstance().lv.id.toString();
				
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
				stage.focus = _inputText;
            }
            this.playShowSound();
            return;
        }// end function
		
		private function changeHandler(e:Event = null):void
		{
			
			var inputNum:int = int(_inputText.text);
			
			if (inputNum > 100)
			{
				_inputText.text = "100";
			}
			else
			{
				_inputText.text = inputNum.toString();
			}
			
			_inputText.setSelection(_inputText.length, _inputText.length);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var temp:int = int(_inputText.text);
			switch (e.currentTarget)
			{
				case _reduceBt:
					if (temp > 1)
					{
						temp--;
						_inputText.text = temp.toString();
					}
					break;
				case _addBt:
					
					if (temp < 100)
					{
						temp++;
						_inputText.text = temp.toString();
					}
					break;
				case _yes: 
					if (int(_inputText.text)<TowerStateModle.getInstance().lv.id)
					{
						//最低为当前要挑战的层
						//_inputText.text = TowerStateModle.getInstance().lv.id.toString();
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TowerScene.AutoBattleTip.@Text);//给出提示
						return;
					}
					hide();
					if (_callBack != null) {
						_callBack.call(null, int(_inputText.text));
						}
					break;
			}
			changeHandler();
		}
		
		public static function getInstance():AutoBattleTargetPanel
		{
			if (_instance == null)
			{
				_instance = new AutoBattleTargetPanel;
			}
			return _instance;
		} // end function
		
		public function get callBack():Function 
		{
			return _callBack;
		}
		
		public function set callBack(value:Function):void 
		{
			_callBack = value;
			changeHandler();
		}
	
	}

}