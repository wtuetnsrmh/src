package project.view.module.helpSoundBBS 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.controller.NewBieControler;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModelId;
	import project.utils.FlashCookie;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import com.greensock.*;
    import com.greensock.easing.*;
	import project.view.module.helppane.HelpPane;
	import project.view.module.scene.main.MainScene;
	/**
	 * 帮助，静音按钮控制台
	 * @author bbjxl 2012
	 */
	public class ContronlBar extends BaseSpritePane 
	{
		//private var _btPoint:Array = [[ -74.85, 15], [ -57.35, 82], [29.65, 119.5]];//帮助，BBS,声音按钮展开的坐标
		//private var _bbsBt:MovieClipButton;
		private var _soundBt:MovieClip;
		private var _sound2Bt:MovieClip;
		private var _isOpen:Boolean = false;//是否展开状态
		private var _arrow:Sprite;
		
		private var _bg:Sprite;//用于点击弹出按钮的圆盘
		
		public function ContronlBar() 
		{
			setSpriteInstance("helpSoundBSSController");
            this.configerUIInstance();
			setLocation(ApplicationConfig.STAGE_WIDTH - 59, 4.6);
		}
		
		private function configerUIInstance():void {
			//_bbsBt = getChild("bbsBt") as MovieClipButton;
			_sound2Bt = getChild("sound2Bt") as MovieClip;
			_soundBt = getChild("soundBtyu") as MovieClip;
			_sound2Bt.buttonMode = true;
			_soundBt.buttonMode = true;
			_soundBt.gotoAndStop(1);
			_sound2Bt.gotoAndStop(1);
			
			_bg = getChild("bg") as Sprite;
			_arrow = getChild("arrow") as Sprite;
			_arrow.y = -95.6;
			_bg.buttonMode = true;
			_bg.addEventListener(MouseEvent.CLICK, clickHandler);
			toolTip.align = "right";
			_bg.addEventListener(MouseEvent.ROLL_OVER, bgRollOverHandler);
			_bg.addEventListener(MouseEvent.ROLL_OUT, bgRollOutHandler);

			
			//_bbsBt.onClick = bbsClickHandler;
			
			_soundBt.addEventListener(MouseEvent.CLICK, soundClickHandler);
			_sound2Bt.addEventListener(MouseEvent.CLICK, sound2ClickHandler);
			
			open();
			_isOpen = true;
			}
			
			private function sound2ClickHandler(e:MouseEvent):void 
			{
				if (_sound2Bt.currentFrame==1)
				{
					_sound2Bt.gotoAndStop(2);
					ModelLocator.getInstance().SEisMute = true;
					FlashCookie.setCookie("cotvolume", "SEisMute", "On");
				}
				else
				{
					_sound2Bt.gotoAndStop(1);
					ModelLocator.getInstance().SEisMute = false;
					FlashCookie.setCookie("cotvolume", "SEisMute", "Off");
				}
			}
		
		/**
		 * 鼠标移到盘上给出提示
		 * @param	e
		 */
		private function bgRollOverHandler(e:MouseEvent):void {
			//toolTipStr = "点击展开或关闭！";
			}
		private function bgRollOutHandler(e:MouseEvent):void {
			//toolTipStr = "";
			}
			
		private function clickHandler(e:MouseEvent):void {
			_bg.removeEventListener(MouseEvent.CLICK, clickHandler);
			if (_isOpen) {
				rebound();
				_isOpen = false;
				}else {
					open();
					_isOpen = true;
					}
			}
			
		/**
		 * 展开
		 * @param	e
		 */	
		public function open():void {
			/*TweenLite.to(_helpBt, 0.4, {x:_btPoint[0][0],y:_btPoint[0][1], onComplete:onTweenSceneComplete});
			TweenLite.to(_bbsBt, 0.4, {x:_btPoint[1][0],y:_btPoint[1][1], onComplete:onTweenSceneComplete});
			TweenLite.to(_soundBt, 0.4, { x:_btPoint[2][0], y:_btPoint[2][1], onComplete:onTweenSceneComplete } );*/
			
			var timeline:TimelineLite = new TimelineLite();
			timeline.append( new TweenLite(_arrow, 0.1, { y:45.9, ease:Elastic.easeOut } ) );
			timeline.append( new TweenLite(_soundBt, 0.1, {x:5, ease:Elastic.easeOut}) );
			timeline.append( new TweenLite(_sound2Bt, 0.1, {x:5, ease:Elastic.easeOut}) );
			timeline.append( new TweenLite(helpBtn, 0.1, {x:5, ease:Elastic.easeOut, onComplete:onTweenSceneComplete}) );
			//timeline.append( new TweenLite(_bbsBt, 0.1, {x:_btPoint[1][0],y:_btPoint[1][1], ease:Elastic.easeOut}) );
			function onTweenSceneComplete():void {
				_bg.addEventListener(MouseEvent.CLICK, clickHandler);
				}
			
			}
		
		 /**
		  * 回缩
		  * @param	e
		  */
		public function rebound():void {
			var timeline:TimelineLite = new TimelineLite();
			timeline.append( new TweenLite(helpBtn, 0.1, {x:_bg.x+_bg.width+2, ease:Elastic.easeOut}) );
			timeline.append( new TweenLite(_sound2Bt, 0.1, {x:_bg.x+_bg.width+2, ease:Elastic.easeOut}) );
			timeline.append( new TweenLite(_soundBt, 0.1, {x:_bg.x+_bg.width+2, ease:Elastic.easeOut}) );
			//timeline.append( new TweenLite(_bbsBt, 0.1, {x:22.4,y:28}) );
			
			timeline.append( new TweenLite(_arrow, 0.1, { y: -95.6, ease:Elastic.easeOut, onComplete:onTweenSceneComplete}) );
			function onTweenSceneComplete():void {
				_bg.addEventListener(MouseEvent.CLICK, clickHandler);
				}
			
			}
			
		/**
		 * 帮助按钮鼠标移上
		 */
		override public function showHelp(event:MouseEvent = null) : void
        {
			/*
			public static const SLAVE_SCENE:int = 7;
			public static const SKYCITY_SCENE:int = 8;
			public static const LONGBAO_SCENE:int = 9;
			public static const CRYSTAL_HOLE_SCENE:int = 10;*/
            //trace(SMZTUIManager.getInstance().mainPane.currentSceneId);
			switch(SMZTUIManager.getInstance().mainPane.currentSceneId) {
				case 0:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_MAIN_SCENE_HELP");
					break;
				case 1:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_ARENA");
					break;
				case 2:
					HelpPane.getInstance().playInstance("NEWBIE_TRAINING_SCENE");
					break;
				case 3:
					//女神像没有
					break;
				case 4:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_TOWER_SCENE");
					break;
				case 5:
					if (SMZTUIManager.getInstance().cultivationScene.currentSlectedTab == 0) {
						HelpPane.getInstance().playInstance("NEWBIE_SHOW_CULTIVATION_SCENE");
						}else {
							HelpPane.getInstance().playInstance("NEWBIE_SHOW_CULTIVATION_SCENE2");
							}
					break;
				case 6:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_TAVERN_SCENE");
					break;
				case 7:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_SLAVE_SCENE");
					break;
				case MainScene.CRYSTAL_HOLE_SCENE:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_CRYSTAL_HOLE_SCENE");
					break;
				default :
					break;
				}
            if (HelpPane.getInstance().isOpened)
            {
                helpBtn.gotoAndStop(2);
            }
            else
            {
                helpBtn.gotoAndStop(1);
            }
            return;
        }// end function
		
		override protected function onUIdChange(event:SMZTDataChangeEvent) : void
        {
            /*if (this.helpBtn)
            {
                this.helpBtn.visible = true;// ModelLocator.getInstance().uId == ModelLocator.getInstance().currentUId;
            }*/
            return;
        }// end function
		
		 
		/**
		 *BBS按钮点击
		 */
		private function bbsClickHandler(e:MouseEvent):void {
			
			}
		/**
		 * 声音按钮点击
		 */
		private function soundClickHandler(e:MouseEvent):void {
			if (_soundBt.currentFrame==1)
            {
                _soundBt.gotoAndStop(2);
                ModelLocator.getInstance().isMute = true;
                /*if (SMZTPlayer.getInstance()._SMZTPlayer)
                {
                    SMZTPlayer.getInstance()._SMZTPlayer.setVolume(0);
                }*/
                FlashCookie.setCookie("smvolume", "isMute", "On");
            }
            else
            {
                _soundBt.gotoAndStop(1);
                ModelLocator.getInstance().isMute = false;
                /*if (SMZTPlayer.getInstance()._SMZTPlayer)
                {
                    SMZTPlayer.getInstance()._SMZTPlayer.setVolume(1);
                }*/
                FlashCookie.setCookie("smvolume", "isMute", "Off");
            }
			}
			
		public function get soundBt() : MovieClip
		 {
		   return _soundBt;
		}// end function
		public function set soundBt(prama:MovieClip) : void
		 {
			_soundBt = prama;
		}// end function
		
		public function get sound2Bt():MovieClip 
		{
			return _sound2Bt;
		}
		
		public function set sound2Bt(value:MovieClip):void 
		{
			_sound2Bt = value;
		}
		
	}

}