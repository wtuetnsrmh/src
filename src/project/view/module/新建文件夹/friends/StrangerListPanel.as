package project.view.module.friends
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import project.config.LocalConfig;
	import project.model.friends.FriendsRowModel;
	import project.utils.Browser;
	import project.view.base.BaseSpritePane;
	import project.view.layout.BaseGridContainer;
	import mx.utils.StringUtil;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.friends.FriendsModel;
	import project.utils.CustomTool;
	import project.view.artplug.MovieClipButton;
	import project.view.module.helppane.HelpPane;
	/**
	 * 陌生人列表
	 * @author bbjxl 2013
	 */
	public class StrangerListPanel extends BaseSpritePane
	{
		//----------------------容器---------------------------------
		private var _gridContainer:BaseGridContainer; //放行容器
		
		//-----------------------UI---------------------------------
		private var _ui:DisplayObject;
		//private var _inviteBt:MovieClipButton;//邀请按钮
		private var _refreshBt:MovieClipButton; //刷新按钮
		//-----------------------数据---------------------------------
		private var _opened:Boolean = false;
		private var _maxRow:int = 6; //一页最多显示多少行
		private var _totalRow:Vector.<FriendsRow>; //所有的行
		private var _strangerRow:Vector.<FriendsRowModel>;
		
		public function StrangerListPanel(ui:DisplayObject)
		{
			_ui = ui;
			addChild(ui);
			configUiInstance();
			_gridContainer =new BaseGridContainer(_maxRow, 1, 8, 198.35, 58.25);
			_gridContainer.setLocation(48, 168.4);
			
			_totalRow = new Vector.<FriendsRow>();
			for (var i:int = 0; i < _maxRow; i++)
			{
				var tempRow:FriendsRow = new FriendsRow();
				_gridContainer.appendChild(tempRow);
				_totalRow.push(tempRow);
				tempRow = null;
			}
			
			addChild(_gridContainer);
		}
		
		private function configUiInstance():void
		{
			//_inviteBt = _ui["inviteBt"] as MovieClipButton;
			_refreshBt = _ui["refreshBt"] as MovieClipButton;
			
			//_inviteBt.onClick = inviteBtClick;
			_refreshBt.onClick = refreshBttClick;
			_refreshBt.toolTip=LocalConfig.LOCAL_LAN.FriendsPanel.RefreshTip.@Text;
		
		}
		
		/**
		 * 刷新列表
		 */
		public function refreshBttClick(e:MouseEvent = null):void
		{
			SMZTController.getInstance().getRandomList(function(param:Object):void
				{
					if (_strangerRow)
					{
						_strangerRow = null;
					}
					_strangerRow = new Vector.<FriendsRowModel>();
					for (var i:String in param)
					{
						var temp:FriendsRowModel = new FriendsRowModel(param[i]);
						_strangerRow.push(temp);
						temp = null;
					}
					updatUI();
				});
		
		}
		
		public function updatUI():void
		{
			for (var i:int = 0; i < _totalRow.length; i++)
			{
				if (i < _strangerRow.length)
				{
					_totalRow[i].visible = true;
					_totalRow[i].updataUI(_strangerRow[i], i + 1, 1);
				}
				else
				{
					_totalRow[i].visible = false;
				}
			}
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