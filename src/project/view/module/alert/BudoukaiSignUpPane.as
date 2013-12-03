package project.view.module.alert
{
    import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import flash.events.*;

    public class BudoukaiSignUpPane extends BaseTitleWindow
    {
        private var conBtn:MovieClipButton;
        public static var bsp:BudoukaiSignUpPane;

        public function BudoukaiSignUpPane()
        {
            if (bsp)
            {
                throw new Error("Error");
            }
            setSpriteInstance("BudoukaiSignUpPane");
            this.configerUIInstance();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.conBtn = getChild("yes") as MovieClipButton;
            this.conBtn.onClick = this.signUpBudoukai;
            return;
        }// end function

        private function signUpBudoukai(event:MouseEvent) : void
        {
            SMZTController.getInstance().signUpForBudokai(this.onSignUpBack);
            return;
        }// end function

        private function onSignUpBack(param1:XML) : void
        {
            AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.BudoukaiSignUpPane.SignUp.@Text);
            SMZTSystemManager.getInstance().refreshHeartBeat();
            hide();
            return;
        }// end function

        public static function getInstance() : BudoukaiSignUpPane
        {
            if (!bsp)
            {
                bsp = new BudoukaiSignUpPane;
            }
            return bsp;
        }// end function

    }
}
