package project.view.module.platform 
{
	import com.ming.ui.controls.TabNavigation;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.controls.TabNavigator;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 *黄钻面板
	 * @author bbjxl 2013
	 */
	public class QQYellowPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		public var tabNvigator:TabNavigator;
		//-----------------------UI---------------------------------
		private var _awardNewBieBt:MovieClipButton;
		private var _awardDailyBt:MovieClipButton;
		private var _awardNewBiePanel:AwardNewBiePanel;
		private var _awardDailyPanel:AwardDailyPanel;
		//-----------------------数据---------------------------------
		private var _currentSlectedTab:int = 0;//当前选的选项ＩＤ
		//-----------------------事件--------------------------------
		private static var _qqyellowPanle:QQYellowPanel;
		public function QQYellowPanel() 
		{
			if (_qqyellowPanle != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			setSpriteInstance("yellowPanelUI");
			confinginstance();
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
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - spriteInstance.height) / 2 - 40;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				//如果有关闭按钮添加ＥＳＣ键关闭功能
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
            }
            this.playShowSound();
            return;
        }// end function
		
		private function confinginstance():void 
		{
			this.rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
			
			_awardNewBiePanel = new AwardNewBiePanel();
			_awardDailyPanel = new AwardDailyPanel();
			addChild(_awardNewBiePanel);
			addChild(_awardDailyPanel);
			_awardNewBieBt = getChild("awardNewBieBt") as MovieClipButton;
			_awardDailyBt = getChild("awardDailyBt") as MovieClipButton;
			
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_awardNewBieBt, _awardDailyBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			tabNvigator.selectedByIndex(0);
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			switch (e.dataObject)
			{
				case _awardNewBieBt: 
					_currentSlectedTab = 0;
					_awardNewBiePanel.visible = true;
					_awardDailyPanel.visible = false;
					break;
				case _awardDailyBt: 
					_currentSlectedTab = 1;
					_awardNewBiePanel.visible = false;
					_awardDailyPanel.visible = true;
					break;
			}
			updataUI();
		}
		
		/**
		 * 初始刷新界面
		 */
		public function updataUI():void 
		{
			switch(_currentSlectedTab) {
				case 0:
					_awardNewBiePanel.updata();
					break;
				case 1:
					_awardDailyPanel.updata();
					break;
					
				}
		}
		
		public static function getInstance() : QQYellowPanel
		{
			if (_qqyellowPanle == null)
			{
			  _qqyellowPanle = new QQYellowPanel;
			}
			return _qqyellowPanle; 
		}// end function
		
		
	}

}