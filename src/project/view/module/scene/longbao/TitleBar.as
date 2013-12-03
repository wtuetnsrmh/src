package project.view.module.scene.longbao 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.LocalConfig;
	import project.model.longBao.LongBaoModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSprite;
	
	/**
	 * 所在章,标题栏
	 * @author bbjxl 2013
	 */
	public class TitleBar extends BaseSprite 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _chapterNameText:TextField;
		private var _prevBt:MovieClipButton;
		private var _nextBt:MovieClipButton;
		//-----------------------数据---------------------------------
		private var _currentChapterId:int;//当前章,以1开始
		private var _maxChapter:int = 4;
		//-----------------------事件--------------------------------
		public function TitleBar(ui:DisplayObject) 
		{
			_chapterNameText = ui["chapterNameText"] as TextField;
			_prevBt = ui["prevBt"] as MovieClipButton;
			_nextBt = ui["nextBt"] as MovieClipButton;
			_prevBt.onClick = clickHandler;
			_nextBt.onClick = clickHandler;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _prevBt:
					if (_currentChapterId >1) {
						currentChapterId--;
						LongBaoModel.getInstance().currentChapter = currentChapterId;
						}
					break;
				case _nextBt:
					if (_currentChapterId < _maxChapter) {
						currentChapterId++;
						LongBaoModel.getInstance().currentChapter = currentChapterId;
						}
					break;
				}
				
			setBtStatue();
		}
		
		private function setBtStatue():void 
		{
			//如果是在序章,或是当前所在章跟最后面的一章相同,或是等于最大的章时
			if (_currentChapterId == _maxChapter || _currentChapterId==LongBaoModel.getInstance().chapter || LongBaoModel.getInstance().chapter==0) {
				_nextBt.clickEnable = false;
				}else {
					_nextBt.clickEnable = true;
					}
			if (_currentChapterId == 1) {
				_prevBt.clickEnable = false;
				}else {
					_prevBt.clickEnable = true;
					}
		}
		
		public function updataUI():void {
			if (currentChapterId != LongBaoModel.getInstance().currentChapter) {
				currentChapterId = LongBaoModel.getInstance().currentChapter;
				var _data:XML = (LocalConfig.LOCAL_LAN.LongBaoPane.chapter.(@id == currentChapterId)[0]);
				_chapterNameText.text =_data.@name;
				}
			setBtStatue();
			}
		
		public function get currentChapterId():int 
		{
			return _currentChapterId;
		}
		
		public function set currentChapterId(value:int):void 
		{
			_currentChapterId = value;
			var _data:XML = (LocalConfig.LOCAL_LAN.LongBaoPane.chapter.(@id == currentChapterId)[0]);
				_chapterNameText.text =_data.@name;
		}
		
	}

}