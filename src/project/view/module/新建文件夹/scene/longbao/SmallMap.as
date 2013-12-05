package project.view.module.scene.longbao 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.SpecialItemIdConfig;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.model.longBao.LongBaoModel;
	import project.model.newBie.NewBieModelId;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.view.base.BaseTitleWindow;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import project.view.layout.BaseGridContainer;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.DeckPane.CreaCardGroupPane;
	import project.view.module.bagpanel.BagPanel;
	import project.controller.SMZTController;
	import project.view.module.helppane.NewbiePane;
	import project.view.module.shop.shopPanel;
	//import com.gfx.PerlinDistort;
	/**
	 * 小地图容器
	 * @author bbjxl 2013
	 */
	public class SmallMap extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _bg:Sprite;//地图层
		private var _grid:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var _groupBt:MovieClipButton;
		private var _packageBt:MovieClipButton;
		private var _shopBt:MovieClipButton;
		
		private var _ruleBt:MovieClipButton;//规则
		private var _buyBt:MovieClipButton;//购买
		private var _worldBt:MovieClipButton;//返回大地图
		private var _power:PowerBar;//体力栏
		private var _title:TitleBar;
		private var _smallMapBase:SmallMapBase;//小地图
		private var _passedNumText:TextField;//噩梦通过次数
		private var _bonusBox:ChapterBonusBox;//宝箱
		
		//private var pDist:PerlinDistort;
		//-----------------------数据---------------------------------
		private static var _smallMap:SmallMap;
		//-----------------------事件--------------------------------
		public function SmallMap() 
		{
			if (_smallMap != null) {
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
				}
			this.rootContainer = SMZTUIManager.getInstance().longBaoScene._smallMapLayer;
			setSpriteInstance("smallMapUI");
			confingerInstance();
		}
		public static function getInstance() : SmallMap
		{
			if (_smallMap == null)
			{
			  _smallMap = new SmallMap;
			}
			return _smallMap; 
		}// end function
		private function confingerInstance():void 
		{
			_bg = new Sprite();
			addChildAt(_bg, 0);
			
			_passedNumText = getChild("passedNumText") as TextField;
			_bonusBox = new ChapterBonusBox();
			addChild(_bonusBox);
			_bonusBox.x = 204;
			_bonusBox.y = 3.2;
			//_bonusBox = getChild("bonusBox") as MovieClipButton;
			//_bonusBox.toolTip = "噩梦通关次数达到5次才可开启宝箱！";
			_ruleBt = getChild("ruleBt") as MovieClipButton;
			_buyBt = getChild("buyBt") as MovieClipButton;
			_worldBt = getChild("worldBt") as MovieClipButton;
			//_bonusBox.onClick = clickhandler;
			_ruleBt.onClick = clickhandler;
			_buyBt.onClick = clickhandler;
			_buyBt.visible = false;
			_worldBt.onClick = clickhandler;
			_power=new PowerBar(getChild("powerUI") as MovieClip)
			_title = new TitleBar(getChild("titleUI"));
			_title.setLocation(ApplicationConfig.STAGE_WIDTH-_title.width>>1,_title.y)
			_smallMapBase = new SmallMapBase();
			_bg.addChild(_smallMapBase);
			
			var uiContent:Sprite = SMZTResourceManager.getInstance().getRes("BottomBarPane", SMZTDomainManager.getInstance().currentUIAppDomain) as Sprite;
			_groupBt = uiContent["groupBt"] as MovieClipButton;
			_packageBt = uiContent["packageBt"] as MovieClipButton;
			_shopBt = uiContent["shopBt"] as MovieClipButton;
			_groupBt.onClick = showPane;
			_packageBt.onClick = showPane;
			_shopBt.onClick = showPane;
			_groupBt.x = 408.15;
			_groupBt.y = 602.5;
			_packageBt.x = 506.25;
			_packageBt.y = 612.5;
			_shopBt.x = 575.2;
			_shopBt.y = 592.65;
			addChild(_groupBt);
			addChild(_packageBt);
			addChild(_shopBt);
			/*_grid = new BaseGridContainer(1, 3, 10, _groupBt.width, _groupBt.height);
			_grid.appendChild(_groupBt);
			_grid.appendChild(_packageBt);
			_grid.appendChild(_shopBt);
			addChild(_grid);*/
			
			//pDist = new PerlinDistort(SMZTUIManager.getInstance().longBaoScene.bigMapLayer,20,20);
			//addChild(pDist);
		}
		
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
					CreaCardGroupPane.getInstance().show(true);
                    break;
                }

				case _packageBt:
                {
					//背包
					BagPanel.getInstance().show(true);
					SMZTController.getInstance().getBagData();
					//-------------------新手引导用-----------------------
					/*if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
						NewBieControler.getInstance().nextStep();
						}*/
					//--------------------end--------------------
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
				
                default:
                {
                    break;
                }
            }
            return;
        }// end function
		
		public function updata():void {
			_title.updataUI();
			
			updataPowerUI();
			
					
			_smallMapBase.setData();
			}
			
		public function updataPowerUI():void {
			_power.energy = LongBaoModel.getInstance().energy;
			_power.maxEnergy = LongBaoModel.getInstance().maxEnergy;
			_power.updata();
			}
		
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
				//pDist.start_noise();
				//pDist.addEventListener("NOISE_ON_COMPLETE", transitionComplete);
				//return;
				
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				
            }
            this.playShowSound();
            return;
        }// end function
		
		private function transitionComplete(e:Event):void 
		{
			/*rootContainer.addChild(this);
			this.isOpened = true;
            this.isPopUP = true;
			pDist.clear();*/
			
			//pDist.swapBmp(this);
			//pDist.end_noise();
		}
		
		private function clickhandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _ruleBt:
					RulePanel.getInstance().show(true);
					break;
				
				case _buyBt:
					UseItemControler.showBuyWin(SpecialItemIdConfig.STORY_ITEM);
					break;
				case _worldBt:
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
						NewBieControler.getInstance().nextStep();
						NewbiePane.getInstance().show();
						}
					//--------------------end--------------------
					hide();
					break;
				}
		}
		
		//关闭
        override public function hide(event:MouseEvent = null) : void
        {
			
			
            if (rootContainer)
            {
				SMZTUIManager.getInstance().longBaoScene._enterMapFlag = true;
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
				
				
				
                if (showEffect)
                {
                    TweenLite.to(this, 0.3, {alpha:0.2, onComplete:this.onTweenClose});
                }
                else
                {
                    if (rootContainer.contains(this))
                    {
                        rootContainer.removeChild(this);
						
                    }
                    this.isOpened = false;
                    this.isPopUP = false;
                }
				
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		public function get power():PowerBar 
		{
			return _power;
		}
		
		public function get passedNumText():TextField 
		{
			return _passedNumText;
		}
		
		public function get bonusBox():ChapterBonusBox 
		{
			return _bonusBox;
		}
		
		
		
	}

}