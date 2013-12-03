package project.view.module.scene.longbao
{
	/**
	 *描述：远征
	 *
	 */
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.controller.ModuleLoadControler;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.longBao.LongBaoModel;
	import project.model.longBao.vo.StoryLevel;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModelId;
	import project.utils.MovieClipController;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.artplug.MovieClipButtonNoSound;
	import project.view.controls.ToolTip;
	import project.view.layout.BaseGridContainer;
	import project.view.module.helppane.NewbiePane;
	
	
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	
	
	public class LongBaoScene extends BaseGameScene
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		
		private var _backBt:MovieClipButton;
		private var _infoBt:MovieClipButton;//片头动画
		private var _bigMapLayer:BigMapLayer;//大地图层
		public var _smallMapLayer:Sprite;//小地图层
		private var _dramaPlayer:DramaPlayer;
		
		private var _loadIntro:Loader = new Loader(); //加载介绍动画
		//-----------------------数据---------------------------------
		public static var firstLoad:Boolean = true; //是否是第一次加载
		private var _longbaoModel:LongBaoModel;
		//private var _currentStoryLevel:StoryLevel;//当前挑战的关卡数据
		public var _enterMapFlag:Boolean = true;//序章剧情结束后的第一章请求回调后不进入地图内
		private var IntroEmbed:Class; //公司介绍动画类
		private var _movieMc:MovieClip;
		//-----------------------事件--------------------------------
		
		public function LongBaoScene()
		{
			
			rubishPosArr = [[360, 300], [411, 198], [646, 261]];
			sceneId = MainScene.EXPEDITOIN_SCENE;
			setSpriteInstance("longBaoScene");
			
			_longbaoModel = LongBaoModel.getInstance();
			dataModel = _longbaoModel;
			
			SMZTUIManager.getInstance().longBaoScene = this;
			configinstance();
			return;
		} // end function
		
		private function configinstance():void
		{
			RulePanel.getInstance().rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
			
			_infoBt = getChild("infoBt") as MovieClipButton;
			_backBt = getChild("backBt") as MovieClipButton;
			_backBt.onClick = backClickHandler;
			_infoBt.onClick = infoBtClickHandler;
			
			_bigMapLayer = new BigMapLayer();
			addChildAt(_bigMapLayer, 0);
			_bigMapLayer.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, enterSmallMap,true);
			
			_smallMapLayer = new Sprite();
			addChild(_smallMapLayer);
			
			_dramaPlayer = new DramaPlayer();
			addChild(_dramaPlayer);
			_dramaPlayer.addEventListener(Event.COMPLETE, onFinish);
		}
		
		/**
		 * 加载故事背景
		 * @param	e
		 */
		private function infoBtClickHandler(e:MouseEvent):void 
		{
			ModuleLoadControler.getInstance().show(true);
			ModuleLoadControler.getInstance().starLoad(ModelLocator.getInstance().staticURL +ApplicationConfig.mainConfig.storyintro, function ():void {
				IntroEmbed = Reflection.getClass("SMZT_IntroEmbed");
				playIntro();
				});
		}
		
		/**
		 * 播放动画
		 */
		private function playIntro():void
		{
			//跳过功能
			var goMovieEnd:Function;
			goMovieEnd = function(event:MouseEvent):void
			{
				(_movieMc["mm"] as MovieClip).gotoAndPlay((_movieMc["mm"] as MovieClip).totalFrames - 2);
				return;
			};
			_movieMc = new IntroEmbed();
			addChild(_movieMc);
			MovieClipController.onMovieClipEnd(this._movieMc["mm"] as MovieClip, this.initLoading);
			this._movieMc["mm"]["tgbtn"].addEventListener(MouseEvent.CLICK, goMovieEnd);
			return;
		} // end function
		
		private function initLoading():void 
		{
			if (contains(_movieMc)) {
				removeChild(_movieMc);
				_movieMc = null;
				}
		}
		
		
		
		private function onFinish( e:Event ):void
		{
			//当前关卡剧情结束,刷新当前章的信息
			//_dramaPlayer.removeEventListener(Event.COMPLETE, onFinish);
			//如果是序章,则章的ID手动加一
			if (LongBaoModel.getInstance().currentChapter == 0) {
				_enterMapFlag = true;
				LongBaoModel.getInstance().currentChapter++;
				//-------------------新手引导用-----------------------
				   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
				   NewbiePane.getInstance().show();
				   NewBieControler.getInstance().nextStep();
				   }
				//--------------------end--------------------
				
				}else {
					_enterMapFlag = true;
					//LongBaoModel.getInstance().currentChapter = LongBaoModel.getInstance().currentChapter;
					LongBaoModel.getInstance().getInfo(true);
					}
		}
		
		/**
		 * 进入小地图
		 * @param	e
		 */
		private function enterSmallMap(e:SMZTDataChangeEvent):void 
		{
			_enterMapFlag = false;
			LongBaoModel.getInstance().currentChapter = int(e.dataObject)+1;
			
		}
		
		
		
		/**
		 * 返回按钮点击返回到主场景
		 * @param	event
		 */
		private function backClickHandler(e:MouseEvent):void
		{
			SMZTUIManager.getInstance().mainPane.returnMainScene();
		//-------------------新手引导用-----------------------
		if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
			NewBieControler.getInstance().nextStep();
			NewbiePane.getInstance().show();
			}
		//--------------------end--------------------
		}
		
		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			//-------------------新手引导用--第二次进入龙宝时---------------------
			   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && NewBieControler.getInstance().currentNewBieModle.stepId==NewBieControler.SCECOND_ENTER_LONGBAO) {
			   NewBieControler.getInstance().nextStep();
			   NewbiePane.getInstance().show();
			   }
			   //--------------------end--------------------
					   
			if (LongBaoModel.getInstance().currentChapter != 0) {
				//不是序章则更新大地图状态
				_bigMapLayer.updata();
				
				//如果小地图已经打开了,则要更新小地图状态
				if (SmallMap.getInstance().isOpened) {
					SmallMap.getInstance().updata();
					return;
					}
					
				if (!_enterMapFlag) {
					//-------------------新手引导用-----------------------
					   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					   NewBieControler.getInstance().nextStep();
					   NewbiePane.getInstance().hide();
					   }
					   //--------------------end--------------------
					//点击进入小地图
					SmallMap.getInstance().show(true);
					SmallMap.getInstance().updata();
					
					
					}
				}
			
			/*//如果还没有进入小地图则刷新大地图
			if (!SmallMap.getInstance().isOpened) {
				_bigMapLayer.updata();
				}*/
			
		} // end function
		
		/**
		 * 帮助点击
		 * @param	event
		 */
		override public function showHelp(event:MouseEvent = null):void
		{
		
		} // end function
		
		public function get dramaPlayer():DramaPlayer 
		{
			return _dramaPlayer;
		}
		
		public function get bigMapLayer():BigMapLayer 
		{
			return _bigMapLayer;
		}

	
	}
}
