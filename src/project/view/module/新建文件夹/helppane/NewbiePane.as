package project.view.module.helppane
{
	/**
	 *描述：新手引导面板
	 *
	 */
	import com.greensock.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import project.config.ApplicationConfig;
	import project.controller.NewBieControler;
	import project.events.SMZTDataChangeEvent;
	import project.model.attack.RoundModel;
	import project.model.data.PlayerData;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.CustomTool;
	import project.utils.DepthManager;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.attack.AttackPanel;
	
	public class NewbiePane extends BaseSpritePane
	{
		private var stageModal:Sprite;
		private static var newbiePane:NewbiePane;
		private var _currentLevelClassName:String = ""; //当前子阶段对应的类名
		private var _callback:Function;
		private var _turnObj:RoundModel;
		
		public function NewbiePane()
		{
			if (newbiePane != null)
			{
				throw new Error("Error");
			}
			this.addEventListener(MouseEvent.CLICK, this.clickHandler);
			return;
		} // end function
		
		
		
		/**
		 * 不屏蔽界面
		 */
		private function hideModal():void
		{
			if (rootContainer)
			{
				if (modal != null && rootContainer.contains(modal))
				{
					rootContainer.removeChild(modal);
					modal = null;
				}
			}
			return;
		} // end function
		
		private function hideMe(event:Event):void
		{
			hide();
			return;
		} // end function
		
		private function clickHandler(event:MouseEvent):void
		{
			//如果点击的是按钮，则显示下一步引导
			if (event.target is MovieClipButton)
			{
				NewBieControler.getInstance().nextStep();
				playUISound("UI_MOUSE_OVER");
				
				if (event.target.name == "firstBt") {
					//如果是第一步
					if (ApplicationConfig.screenHeight < 900) {
						//NewBieControler.getInstance().nextStep();
						}else {
							NewBieControler.getInstance().refreshByValue( -1, -1, NewBieControler.FFULL_SCREE);//跳过全屏按钮步
							}
					}
				
				if (event.target.name == "battelNew") {
					//如果是一阶段
					NewbiePane.getInstance().hide();//先不显示引导
					AttackPanel.getInstance()._attackPlayer.continuePlay();//战斗继续
					}
				if (event.target.name == "battelNewSpe") {
					//一阶段,等待值为0后点击继续执行下一个动作
					NewbiePane.getInstance().hide();//先不显示引导
					_callback.call(null, _turnObj);
					AttackPanel.getInstance()._attackPlayer.continuePlay();//战斗继续
					}
				
			}
			return;
		} // end function
		
		/**
		 * 显示指定类名的引导界面
		 * @param	param1
		 */
		public function playInstance(param1:NewBieModel):void
		{
			if (param1.modelId==1 && (param1.levelId == 0 || param1.levelId == 1))
			{
				//如果是前两个子阶段，即：开场动画和选择英雄界面时没有要提示的界面
				return;
			}
			
			if (_currentLevelClassName == "")
			{
				_currentLevelClassName = param1.levelClassName;
				setSpriteInstance(param1.levelClassName);
				
				//如果是刚进入时，判断选的人物来决定显示相应的引导
				if (getChild("heroMc")) {
					if (ModelLocator.getInstance().initHeroId == 2) {
							(getChild("heroMc") as MovieClip).gotoAndStop(2);
							}else {
								(getChild("heroMc") as MovieClip).gotoAndStop(1);
								}
					}
					
				(_spriteInstance as MovieClip).gotoAndStop(param1.step);
			}
			else
			{
				if (_currentLevelClassName != param1.levelClassName)
				{
					//如果将要进入下一个子阶段，则重新加载ＵＩ
					setSpriteInstance(param1.levelClassName);
					(_spriteInstance as MovieClip).gotoAndStop(param1.step);
				}
				else
				{
					//子阶段相同，则跳转到相应的帧
					(_spriteInstance as MovieClip).gotoAndStop(param1.step);
				}
			}
			DepthManager.bringToTop(this);
			this.show();
			return;
		} // end function
		
		override public function show(param1:Boolean = false):void
		{
			if (_isOpened)
			{
			}
			else if (_rootContainer)
			{
				if (param1)
				{
					drawModalRect();
				}
				_rootContainer.addChild(this);
				
				_isOpened = true;
			}
			return;
		} // end function
		
		public static function getInstance():NewbiePane
		{
			if (newbiePane == null)
			{
				newbiePane = new NewbiePane;
			}
			return newbiePane;
		} // end function
		
		public function get turnObj():RoundModel 
		{
			return _turnObj;
		}
		
		public function set turnObj(value:RoundModel):void 
		{
			_turnObj = value;
		}
		
		public function get callback():Function 
		{
			return _callback;
		}
		
		public function set callback(value:Function):void 
		{
			_callback = value;
		}
	
	}
}
