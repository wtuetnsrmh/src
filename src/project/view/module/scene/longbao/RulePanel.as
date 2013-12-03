package project.view.module.scene.longbao 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import project.core.SMZTUIManager;
	import project.config.ErrorZhCn;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	
	/**
	 * 地图说明
	 * @author bbjxl 2013
	 */
	public class RulePanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _formulaPanel:Sprite;
		private var _formulaBt:MovieClipButton;
		private var _scloseBtn:MovieClipButton;
		//-----------------------数据---------------------------------
		
		//-----------------------事件--------------------------------
		private static var _rulePanle:RulePanel;
		public function RulePanel() 
		{
			if (_rulePanle != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
				
			setSpriteInstance("rulePanelUI");
			_formulaPanel = getChild("formulaPanel") as Sprite;
			_formulaBt = getChild("formulaBt") as MovieClipButton;
			_scloseBtn = _formulaPanel["closeBtn"] as MovieClipButton;
			_scloseBtn.onClick = clickHandler;
			_formulaBt.onClick = clickHandler;
			_formulaPanel.visible = false;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.target) {
				case _scloseBtn:
					_formulaPanel.visible = false;
					break;
				case _formulaBt:
					_formulaPanel.visible = true;
					break;
				}
		}

		public static function getInstance() : RulePanel
		{
			if (_rulePanle == null)
			{
			  _rulePanle = new RulePanel;
			}
			return _rulePanle; 
		}// end function
		
	}

}