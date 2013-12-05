package project.view.module.alert
{
	/**
	 * 鼠标点击场景任意位置则隐藏
	* 描述：有一个提示文本框，各种按钮(需要根据情况隐藏相应的按钮)，一个确认按钮
	* 返回错误，要求购买等，扩充背包，购买VIP权限等提示
	* 
	*/
	import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
	import project.config.ApplicationConfig;
	import project.config.ItemCategory;
	import project.config.LocalConfig;
	import project.config.PropConfig;
	import project.controller.NewBieControler;
	import project.model.newBie.NewBieModelId;
	
	import project.controller.SMZTController;
	import project.model.data.PlayerData;
	import project.model.item.ItemModel;
	import project.model.ItemBuilder;
	import project.model.ModelLocator;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;

    

    public class AlertConfirmPane extends BaseTitleWindow
    {
        private var _type:int = 0;
        private var _isWeaponShowed:Boolean = false;
        private var _isSkillShowed:Boolean = false;
        private var _isOfficeShowed:Boolean = false;
       
        private var infoText:TextField;
        private var yesBtn:MovieClipButton;
        private var _errorType:String;
        private static var alertConfirmPane:AlertConfirmPane;
        public static const ALERT_YES:String = "ALERT_YES";
		private var _initY:Number = 36.45;
		private var _initHeight:Number = 103.5;
		private var _initWidth:Number = 288.05;

        public function AlertConfirmPane()
        {
            if (alertConfirmPane != null)
            {
                throw new Error("Error");
            }
            this.showEffect = true;
            setSpriteInstance("AlertConfirmPane");
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
            this.yesBtn.addEventListener(MouseEvent.CLICK, this.hide);
           
            return;
        }// end function



        /*protected function beYellowClick(event:MouseEvent) : void
        {
            navigateToURL(new URLRequest("http://pay.qq.com/qzone/index.shtml?aid=game100620927.yop&paytime=year"), "_blank");
            this.hide();
            return;
        }// end function*/


        override protected function onAddToStage(event:Event) : void
        {
            var t:Timer;
            var tt:Function;
            //var event:* = event;
            tt = function (event:TimerEvent) : void
            {
				if (stage){
                stage.addEventListener(MouseEvent.CLICK, stageC);
				}
                t.removeEventListener(TimerEvent.TIMER, tt);
                t = null;
                return;
            };
            t = new Timer(200);
            t.addEventListener(TimerEvent.TIMER, tt);
            t.start();
            return;
        }// end function

		
        private function exBtnClick(event:MouseEvent) : void
        {
            var _loc_2:String = null;
            switch(event.currentTarget)
            {
               
                default:
                {
                    break;
                }
            }
            this.hide();
            return;
        }// end function


        private function onCheckBack(param1:XML) : void
        {
            /*var _loc_2:ItemModel = null;
            var _loc_3:ItemModel = null;
            if (param1.hasOwnProperty("UserPackage"))
            {
                _loc_2 = ItemBuilder.createItem(ItemCategory.ITEM, param1.UserPackage.@ItemId, 0, param1.UserPackage.@ItemId);
                _loc_2.itemId = param1.UserPackage.@ItemId;
                _loc_2.sId = param1.UserPackage.@Id;
                QuickPurchasePane.getInstance().type = 0;
                QuickPurchasePane.getInstance().mode = 1;
                QuickPurchasePane.getInstance().itemModel = _loc_2;
                QuickPurchasePane.getInstance().show(true);
            }
            else
            {
                _loc_3 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
                _loc_3.itemId = param1.Offer.@PropId;
                _loc_3.sId = param1.Offer.@Id;
                _loc_3.shopPrice = param1.Offer.@Silver;
                _loc_3.shopPriceRMB = param1.Offer.@Gold;
                QuickPurchasePane.getInstance().type = 0;
                QuickPurchasePane.getInstance().mode = 0;
                QuickPurchasePane.getInstance().itemModel = _loc_3;
                QuickPurchasePane.getInstance().show(true);
            }
            return;*/
        }// end function

        override public function hide(event:MouseEvent = null) : void
        {
            var event:* = event;
            if (this.errorType == "NeedLogin")
            {
                try
                {
                    if (ApplicationConfig.mainConfig.appURL.@method == "JS")
                    {
                        ExternalInterface.call(ApplicationConfig.mainConfig.appURL);
                    }
                    else
                    {
                        navigateToURL(new URLRequest(ApplicationConfig.mainConfig.appURL), "_top");
                    }
                }
                catch (e:Error)
                {
                }
            }
            this.errorType = "";
            this.type = 0;
            if (rootContainer)
            {
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
                if (rootContainer.contains(this))
                {
                    rootContainer.removeChild(this);
                }
                isOpened = false;
                isPopUP = false;
            }
           
			//-------------------新手引导用--购买金币卡包后关掉提示窗口---------------------
			/*if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && NewBieControler.getInstance().currentNewBieModle.stepId==NewBieControler.BUY_GOLD_OVER) {
				NewBieControler.getInstance().nextStep();
				}*/
			//酒馆
			if (!NewBieControler.getInstance().finishDic[NewBieModelId.TAVER] && NewBieControler.getInstance().currentNewBieModle.modelId==NewBieModelId.TAVER) {
				NewBieControler.getInstance().nextStep();
				}
			//--------------------end--------------------
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

		/**
		 * 场景点击就隐藏
		 * @param	event
		 */
        protected function stageC(event:MouseEvent) : void
        {
            if (this.stage)
            {
                if (this.stage.hasEventListener(MouseEvent.CLICK))
                {
                    this.stage.removeEventListener(MouseEvent.CLICK, this.stageC);
                }
            }
            this.hide();
            return;
        }// end function

		/**
		 * 显示
		 * @param	param1内容
		 * @param	param2
		 * @param	param3
		 */
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
            }
            return;
        }// end function

       

        override protected function onRemoveFromStage(event:Event) : void
        {
            this.type = 0;
            if (this.stage)
            {
                if (this.stage.hasEventListener(MouseEvent.CLICK))
                {
                    this.stage.removeEventListener(MouseEvent.CLICK, this.stageC);
                }
            }
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function set type(param1:int) : void
        {
            this._type = param1;
            switch(this._type)
            {
                case 0:
                {
                    break;
                }
                
                default:
                {
                    break;
                }
            }
            return;
        }// end function

      

        public function get errorType() : String
        {
            return this._errorType;
        }// end function

        public function set errorType(param1:String) : void
        {
            this._errorType = param1;
            return;
        }// end function

        public static function getInstance() : AlertConfirmPane
        {
            if (alertConfirmPane == null)
            {
                alertConfirmPane = new AlertConfirmPane;
            }
            return alertConfirmPane;
        }// end function

    }
}
