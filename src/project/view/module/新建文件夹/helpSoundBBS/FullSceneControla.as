package project.view.module.helpSoundBBS 
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.core.AppliactionManager;
	import project.core.SMZTUIManager;
	import project.model.newBie.NewBieModelId;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class FullSceneControla extends BaseSpriteSetUI 
	{
		private var _exitBt:MovieClipButton;
		private var _fullBt:MovieClipButton;
		public function FullSceneControla() 
		{
			/*if (stage) init();
			else {
				this.addEventListener(Event.ADDED_TO_STAGE, addTostage);
				}*/
			 init();
		}
		
		/*private function addTostage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addTostage);
			init();
		}*/
		
		public function exitFullScene():void {
			if(stage)
			stage.displayState = StageDisplayState.NORMAL;
			}
		
		private function init():void 
		{
			setSpriteInstance("fullSceneUI");
			_exitBt = getChild("exitBt") as MovieClipButton;
			_fullBt = getChild("fullBt") as MovieClipButton;
			_exitBt.visible = false;
			_exitBt.onClick = clickHandler;
			_fullBt.onClick = clickHandler;
			_exitBt.toolTip = "<font color='#ffffff'>退出全屏</font>";
			_fullBt.toolTip = "<font color='#ffffff'>全屏</font>";
			
			AppliactionManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullEvent);
		}
		
		private function fullEvent(e:FullScreenEvent):void 
		{
			trace(e.fullScreen);
			if (e.fullScreen) {
				_exitBt.visible = true;
				_fullBt.visible = false;
				
				}else {
					_exitBt.visible = false;
					_fullBt.visible = true;
					
					}
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (stage == null) return;
			switch(e.currentTarget) {
				case _exitBt:
					//javacript:window.open("nfd.swf","","fullscreen=1,menubar=no,width=800,height=600")
					stage.displayState = StageDisplayState.NORMAL;
					SMZTUIManager.getInstance().mainPane.updataBg();
					
					
					break;
				case _fullBt:
					stage.displayState = StageDisplayState.FULL_SCREEN;
					SMZTUIManager.getInstance().mainPane.updataBg(true);
					
					//--------------新手引导---------------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && !NewBieControler.getInstance()._newBieFullScreen) {
						NewBieControler.getInstance()._newBieFullScreen = true;
						NewBieControler.getInstance().nextStep();
						}
					break;
				}
			
		}
		/*public function refreshBtState(value:String):void {
			if (value == StageDisplayState.FULL_SCREEN) {
				_exitBt.visible = true;
				_fullBt.visible = false;
				}else {
					_exitBt.visible = false;
					_fullBt.visible = true;
					}
			}*/
	}

}