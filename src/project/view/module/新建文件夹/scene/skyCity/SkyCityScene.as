package project.view.module.scene.skyCity
{
	/**
	*描述：天空之城
	*
	*/
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.view.controls.ToolTip;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;

    public class SkyCityScene extends BaseGameScene
    {
        
        private var tt:ToolTip;
        
        private var _canRefresh:Boolean = true;
        

        public function SkyCityScene()
        {
			
            rubishPosArr = [[360, 300], [411, 198], [646, 261]];
            sceneId =MainScene.SKYCITY_SCENE;
            setSpriteInstance("SkyCityScene");
			
            /*this.officerFS = new OfficerForceSelectBar();
            addChild(this.officerFS);
            this._officerContainer = new OfficerContainer();
            addChild(this._officerContainer);
            this.officerPlayer = OfficerDisplayer.getInstance();
            this.officerPlayer.rootContainer = this;
            this.officerPlayer.show();
            this.officerPlayer.visible = false;*/
			
            this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.88;
            this.tt.cornerRadius = 12;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 16762389;
            this.tt.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_1;
			
           
            //dataModel =SkyCityData.getInstance();
            PlayerData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onPlayerDataChange);
            //SkyCityData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, this.onSkyCityDataRefresh);
            
            return;
        }// end function

		/**
		 * 帮助点击
		 * @param	event
		 */
        override public function showHelp(event:MouseEvent = null) : void
        {
            /*HelpPane.getInstance().playInstance("NEWBIE_SHOW_OFFICE_HELP");
            if (HelpPane.getInstance().isOpened)
            {
                helpBtn.gotoAndPlay(2);
            }
            else
            {
                helpBtn.gotoAndStop(1);
            }
            this.newbieOnly();
            return;*/
        }// end function

        public function newbieOnly() : void
        {
            /*if (this.officerContainer.selectedOfficerBox && this.officerContainer.selectedOfficerBox.item)
            {
                OfficerDisplayer.getInstance().show();
                OfficerDisplayer.getInstance().setData(this.officerContainer.selectedOfficerBox.item);
            }
            else
            {
                this.officerContainer.setDefaultDisplay();
            }*/
            return;
        }// end function

        

        override protected function onRemoveFromStage(event:Event) : void
        {
            clearRubish();
            
            return;
        }// end function

		/**
		 * 用户信息变化时
		 * @param	event
		 */
        private function onPlayerDataChange(event:SMZTDataChangeEvent) : void
        {
            
           
            return;
        }// end function

       

		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            
        }// end function

		/**
		 * 自身数据模型刷新时
		 * @param	event
		 */
        private function onSkyCityDataRefresh(event:SMZTDataChangeEvent) : void
        {
            
        }// end function


        

        public function get canRefresh() : Boolean
        {
            return this._canRefresh;
        }// end function

        public function set canRefresh(param1:Boolean) : void
        {
            this._canRefresh = param1;
            return;
        }// end function

    }
}
