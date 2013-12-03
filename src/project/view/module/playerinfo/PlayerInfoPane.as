package project.view.module.playerinfo
{
	/**
	 * 描述：上部个人信息面板
	 */
	import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.controller.EventController;
	import project.controller.ModuleLoadControler;
	import project.controller.SMZTController;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.event.eventTower.EventTowerModel;
	import project.model.friends.BonusModel;
	import project.model.ModelLocator;
	import project.model.platform.AwardYellowInfo;
	import project.model.statue.SignModel;
	import project.model.statue.StatueModel;
	import project.model.vip.VipState;
	import project.utils.Browser;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.controls.ToolTip;
	import project.view.layout.BaseGridContainer;
	import project.view.module.event.eventTower.EventTowerPanel;
	import project.view.module.helpSoundBBS.FullSceneControla;
	import project.view.module.loading.LockScreen;
	import project.view.module.loadModule.ModuleLoader;
	import project.view.module.platform.QQYellowPanel;
	import project.view.module.platform.YellowIco;
	import project.view.module.scene.statue.StatuePanel;
	//import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.BaseIcoCellLoader;

    

    public class PlayerInfoPane extends BaseSpritePane
    {
        private var playerData:PlayerData;
		private var _nameText:TextField;//昵称
		private var _levelText:TextField;//等级
		private var _goldText:TextField;//金币
		private var _cryText:TextField;//水晶
		private var _honorText:TextField;//荣誉
		private var _expMc:Sprite;//鼠标移上显示 经验/升级经验
		//private var _expText:TextField;//经验/升级经验
		//private var _cardsNumText:TextField;//卡牌数
		private var _expBar:MovieClip;//经验进度条 
		private var _vipico:MovieClip;//vip图标
		private var _vipBt:MovieClipButton;//ＶＩＰ礼包按钮
		private var _vipBt1:MovieClipButton;//ＶＩＰ礼包按钮
		private var _activeBt:MovieClipButton;//活动按钮
		private var _chargeBt:MovieClipButton;//充值按钮
		private var _eventTower:MovieClipButton;//泰坦逆袭活动按钮
		private var _activeListBt:MovieClip;//活跃任务按钮

        private var icoBox:BaseIcoCellLoader;//头像图标
		private var _controlFullBt:FullSceneControla;
		private var _yellowBt:MovieClip;//黄钻按钮
		private var _yellowIco:YellowIco;//黄钻图标

        private var tt:ToolTip;
		
        private var ad:Boolean = false;
        private var adLoader:Loader;

        public function PlayerInfoPane()
        {
            this.adLoader = new Loader();
			
            setSpriteInstance("PlayerInfoPane");
            this.configerUIInstance();
			//------------------bbjxl --网格布局容器测试-------------------------------
			/* this.buffContainer = new BaseGridContainer(2, 2, 10, 40, 40);
            this.buffContainer.setLocation(115, 58);
            addChild(this.buffContainer);
            setLocation(2, 4);
			buffContainer.appendChild(SMZTResourceManager.getInstance().getRes("arenasmc"));// SMZTResourceManager.getInstance().getRes("qedd"));
			buffContainer.appendChild(SMZTResourceManager.getInstance().getRes("arenasmc"));// SMZTResourceManager.getInstance().getRes("qedd"));
			buffContainer.appendChild(SMZTResourceManager.getInstance().getRes("arenasmc"));// SMZTResourceManager.getInstance().getRes("qedd"));*/
			
			
            this.playerData = PlayerData.getInstance();
            dataModel = this.playerData;
            this.playerData.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, this.onPlayerDataRefresh);//用户个人数据刷新之后触发
			
            this.icoBox = new BaseIcoCellLoader();
            this.icoBox.showBg = false;
            this.icoBox.restrictHW = 58;
			
			//addChild(icoBox);
            (getChild("av") as MovieClip).addChild(this.icoBox);
            /*(getChild("pg") as MovieClip).mouseChildren = false;
            (getChild("pg") as MovieClip).mouseEnabled = false;*/
            mouseEnabled = false;
            /*this.icoBox.addEventListener(MouseEvent.CLICK, this.onAvatarClick);
            this.icoBox.buttonMode = true;*/
            
            this.tt = ToolTip.getInstance();
            /*this.tt.bgAlpha = 0.88;
            this.tt.cornerRadius = 12;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 16762389;
            this.tt.borderSize = 1;
            var _loc_2:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_2;*/
			
            //this.icoBox.ico = ModelLocator.getInstance().staticURL + "/assets/images/2.swf";//初始头像
			
			addChild(SMZTUIManager.getInstance().helpSoundBtBBSController);
			
			_controlFullBt= new FullSceneControla();
			addChild(_controlFullBt);
			_controlFullBt.setLocation(682.2,46.1);
            /*this.buffContainer = new BaseGridContainer(1, 20, 2, 26, 26);
            this.buffContainer.setLocation(115, 58);
            addChild(this.buffContainer);*/
			
            setLocation(0, 0);
			
            /*this.btnContainer = new BaseGridContainer(4, 1, 10, 55, 50);
            this.btnContainer.setLocation(10, 120);
            addChild(this.btnContainer);
            getChild("goldmc").visible = false;
            getChild("attrppmc").visible = false;*/
            //this.goldText.visible = false;
            
        }// end function

		private function mouseOverHandler(e:MouseEvent):void 
		{
			tt.autoSize = false;
			tt.show(this, "查看黄钻特权","");
		}
		
		//用户头像点击
		private function onAvatarClick(event:MouseEvent) : void
        {
            LockScreen.getInstance().show(true);
			//从服务器中获取用户初始信息
            //SMZTController.getInstance().initPlayerInfo(ModelLocator.getInstance().currentUId, this.onCallBack);
			onCallBack(null);
            return;
        }// end function

        private function onCallBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
			//显示用户个人信息面板
            //PlayerAttrInfoPane.getInstance().show(true);
            return;
        }// end function
		
		//用户信息更新时更新界面信息
		private function onPlayerDataRefresh(event:SMZTDataChangeEvent) : void
		   {
			   if (PlayerData.getInstance().pfqq == null) {
				//不是腾讯平台
				_yellowBt.visible = false;
				}else {
					//是腾讯平台
					_yellowBt.visible = true;
					_yellowBt.buttonMode = true;
				}
			   return;
		   }// end function
		
		 //配置UI
		private function configerUIInstance() : void
        {
			_yellowIco = new YellowIco();
			_yellowIco.visible = false;
			addChild(_yellowIco);
			
			_yellowBt = getChild("yellowBt") as MovieClip;
			_yellowBt.visible = false;
			_yellowBt.addEventListener(MouseEvent.CLICK, showYellowPanel);
			_yellowBt.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			
			_activeListBt = getChild("activeListBt") as MovieClip;
			_chargeBt = getChild("chargeBt") as MovieClipButton;
			_chargeBt.onClick = onChargeHandlerClick;
			_activeBt = getChild("activeBt") as MovieClipButton;
			_eventTower = getChild("eventTower") as MovieClipButton;
			_eventTower.onClick = eventTowerClick;
			
			//trace(ApplicationConfig.mainConfig.module.eventTower.@show)
			if (ApplicationConfig.mainConfig.module.eventTower.@show == "true") {
				_eventTower.visible = true;
				}else {
					_eventTower.visible = false;
					}
			
			
			_activeListBt.stop();
			_activeListBt.buttonMode = true;
			_activeListBt.addEventListener(MouseEvent.CLICK, activeListBtClick);
			
			_activeBt.onClick = activeClick;
			if (ApplicationConfig.mainConfig.event == "none")
            {
                _activeBt.visible = false;
            }
			
			_vipBt = getChild("vipBt") as MovieClipButton;
			_vipBt1 = getChild("vipBt1") as MovieClipButton;
			//_vipBt.visible = false;//暂时隐藏ＶＩＰ功能
			_vipBt.onClick = vipClick;
			_vipBt1.onClick = vipClick;
			_nameText = getChild("nameText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			_levelText = getChild("levelText") as TextField;
			_goldText = getChild("goldText") as TextField;
			_cryText = getChild("cryText") as TextField;
			_honorText = getChild("honorText") as TextField;
			ApplicationConfig.setDefaultTextFormat(_nameText);
			
			_expBar = getChild("expBar") as MovieClip;
			_expMc = getChild("expMc") as Sprite;
			//_cardsNumText = getChild("cardsNumText") as TextField;
			_vipico = getChild("vipico") as MovieClip;
			_vipico.stop();
			_vipico.visible = true;
			//_expText.text ="";
			
			_expMc.addEventListener(MouseEvent.MOUSE_OVER, this.showExp);
			//_expText.addEventListener(MouseEvent.MOUSE_OVER, this.onTextOver);
            //_expText.addEventListener(MouseEvent.MOUSE_OUT, this.onTextOver);
			
			this._nameText.addEventListener(MouseEvent.MOUSE_OVER, this.showName);
			_levelText.mouseEnabled = false;
			//_nameText.mouseEnabled = false;
			_goldText.mouseEnabled = false;
			_cryText.mouseEnabled = false;
			_honorText.mouseEnabled = false;
			//音效设置
			if (ModelLocator.getInstance().SEisMute)
            {
				SMZTUIManager.getInstance().helpSoundBtBBSController.sound2Bt.gotoAndStop(2);
            }
            else
            {
				
				SMZTUIManager.getInstance().helpSoundBtBBSController.sound2Bt.gotoAndStop(1);
            }
			//音乐设置
            if (ModelLocator.getInstance().isMute)
            {
				SMZTUIManager.getInstance().helpSoundBtBBSController.soundBt.gotoAndStop(2);
                /*this.soundBtn.gotoAndStop(2);
                if (SMZTPlayer.getInstance()._SMZTPlayer)
                {
                    SMZTPlayer.getInstance()._SMZTPlayer.setVolume(0);
                }*/
            }
            else
            {
				
				SMZTUIManager.getInstance().helpSoundBtBBSController.soundBt.gotoAndStop(1);
                /*this.soundBtn.gotoAndStop(1);
                if (SMZTPlayer.getInstance()._SMZTPlayer)
                {
                    SMZTPlayer.getInstance()._SMZTPlayer.setVolume(1);
                }*/
            }
           
        }// end function
		
		/**
		 * 充值按钮
		 * @param	e
		 */
		private function onChargeHandlerClick(e:MouseEvent):void 
		{
			Browser.charge();
			//navigateToURL(new URLRequest(ApplicationConfig.mainConfig.chargeURL), ApplicationConfig.mainConfig.chargeURL.@method);
		}
		
		/**
		 * 显示黄钻面板
		 */
		private function showYellowPanel(e:MouseEvent):void 
		{
			if (PlayerData.getInstance().pfqq == null) {
				//不是腾讯平台
				_yellowBt.visible = false;
				return;
				}else {
					//是腾讯平台
					SMZTController.getInstance().getAwardYellowData(function (param:Object):void {
						AwardYellowInfo.getInstance().setData(param);//更新礼包信息
						QQYellowPanel.getInstance().show(true);
						})
					}
		}
		
		private function eventTowerClick(e:MouseEvent):void 
		{
			if (EventTowerPanel.firstLoad) {
				ModuleLoadControler.getInstance().show(true);
				ModuleLoadControler.getInstance().starLoad(ModelLocator.getInstance().staticURL +ApplicationConfig.mainConfig.module.eventTower.@source, function ():void {
					EventTowerPanel.firstLoad = false;
					SMZTUIManager.getInstance().eventTowerPanel = new EventTowerPanel();
					EventTowerModel.getInstance().getPassInfo();
					SMZTUIManager.getInstance().eventTowerPanel.show(true);
					});
				}else {
					EventTowerModel.getInstance().getPassInfo();
					SMZTUIManager.getInstance().eventTowerPanel.show(true);
					}
		}
		
		/**
		 * 点击打开女神像
		 */
		private function activeListBtClick(e:MouseEvent):void 
		{
			//女神像以弹窗形式
			SMZTController.getInstance().getActivityListData(function (param:Object):void {
				StatueModel.getInstance().setData(param);
				StatuePanel.getInstance().show(true);
				});
			SMZTController.getInstance().getSignInfo(function (param:Object):void {
				SignModel.getInstance().setData(param);
				})
		}
		/**
		 * 活动
		 */
		private function activeClick(e:MouseEvent):void 
		{
			if (ApplicationConfig.mainConfig.event == "none")
            {
                return;
            }
			var mdl:ModuleLoader;
            
			mdl = new ModuleLoader();
			mdl.show(ApplicationConfig.mainConfig.event);
			mdl.addEventListener("MODULE_LOAD", function onEventModuleLoad(event:Event):void {
				mdl.instance["showActive"](EventController.getInstance().events, ApplicationConfig.mainConfig.staticURL, PlayerData.getInstance().userId,LockScreen.getInstance(),ApplicationConfig.mainConfig.events);//如果有活动加载活动界面
				mdl = null;
				return;
				});
			
		}
		
		/**
		 * ＶＩＰ
		 * @param	e
		 */
		private function vipClick(e:MouseEvent):void 
		{
			var _vipstate:VipState = new VipState();
			var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance["showModel"](_vipstate, function (bm:BonusModel, type:int, lv:int = 0):void {
					if (type == 1) {
						//每日领取
						SMZTController.getInstance().getDialyGift(function():void {
							SMZTUIManager.getInstance().manageShowBonus.showBonus(bm);
							//刷新ＶＩＰ面板
							refreshVIPPanel();
							} );
						}else {
							//一次领取
							SMZTController.getInstance().getOnceGift(lv,function():void {
								SMZTUIManager.getInstance().manageShowBonus.showBonus(bm);
								//刷新ＶＩＰ面板
								refreshVIPPanel();
								} );
							}
					},SMZTUIManager.getInstance().bagPopPanel,ModelLocator.getInstance().staticURL);//把会员信息传给加载进来的ＶＩＰ界面模块
                return;
            }
			/**
			 * 重新获取数据模型，从而更新ＶＩＰ界面
			 */
			function refreshVIPPanel():void {
				SMZTController.getInstance().getVipState(function (param:Object):void {
					_vipstate.setData(param);
					//mdl.instance["refresh"](VipState.getInstance());
					})
				}
			
            mdl = new ModuleLoader();
			//获取会员信息
			SMZTController.getInstance().getVipState(function (param:Object):void {
				_vipstate.setData(param);
				mdl.show(ApplicationConfig.mainConfig.VIP_UI);
				})
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
		}
		
		
        /*public function removeRemindSign() : void
        {
            this.btnContainer.removeAll();
            return;
        }// end function

        public function addWinningGoalFb() : void
        {
            var _loc_1:Loader = new Loader();
            _loc_1.load(new URLRequest(ModelLocator.getInstance().staticURL + ApplicationConfig.mainConfig.imgSrc + "events/event_9c.swf"));
            this.btnContainer.appendChild(_loc_1);
            _loc_1.addEventListener(MouseEvent.CLICK, this.onWinningGoalFbClick);
            return;
        }// end function

        private function onWinningGoalFbClick(event:MouseEvent) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            var event:* = event;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance.staticURL = ModelLocator.getInstance().staticURL;
                mdl.instance.dynamicURL = ModelLocator.getInstance().dynamicURL;
                mdl.instance.imgSrc = ApplicationConfig.mainConfig.imgSrc;
                mdl.instance.fire();
                return;
            }// end function
            ;
            mdl = new ModuleLoader();
            mdl.show(ApplicationConfig.mainConfig.imgSrc + "events/event_9c_fb.swf");
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function

        public function addEventSign(param1:int) : void
        {
            var _loc_2:String = "ex" + param1.toString() + ".swf";
            var _loc_3:Loader= new Loader();
            _loc_3.load(new URLRequest(ModelLocator.getInstance().staticURL + ApplicationConfig.mainConfig.imgSrc + "events/" + _loc_2));
            _loc_3.name = _loc_2.replace(".swf", "");
            this.btnContainer.appendChild(_loc_3);
            _loc_3.addEventListener(MouseEvent.CLICK, this.onEventClick);
            return;
        }// end function

        private function onEventClick(event:MouseEvent) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            var event:* = event;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance.staticURL = ModelLocator.getInstance().staticURL;
                mdl.instance.dynamicURL = ModelLocator.getInstance().dynamicURL;
                mdl.instance.imgSrc = ApplicationConfig.mainConfig.imgSrc;
                mdl.instance.fire();
                return;
            }// end function
            ;
            mdl = new ModuleLoader();
            mdl.show(ApplicationConfig.mainConfig.imgSrc + "events/" + event.currentTarget.name + "_event.swf");
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function

        public function addRemindSign(param1:int = 1) : void
        {
            switch(param1)
            {
                case 10:
                {
                    if (!this.btnContainer.contains(this.winnigSoccerSign))
                    {
                        this.btnContainer.appendChild(this.winnigSoccerSign);
                    }
                    break;
                }
                case 9:
                {
                    if (!this.btnContainer.contains(this.kaixinCitySign))
                    {
                        this.btnContainer.appendChild(this.kaixinCitySign);
                    }
                    break;
                }
                case 1:
                {
                    if (!this.btnContainer.contains(this.budoukaiSign))
                    {
                        this.btnContainer.appendChild(this.budoukaiSign);
                    }
                    break;
                }
                case 2:
                {
                    if (!this.btnContainer.contains(this.arenaSign))
                    {
                        this.btnContainer.appendChild(this.arenaSign);
                    }
                    break;
                }
                case 3:
                {
                    if (!this.btnContainer.contains(this.teaseSign))
                    {
                        this.btnContainer.appendChild(this.teaseSign);
                    }
                    break;
                }
                case 4:
                {
                    if (!this.btnContainer.contains(this.teaseGetSign))
                    {
                        this.btnContainer.appendChild(this.teaseGetSign);
                    }
                    break;
                }
                case 5:
                {
                    if (!this.btnContainer.contains(this.newBieItemMc))
                    {
                        this.btnContainer.appendChild(this.newBieItemMc);
                    }
                    break;
                }
                case 6:
                case 7:
                {
                    if (!this.btnContainer.contains(this.fansSign))
                    {
                        this.btnContainer.appendChild(this.fansSign);
                    }
                    break;
                }
                case 8:
                {
                    if (!this.btnContainer.contains(this.addFriendSign))
                    {
                        this.btnContainer.appendChild(this.addFriendSign);
                    }
                    break;
                }
                case 11:
                {
                    if (!this.btnContainer.contains(this.rouletSign))
                    {
                        this.btnContainer.appendChild(this.rouletSign);
                    }
                    break;
                }
                case 12:
                {
                    if (!this.btnContainer.contains(this.thanksSign))
                    {
                        this.btnContainer.appendChild(this.thanksSign);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function showEvent(param1:Boolean) : void
        {
            if (getChild("eventb") as SimpleButton)
            {
                (getChild("eventb") as SimpleButton).visible = param1;
            }
            if (getChild("duib") as MovieClip && ApplicationConfig.mainConfig.giftExchange == 1)
            {
                (getChild("duib") as MovieClip).visible = param1;
            }
            return;
        }// end function

        

        private function onQifuClick(event:MouseEvent) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            var event:* = event;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance.dynamicURL = ModelLocator.getInstance().dynamicURL;
                return;
            }// end function
            ;
            mdl = new ModuleLoader();
            mdl.show(ApplicationConfig.mainConfig.qifu);
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function

        

		//黄钻请求
        public function onHuangzuanTequan(event:MouseEvent = null) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            var event:* = event;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance.staticURL = ModelLocator.getInstance().staticURL;
                mdl.instance.dynamicURL = ModelLocator.getInstance().dynamicURL;
                mdl.instance.imgSrc = ApplicationConfig.mainConfig.imgSrc;
                mdl.instance.fire(PlayerData.getInstance().sinaVip);
                return;
            }// end function
            ;
            mdl = new ModuleLoader();
            mdl.show(ApplicationConfig.mainConfig.hztq);
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function

        private function onHuangzuanXinJi(event:MouseEvent) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            var event:* = event;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance.staticURL = ModelLocator.getInstance().staticURL;
                mdl.instance.dynamicURL = ModelLocator.getInstance().dynamicURL;
                mdl.instance.imgSrc = ApplicationConfig.mainConfig.imgSrc;
                mdl.instance.fire(PlayerData.getInstance().sinaVip);
                return;
            }// end function
            ;
            mdl = new ModuleLoader();
            mdl.show(ApplicationConfig.mainConfig.hzxj);
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function

        public function onHuangzuanXinshou(event:MouseEvent = null) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            var onUserInfoUp:Function;
            var event:* = event;
            onEventModuleLoad = function (event:Event) : void
            {
                mdl.instance.staticURL = ModelLocator.getInstance().staticURL;
                mdl.instance.dynamicURL = ModelLocator.getInstance().dynamicURL;
                mdl.instance.imgSrc = ApplicationConfig.mainConfig.imgSrc;
                mdl.instance.fire(PlayerData.getInstance().sinaVip);
                return;
            }// end function
            ;
            onUserInfoUp = function (event:Event) : void
            {
                SMZTController.getInstance().initPlayerInfo();
                return;
            }// end function
            ;
            mdl = new ModuleLoader();
            mdl.show(ApplicationConfig.mainConfig.hzxs);
            mdl.addEventListener("USER_INFO", onUserInfoUp);
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function

        

        protected function giftExchange(event:MouseEvent) : void
        {
            GiftExchangePane.getInstance().show(true);
            return;
        }// end function

        protected function goEvent(event:MouseEvent) : void
        {
            ApplicationController.getInstance().checkEvent(null, true);
            return;
        }// end function

        private function hideTr(event:MouseEvent) : void
        {
            this.tt.hide();
            return;
        }// end function

        private function showTr(event:MouseEvent) : void
        {
            return;
        }// end function

        private function ccd(event:MouseEvent) : void
        {
            PlayerAttrInfoPane.getInstance().show(true);
            SMZTController.getInstance().initPlayerInfo();
            return;
        }// end function

        private function onShowBagCallBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
            ItemBagPane.getInstance().switchTab(4);
            return;
        }// end function

        private function onSignClick(event:MouseEvent) : void
        {
            var _loc_2:ModuleLoader = null;
            var _loc_3:ModuleLoader = null;
            switch(event.currentTarget)
            {
                case this.rouletSign:
                {
                    ExternalInterface.call("showActBox");
                    break;
                }
                case this.getPrizeSign:
                {
                    break;
                }
                case this.fansSign:
                {
                    if (ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA)
                    {
                        navigateToURL(new URLRequest("http://weibo.com/lqjsg"), "_blank");
                    }
                    else if (ModelLocator.getInstance().isQQRelated())
                    {
                        navigateToURL(new URLRequest("http://user.qzone.qq.com/2202411495/"), "_blank");
                    }
                    else
                    {
                        ExternalInterface.call("showfanbox");
                    }
                    break;
                }
                case this.budoukaiSign:
                {
                    BudoukaiSignUpPane.getInstance().show(true);
                    break;
                }
                case this.teaseSign:
                {
                    AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.PlayerInfoPane.TeaseRemind.@Text);
                    break;
                }
                case this.arenaSign:
                {
                    SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_ARENA_SCENE);
                    break;
                }
                case this.teaseGetSign:
                {
                    AchievePane.getInstance().show(true);
                    SMZTController.getInstance().initAchivementsList();
                    break;
                }
                case this.newBieItemMc:
                {
                    ItemBagPane.getInstance().show(true);
                    LockScreen.getInstance().show(true);
                    SMZTController.getInstance().initPlayerBag(this.onShowBagCallBack);
                    break;
                }
                case this.addFriendSign:
                {
                    GetStudentPane.getInstance().show(true);
                    break;
                }
                case this.kaixinCitySign:
                {
                    _loc_2 = new ModuleLoader();
                    _loc_2.show(ApplicationConfig.mainConfig.kaixinAd);
                    break;
                }
                case this.winnigSoccerSign:
                {
                    _loc_3 = new ModuleLoader();
                    _loc_3.show(ApplicationConfig.mainConfig.winningAd);
                    break;
                }
                case this.thanksSign:
                {
                    DailyEventPane.getInstance().show(true);
                    DailyEventPane.getInstance().initLotteryData();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        
		
        private function onSoundClick(event:MouseEvent) : void
        {
            if (this.soundBtn.currentFrame == 1)
            {
                this.soundBtn.gotoAndStop(2);
                ModelLocator.getInstance().isMute = true;
                if (SMZTPlayer.getInstance()._SMZTPlayer)
                {
                    SMZTPlayer.getInstance()._SMZTPlayer.setVolume(0);
                }
                FlashCookie.setCookie("smvolume", "isMute", "On");
            }
            else
            {
                this.soundBtn.gotoAndStop(1);
                ModelLocator.getInstance().isMute = false;
                if (SMZTPlayer.getInstance()._SMZTPlayer)
                {
                    SMZTPlayer.getInstance()._SMZTPlayer.setVolume(1);
                }
                FlashCookie.setCookie("smvolume", "isMute", "Off");
            }
            return;
        }// end function

        private function sendMail(event:MouseEvent) : void
        {
            navigateToURL(new URLRequest("mailto:sgq_bugreport@corp.the9.com?subject=报错、建议、说几句"), "_parent");
            return;
        }// end function

       
        

        private function showPane(event:Event) : void
        {
            switch(event.currentTarget.name)
            {
                case "rankBtn":
                {
                    SMZTController.getInstance().initRankList(0, 1);
                    RankPane.getInstance().show(true);
                    break;
                }
                case "fBtn":
                {
                    FavoritePane.getInstance().show(true);
                    SMZTController.getInstance().initFavoriteList();
                    break;
                }
                case "shopBtn":
                {
                    ShopPane.getInstance().show(true);
                    SMZTController.getInstance().initShopList();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        

        public function enterChampion() : void
        {
            this.huangzuantq.visible = false;
            this.huangzuanxs.visible = false;
            this.huangzuanxj.visible = false;
            if (getChild("qifu"))
            {
                getChild("qifu").visible = false;
            }
            return;
        }// end function

        public function leaveChampion() : void
        {
            var _loc_1:* = this.playerData.sinaVip == 0 && ModelLocator.getInstance().isQQRelated();
            var _loc_2:* = (this.playerData.newbieStep & 1 << 28) != 1 << 28 && ModelLocator.getInstance().isQQRelated();
            var _loc_3:* = isHome;
            var _loc_4:* = this.playerData.skin == 0;
            this.huangzuanxs.visible = _loc_1 || _loc_2;
            if (!_loc_3)
            {
                this.huangzuanxs.visible = false;
            }
            this.huangzuantq.visible = ModelLocator.getInstance().isQQRelated() && _loc_3;
            this.huangzuanxj.visible = ModelLocator.getInstance().isQQRelated() && _loc_3 && _loc_4;
            if (getChild("qifu"))
            {
                getChild("qifu").visible = ModelLocator.getInstance().snsType != ModelLocator.SNS_GUMMY || ModelLocator.getInstance().snsType != ModelLocator.SNS_MIXI;
            }
            this.posIco();
            return;
        }// end function

        private function posIco() : void
        {
            if (!this.huangzuanxs.visible)
            {
                this.huangzuanxj.x = 515.8;
            }
            else
            {
                this.huangzuanxs.x = 487.9;
                this.huangzuanxj.x = 455.8;
            }
            return;
        }// end function*/

		private function showExp(event:MouseEvent) : void
        {
            if (this.playerData)
            {
				ToolTip.getInstance().autoSize = true;
				////当前的经验/升级的经验
                ToolTip.getInstance().show(event.currentTarget as DisplayObject, "", "<font color=\'#ffffff\'>" + this.playerData.expGain.toString() + " / " + this.playerData.expRec.toString() + "</font>");
            }
            return;
        }// end function
		
		private function showName(event:MouseEvent) : void
        {
            if (this.playerData)
            {
				ToolTip.getInstance().autoSize = true;
                ToolTip.getInstance().show(event.currentTarget as DisplayObject, "", "<font color=\'#ffffff\'>" + this.playerData.nick + "</font>");
            }
            return;
        }// end function
		
		override protected function onUIdChange(event:SMZTDataChangeEvent) : void
        {
            /*if (helpBtn)
            {
                helpBtn.visible = isHome;
            }
            if (chargeMoneyBtn)
            {
                chargeMoneyBtn.visible = isHome && ApplicationConfig.mainConfig.chargeInGame == 1 && !ModelLocator.getInstance().isQQRelated();
            }
            (getChild("gmmc") as MovieClip).visible = isHome;
            this.goldText.visible = isHome;
            this.fooText.visible = isHome;
            this.buffContainer.visible = isHome;*/
            return;
        }// end function

		
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            //var _loc_2:UserBuff = null;
            if (String(ApplicationConfig.mainConfig.gamead) != "" && !this.ad)
            {
				//有广告的话加载广告，预留功能
                //this.loadAd();
            }
			//_cardsNumText.text = String(playerData.cardsNum);
            //_expText.text = playerData.expStr;
			//_vipico.visible = playerData.ownVip;
			
			if (playerData.ownVip) {
				_vipico.gotoAndStop(playerData.vipLevel+1);
				}else {
					_vipico.gotoAndStop(1);
					}
			_expBar.gotoAndStop(this.playerData.expRatio);
			if (!icoBox.ico) {
				if(this.icoBox.icoUri!=this.playerData.avatar){
				this.icoBox.ico = this.playerData.avatar;
				this.icoBox.icoUri = this.playerData.avatar;
				}
				}
			
			this._goldText.text = this.playerData.gold.toString();
			_cryText.text = this.playerData.crystal.toString();
			_honorText.text = playerData.honor.toString();
			_nameText.text = playerData.nick;
			
			if (PlayerData.getInstance().pfqq == null) {
				//不是腾讯平台
				_yellowIco.visible = false;
				
				}else {
					//是腾讯平台
					_yellowIco.visible = true;
					_yellowIco.x = _nameText.x + _nameText.textWidth + 10;
					if (_yellowIco.x > 160.2)_yellowIco.x = 160.2;
					_yellowIco.y = _nameText.y-3;
					_yellowIco.updataUI(playerData.pfqq);
				}
			
			_levelText.text = playerData.level.toString();
			
			//Debug.log("PlayerInfoPanelOver");
            /*(getChild("sv") as MovieClip).visible = this.playerData.sinaVip > 0 && ModelLocator.getInstance().snsType == ModelLocator.SNS_SINA;
            if (this.playerData.sinaVip > 0)
            {
                (getChild("sv") as MovieClip).gotoAndStop(this.playerData.sinaVip);
            }*/
			
			
			
			
            
            /*this.buffContainer.removeAll();
            for each (_loc_2 in this.playerData.buffArr)
            {
                
                this.buffContainer.appendChild(_loc_2.buffAvatar);
            }
            this.goldText.visible = isHome;
            getChild("goldmc").visible = isHome;
            getChild("attrppmc").visible = this.playerData.attrPoint > 0 && ModelLocator.getInstance().currentUId == ModelLocator.getInstance().uId;
            if (ModelLocator.getInstance().isQQRelated())
            {
                (getChild("goldmc") as MovieClip).gotoAndStop(2);
            }
            else
            {
                (getChild("goldmc") as MovieClip).gotoAndStop(1);
            }
            var _loc_3:* = this.playerData.sinaVip == 0 && ModelLocator.getInstance().isQQRelated();
            var _loc_4:* = (this.playerData.newbieStep & 1 << 28) != 1 << 28 && ModelLocator.getInstance().isQQRelated();
            var _loc_5:* = isHome;
            var _loc_6:* = this.playerData.skin == 0;
            this.huangzuanxs.visible = _loc_3 || _loc_4;
            if (!_loc_5)
            {
                this.huangzuanxs.visible = false;
            }
            this.huangzuanxj.visible = ModelLocator.getInstance().isQQRelated() && _loc_5 && _loc_6;
            this.huangzuantq.visible = ModelLocator.getInstance().isQQRelated() && _loc_5;
            this.posIco();
            if (SMZTUIManager.getInstance().mainPane.isChampionCupsScene)
            {
                this.huangzuanxs.visible = false;
                this.huangzuanxj.visible = false;
                this.huangzuantq.visible = false;
            }*/
            return;
        }// end function
		
		/*private function loadAd() : void
        {
            this.ad = true;
            this.adLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onAdModuleLoad);
            this.adLoader.load(new URLRequest(ModelLocator.getInstance().staticURL + "game/" + ApplicationConfig.VERSION + "/assets/images/" + String(ApplicationConfig.mainConfig.gamead)));
            return;
        }// end function

        private function onAdModuleLoad(event:Event) : void
        {
            var _loc_2:* = this.adLoader.content;
            _loc_2.staticURL = ModelLocator.getInstance().staticURL;
            _loc_2.dynamicURL = ModelLocator.getInstance().dynamicURL;
            var _loc_3:int = 62;
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_RR)
            {
                _loc_3 = 61;
            }
            if (ModelLocator.getInstance().snsType == ModelLocator.SNS_KX)
            {
                _loc_3 = 62;
            }
            _loc_2.addEventListener("IG", this.igUpdate);
            _loc_2.fire(_loc_3, PlayerData.getInstance().userId.toString(), SMZTUIManager.getInstance().mainPane._uiLayer, 760, 570, new Point(660, 446));
            return;
        }// end function

        private function igUpdate(event:Event) : void
        {
            SMZTSystemManager.getInstance().refreshHeartBeat();
            return;
        }// end function*/
		
        private function onTextOver(event:MouseEvent) : void
        {
            if (event.type == MouseEvent.MOUSE_OVER)
            {
                //this._expText.text = this.playerData.expGain.toString() + " / " + this.playerData.expRec.toString();//当前的经验/升级的经验
            }
            else
            {
                //this._expText.text = "";
            }
            return;
        }// end function
		
		public function get controlFullBt():FullSceneControla 
		{
			return _controlFullBt;
		}
		
		public function get activeListBt():MovieClip 
		{
			return _activeListBt;
		}
		
		public function set activeListBt(value:MovieClip):void 
		{
			_activeListBt = value;
		}
		

    }
}
