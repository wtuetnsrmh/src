package project.view.module.helpSoundBBS 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.ModelLocator;
	import project.utils.FlashCookie;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import com.greensock.*;
    import com.greensock.easing.*;
	import project.view.module.helppane.HelpPane;
	/**
	 * 帮助，静音，BBS按钮控制台
	 * @author bbjxl 2012
	 */
	public class ContronlBar extends BaseSpritePane 
	{
		private var _btPoint:Array = [[ -74.85, 15], [ -57.35, 82], [29.65, 119.5]];//帮助，BBS,声音按钮展开的坐标
		//private var _bbsBt:MovieClipButton;
		private var _soundBt:MovieClip;
		private var _isOpen:Boolean = false;//是否展开状态
		
		private var _bg:Sprite;//用于点击弹出按钮的圆盘
		
		public function ContronlBar() 
		{
			setSpriteInstance("helpSoundBSSController");
            this.configerUIInstance();
			setLocation(ApplicationConfig.STAGE_WIDTH - spriteInstance.width, 0);
		}
		
		private function configerUIInstance():void {
			//_bbsBt = getChild("bbsBt") as MovieClipButton;
			_soundBt = getChild("soundBtyu") as MovieClip;
			_soundBt.buttonMode = true;
			_soundBt.gotoAndStop(1);
			
			_bg = getChild("bg") as Sprite;
			_bg.buttonMode = true;
			_bg.addEventListener(MouseEvent.CLICK, clickHandler);
			toolTip.align = "right";
			_bg.addEventListener(MouseEvent.ROLL_OVER, bgRollOverHandler);
			_bg.addEventListener(MouseEvent.ROLL_OUT, bgRollOutHandler);

			
			//_bbsBt.onClick = bbsClickHandler;
			
			_soundBt.addEventListener(MouseEvent.CLICK, soundClickHandler);
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
			timeline.append( new TweenLite(helpBtn, 0.1, {x:_btPoint[0][0],y:_btPoint[0][1], ease:Elastic.easeOut}) );
			//timeline.append( new TweenLite(_bbsBt, 0.1, {x:_btPoint[1][0],y:_btPoint[1][1], ease:Elastic.easeOut}) );
			timeline.append( new TweenLite(_soundBt, 0.1, {x:_btPoint[2][0], y:_btPoint[2][1], ease:Elastic.easeOut}) );
			}
		
		 /**
		  * 回缩
		  * @param	e
		  */
		public function rebound():void {
			var timeline:TimelineLite = new TimelineLite();
			timeline.append( new TweenLite(_soundBt, 0.1, {x:22.4,y:28}) );
			//timeline.append( new TweenLite(_bbsBt, 0.1, {x:22.4,y:28}) );
			timeline.append( new TweenLite(helpBtn, 0.1, {x:22.4,y:28}) );
			
			}
			
		/**
		 * 帮助按钮鼠标移上
		 */
		override public function showHelp(event:MouseEvent = null) : void
        {
            trace(SMZTUIManager.getInstance().mainPane.currentSceneId);
			switch(SMZTUIManager.getInstance().mainPane.currentSceneId) {
				case 0:
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_MAIN_SCENE_HELP");
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
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
		
	}

}