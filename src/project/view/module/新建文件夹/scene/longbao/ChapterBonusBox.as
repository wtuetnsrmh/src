package project.view.module.scene.longbao 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.friends.BonusModel;
	import project.model.longBao.LongBaoModel;
	import project.utils.Reflection;
	import project.utils.XColor;
	import project.view.controls.ToolTip;
	
	/**
	 * 章通关宝箱
	 * @author bbjxl 2013
	 */
	public class ChapterBonusBox extends MovieClip 
	{
		private var _ui:MovieClip;
		private var _tp:ToolTip;
		private var _currentStatue:int = 0;
		public function ChapterBonusBox() 
		{
			_ui = Reflection.createInstance("chapterBonusBoxUI") as MovieClip;
			addChild(_ui);
			this.buttonMode = true;
			_tp = ToolTip.getInstance();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		}
		
		private function mouseOverHandler(e:MouseEvent):void 
		{
			//_tp.autoSize = false;
			switch(_currentStatue) {
				case 0:
					//还未达到领取条件
					_tp.show(this, "",LocalConfig.LOCAL_LAN.LongBaoPane.AWardTip.@Text+"\n"+LongBaoModel.getInstance().chest.chestToString());
					break;
				case 1:
					//达到领取条件但没领
					_tp.show(this,"","<font color='#ffffff'>可领取</font>");
					break;
				case 2:
					//领过
					_tp.show(this, "","<font color='#ffffff'>已领取</font>");
					break;
				}
			
		}
		
		public function setStatue(value:int = 0):void {
			_currentStatue = value;
			switch(value) {
				case 0:
					//还未达到领取条件
					_ui.filters = null;
					_ui.gotoAndStop(1);
					this.removeEventListener(MouseEvent.CLICK, clickHandler);
					break;
				case 1:
					//达到领取条件但没领
					_ui.filters = null;
					_ui.gotoAndStop(2);
					this.addEventListener(MouseEvent.CLICK, clickHandler);
					break;
				case 2:
					//领过
					_ui.gotoAndStop(3);
					XColor.removeColor(_ui);
					this.removeEventListener(MouseEvent.CLICK, clickHandler);
					break;
				}
			}
			
			private function clickHandler(e:MouseEvent):void 
			{
				SMZTController.getInstance().getBonusChapter(LongBaoModel.getInstance().currentChapter, function(param:Object):void {
					var tempBonus:BonusModel = new BonusModel();
					tempBonus.setData(param.bonus);
					SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus);
					tempBonus = null;
					LongBaoModel.getInstance().getInfo(true);
					})
			}
	}

}