package project.view.module.building
{
	import flash.display.*;
    import flash.events.*;
	import flash.geom.Point;
	import project.core.SMZTSoundManager;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.ModelLocator;
	import project.utils.CustomTool;
	import project.view.base.BaseSpritePane;
	import project.view.MainPane;
	import project.view.module.alert.AlertSelectPane;
    /*import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.events.*;
    import project.model.*;
    import project.model.data.*;
    import project.view.base.*;
    import project.view.module.alert.*;*/
    

    public class SeceneBuilding extends BaseSpritePane
    {
        //private var levelMc:MovieClip;//等级
        private var _enable:Boolean;//是否开启
        //private var 建筑名字:String;
        //private var upBtn:SimpleButton;//升级
        private var _type:int = -1;//类型
        //private var _level:int = 0;//等级
        private var _buildingName:String = "N/A";//建筑物名
        private var _buidingMc:MovieClip;//建筑物UI 每级对应一帧（这里没有升级的概念，待扩展）
		private var _seceneId:int;//对应的场景ＩＤ
		//private var _overMc:Sprite;

        public function SeceneBuilding(param1:String,id:int)
        {
			_seceneId = id;
            this._buildingName = param1;
            setSpriteInstance(param1);
            //this._buidingMc = new MovieClip();// spriteInstance["bd"] as MovieClip;
            //this._buidingMc.gotoAndStop(1);
            this._enable = true;
            this.configerUIInstance();
			//_overMc = getChild("overMc") as Sprite;
            _spriteInstance["hotMc"].addEventListener(MouseEvent.ROLL_OUT, this.mouseHandler);
           _spriteInstance["hotMc"].addEventListener(MouseEvent.ROLL_OVER, this.mouseHandler);
            buttonMode = this._enable;
			this.cacheAsBitmap = true;
            return;
        }// end function

       /* public function hideUpBtn() : void
        {
            this.upBtn.visible = false;
            return;
        }// end function*/

		//主场景中的数据变化时
        override protected function onUIdChange(event:SMZTDataChangeEvent) : void
        {
            //this.upBtn.visible = ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId;
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            /*if (this._level < 0)
            {
                return;
            }*/
			/*//trace("spriteInstance.x=" + spriteInstance.x);
			var temp:Point = new Point(spriteInstance.x,spriteInstance.y);
			//trace("spriteInstance.gx=" + this.localToGlobal(temp).x);
			//trace("this.x=" + this.x);
			var tempx:Point = new Point(this.x,this.y);
			//trace("this.gx=" +  + this.localToGlobal(tempx).x);*/
			////trace("event.type="+event.type)
            switch(event.type)
            {
				
                /*case MouseEvent.MOUSE_OUT:
                {
                    stopUISound();
                    if (this._enable)
                    {
						//_overMc.visible = false;
                        (spriteInstance as MovieClip).gotoAndStop(1);
                    }
                    break;
                }*/
				
                case MouseEvent.ROLL_OUT:
                {
                    stopUISound();
                    if (this._enable)
                    {
						//_overMc.visible = false;
                        (spriteInstance as MovieClip).gotoAndStop(1);
                    }
                    break;
                }
                case MouseEvent.MOUSE_DOWN:
                {
                    if (this._enable)
                    {
						//_overMc.visible = true;
                        (spriteInstance as MovieClip).gotoAndStop(2);
                    }
                    break;
                }
                case MouseEvent.MOUSE_UP:
                {
                    if (this._enable)
                    {
						//_overMc.visible = false;
                        (spriteInstance as MovieClip).gotoAndStop(1);
                    }
                    break;
                }
                case MouseEvent.ROLL_OVER:
                {
					stopUISound();
					//保证鼠标移上时是当前对应的场景
					if (_seceneId != SMZTUIManager.getInstance().mainPane.currentSceneId && SMZTUIManager.getInstance().mainPane.currentSceneId!=0)
					return;
					
                    if (this._enable && buttonMode)
                    {
						//_overMc.visible = true;
                        (spriteInstance as MovieClip).gotoAndStop(2);
                        this.playBuildingSound();
                    }
					
                    /*if (ModelLocator.getInstance().currentUId == ModelLocator.getInstance().uId && this._level < 5)
                    {
                        this.upBtn.visible = true;
                    }*/
                    break;
                }
				/*case MouseEvent.MOUSE_OVER:
                {
					stopUISound();
					//保证鼠标移上时是当前对应的场景
					if (_seceneId != SMZTUIManager.getInstance().mainPane.currentSceneId && SMZTUIManager.getInstance().mainPane.currentSceneId!=0)
					return;
					
                    if (this._enable && buttonMode)
                    {
						//_overMc.visible = true;
                        (spriteInstance as MovieClip).gotoAndStop(2);
                        this.playBuildingSound();
                    }
					
                    break;
                }*/
                default:
                {
					
                    break;
                }
            }
            return;
        }// end function

		/**
		 * 播放建筑鼠标移上的声音
		 * 这里先暂时统一用一种声音
		 * 
		 * 天空之城:SKYCITY_BUILDING
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
        private function playBuildingSound() : void
        {
            switch(this._buildingName)
            {
				case "EXPEDITION_BUILDING":
                {
                    playUISound("SENCE_STORY");
                    break;
                }
				case "SKYCITY_BUILDING":
                {
                    playUISound("UI_TOWER");
                    break;
                }
				case "LONGBAO_BUILDING":
                {
                    playUISound("UI_TOWER");
                    break;
                }
				case "STATUE_BUILDING":
                {
                    playUISound("SENCE_STATUE");
                    break;
                }
				case "SLAVE_BUILDING":
                {
                    playUISound("SENCE_SLAVE");
                    break;
                }
				case "ARENA_BUILDING":
                {
                    playUISound("UI_CHAMPOIN");
                    break;
                }
				case "TOWER_BUILDING":
                {
                    playUISound("UI_TOWER");
                    break;
                }
				case "COLLENGE_BUILDING":
                {
                    playUISound("SENCE_TRANING");
                    break;
                }
				case "CULTIVATION_BUILDING":
                {
                    playUISound("SENCE_CUL");
                    break;
                }
				case "TAVERN_BUILDING":
                {
                    playUISound("SENCE_TAWER");
                    break;
                }
				case "CRYSTALHOLE_BUILDING":
                {
                    playUISound("SENCE_CRYSTAL");
                    break;
                }
                /*case "CHAMPION_BUILDING":
                {
                    playUISound("UI_CHAMPOIN");
                    break;
                }
                case "ARENA_BUILDING":
                {
                    playUISound("UI_ARENA");
                    break;
                }
                case "SKILL_BUILDING":
                {
                    playUISound("SKILL_" + this.level);
                    break;
                }
                case "WEAPON_BUILDING":
                {
                    playUISound("WEAPON_" + this.level);
                    break;
                }
                case "BUDOUKAI_BUILDING":
                {
                    playUISound("UI_CHAMPOIN");
                    break;
                }
                case "CAMP_BUILDING":
                {
                    playUISound("OFFICE_" + this.level);
                    break;
                }
                case "PVE_BUILDING":
                {
                    playUISound("UI_PVE");
                    break;
                }
                case "BUS_BUILDING":
                {
                    playUISound("UI_YIZHAN");
                    break;
                }*/
                default:
                {
                    break;
                }
            }
            return;
        }// end function

		/**
		 * 播放建筑物升级效果
		 */
        public function playLevelUpEffect() : void
        {
            /*((getChild("eff") as MovieClip)["de"] as MovieClip).gotoAndPlay(2);
            ((getChild("eff") as MovieClip)["ue"] as MovieClip).gotoAndPlay(2);
            if (this._level == 5)
            {
                this.upBtn.visible = false;
            }
            else if (ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId)
            {
                this.upBtn.visible = true;
            }
            SMZTSoundManager.playSimpleSound("UI_BUILDING_LEVEL_UP");
            return;*/
        }// end function

		/**
		 * 配置UI
		 */
        private function configerUIInstance() : void
        {
            //this.levelMc = spriteInstance["lv"] as MovieClip;
            //this.upBtn = spriteInstance["up"] as SimpleButton;
            //this.upBtn.visible = true;
            //this.upBtn.addEventListener(MouseEvent.CLICK, this.upgradeBuilding);
            (spriteInstance as MovieClip).gotoAndStop(1);
			if (this._spriteInstance["effectMc"] != null) {
				this._spriteInstance["effectMc"].mouseChildren = false;
				this._spriteInstance["effectMc"].mouseEnabled = false;
				}
            //this.levelMc.gotoAndStop(1);
            return;
        }// end function

		//升级
        private function upgradeBuilding(event:MouseEvent) : void
        {
            /*if (this._type < 0)
            {
                return;
            }
            if (this._level >= 5)
            {
                return;
            }
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_MIXI || ModelLocator.getInstance().isQQRelated() || ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA || ModelLocator.getInstance().snsType == ModelLocator.SNS_FACEBOOK || ModelLocator.getInstance().snsType == ModelLocator.SNS_360)
            {
                //this.goSina();
            }
            else
            {
                //this.goNoraml();
            }
            return;*/
        }// end function

        /*private function goSina() : void
        {
            BuildingUpgradePaneNew.getInstance().needLevelStr = ((this._level + 1) * 10).toString();
            BuildingUpgradePaneNew.getInstance().type = this._type;
            BuildingUpgradePaneNew.getInstance().target = this;
            BuildingUpgradePaneNew.getInstance().show(true);
            var _loc_1:* = int(PlayerData.getInstance().playerLevel) >= (this._level + 1) * 10;
            BuildingUpgradePaneNew.getInstance().canUpgrade = _loc_1;
            BuildingUpgradePaneNew.getInstance().needLevelStr = ((this._level + 1) * 10).toString();
            BuildingUpgradePaneNew.getInstance().needNumb = this._level + 1;
            switch(this._type)
            {
                case 0:
                {
                    BuildingUpgradePaneNew.getInstance().infoText1.htmlText = LocalConfig.LOCAL_LAN.SeceneBuilding.Skill.@Text;
                    break;
                }
                case 1:
                {
                    BuildingUpgradePaneNew.getInstance().infoText1.htmlText = LocalConfig.LOCAL_LAN.SeceneBuilding.Weapon.@Text;
                    break;
                }
                case 2:
                {
                    BuildingUpgradePaneNew.getInstance().infoText1.htmlText = LocalConfig.LOCAL_LAN.SeceneBuilding.Officer.@Text;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function goNoraml() : void
        {
            BuildingUpgradePane.getInstance().type = this._type;
            BuildingUpgradePane.getInstance().show(true);
            BuildingUpgradePane.getInstance().target = this;
            BuildingUpgradePane.getInstance().moneyText.text = this.getUpgradeFee().toString();
            BuildingUpgradePane.getInstance().goldText.text = (this.getUpgradeFee() * 0.1).toString();
            if (this._level > 2)
            {
                BuildingUpgradePane.getInstance().payMode = 1;
            }
            else
            {
                BuildingUpgradePane.getInstance().payMode = 0;
            }
            var _loc_1:* = int(PlayerData.getInstance().playerLevel) >= (this._level + 1) * 10;
            BuildingUpgradePane.getInstance().canUpgrade = _loc_1;
            BuildingUpgradePane.getInstance().needLevelStr = ((this._level + 1) * 10).toString();
            switch(this._type)
            {
                case 0:
                {
                    BuildingUpgradePane.getInstance().infoText1.htmlText = LocalConfig.LOCAL_LAN.SeceneBuilding.Skill.@Text;
                    break;
                }
                case 1:
                {
                    BuildingUpgradePane.getInstance().infoText1.htmlText = LocalConfig.LOCAL_LAN.SeceneBuilding.Weapon.@Text;
                    break;
                }
                case 2:
                {
                    BuildingUpgradePane.getInstance().infoText1.htmlText = LocalConfig.LOCAL_LAN.SeceneBuilding.Officer.@Text;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (!_loc_1)
            {
                BuildingUpgradePane.getInstance().infoText1.htmlText = BuildingUpgradePane.getInstance().infoText1.htmlText + ("    <font color=\'#FF0000\'>" + String(LocalConfig.LOCAL_LAN.Weapon.Officer.@Text).replace("{level}", ((this._level + 1) * 10).toString()) + "</font>");
            }
            return;
        }// end function*/

       /* private function getUpgradeFee() : int
        {
            var _loc_1:int = 500;
            if (this._level < 5)
            {
                return _loc_1 * (this._level + 1);
            }
            return 0;
        }// end function

        private function onConfirmBack(param1:String) : void
        {
            if (param1 == AlertSelectPane.ALERT_YES)
            {
                //SMZTController.getInstance().upgradeBuilding(this._type, 0, this.onUpgradeBack);
            }
            return;
        }// end function*/

        private function onUpgradeBack(param1:XML) : void
        {
            return;
        }// end function

		/**
		 * 设置建筑物等级
		 * @param	param1
		 */
		
        public function setBuildingLevel(param1:int) : void
        {
            //this.levelMc.gotoAndStop(param1);
            return;
        }// end function

        public function get enable() : Boolean
        {
            return this._enable;
        }// end function

        public function set enable(param1:Boolean) : void
        {
            this._enable = param1;
            buttonMode = this._enable;
            if (this._enable)
            {
                (spriteInstance as MovieClip).gotoAndStop(1);
            }
            else
            {
                (spriteInstance as MovieClip).gotoAndStop(3);
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
            return;
        }// end function

        public function get buildingName() : String
        {
            return this._buildingName;
        }// end function

        public function set buildingName(param1:String) : void
        {
            this._buildingName = param1;
            return;
        }// end function

        /*public function get level() : int
        {
            return this._level;
        }// end function

        public function set level(param1:int) : void
        {
            this._level = param1;
            this.levelMc.gotoAndStop((param1 + 1));
            this._buidingMc.gotoAndStop((param1 + 1));
            if (this._level < 0)
            {
                (spriteInstance as MovieClip).gotoAndStop(6);
                this._enable = false;
                this.buttonMode = false;
            }
            else
            {
                (spriteInstance as MovieClip).gotoAndStop(1);
                this._enable = true;
                this.buttonMode = true;
            }
			//最多五级
            if (this._level == 5)
            {
                this.upBtn.visible = false;
            }
            else if (ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId)
            {
                this.upBtn.visible = true;
            }
            return;
        }// end function*/

        public function get buidingMc() : MovieClip
        {
            return this._buidingMc;
        }// end function

        public function set buidingMc(param1:MovieClip) : void
        {
            this._buidingMc = param1;
            return;
        }// end function

    }
}
