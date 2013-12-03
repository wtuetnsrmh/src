package project.view.module.alert
{
    import project.config.*;
    import project.controller.*;
    import project.model.*;
    import project.model.data.*;
    
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.bagpane.*;
    import project.view.module.loading.*;
    
    import flash.events.*;
    import flash.text.*;

    public class NewbieAlertPane extends BaseTitleWindow
    {
        private var infoText:TextField;
        private var yesBtn:MovieClipButton;
        private var callBackFunction:Function;
        public var fuck5:int = 0;
        private static var newAlertPane:NewbieAlertPane;
        public static const ALERT_YES:String = "ALERT_YES";
        public static const ALERT_NO:String = "ALERT_NO";

        public function NewbieAlertPane()
        {
            if (newAlertPane != null)
            {
                throw new Error("Error");
            }
            this.showEffect = false;
            setSpriteInstance("NewbieAlertPane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.infoText = getChild("txt") as TextField;
            this.infoText.antiAliasType = AntiAliasType.ADVANCED;
            this.yesBtn = getChild("yes") as MovieClipButton;
            this.yesBtn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        override public function hide(event:MouseEvent = null) : void
        {
            super.hide();
            if (this.fuck5 != 0)
            {
                this.fuck5 = 0;
                ItemBagPane.getInstance().switch2ItemTab();
                ItemBagPane.getInstance().show(true);
                LockScreen.getInstance().show(true);
                SMZTController.getInstance().initPlayerBag(this.onCallBack);
                SMZTController.getInstance().getJewelryData();
                SMZTController.getInstance().getSuitData();
            }
            return;
        }// end function

        private function onCallBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
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
                this.infoText.htmlText = param1;
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2;
                isOpened = true;
                isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            }
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            var _loc_2:* = PlayerData.getInstance().currentNewbieQuest;
            SMZTController.getInstance().submitNewbieTask(_loc_2.questId, this.onNewbieTaskEnd);
            return;
        }// end function

        private function onNewbieTaskEnd(param1:XML) : void
        {
            if (this.callBackFunction != null)
            {
                this.callBackFunction.call(null, ALERT_YES);
            }
            PlayerData.getInstance().currentNewbieQuest.taskName = "Complete";
            this.hide();
            if (HelpPane.getInstance().isOpened)
            {
                HelpPane.getInstance().hide();
            }
            SMZTController.getInstance().initPlayerInfo(ModelLocator.getInstance().currentUId);
            return;
        }// end function

        public static function getInstance() : NewbieAlertPane
        {
            if (newAlertPane == null)
            {
                newAlertPane = new NewbieAlertPane;
            }
            return newAlertPane;
        }// end function

    }
}
