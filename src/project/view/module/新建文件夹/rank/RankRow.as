package project.view.module.rank
{
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.config.ApplicationConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.data.DataModel;
	import project.model.data.PlayerData;
	import project.model.data.User;
	import project.model.friends.FriendsInforModel;
	import project.model.rank.CardRankItem;
	import project.model.rank.RankType;
	import project.model.rank.TowerRankItem;
	import project.model.rank.UserRankItem;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class RankRow extends BaseSpriteSetUI
	{
		private var _rankNumText:TextField;
		private var _nameText:TextField;
		private var _titleText:TextField;
		
		//private var _userData:User;
		
		public function RankRow()
		{
			setSpriteInstance("rankRowUI");
			configerInstance();
		}
		public function updataUI(dm:DataModel, type:int):void
		{
			var tempcolor:String;
			
			switch (type)
			{
				case RankType.LEVEL: 
					if ((dm as UserRankItem).user.userId == PlayerData.getInstance().userId) {
						//自己名字颜色不同
						tempcolor = "#ABFC14'>";
						}else {
							tempcolor = "#ffffff'>";
							}
							
					_titleText.htmlText = (dm as UserRankItem).user.level.toString();
					
					_nameText.htmlText = "<a href='event:" + (dm as UserRankItem).user.userId + "'><font color='" +tempcolor+ (dm as UserRankItem).user.nick + "</font></a>";
					_rankNumText.htmlText = "第"+(dm as UserRankItem).rank.toString()+"名";
					//_userData = (dm as UserRankItem).user;
					break;
				case RankType.TOWER: 
					if ((dm as TowerRankItem).user.userId == PlayerData.getInstance().userId) {
						//自己名字颜色不同
						tempcolor = "#ABFC14'>";
						}else {
							tempcolor = "#ffffff'>";
							}
					_titleText.htmlText = (dm as TowerRankItem).lv.toString();
					_nameText.htmlText = "<a href='event:" + (dm as TowerRankItem).user.userId + "'><font color='" +tempcolor+ (dm as TowerRankItem).user.nick + "</font></a>";
					_rankNumText.htmlText = "第"+(dm as TowerRankItem).rank.toString()+"名";
					//_userData = (dm as TowerRankItem).user;
					break;
				case RankType.CARD: 
					if ((dm as CardRankItem).user.userId == PlayerData.getInstance().userId) {
						//自己名字颜色不同
						tempcolor = "#ABFC14'>";
						}else {
							tempcolor = "#ffffff'>";
							}
					_titleText.htmlText = (dm as CardRankItem).power.toString();
					_nameText.htmlText = "<a href='event:" + (dm as CardRankItem).user.userId + "'><font color='" +tempcolor+ (dm as CardRankItem).user.nick + "</font></a>";
					_rankNumText.htmlText = "第"+(dm as CardRankItem).rank.toString()+"名";
					//_userData = (dm as CardRankItem).user;
					break;
			}
			_nameText.addEventListener(TextEvent.LINK, linkHandler, false, 0, true);
			
			ApplicationConfig.setAppTextFormat(_titleText, _nameText, _rankNumText);
		}
		
		/**
		 * 弹出用户信息面板
		 * @param	e
		 */
		private function linkHandler(e:TextEvent):void
		{
			SMZTController.getInstance().getUserDataById(int(e.text), showFriendsInfoPanel);
		}
		
		private function showFriendsInfoPanel(param:Object):void
		{
			SMZTUIManager.getInstance().friendsInforPanel.showCenter(false);
			FriendsInforModel.getInstance().updataData(param);
		}
		
		private function configerInstance():void
		{
			_titleText = getChild("titleText") as TextField;
			_nameText = getChild("nameText") as TextField;
			_rankNumText = getChild("rankNumText") as TextField;
			
			
			_nameText.autoSize = TextFieldAutoSize.CENTER;
			_rankNumText.autoSize = TextFieldAutoSize.CENTER;
			//_titleText.autoSize = TextFieldAutoSize.CENTER;
			
			
		}
	
	}

}