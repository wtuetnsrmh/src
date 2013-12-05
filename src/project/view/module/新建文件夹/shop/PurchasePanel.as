package project.view.module.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.data.PlayerData;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.lottery.LotteryPanel;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * 购买弹出框
	 * @author bbjxl
	 */
	public class PurchasePanel extends BaseTitleWindow 
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
		private var _rechargeBt:MovieClipButton;
		private var _yes:MovieClipButton;
		private var _goodImage:BaseIcoCellLoader;//图片
		//-----------------------数据---------------------------------
		private var _goodModel:GoodsModel;
		//-----------------------事件--------------------------------
		private static var _instance:PurchasePanel;
		public function PurchasePanel() 
		{
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("purchasePanel");
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
			_rechargeBt = getChild("rechargeBt") as MovieClipButton;
			_rechargeBt.visible = false;
			_yes = getChild("yes") as MovieClipButton;
			
			_goodImage = new BaseIcoCellLoader();
			_goodImage.restrictHW = 51;
			_goodImage.showBg = false;
			_goodImage.setLocation(36.15, 41.85);
			addChild(_goodImage);
			
			
			_reduceBt.onClick = clickHandler;
			_addBt.onClick = clickHandler;
			_rechargeBt.onClick = clickHandler;
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
					
			switch(_goodModel.priceType) {
				case PurchaseType.FREE:
					_numText1.text = "0";
					_numText2.text = "0";
					break;
				case PurchaseType.CRYSTAL:
					
					_numText1.text = _goodModel.crystal.toString();
					_numText2.text = String(_goodModel.crystal * int(_inputText.text));
					if (int(_numText2.text) > PlayerData.getInstance().crystal) {
						//大于最多能买的数时显示最多能买的商品个数
						_inputText.text = Math.floor(PlayerData.getInstance().crystal / _goodModel.crystal).toString();
						_numText2.text = String(_goodModel.crystal * int(_inputText.text));
						}
					break;
				case PurchaseType.GOLD:
					_numText1.text = _goodModel.gold.toString();
					_numText2.text = String(_goodModel.gold * int(_inputText.text));
					if (int(_numText2.text) > PlayerData.getInstance().gold) {
						//大于最多能买的数时显示最多能买的商品个数
						_inputText.text = Math.floor(PlayerData.getInstance().gold / _goodModel.gold).toString();
						_numText2.text = String(_goodModel.gold * int(_inputText.text));
						}
					break;
				/*case PurchaseType.HONOR:
					_numText1.text = _goodModel.honor.toString();
					_numText2.text = String(_goodModel.honor * int(_inputText.text));
					if (int(_numText2.text) > PlayerData.getInstance().honor) {
						//大于最多能买的数时显示最多能买的商品个数
						_inputText.text = Math.floor(PlayerData.getInstance().honor / _goodModel.honor).toString();
						_numText2.text = String(_goodModel.honor * int(_inputText.text));
						}*/
					break;
				}
				//如果购买的数量为０时不能点购买按钮
				if (int(_inputText.text) <= 0) {
					_yes.clickEnable = false;
					}else {
						_yes.clickEnable = true;
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
					
					if(temp<999){
						temp++;
						_inputText.text = temp.toString();
						}
					break;
				case _rechargeBt:
					//navigateToURL(new URLRequest(ApplicationConfig.mainConfig.chargeURL),ApplicationConfig.mainConfig.chargeURL.@method);
					Browser.charge();
					break;
				case _yes:
					SMZTController.getInstance().purchaseGoods(_goodModel.id, int(_inputText.text), _goodModel.priceType, function():void {
						//刷新背包数据
						SMZTController.getInstance().getBagData(false, function():void {
							//如果当前打开了抽奖界面则更新
							if (LotteryPanel.getInstance().isOpened) {
								LotteryPanel.getInstance().updataUI();
								}
							});
						
						AlertConfirmPane.getInstance().type = 0;
						AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.ShopScene.BuySuccess.@Text);
						
						hide();
						switch(_goodModel.priceType) {
							case PurchaseType.CRYSTAL:
								PlayerData.getInstance().crystal -= int(_numText2.text);
								break;
							case PurchaseType.GOLD:
								PlayerData.getInstance().gold -= int(_numText2.text);
								break;
							/*case PurchaseType.HONOR:
								PlayerData.getInstance().honor -= int(_numText2.text);
								break;*/
							}

						});
					break;
				}
			changeHandler();
		}
		
		public static function getInstance() : PurchasePanel
		{
			if (_instance == null)
			{
			  _instance = new PurchasePanel;
			}
			return _instance; 
		}// end function
		
		public function get goodModel():GoodsModel 
		{
			return _goodModel;
		}
		
		public function set goodModel(value:GoodsModel):void 
		{
			_inputText.text = "1";
			_goodModel = value;
			_icoMc1.gotoAndStop(_goodModel.priceType+1);
			_icoMc2.gotoAndStop(_goodModel.priceType+1);
			_nameText.text = _goodModel.name;
			switch(_goodModel.priceType) {
				case PurchaseType.GOLD:
					//金币不显示充值
					_rechargeBt.visible = false;
					_numText1.text = _goodModel.gold.toString();
					_numText2.text = String(_goodModel.gold * int(_inputText.text));
					break;
				case PurchaseType.CRYSTAL:
					_rechargeBt.visible = true;
					_numText1.text = _goodModel.crystal.toString();
					_numText2.text = String(_goodModel.crystal * int(_inputText.text));
					break;
				/*case PurchaseType.HONOR:
					//荣誉不显示充值
					_rechargeBt.visible = false;
					_numText1.text = _goodModel.honor.toString();
					_numText2.text = String(_goodModel.honor * int(_inputText.text));
					break;*/
				}
			_goodImage.ico = _goodModel.imageUrl;
			
			changeHandler();
		}
	}

}