package project.view.module.bottombar
{
	/*
	* 描述：下面的背包等按钮
	* 
	*/
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
	import project.config.ApplicationConfig;
	import project.controller.AttackController;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.achievement.AchievementModel;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.defence.DefenceModel;
	import project.model.log.EventLogModel;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModelId;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.achievement.AchievementPanel;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.bagpanel.BagPanel;
	import project.view.module.base.ModuleLoader;
	import project.view.module.DeckPane.CreaCardGroupPane;
	import project.view.module.defence.DefencePanel;
	import project.view.module.loading.LockScreen;
	import project.view.module.log.LogPanel;
	import project.view.module.rank.RankPanel;
	import project.view.module.shop.shopPanel;
	//import project.view.module.playerinfo.PlayerAttrInfoPane;
    /*import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.events.*;
    import project.model.*;
    import project.model.data.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.achieve.*;
    import project.view.module.bagpane.*;
    import project.view.module.base.*;
    import project.view.module.favorite.*;
    import project.view.module.feed.*;
    import project.view.module.loading.*;
    import project.view.module.playerinfo.*;*/

	/**
	 * 佣兵团：groupBt
		包裹：packageBt
		日志：logBt
		排行：rankingBt
		成就：achievementBt
		商城：shopBt
	 */
    public class BottomBarPane extends BaseSpritePane
    {
        private var _achiveffect:MovieClip;//有成就提示动画
		
		private var _groupBt:MovieClipButton;
		private var _defense:MovieClipButton;//防御塔
		private var _packageBt:MovieClipButton;
		private var _logBt:MovieClipButton;
		private var _rankingBt:MovieClipButton;
		private var _achievementBt:MovieClipButton;
		private var _shopBt:MovieClipButton;
		
		private var _backBt:SimpleButton;//返回按钮
		
        private var versionText:TextField;
        //public var newmc:MovieClip;

        public function BottomBarPane()
        {
            setSpriteInstance("BottomBarPane");
            setLocation(0, ApplicationConfig.STAGE_HEIGHT-spriteInstance.height);
            this.configerUIInstance();
            dataModel = PlayerData.getInstance();
            this.refreshState();
            ModelLocator.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onUIdChange);
            return;
        }// end function

		/**
		 * 显示隐藏成就动画
		 * @param	value
		 */
		public function showAchivEffect(value:Boolean=false):void {
			_achiveffect.visible = value;
			}
			
        private function configerUIInstance() : void
        {
            //this.newmc = getChild("newa") as MovieClip;//是否有新任务图标
            //this.newmc.visible = false;
			
			_achiveffect = getChild("achiveffect") as MovieClip;
			_achiveffect.visible = false;
			_achiveffect.mouseEnabled = false;
			
			_groupBt = getChild("groupBt") as MovieClipButton;
			_defense = getChild("defense") as MovieClipButton;
			_packageBt = getChild("packageBt") as MovieClipButton;
			_logBt = getChild("logBt") as MovieClipButton;
			_rankingBt = getChild("rankingBt") as MovieClipButton;
			_achievementBt = getChild("achievementBt") as MovieClipButton;
			_shopBt = getChild("shopBt") as MovieClipButton;
			
			_groupBt.playxa = true;//鼠标移上有声音
			_defense.playxa = true;//鼠标移上有声音
			_packageBt.playxa = true;//鼠标移上有声音
			_logBt.playxa = true;//鼠标移上有声音
			_rankingBt.playxa = true;//鼠标移上有声音
			_achievementBt.playxa = true;//鼠标移上有声音
			_shopBt.playxa = true;//鼠标移上有声音
			
			_groupBt.onClick = showPane;
			_defense.onClick = showPane;
			_packageBt.onClick = showPane;
			_logBt.onClick = showPane;
			_rankingBt.onClick = showPane;
			_achievementBt.onClick = showPane;
			_shopBt.onClick = showPane;
			
			_backBt = getChild("SHOW_MAIN_SCENE") as SimpleButton;
			_backBt.visible = false;
			
            /*this.attrBtn = getChild("btnAttr") as MovieClipButton;//角色跟回家同位置
            this.bagBtn = getChild("btnBag") as MovieClipButton;//背包
            this.feedBtn = getChild("feBtn") as MovieClipButton;//事件
            this.acBtn = getChild("ac") as MovieClipButton;//任务
            this.favBtn = getChild("fBtn") as MovieClipButton;//收藏
            this.rankBtn = getChild("rBtn") as MovieClipButton;//排行榜
            this.shopBtn = getChild("shBtn") as MovieClipButton;//商场
            this.homeBtn = getChild("home") as MovieClipButton;//回家
            this.synthesisBtn = getChild("mobtn") as MovieClipButton;//锻造按钮*/
			
            this.versionText = getChild("vt") as TextField;//版本
            this.versionText.text = ApplicationConfig.FLASH_VERSION;

            /*this.newQuestMc = getChild("nmmc") as MovieClip;//新任务时提示效果
            this.newQuestMc.visible = false;
            this.newQuestMc.mouseChildren = false;
            this.newQuestMc.mouseEnabled = false;
            this.newQuestMc.gotoAndStop(1);*/
			
            //this.synthesisBtn.visible = ApplicationConfig.mainConfig.dungeon == 1;
            
			
            return;
        }// end function

		/**
		 * 设置返回按钮是否可见
		 * @param	true/false;
		 */
		public function setBackBt(parma:Boolean = false):void {
			if (parma) {
				if (!_backBt.hasEventListener(MouseEvent.CLICK)) {
					_backBt.addEventListener(MouseEvent.CLICK, backClickHandler);
					}
					_backBt.visible = parma;
				}else {
					if (_backBt.hasEventListener(MouseEvent.CLICK)) {
						_backBt.removeEventListener(MouseEvent.CLICK, backClickHandler);
						}
						_backBt.visible = parma;
					}
			}
			
		/**
		 * 返回按钮点击返回到主场景
		 * @param	event
		 */
			private function backClickHandler(e:MouseEvent):void {
				SMZTUIManager.getInstance().mainPane.returnMainScene();
				setBackBt(false);
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					NewBieControler.getInstance().nextStep();
					}
				//--------------------end--------------------
				
				}
		
		//冲级面板
        /*private function chongjiClick(event:MouseEvent) : void
        {
            var mdl:ModuleLoader;
            var onEventModuleLoad:Function;
            //var event:* = event;
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
            mdl.show(ApplicationConfig.mainConfig.chongji);
            mdl.addEventListener("MODULE_LOAD", onEventModuleLoad);
            return;
        }// end function*/

		//用户ID变化时即访问朋友或回家时
        override protected function onUIdChange(event:SMZTDataChangeEvent) : void
        {
            //this.newQuest(false);
            return;
        }// end function

		//新任务效果 有时显示
        public function newQuest(param1:Boolean) : void
        {
            /*if (param1)
            {
                this.newQuestMc.visible = true;
                this.newQuestMc.gotoAndPlay(2);
            }
            else
            {
                this.newQuestMc.visible = false;
                this.newQuestMc.gotoAndStop(1);
            }*/
            return;
        }// end function

        private function goHome(event:MouseEvent) : void
        {
            LockScreen.getInstance().show(true);
            //SMZTController.getInstance().initPlayerInfo(ModelLocator.getInstance().uId, this.onInitBack);
            //SMZTUIManager.getInstance().friendPane.closeHellFuck();
            return;
        }// end function

        private function onInitBack(param1:XML) : void
        {
            SMZTUIManager.getInstance().mainScene.reCheckEvent();//检查是否有活动
            SMZTUIManager.getInstance().mainPane.returnMainScene();
            LockScreen.getInstance().hide();
            return;
        }// end function

		//数据模型变化
        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            this.refreshState();
            return;
        }// end function

		//刷新状态
        public function refreshState() : void
        {
            
            return;
        }// end function

        private function onCallBack(param1:XML) : void
        {
            LockScreen.getInstance().hide();
            return;
        }// end function

        private function showPane(event:MouseEvent) : void
        {
			SMZTUIManager.getInstance().friendsInforPanel.hide();//关闭好友个人信息面板
			SMZTUIManager.getInstance().friendsBonusPanel.hide();//关闭好友任务面板
			
            switch(event.currentTarget)
            {
				//====================================================
				case _groupBt:
                {
					//佣兵团
					/*if (BagData.getInstance().max== 0)
						{
							//背包为空时要加载背包数据再初始化要显示的场景 max为0表示没有初始获取背包数据;用于CTRL+鼠标点击时要用到背包数据判断
							SMZTController.getInstance().getBagData(false,function ():void{CreaCardGroupPane.getInstance().show(true);});
						}else {
							CreaCardGroupPane.getInstance().show(true);
							}*/
					CreaCardGroupPane.getInstance().show(true);
					//CreaCardGroupPane.getInstance().setLocation()
					//trace(CreaCardGroupPane.getInstance().width + "/" + CreaCardGroupPane.getInstance().x);
					//trace(CreaCardGroupPane.getInstance().width + "/" + CreaCardGroupPane.getInstance().x);
                    break;
                }
				case _defense:
                {
					//防御
					SMZTController.getInstance().getDefenceData(function ():void {
						DefencePanel.getInstance().show(true);
						
						//-------------------新手引导用-----------------------
						if (!NewBieControler.getInstance().finishDic[NewBieModelId.DEFFENCE]) {
							NewBieControler.getInstance().refreshByValue(NewBieModelId.DEFFENCE, 0, 0);
							}
						//--------------------end--------------------
						})
                    break;
                }
				case _packageBt:
                {
					//背包
					BagPanel.getInstance().show(true);
					SMZTController.getInstance().getBagData();
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
                    break;
                }
				case _logBt:
                {
					//日志
					SMZTController.getInstance().getLogListData(function (param:Object):void {
						EventLogModel.getInstance().setData(param);
						LogPanel.getInstance().show(true);
						});
                    break;
                }
				case _rankingBt:
                {
					//排行
					RankPanel.getInstance().show(true);
					 break;
                }
				case _achievementBt:
                {
					//成就
					SMZTController.getInstance().getAchievementList(function (param:Object):void {
						AchievementModel.getInstance().setData(param);
						AchievementPanel.getInstance().show(true);
						//-------------------新手引导用-----------------------
						if (!NewBieControler.getInstance().finishDic[NewBieModelId.ACHIVEVEMENT]) {
							NewBieControler.getInstance().refreshByValue(NewBieModelId.ACHIVEVEMENT, 0, 0);
							}
						//--------------------end--------------------
						
						})
					
                    break;
                }
				case _shopBt:
                {
					//商城
					
					SMZTController.getInstance().getShopGoods(function ():void {
						shopPanel.getInstance().show(true);
						
						});
                    break;
                }
				//====================================================
				
                /*case this.bagBtn:
                {
					//背包
					ItemBagPane.getInstance().show(true);//显示背包且初始化
                    LockScreen.getInstance().show(true);
                    //SMZTController.getInstance().initPlayerBag(this.onCallBack);//初始化用户背包信息
                    //SMZTController.getInstance().getJewelryData();
                    //SMZTController.getInstance().getSuitData();
                    break;
                }
                case this.attrBtn:
                {
					//角色
                    PlayerAttrInfoPane.getInstance().show(true);//显示角色面板
                    //SMZTController.getInstance().initPlayerInfo();
                    break;
                }
                case this.feedBtn:
                {
					//事件
                    FeedPane.getInstance().show(true);
                    LockScreen.getInstance().show(true);
                    //SMZTController.getInstance().initEventFeed(this.onCallBack);
                    break;
                }
                case this.acBtn:
                {
					//任务
                    AchievePane.getInstance().show(true);
                    SMZTController.getInstance().initAchivementsList();
                    this.newmc.visible = false;
                    break;
                }
                case this.rankBtn:
                {
					//排行
                    SMZTController.getInstance().initRankList(1, 1);
                    RankPane.getInstance().show(true);
                    break;
                }
                case this.favBtn:
                {
					//收藏
                    FavoritePane.getInstance().show(true);
                    SMZTController.getInstance().initFavoriteList();
                    break;
                }
                case this.shopBtn:
                {
					//商场
                    ShopPane.getInstance().show(true);
                    SMZTController.getInstance().initShopList();
                    break;
                }
                case this.homeBtn:
                {
					//回家
                    LockScreen.getInstance().show(true);
                    SMZTController.getInstance().initPlayerInfo(ModelLocator.getInstance().uId, this.onInitBack);
                    SMZTUIManager.getInstance().friendPane.closeHellFuck();
                    break;
                }
                case this.synthesisBtn:
                {
                    MosaicController.getInstance().showMosaic();
                    break;
                }*/
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
