package project.view.module.log 
{
	import project.config.ErrorZhCn;
	import project.model.log.EventLog;
	import project.model.log.EventLogCategory;
	import project.model.log.EventLogModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.controls.TabNavigator;
	import project.view.common.FriendsControlPage;
	import project.view.layout.BaseGridContainer;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	/**
	 *日志面板
	 * @author bbjxl 2013
	 */
	public class LogPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _rowGrid:BaseGridContainer;
		private var tabNvigator:TabNavigator;
		//-----------------------UI---------------------------------
		private var _controlPage:FriendsControlPage; //分页
		
		private var _roleBt:MovieClipButton;
		private var _grandBt:MovieClipButton;//战报
		private var _traingBt:MovieClipButton;
		private var _friendsBt:MovieClipButton;
		private var _deckBt:MovieClipButton;
		//-----------------------数据---------------------------------
		private var _logModel:EventLogModel;
		private var _maxRow:int = 5;
		private var _totalRow:Vector.<LogRow>;
		private var _currentPage:int=1;
		private var _currentSelectedTypeLogs:Vector.<EventLog>;
		private var _currentSelectedType:int=EventLogCategory.ROLE;
		//-----------------------事件--------------------------------
		
		private static var _logPanel:LogPanel;
		
		public function LogPanel() 
		{
			if (_logPanel != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			_logModel = EventLogModel.getInstance();
			dataModel = _logModel;
			setSpriteInstance("LogUI");
			configerInstance();
		}
		
		private function configerInstance():void 
		{
			_roleBt = getChild("roleBt") as MovieClipButton;
			_grandBt = getChild("grandBt") as MovieClipButton;
			_traingBt = getChild("traingBt") as MovieClipButton;
			_friendsBt = getChild("friendsBt") as MovieClipButton;
			_deckBt = getChild("deckBt") as MovieClipButton;
			
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_roleBt, _grandBt, _traingBt,_friendsBt,_deckBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(248, 494.1);
			_controlPage.updatLoc = updatLoc;
			_spriteInstance.addChild(_controlPage);
			
			_rowGrid = new BaseGridContainer(_maxRow, 1, 6.9, 424.05, 42);
			_rowGrid.setLocation(85, 235.55);
			
			_totalRow = new Vector.<LogRow>
			for (var i:int = 0; i < _maxRow; i++)
			{
				var tempRow:LogRow = new LogRow();
				_rowGrid.appendChild(tempRow);
				_totalRow.push(tempRow);
				tempRow = null;
			}
			
			addChild(_rowGrid);
		}
		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			_controlPage.setLocation(this.width - _controlPage.width >> 1, 494.1);
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void
		{
			_currentPage = 1;
			switch (e.dataObject)
			{
				case _roleBt: 
					_currentSelectedType = EventLogCategory.ROLE;
					break;
				case _grandBt: 
					_currentSelectedType = EventLogCategory.GRAND;
					break;
				case _traingBt: 
					_currentSelectedType = EventLogCategory.TRAINING;
					break;
				case _friendsBt: 
					_currentSelectedType = EventLogCategory.FRIENDS;
					break;
				case _deckBt: 
					_currentSelectedType = EventLogCategory.DECKS;
					break;
			}
		
			onDataChange(null);
		}

		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			_currentSelectedTypeLogs = null;
            switch(_currentSelectedType) {
				case EventLogCategory.ROLE: 
					_controlPage.starComputeNoInit(_maxRow, (_logModel.roleLogs.length>0)?Math.ceil(_logModel.roleLogs.length / _maxRow):1, updataUI);
					_currentSelectedTypeLogs = _logModel.roleLogs;
					break;
				case EventLogCategory.GRAND: 
					_controlPage.starComputeNoInit(_maxRow, (_logModel.battleLogs.length>0)?Math.ceil(_logModel.battleLogs.length / _maxRow):1, updataUI);
					_currentSelectedTypeLogs = _logModel.battleLogs;
					break;
				case EventLogCategory.TRAINING: 
					_controlPage.starComputeNoInit(_maxRow, (_logModel.traningLogs.length>0)?Math.ceil(_logModel.traningLogs.length / _maxRow):1, updataUI);
					_currentSelectedTypeLogs = _logModel.traningLogs;
					break;
				case EventLogCategory.FRIENDS: 
					_controlPage.starComputeNoInit(_maxRow, (_logModel.friendsLogs.length>0)?Math.ceil(_logModel.friendsLogs.length / _maxRow):1, updataUI);
					_currentSelectedTypeLogs = _logModel.friendsLogs;
					break;
				case EventLogCategory.DECKS: 
					_controlPage.starComputeNoInit(_maxRow, (_logModel.deckLogs.length>0)?Math.ceil(_logModel.deckLogs.length / _maxRow):1, updataUI);
					_currentSelectedTypeLogs = _logModel.deckLogs;
					break;
					
				}
				
			if (_currentPage > _controlPage.totalPageNum) {
				//当前页码比总页码还大时，当前页为总页
				_currentPage = _controlPage.totalPageNum;
				}
				_controlPage.currentPageNum = _currentPage;
			return;
		} // end function
		
		private function updataUI():void 
		{
			_currentPage = _controlPage.currentPageNum;
			for (var i:int; i < _totalRow.length;i++) {
				var tempIndex:int = ((_currentPage-1) * _maxRow + i);
				if ( tempIndex< _currentSelectedTypeLogs.length) {
					if (_currentSelectedTypeLogs[tempIndex]) {
						_totalRow[i].updataUI(_currentSelectedTypeLogs[tempIndex]);
						_totalRow[i].visible = true;
						}else {
							_totalRow[i].visible = false;
							}
					}else {
						_totalRow[i].visible = false;
						}
				}
			
		}
		
		public static function getInstance() : LogPanel
		{
			if (_logPanel == null)
			{
			  _logPanel = new LogPanel;
			}
			return _logPanel; 
		}// end function
		
	}

}