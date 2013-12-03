package project.view.module.scene.main
{
    import com.adobe.net.*;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.controller.EventController;
	import project.controller.ModuleLoadControler;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.events.UIEvent;
	import project.model.data.PlayerData;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModelId;
	import project.model.statue.SignModel;
	import project.model.statue.StatueModel;
	import project.utils.DepthManager;
	import project.view.controls.ToolTip;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.building.SeceneBuilding;
	import project.view.module.helppane.NewbiePane;
	import project.view.module.loading.LockScreen;
	import project.view.module.loadModule.AnimationManager;
	import project.view.module.loadModule.ModuleLoader;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.crystalHole.CrystalHoleScene;
	import project.view.module.scene.longbao.LongBaoScene;
	import project.view.module.scene.statue.StatuePanel;
	import project.view.module.vip.VipPanel;

	
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;

	/**
	 * 天空之城：SKYCITY_BUILDING
		龙宝密窟: LONGBAO_BUILDING
		女神像: STATUE_BUILDING
		奴隶营地: SLAVE_BUILDING
		竞技场: ARENA_BUILDING
		宿命之塔: TOWER_BUILDING
		战争学院: COLLENGE_BUILDING
		修炼馆: CULTIVATION_BUILDING
		酒馆: TAVERN_BUILDING
		水晶矿洞: CRYSTALHOLE_BUILDING
		远征: EXPEDITION_BUILDING

	 */
    public class MainScene extends BaseGameScene
    {
        private var skyCity:SeceneBuilding;//天空之城
        private var longBao:SeceneBuilding;//龙宝密窟
        private var statue:SeceneBuilding;//女神像
        private var slave:SeceneBuilding;//奴隶营地
        private var arena:SeceneBuilding;//竞技场
        private var tower:SeceneBuilding;//宿命之塔
        private var collenge:SeceneBuilding;//战争学院
        private var cultivation:SeceneBuilding;//修炼馆
        private var tavern:SeceneBuilding;//酒馆
        private var crystalHole:SeceneBuilding;//水晶矿洞
        private var expedition:SeceneBuilding;//远征
		
		public static const MAIN_SCENE:int = 0;
		public static const ARENA_SCENE:int = 1;
		public static const TRAINING_SCENE:int = 2;
		public static const STATUE_SCENE:int = 3;
		public static const TOWER_SCENE:int = 4;
		public static const CULTIVATION_SCENE:int = 5;
		public static const TAVERN_SCENE:int = 6;
		public static const SLAVE_SCENE:int = 7;
		public static const SKYCITY_SCENE:int = 8;
		public static const LONGBAO_SCENE:int = 9;
		public static const CRYSTAL_HOLE_SCENE:int = 10;
		public static const EXPEDITOIN_SCENE:int = 11;

        //private var remainCountText:TextField;
        private var mapLayer:MovieClip;//地图层
        private var tt:ToolTip;//提示信息，如一些场景未开发，或等级不够之类（这个游戏没有用到）
        private var eventAv:MovieClip;//活动容器
        private var eventSWF:MovieClip;

        public function MainScene()
        {
            sceneId = MAIN_SCENE;
			
            this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.7;
            this.tt.cornerRadius = 0;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 4211070;
            this.tt.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_1;
			
            setSpriteInstance("MainScene");
			
            this.configerUIInstance();
			
			skyCity= new SeceneBuilding("SKYCITY_BUILDING",SKYCITY_SCENE);
			longBao= new SeceneBuilding("LONGBAO_BUILDING",LONGBAO_SCENE);
			statue= new SeceneBuilding("STATUE_BUILDING",STATUE_SCENE);
			slave= new SeceneBuilding("SLAVE_BUILDING",SLAVE_SCENE);
			arena= new SeceneBuilding("ARENA_BUILDING",ARENA_SCENE);
			tower= new SeceneBuilding("TOWER_BUILDING",TOWER_SCENE);
			collenge= new SeceneBuilding("COLLENGE_BUILDING",TRAINING_SCENE);
			cultivation= new SeceneBuilding("CULTIVATION_BUILDING",CULTIVATION_SCENE);
			tavern= new SeceneBuilding("TAVERN_BUILDING",TAVERN_SCENE);
			crystalHole= new SeceneBuilding("CRYSTALHOLE_BUILDING",CRYSTAL_HOLE_SCENE);
			expedition= new SeceneBuilding("EXPEDITION_BUILDING",EXPEDITOIN_SCENE);
			
            //this.remainCountText = getChild("gamec") as TextField;
            //this.remainCountText.mouseEnabled = false;
			
            this.eventAv = getChild("eav") as MovieClip;
			
            dataModel = ModelLocator.getInstance();
			
			skyCity.setLocation(435, 65);
			longBao.setLocation(626, 109);
			statue.setLocation(462, 261);
			slave.setLocation(501, 429);
			arena.setLocation(202, 370);
			tower.setLocation(220, 135);
			collenge.setLocation(0, 112);
			cultivation.setLocation(138, 536);
			tavern.setLocation(394, 532);
			crystalHole.setLocation(639, 559);
			expedition.setLocation(342.95, 284);
			
			//龙宝跟天空之城暂不开发
			//skyCity.enable=false;
			longBao.enable=false;
			//crystalHole.enable=false;
			skyCity.enable=false;
			
			this.mapLayer.addChild(expedition);
            this.mapLayer.addChild(skyCity);
            this.mapLayer.addChild(longBao);
            this.mapLayer.addChild(statue);
            this.mapLayer.addChild(slave);
            this.mapLayer.addChild(arena);
            this.mapLayer.addChild(tower);
            this.mapLayer.addChild(collenge);
            this.mapLayer.addChild(cultivation);
            this.mapLayer.addChild(tavern);
            this.mapLayer.addChild(crystalHole);
           
           
            expedition.addEventListener(MouseEvent.CLICK, this.clickHandler);
            skyCity.addEventListener(MouseEvent.CLICK, this.clickHandler);
            longBao.addEventListener(MouseEvent.CLICK, this.clickHandler);
            statue.addEventListener(MouseEvent.CLICK, this.clickHandler);
            slave.addEventListener(MouseEvent.CLICK, this.clickHandler);
            arena.addEventListener(MouseEvent.CLICK, this.clickHandler);
            tower.addEventListener(MouseEvent.CLICK, this.clickHandler);
            collenge.addEventListener(MouseEvent.CLICK, this.clickHandler);
            cultivation.addEventListener(MouseEvent.CLICK, this.clickHandler);
            tavern.addEventListener(MouseEvent.CLICK, this.clickHandler);
            crystalHole.addEventListener(MouseEvent.CLICK, this.clickHandler);
            
			skyCity.addEventListener(MouseEvent.MOUSE_OVER, showSkyCityTip);
			longBao.addEventListener(MouseEvent.MOUSE_OVER, showLongBaoTip);
			//crystalHole.addEventListener(MouseEvent.MOUSE_OVER, showCrystalHoleTip);
			
            /*this.battle.addEventListener(MouseEvent.MOUSE_OVER, this.showBattleTip);
            this.team.addEventListener(MouseEvent.MOUSE_OVER, this.showTeamTip);
            this.pve.addEventListener(MouseEvent.MOUSE_OVER, this.showPVETip);
            this.bless.addEventListener(MouseEvent.MOUSE_OVER, this.showBlessTip);
            this.pve.addEventListener(MouseEvent.MOUSE_OUT, this.pveMouseHandler);
            this.pve.addEventListener(MouseEvent.MOUSE_OVER, this.pveMouseHandler);*/
            //DepthManager.bringToTop(this.remainCountText);
            PlayerData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onPlayerDataChange);
            rubishPosArr = [[376, 476], [376, 476], [376, 476]];
            this.eventAv.visible = false;
            this.checkEvent();
			this.cacheAsBitmap = false;
            return;
        }// end function

        override protected function onUIdChange(event:SMZTDataChangeEvent) : void
        {
            if (this.eventSWF)
            {
                /*if (ModelLocator.getInstance().uId != ModelLocator.getInstance().currentUId)
                {
                    this.eventSWF.setFriend();//在访问朋友时
                }
                else
                {
                    this.eventSWF.setHome();
                }*/
            }
            return;
        }// end function

		//检查是否有活动
        public function checkEvent() : void
        {
            if (ApplicationConfig.mainConfig.event == "none" || !NewBieControler.getInstance().finishDic[NewBieModelId.FISET])
            {
                return;
            }
			var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            onEventModuleLoad = function (event:Event) : void
            {
				eventSWF = mdl.instance;
				reCheckEvent();
            }
            mdl = new ModuleLoader();
			mdl.show(ApplicationConfig.mainConfig.event);
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
			
            /*var _loc_1:Loader = new Loader();
            _loc_1.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onEventLoad);
            var _loc_2:LoaderContext = new LoaderContext();
            _loc_2.applicationDomain = ApplicationDomain.currentDomain;
            _loc_1.load(new URLRequest(ModelLocator.getInstance().staticURL + ApplicationConfig.mainConfig.event), _loc_2);*/
            return;
        }// end function

		//增加活动的界面SWF
       /* private function onEventLoad(event:Event) : void
        {
            this.eventSWF = MovieClip(event.currentTarget.content);
            this.eventSWF.addEventListener("EventError", this.onEventError);
            //this.eventSWF.setHome();
            this.eventAv.addChild(this.eventSWF);
			AnimationManager.transfromAroundCenter(eventSWF);
            this.eventAv.visible = true;
            this.reCheckEvent();
            return;
        }// end function*/

        private function onEventError(event:Event) : void
        {
            AlertConfirmPane.getInstance().showMessage(event.currentTarget.errorMsg, null, true);
            return;
        }// end function

		/**
		 * 再次检查，把用户ID跟动态地址传入加载进来的活动SWF
		 */
        public function reCheckEvent() : void
        {
            this.eventAv.visible = false;
            if (ApplicationConfig.mainConfig.event == "none")
            {
                return;
            }
            if (this.eventSWF == null)
            {
                return;
            }
            this.eventAv.visible = true;
            this.eventSWF.showActive(EventController.getInstance().events, ApplicationConfig.mainConfig.staticURL, PlayerData.getInstance().userId,LockScreen.getInstance(),ApplicationConfig.mainConfig.events);//如果有活动加载活动界面
            return;
        }// end function

       /* public function showBudoukaiBuilding() : void
        {
            this.budoukaiKanBan.visible = true;
            this.budoukai.visible = true;
            return;
        }// end function

        public function showChampionBuilding() : void
        {
            this.champion.visible = true;
            return;
        }// end function

		//显示技能房
        public function showSkillBuilding() : void
        {
            this.skill.enable = true;
            return;
        }// end function

        public function showOfficerBuilding() : void
        {
            this.officer.enable = true;
            return;
        }// end function

        public function showWeaponBuilding() : void
        {
            this.weapon.enable = true;
            return;
        }// end function*/

        private function signUpBudoukai(event:MouseEvent) : void
        {
            /*if (this._budoukaiKanBan.currentFrame == 1)
            {
                SMZTController.getInstance().signUpForBudokai(this.onSignUpBack);
            }
            else if (this.budoukaiKanBan.currentFrame == 3)
            {
                if (PlayerData.getInstance().isVip >= 1)
                {
                    AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.BudoukaiSignUpPane.SignUp.@Text);
                }
                else
                {
                    AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.BudoukaiSignUpPane.SignUp.@Text);
                }
            }
            else if (this.budoukaiKanBan.currentFrame == 4)
            {
                SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_BUDOUKAI_SCENE);
            }
            return;*/
        }// end function

        private function onSignUpBack(param1:XML) : void
        {
           /* AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.BudoukaiSignUpPane.SignUp.@Text);
            this._budoukaiKanBan.gotoAndStop(3);
            return;*/
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
            clearRubish();
            return;
        }// end function

		/**
		 * 用户信息变化时触发，如果 等级到一定程度时有些场景会开放
		 * @param	event
		 */
        private function onPlayerDataChange(event:SMZTDataChangeEvent) : void
        {
            /*if (int(PlayerData.getInstance().playerLevel) < 15)
            {
                this.team.enable = false;
            }
            else
            {
                this.team.enable = true;
            }
            if (int(PlayerData.getInstance().playerLevel) < 30)
            {
                this.battle.enable = false;
            }
            else
            {
                this.battle.enable = true;
            }
            if (int(PlayerData.getInstance().playerLevel) < 5)
            {
                this.bless.enable = false;
            }
            else
            {
                this.bless.enable = true;
            }
            trace(PlayerData.getInstance().gather + " asfdsdaf " + PlayerData.getInstance().gather % 2);
            if (PlayerData.getInstance().gather % 2 != 0)
            {
                refreshRubish(PlayerData.getInstance().gather);
            }
            else
            {
                clearRubish();
            }
            this.skill.level = PlayerData.getInstance().skillBuildingLv;
            this.weapon.level = PlayerData.getInstance().weaponBuildingLv;
            this.officer.level = PlayerData.getInstance().officerBuildingLv;
            this.remainCountText.text = PlayerData.getInstance().fightCount.toString();
            if (PlayerData.getInstance().budoukaiBuildingLv < 1)
            {
                this.budoukai.visible = false;
                this.budoukaiKanBan.visible = false;
            }
            else
            {
                this.budoukai.visible = true;
                this.budoukai.enable = true;
                this.budoukaiKanBan.visible = true;
            }
            if (PlayerData.getInstance().champinBuildingLv < 1)
            {
                this.champion.visible = false;
            }
            else
            {
                this.champion.visible = true;
                this.champion.enable = true;
            }
            if (int(PlayerData.getInstance().playerLevel) >= 10)
            {
                (this.pve.spriteInstance["bd"] as MovieClip).gotoAndStop(2);
                (this.pve.spriteInstance["kp"] as MovieClip).visible = true;
            }
            else
            {
                (this.pve.spriteInstance["bd"] as MovieClip).gotoAndStop(1);
                (this.pve.spriteInstance["kp"] as MovieClip).visible = false;
                this.pve.buttonMode = false;
            }*/
            return;
        }// end function

		/**
		 * 显示龙宝还未开发的提示
		 * @param	event
		 */
		private function showLongBaoTip(event:MouseEvent):void {
			tt.autoSize = true;
			this.tt.show(longBao, "", LocalConfig.LOCAL_LAN.MainScene.LongBaoTip.@Text);
			}
			
		/**
		 * 显示天空之城还未开发的提示
		 * @param	event
		 */
		private function showSkyCityTip(event:MouseEvent):void {
			tt.autoSize = true;
			this.tt.show(skyCity, "", LocalConfig.LOCAL_LAN.MainScene.LongBaoTip.@Text);
			}
			
		/**
		 * 显示水晶矿洞还未开发的提示
		 * @param	event
		 */
		private function showCrystalHoleTip(event:MouseEvent):void {
			tt.autoSize = true;
			this.tt.show(crystalHole, "", LocalConfig.LOCAL_LAN.MainScene.CrytalHoleTip.@Text);
			}
		
        /*private function showBlessTip(event:MouseEvent) : void
        {
            if (int(PlayerData.getInstance().playerLevel) < 5)
            {
                this.tt.show(this.bless, "", LocalConfig.LOCAL_LAN.MainScene.BlessTip.@Text);
            }
            return;
        }// end function

        private function showBattleTip(event:MouseEvent) : void
        {
            if (int(PlayerData.getInstance().playerLevel) < 30)
            {
                this.tt.show(this.battle, "", LocalConfig.LOCAL_LAN.MainScene.BattleTip.@Text);
            }
            return;
        }// end function

        private function showTeamTip(event:MouseEvent) : void
        {
            if (int(PlayerData.getInstance().playerLevel) < 15)
            {
                this.tt.show(this.team, "", LocalConfig.LOCAL_LAN.MainScene.TeamTip.@Text);
            }
            return;
        }// end function

        private function showPVETip(event:MouseEvent) : void
        {
            if (int(PlayerData.getInstance().playerLevel) < 10)
            {
                this.tt.show(this.pve, "", LocalConfig.LOCAL_LAN.MainScene.PVETip.@Text);
            }
            return;
        }// end function

        private function pveMouseHandler(event:MouseEvent) : void
        {
            if (!this.pve.spriteInstance["bd"] as MovieClip || !this.pve.spriteInstance["bd"]["dd"] as MovieClip)
            {
                return;
            }
            if (event.type == MouseEvent.MOUSE_OVER)
            {
                if (ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId && this.pve.enable && int(PlayerData.getInstance().playerLevel) >= 10)
                {
                    (this.pve.spriteInstance["bd"] as MovieClip).gotoAndStop(2);
                    (this.pve.spriteInstance["bd"]["dd"] as MovieClip).gotoAndPlay(2);
                }
            }
            else if (this.pve.spriteInstance["bd"]["dd"] as MovieClip)
            {
                (this.pve.spriteInstance["bd"]["dd"] as MovieClip).gotoAndStop(2);
            }
            return;
        }// end function*/

		/**
		 * 数据模型变化时
		 * @param	event
		 */
        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            /*if (ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId)
            {
                this.budoukai.enable = true;
                this.arena.enable = true;
                this.arena.visible = true;
                this.pve.enable = true;
                this.remainCountText.visible = true;
                this.champion.enable = true;
                this.busStop.visible = false;
                this.team.visible = ApplicationConfig.mainConfig.convoy == 1;
                this.battle.visible = ApplicationConfig.mainConfig.battle == 1;
            }
            else
            {
                this.champion.enable = false;
                this.budoukai.enable = false;
                this.champion.visible = false;
                this.budoukai.visible = false;
                this.arena.enable = false;
                this.arena.visible = false;
                this._budoukaiKanBan.visible = false;
                this.pve.enable = false;
                this.remainCountText.visible = false;
                this.busStop.visible = true;
                this.team.visible = false;
                this.battle.visible = false;
            }*/
            return;
        }// end function

        private function showChampion(event:MouseEvent) : void
        {
            //SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_CHAMPION);
            return;
        }// end function

        private function showPVE(event:MouseEvent) : void
        {
            //SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_PVE_SCENE);
            return;
        }// end function

        private function onInitBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
            //SMZTUIManager.getInstance().mainScene.reCheckEvent();
            return;
        }// end function

		/**
		 * 主场景 中各建筑物点击显示相应的场景 
		 * @param	event
		 */
        private function clickHandler(event:MouseEvent) : void
        {
            /*if (event.target is SimpleButton && event.target.name == "up")
            {
                return;
            }*/
			//是否允许点击
            if (!(event.currentTarget as SeceneBuilding).enable)
            {
                //trace("Block");
                return;
            }
            switch(event.currentTarget)
            {
				case this.skyCity:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_SKYCITY_SCENE);
                    break;
                }
				case this.longBao:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_LONGBAO_SCENE);
                    break;
                }
				case expedition:
                {
					//-------------------新手引导用-----------------------
				   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
				   //NewBieControler.getInstance().nextStep();
					NewbiePane.getInstance().hide();//先隐藏新手引导
				   }
				  //--------------------end--------------------
					if (LongBaoScene.firstLoad) {
						ModuleLoadControler.getInstance().show(true);
						ModuleLoadControler.getInstance().starLoad(ModelLocator.getInstance().staticURL +ApplicationConfig.mainConfig.module.longBao.@source, function ():void {
							LongBaoScene.firstLoad = false;
							SMZTUIManager.getInstance().longBaoScene = new LongBaoScene();
							SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_EXPEDTION_SCENE);
							
							
							});
						}else {
							
							SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_EXPEDTION_SCENE);
							}
                    break;
                }
				case this.statue:
                {
					//女神像以弹窗形式
                    //SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_STATUE_SCENE);
					SMZTController.getInstance().getActivityListData(function (param:Object):void {
						StatueModel.getInstance().setData(param);
						StatuePanel.getInstance().show(true);
						});
					SMZTController.getInstance().getSignInfo(function (param:Object):void {
						SignModel.getInstance().setData(param);
						})
                    break;
                }
				case this.slave:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_SLAVE_SCENE);
                    break;
                }
				case this.arena:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_ARENA_SCENE);
                    break;
                }
				case this.tower:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_TOWER_SCENE);
                    break;
                }
				case this.collenge:
                {
					//战争学院
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_COLLENGE_SCENE);
                    break;
                }
				case this.cultivation:
                {
					//修炼馆
					//-------------------新手引导用-----------------------
					   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					   NewBieControler.getInstance().nextStep();
						NewbiePane.getInstance().hide();//先隐藏新手引导
					   }
					  //--------------------end--------------------
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_CULTIVATION_SCENE);
                    break;
                }
				case this.tavern:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_TAVERN_SCENE);
                    break;
                }
				case this.crystalHole:
                {
					if (CrystalHoleScene.firstLoad) {
						ModuleLoadControler.getInstance().show(true);
						ModuleLoadControler.getInstance().starLoad(ModelLocator.getInstance().staticURL +ApplicationConfig.mainConfig.module.crystalHole.@source, function ():void {
							CrystalHoleScene.firstLoad = false;
							SMZTUIManager.getInstance().crystalHoleScene = new CrystalHoleScene();
							SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_CRYSTALHOLE_SCENE);
							});
						}else {
							SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_CRYSTALHOLE_SCENE);
							}
                    break;
                }
				
                /*case this.busStop:
                {
                    SMZTUIManager.getInstance().mainPane.returnMainScene();
                    //SMZTController.getInstance().initPlayerInfo(ModelLocator.getInstance().uId, this.onInitBack);
					LockScreen.getInstance().show(true);
                    //SMZTUIManager.getInstance().friendPane.closeHellFuck();
                    break;
                }
                case this.pve:
                {
                    if ((this.pve.spriteInstance["bd"] as MovieClip).currentFrame == 1)
                    {
                        return;
                    }
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_PVE_SCENE);
                    break;
                }
                case this.arena:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_ARENA_SCENE);
                    break;
                }
                case this.bless:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_BLESS_SCENE);
                    break;
                }
                case this.skill:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_SKILL_SCENE);
                    break;
                }
                case this.weapon:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_WEAPON_SCENE);
                    break;
                }
                case this.budoukai:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_BUDOUKAI_SCENE);
                    break;
                }
                case this.officer:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_OFFICER_SCENE);
                    break;
                }
                case this.champion:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_CHAMPION);
                    break;
                }
                case this.team:
                {
                    navigateToURL(new URLRequest(ApplicationConfig.mainConfig.teamURL + "?server=" + URI.escapeChars(ModelLocator.getInstance().dynamicURL)), ApplicationConfig.mainConfig.teamURL.@method);
                    break;
                }
                case this.battle:
                {
                    navigateToURL(new URLRequest(ApplicationConfig.mainConfig.royaleURL + "?server=" + URI.escapeChars(ModelLocator.getInstance().dynamicURL)), ApplicationConfig.mainConfig.royaleURL.@method);
                    break;
                }*/
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.mapLayer = getChild("mp") as MovieClip;
			////trace("mapLayer=" + mapLayer.x);
            return;
        }// end function

        private function naviFaq(event:MouseEvent) : void
        {
           /* navigateToURL(new URLRequest("/faq.aspx"), "_blank");
            return;*/
        }// end function

        override public function showHelp(event:MouseEvent = null) : void
        {
            /*HelpPane.getInstance().playInstance("NEWBIE_SHOW_MAIN_SCENE_HELP");
            if (HelpPane.getInstance().isOpened)
            {
                helpBtn.gotoAndPlay(2);
            }
            else
            {
                helpBtn.gotoAndStop(1);
            }
            return;*/
        }// end function

       /* public function get budoukaiKanBan() : MovieClip
        {
            return this._budoukaiKanBan;
        }// end function

        public function set budoukaiKanBan(param1:MovieClip) : void
        {
            this._budoukaiKanBan = param1;
            return;
        }// end function*/

    }
}
