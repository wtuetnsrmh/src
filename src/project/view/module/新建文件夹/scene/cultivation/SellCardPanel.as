package project.view.module.scene.cultivation 
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
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.cultivation.CultivationModel;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.item.CardModel;
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
	import project.view.module.cell.Card;
	/**
	 * 出售卡牌弹出框
	 * 只有金币类型
	 * @author bbjxl
	 */
	public class SellCardPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
				
		//-----------------------UI---------------------------------
		private var _nameText:TextField;
		private var _numText1:TextField;
		private var _numText2:TextField;
		private var _inputText:TextField;
		private var _icoMc1:MovieClip;
		private var _icoMc2:MovieClip;
		private var _reduceBt:MovieClipButton;
		private var _addBt:MovieClipButton;
		//private var _rechargeBt:MovieClipButton;
		private var _yes:MovieClipButton;
		private var _cardImage:Card;//卡
		//-----------------------数据---------------------------------
		private var _cardModel:CardModel;
		//-----------------------事件--------------------------------
		private static var _instance:SellCardPanel;
		public function SellCardPanel() 
		{
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("sellCardPanel");
			configerUIInstance();
		}
		
		private function configerUIInstance():void 
		{
			_nameText = getChild("nameText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			_numText1 = getChild("numText1") as TextField;
			_numText1.autoSize = TextFieldAutoSize.LEFT;
			_numText1.wordWrap = false;
			_numText1.multiline = false;
			
			_numText2 = getChild("numText2") as TextField;
			_numText2.autoSize = TextFieldAutoSize.LEFT;
			_numText2.wordWrap = false;
			_numText2.multiline = false;
			
			_inputText = getChild("inputText") as TextField;
			_inputText.type = TextFieldType.INPUT;
			_inputText.autoSize = TextFieldAutoSize.CENTER;
			_inputText.multiline = false;
			_inputText.restrict = "0-9";
			_inputText.maxChars = 3;
			_inputText.addEventListener(Event.CHANGE, changeHandler);
			_inputText.addEventListener(FocusEvent.FOCUS_IN, inputTextFocusIn);
			
			_icoMc1 = getChild("icoMc1") as MovieClip;
			_icoMc2 = getChild("icoMc2") as MovieClip;
			
			_reduceBt = getChild("reduceBt") as MovieClipButton;
			_addBt = getChild("addBt") as MovieClipButton;
			//_rechargeBt = getChild("rechargeBt") as MovieClipButton;
			_yes = getChild("yes") as MovieClipButton;
			
			_cardImage = new Card();
			_cardImage._currentCardTye = 2;
			_cardImage.setLocation(30.15, 36);
			addChild(_cardImage);
			
			
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
					
			_numText1.text = _cardModel.price.toString();
			_numText2.text = String(_cardModel.price * int(_inputText.text));
			if (int(_inputText.text) > _cardModel.number) {
				//大于最多能卖的物品数时
				_inputText.text = _cardModel.number.toString();
				_numText2.text = String(_cardModel.price * int(_inputText.text));
				}
				
			_icoMc1.x = _numText1.x + _numText1.textWidth+10;
			_icoMc2.x = _numText2.x + _numText2.textWidth + 10;
			
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
					
					if(temp<_cardModel.number){
						temp++;
						_inputText.text = temp.toString();
						}
					break;
				
				case _yes:
					
					SMZTController.getInstance().sellCardById(cardModel.id, int(_inputText.text), function(param:Object):void {
						PlayerData.getInstance().deleteOneCard(cardModel.id, true,int(_inputText.text));//去掉卖掉的卡
						CultivationModel.getInstance().updata();//刷新升星界面
						//显示队列显示在舞台中间
						var temp:BonusModel = new BonusModel();
						temp.setData(param);
						SMZTUIManager.getInstance().manageShowBonus.showBonus(temp);
						hide();
						})
					
					break;
				}
			changeHandler();
		}
		
		public static function getInstance() : SellCardPanel
		{
			if (_instance == null)
			{
			  _instance = new SellCardPanel;
			}
			return _instance; 
		}// end function

		
		public function get cardModel():CardModel 
		{
			return _cardModel;
		}
		
		public function set cardModel(value:CardModel):void 
		{
			_cardModel = value;
			
			_inputText.text = "1";
			_icoMc1.gotoAndStop(PurchaseType.GOLD+1);
			_icoMc2.gotoAndStop(PurchaseType.GOLD+1);
			_nameText.htmlText = "<font color='#"+retunCardColorByQuity(value.quality)+"'>"+value.name+"</font>";
			_numText1.text = _cardModel.price.toString();
			_numText2.text = String(_cardModel.price * int(_inputText.text));
			_cardImage.setCardModel(value);
			
			changeHandler();
		}
		
		/**
		 * 根据不同的品质显示不同颜色的卡名-没有number
		 * 1	普通
		   2	良好
		   3	优秀
		   4	史诗
		   5	魔神
		   6	传说
		 */
		
		private static function retunCardColorByQuity(qu:int):String 
		{
			switch(qu) {
				case 4:
					//史诗
					return "BE3CFC";
					break;
				case 5:
					//魔神
					return "F7061E";
					break;
				case 6:
					//传说
					return "E7A22A";
					break;
				}
			return "ffffff";
		}	
	}

}