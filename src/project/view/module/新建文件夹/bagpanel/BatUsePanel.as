package project.view.module.bagpanel 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.item.ItemModel;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.cell.BaseIcoCellLoader;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * 批量使用弹出框
	 * 
	 * @author bbjxl
	 */
	public class BatUsePanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
				
		//-----------------------UI---------------------------------
		private var _nameText:TextField;
		private var _inputText:TextField;
		private var _reduceBt:MovieClipButton;
		private var _addBt:MovieClipButton;
		private var _yes:MovieClipButton;
		private var _goodImage:BaseIcoCellLoader;//图片
		//-----------------------数据---------------------------------
		private var _itemModel:ItemModel;
		//-----------------------事件--------------------------------
		private static var _instance:BatUsePanel;
		public function BatUsePanel() 
		{
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("batUselPanel");
			configerUIInstance();
		}
		
		private function configerUIInstance():void 
		{
			_nameText = getChild("nameText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.CENTER;

			_inputText = getChild("inputText") as TextField;
			_inputText.type = TextFieldType.INPUT;
			_inputText.autoSize = TextFieldAutoSize.CENTER;
			_inputText.multiline = false;
			_inputText.restrict = "0-9";
			_inputText.maxChars = 3;
			_inputText.addEventListener(Event.CHANGE, changeHandler);
			_inputText.addEventListener(FocusEvent.FOCUS_IN, inputTextFocusIn);
			
			//_icoMc1 = getChild("icoMc1") as MovieClip;
			//_icoMc2 = getChild("icoMc2") as MovieClip;
			
			_reduceBt = getChild("reduceBt") as MovieClipButton;
			_addBt = getChild("addBt") as MovieClipButton;
			//_rechargeBt = getChild("rechargeBt") as MovieClipButton;
			_yes = getChild("yes") as MovieClipButton;
			
			_goodImage = new BaseIcoCellLoader();
			_goodImage.restrictHW = 51;
			_goodImage.setLocation(36.15, 41.85);
			addChild(_goodImage);
			
			
			_reduceBt.onClick = clickHandler;
			_addBt.onClick = clickHandler;
			//_rechargeBt.onClick = clickHandler;
			_yes.onClick = clickHandler;
		}
		
		private function inputTextFocusIn(e:FocusEvent):void 
		{
			_inputText.setSelection(0,_inputText.length);
		}
		
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
                if (this.showEffect)
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
		
		private function changeHandler(e:Event=null):void 
		{
			
			var inputNum:int = int(_inputText.text);
			if (inputNum == 0) {
				_inputText.text = "1";
				}else {
					_inputText.text = inputNum.toString();
					}
					
			if (int(_inputText.text) > _itemModel.number) {
				//大于最多能卖的物品数时
				_inputText.text = _itemModel.number.toString();
				}
				
			
			_inputText.setSelection(_inputText.length,_inputText.length);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var temp:int = int(_inputText.text);
			switch(e.currentTarget) {
				case _reduceBt:
					if(temp>1){
						temp--;
						_inputText.text = temp.toString();
						}
					break;
				case _addBt:
					
					if(temp<_itemModel.number){
						temp++;
						_inputText.text = temp.toString();
						}
					break;
				
				case _yes:
					UseItemControler.batUserItem(_itemModel,int(_inputText.text), function():void {
						//trace("更新背包数据1")
						//更新个货币数量
						SMZTUIManager.getInstance().mainPane.refreshSelfData();
						//更新背包数据
						SMZTController.getInstance().getBagData(true);
						hide();
						});
					break;
				}
			changeHandler();
		}
		
		public static function getInstance() : BatUsePanel
		{
			if (_instance == null)
			{
			  _instance = new BatUsePanel;
			}
			return _instance; 
		}// end function
		
		public function get itemModel():ItemModel 
		{
			return _itemModel;
		}
		
		public function set itemModel(value:ItemModel):void 
		{
			_inputText.text =value.number.toString();
			_itemModel = value;
			_nameText.text = _itemModel.name;
			_goodImage.ico = _itemModel.ico;
			
			changeHandler();
		}
	}

}