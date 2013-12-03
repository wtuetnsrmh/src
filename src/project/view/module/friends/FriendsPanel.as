package project.view.module.friends
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import mx.utils.StringUtil;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.friends.FriendsModel;
	import project.utils.Browser;
	import project.utils.CustomTool;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import com.greensock.*;
	import com.greensock.core.*;
	import com.greensock.easing.*;
	import project.view.common.FriendsControlPage;
	import project.view.layout.BaseGridContainer;
	import project.view.module.helppane.HelpPane;
	import project.view.controls.TabNavigator;
	/**
	 * 好友列表
	 * @author bbjxl 2012
	 */
	public class FriendsPanel extends BaseSpritePane
	{
		//----------------------容器---------------------------------
		private var _gridContainer:BaseGridContainer; //放行容器
		private var tabNvigator:TabNavigator;
		//-----------------------UI---------------------------------
		private var _openBt:MovieClipButton; //展开按钮
		private var _searchText:TextField; //搜索文本
		private var _controlPage:FriendsControlPage; //分页
		private var _soption:MovieClipButton;//陌生人选项
		private var _foption:MovieClipButton;//好友选项
		private var _inviteBt:MovieClipButton;//邀请好友
		private var _strangerList:StrangerListPanel;//陌生人列表
		//-----------------------数据---------------------------------
		private var _opened:Boolean = false;
		private var _maxRow:int = 6; //一页最多显示多少行
		private var _totalRow:Array; //所有的行
		private var _friendsModel:FriendsModel;
		
		public var _currentRowUserId:int = 0;//当前选中行的好友ID
		public var _currentRowMasterId:int = 0;//当前选中行的奴隶主ID
		private var _currentSelectedOption:int = 0;//当前选中的选项
		//-----------------------事件--------------------------------
		private static var _friendsPanel:FriendsPanel;
		
		public function FriendsPanel()
		{
			if (_friendsPanel != null)
			{
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
			}
			
			_friendsModel = FriendsModel.getInstance();
			dataModel = _friendsModel;
			
			setSpriteInstance("friendsPanel");
			configUiInstance();
			_gridContainer = new BaseGridContainer(_maxRow, 1, 8, 198.35, 58.25);
			_gridContainer.setLocation(47, 168.4);
			
			_totalRow = new Array();
			for (var i:int = 0; i < _maxRow; i++)
			{
				var tempRow:FriendsRow = new FriendsRow();
				_gridContainer.appendChild(tempRow);
				_totalRow.push(tempRow);
				tempRow = null;
			}
			
			addChild(_gridContainer);
			
			_strangerList = new StrangerListPanel(getChild("strangerListUI"));
			_strangerList.visible = false;
			addChild(_strangerList);
			addChild(_soption);
			addChild(_foption);
			addChild(_inviteBt);
		}
		
		private function configUiInstance():void
		{
			_inviteBt = getChild("inviteBt") as MovieClipButton;
			_inviteBt.toolTip =LocalConfig.LOCAL_LAN.FriendsPanel.IviteTip.@Text;
			_soption = getChild("soption") as MovieClipButton;
			_foption = getChild("foption") as MovieClipButton;
			_openBt = getChild("openBt") as MovieClipButton;
			_searchText = getChild("searchText") as TextField;
			_searchText.type = TextFieldType.INPUT;
			_searchText.addEventListener(Event.CHANGE, searchHandler);
			_inviteBt.onClick = inviteBtClick;
			_openBt.onClick = openOnClick;
			
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(84.5, 562.95);
			_spriteInstance.addChild(_controlPage);
			this.x = ApplicationConfig.STAGE_WIDTH - 38;
			this.y = 42;
			
			
			
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_foption, _soption);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
		}
		/**
		 * 选项切换
		 * @param	e
		 */
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			switch(e.dataObject) {
				case _foption:
					_currentSelectedOption = 0
					_strangerList.visible = false;
					_controlPage.visible = true;
					
					break;
					
				case _soption:
					_currentSelectedOption = 1
					_strangerList.visible = true;
					_strangerList.refreshBttClick();
					_controlPage.visible = false;
					break;
				}
			
		}
		
		
		/**
		 * 邀请好友
		 * @param	e
		 */
		
		private function inviteBtClick(e:MouseEvent):void 
		{
			Browser.inviteFriends();
		}
		
		private function searchHandler(e:Event):void
		{
			//trace("chandge")
			getFriendsList(1);
			//getFriendsList(_controlPage.currentPageNum);
		}
		
		/**
		 * 分页改变
		 */
		public function controlpageChange():void
		{
			getFriendsList(_controlPage.currentPageNum);
		}
		
		private function getFriendsList(param:int):void
		{
			SMZTController.getInstance().getFriendsList(param, StringUtil.trim(_searchText.text), function(param1:Object):void
				{
					if (param != param1.page) return;
					_controlPage.updataUI(param1.page, param1.maxPage); //更新服务端返回的页码跟总页数
					_controlPage.setLocation(((218.9 - _controlPage.width) >> 1)+37, 562.95);
				});
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			for (var i:int = 0; i < _totalRow.length; i++)
			{
				if (i < _friendsModel.friends.length)
				{
					_totalRow[i].visible = true;
					(_totalRow[i] as FriendsRow).updataUI(_friendsModel.friends[i], ((_controlPage.currentPageNum - 1) * _maxRow + i + 1));
				}
				else
				{
					_totalRow[i].visible = false;
				}
			}
			
			return;
		} // end function
		
		/**
		 * 帮助
		 * @param	event
		 */
		override public function showHelp(event:MouseEvent = null) : void
        {
			if (event.type == MouseEvent.MOUSE_OVER) {
				if (_currentSelectedOption == 0) {
					HelpPane.getInstance().playInstance("NEWBIE_SHOW_FRIENDS");
					}else {
						HelpPane.getInstance().playInstance("NEWBIE_SHOW_STRANGER");
						}
				}else if (event.type == MouseEvent.MOUSE_OUT){
					HelpPane.getInstance().hide();
					}
            return;
        }// end function
		
		/**
		 * 展开
		 * @param	e
		 */
		public function open():void
		{
			_opened = false;
			openOnClick(null);
		}
		
		/**
		 * 缩进
		 * @param	e
		 */
		public function close():void
		{
			_opened = true;
			openOnClick(null);
		}
		
		private function openOnClick(e:MouseEvent):void
		{
			if (!_opened)
			{
				_controlPage.starCompute(_maxRow, 1, controlpageChange); //打开时显示第一页
			}
			var targetX:Number = (_opened) ? ApplicationConfig.STAGE_WIDTH - 37 : ApplicationConfig.STAGE_WIDTH - this.width;
			_opened = !_opened;
			TweenLite.to(this, 0.5, {ease: Expo.easeOut, x: targetX});
		}
		
		public function get opened():Boolean 
		{
			return _opened;
		}
		
		public function set opened(value:Boolean):void 
		{
			_opened = value;
		}
	
	}

}