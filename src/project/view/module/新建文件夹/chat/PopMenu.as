package project.view.module.chat
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.data.PlayerData;
	import project.model.friends.FriendsInforModel;
	import project.model.ModelLocator;
	import project.utils.Browser;
	import project.view.base.BaseSprite;
	
	/**
	 * 名字点击弹出下拉菜单
	 * @author bbjxl
	 */
	public class PopMenu extends BaseSprite
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		
		//-----------------------数据---------------------------------
		private var _options:Vector.<PopOption>;
		private var _optionsArr:Array = ["私聊", "个人信息"];
		
		//-----------------------事件--------------------------------
		public function PopMenu()
		{
			_options = new Vector.<PopOption>();
			for (var i:String in _optionsArr)
			{
				var tempOptoin:PopOption = new PopOption(60, 20);
				tempOptoin.textStr = _optionsArr[i];
				tempOptoin.id = int(i);
				tempOptoin.y = tempOptoin.height * int(i) + int(i) * -1;
				addChild(tempOptoin);
				_options.push(tempOptoin);
				tempOptoin.addEventListener(MouseEvent.CLICK, clickHandler);
				tempOptoin = null;
			}
		}
		/**
		 * 弹出用户信息面板
		 * @param	e
		 */
		private function showFriendsInfoPanel(param:Object):void
		{
			SMZTUIManager.getInstance().friendsInforPanel.showCenter(false);
			FriendsInforModel.getInstance().updataData(param);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			//trace((e.currentTarget as PopOption).id);
			if ((e.currentTarget as PopOption).id == 0)
			{
				//私聊
				ChatPane.getInstance().comboBox.selectedCellById(1);
				ChatPane.getInstance().currentPrivateChatUserId = ManagerPopMenu.getInstance().currentRrefInfo.userId;
				ChatPane.getInstance().currentPrivateChatUserName = ManagerPopMenu.getInstance().currentRrefInfo.userName;
				if (!ChatPane.getInstance().currentOpened) {
					ChatPane.getInstance().openBtClickHandler();
					}
			}
			else
			{
				//显示个人信息
				//Browser.visiteInfo(ManagerPopMenu.getInstance().currentRrefInfo);
				SMZTController.getInstance().getUserDataById(ManagerPopMenu.getInstance().currentRrefInfo.userId, showFriendsInfoPanel);
			}
			ManagerPopMenu.getInstance().hideMenu();
		}
	
	}

}