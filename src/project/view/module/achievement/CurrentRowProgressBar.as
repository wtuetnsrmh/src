package project.view.module.achievement 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 当前行的成就进度
	 * @author bbjxl 2013
	 */
	public class CurrentRowProgressBar
	{
		private var _text:TextField;
		private var _bar:Sprite;
		private var _ui:DisplayObject;
		public function CurrentRowProgressBar(ui:DisplayObject) 
		{
			_ui = ui;
			_text = ui["progressText"] as TextField;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_bar = ui["bar"] as Sprite;
		}
		public function setProgress(progress:int, total:int):void {
			if (total == 1) {
				_ui.visible = false;
				return;
				}else {
					_ui.visible = true;
					}
			_bar.scaleX = progress / total;
			_text.text = progress + "/" + total;
			}
		
	}

}