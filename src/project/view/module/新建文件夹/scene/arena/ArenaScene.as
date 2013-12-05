package project.view.module.scene.arena
{
	/**
	*描述：天空之城
	*
	*/
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.arena.ArenaModel;
	import project.model.data.PlayerData;
	import project.view.artplug.MovieClipButton;
	import project.view.controls.TabNavigator;
	import project.view.controls.ToolTip;
	import project.view.layout.BaseGridContainer;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	

    public class ArenaScene extends BaseGameScene
    {
        
		//----------------------容器---------------------------------
		private var _gidContent:BaseGridContainer;//放擂主信息面板
		
		//-----------------------UI---------------------------------
		private var tt:ToolTip;
		private var _goldBt:MovieClipButton;//金币竞技按钮
		private var _crystalBt:MovieClipButton;//水晶竞技按钮
		private var _ruleBt:MovieClipButton;//规则
		private var tabNvigator:TabNavigator;
		private var _icoMc:MovieClip;//水晶金币图标
		//-----------------------数据---------------------------------
		private var _canRefresh:Boolean = true;
		private var _refreshTimer:Timer = new Timer(20000);//20秒刷新一次
		private var _champions:Array;
		private var _currentSelectedType:int = 1;//当前选择的竞技付费方式  0:免支付  1:金币支付 2:水晶支付 3:荣誉支付
		private var _currentSetDataIndex:int = 0;
		private var _arenaModel:ArenaModel;
		//-----------------------事件--------------------------------
        public function ArenaScene()
        {
            rubishPosArr = [[360, 300], [411, 198], [646, 261]];
            sceneId = MainScene.ARENA_SCENE;
            setSpriteInstance("ArenaScene");
			configerUIInstance();
			
            /*this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.88;
            this.tt.cornerRadius = 12;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 16762389;
            this.tt.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_1;*/
			
           _arenaModel=ArenaModel.getInstance();
            dataModel =_arenaModel;
            //PlayerData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onPlayerDataChange);
            _refreshTimer.addEventListener(TimerEvent.TIMER, updataUI);
			
            return;
        }// end function
		
		private function configerUIInstance():void 
		{
			_gidContent = new BaseGridContainer(1, 4, 102, 91.75, 271.15);
			_gidContent.setLocation(47.5, 227.45);
			
			_icoMc = getChild("icoMc") as MovieClip;
			_goldBt = getChild("goldBt") as MovieClipButton;
			_crystalBt = getChild("crystalBt") as MovieClipButton;
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_goldBt, _crystalBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			_ruleBt = getChild("ruleBt") as MovieClipButton;
			_ruleBt.toolTip = LocalConfig.LOCAL_LAN.ArenaScene.RuleTip.@Text;
			
			_champions = new Array();
			for (var i:int = 0; i < 4; i++ ) {
				var temp:ChampionPanel = new ChampionPanel();
				
				//temp.x = 47.5 + 91.75 * i + i * 101;
				//temp.y = 227.45;
				_champions.push(temp);
				//addChild(temp);
				_gidContent.appendChild(temp);
				temp = null;
				}
				
			addChild(_gidContent);
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			switch(e.dataObject) {
				case _crystalBt:
					_currentSelectedType = 3
					_icoMc.gotoAndStop(2);
					break;
					
				case _goldBt:
					_currentSelectedType = 1
					_icoMc.gotoAndStop(1);
					break;
				}
			onDataChange(null);
		}

		/**
		 * 刷新界面
		 * @param	e
		 * @param	firstFlag第一次触发
		 * @param	timerReresh定时触发
		 */
		public function updataUI(e:TimerEvent=null,firstFlag:Boolean=false,timerReresh:Boolean=true):void {
			if (timerReresh) {
				SMZTController.getInstance().getArenaData(false);//定时刷新触发
				}
			if (firstFlag) {
				//第一次默认选金币
				SMZTController.getInstance().getArenaData(firstFlag);
				tabNvigator.selectedByIndex();
				}
			if (!_refreshTimer.running) {
				_refreshTimer.reset();
				_refreshTimer.start();
				}
			}
		/**
		 * 停止更新
		 * @param	event
		 */	
		public function stopUpdataUI():void {
			_refreshTimer.stop();
			}
		 public function startUpdataUI():void {
			_refreshTimer.start();
			}
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
			
			_currentSetDataIndex = 0;
			for (var i:String in _arenaModel.arenas) {
				if (_arenaModel.arenas[i].type == _currentSelectedType) {
					//trace(_champions[_currentSetDataIndex].width)
					_champions[_currentSetDataIndex].updata(_arenaModel.arenas[i]);
					_currentSetDataIndex++;
					}
				}
           
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
