package project.view.module.friendpane
{
    import project.config.*;
    import project.model.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;

    public class GetStudentPane extends BaseTitleWindow
    {
        private static var feedPane:GetStudentPane;

        public function GetStudentPane(param1:Boolean = true)
        {
            super(param1);
            setSpriteInstance("GetStudentPane");
            this.configureUIInstance();
            return;
        }// end function

        private function configureUIInstance() : void
        {
            (getChild("geti") as MovieClipButton).onClick = this.inviteFrClick;
            (getChild("labs") as MovieClip).gotoAndStop(ModelLocator.getInstance().snsType);
            (getChild("bg") as MovieClip).gotoAndStop(1);
            if (ModelLocator.getInstance().isQQRelated())
            {
                (getChild("labs") as MovieClip).visible = false;
                (getChild("bg") as MovieClip).gotoAndStop(2);
            }
            return;
        }// end function

        private function inviteFrClick(event:MouseEvent) : void
        {
            var _loc_2:* = ApplicationConfig.mainConfig.invite.@method;
            trace(_loc_2);
            switch(_loc_2)
            {
                case "JS":
                {
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call(ApplicationConfig.mainConfig.invite);
                    }
                    break;
                }
                case "HTTP":
                {
                    navigateToURL(new URLRequest(ApplicationConfig.mainConfig.invite), ApplicationConfig.mainConfig.invite.@target);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public static function getInstance() : GetStudentPane
        {
            if (feedPane == null)
            {
                feedPane = new GetStudentPane;
            }
            return feedPane;
        }// end function

    }
}
