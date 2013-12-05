package project.view.module.scene.statue
{
	import project.core.SMZTUIManager;
	import project.events.UIEvent;
	import project.view.module.chat.ChatPane;
	import project.view.module.friends.FriendsPanel;
	
	/**
	 * 管理活跃度列表中的前往按钮点击后跳转到相应的模块
	 * @author bbjxl 2013
	 */
	public class ManageToSenceById
	{
		/* <Objective ID="1" Title="每日登录（首次登录+20分）" Max="1" Point="5" />
		   <Objective ID="2" Title="挑战宿命之塔（每次进入挑战+20分）" Max="10" Point="20" />
		   <Objective ID="3" Title="挑战竞技场（每次进入挑战+20分）" Max="10" Point="20" />
		   <Objective ID="4" Title="战争学院训练（每次挑战+5分）" Max="10" Point="5" />
		   <Objective ID="5" Title="酒馆招募（每次刷新+20分）" Max="10" Point="20" />
		   <Objective ID="6" Title="进阶卡牌（每次进阶+20分）" Max="10" Point="20" />
		   <Objective ID="7" Title="聊天广播（每次使用任意号角+20)" Max="10" Point="20" />
		   <Objective ID="8" Title="奴役好友（每次奴役好友+10)" Max="10" Point="10" />
		   <Objective ID="9" Title="与好友切磋（每次挑战+10)" Max="10" Point="10" />
		   <Objective ID="10" Title="随机事件(每次开宝箱+10)" Max="10" Point="10" />
		   <Objective ID="11" Title="获得新卡牌(每次开卡包+20)" Max="10" Point="20" />
		   <Objective ID="12" Title="成功奴役收获(每次收获+20)" Max="10" Point="20" />
		 */
		public static const TOWER:int = 1;
		public static const ARENA:int = 2;
		public static const TRAINING:int = 3;
		public static const TAVERN:int = 4;
		public static const CULTIVATION:int = 5;
		//public static const CHAT:int = 7;
		public static const SLAVE_FRIENDS:int = 7;
		public static const CHALLENGE_FRIENDS:int = 7;
		public static const RANDOM_EVENT:int = 7;
		public static const SLAVE:int = 6;
		
		public function ManageToSenceById()
		{
		
		}
		
		public static function gotoSecne(value:int):void
		{
			StatuePanel.getInstance().hide();
			
			switch (value)
			{
				case TOWER: 
					SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_TOWER_SCENE);
					break;
				case ARENA: 
					SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_ARENA_SCENE);
					break;
				case TRAINING: 
					SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_COLLENGE_SCENE);
					break;
				case TAVERN: 
					SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_TAVERN_SCENE);
					break;
				case CULTIVATION: 
					SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_CULTIVATION_SCENE);
					break;
				/*case CHAT: 
					//如果聊天窗口合上则展开
					if (!ChatPane.getInstance().isOpened) {
						ChatPane.getInstance().openBtClickHandler();
						}
					break;*/
				case SLAVE_FRIENDS: 
					SMZTUIManager.getInstance().mainPane.returnMainScene();
					//打开好友列表
					if (!SMZTUIManager.getInstance().friendsPanel.isOpened) {
						SMZTUIManager.getInstance().friendsPanel.open();
						}
					break;
				case CHALLENGE_FRIENDS: 
					SMZTUIManager.getInstance().mainPane.returnMainScene();
					//打开好友列表
					if (!SMZTUIManager.getInstance().friendsPanel.isOpened) {
						SMZTUIManager.getInstance().friendsPanel.open();
						}
					break;
				case RANDOM_EVENT: 
					SMZTUIManager.getInstance().mainPane.returnMainScene();
					//打开好友列表
					if (!SMZTUIManager.getInstance().friendsPanel.isOpened) {
						SMZTUIManager.getInstance().friendsPanel.open();
						}
					break;
				case SLAVE: 
					SMZTUIManager.getInstance().mainPane.showScene(UIEvent.SHOW_SLAVE_SCENE);
					break;
				
			}
		}
	
	}

}