package project.view.module.friends
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.friends.FriendsInforModel;
	import project.model.friends.FriendsRowModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.platform.YellowIco;
	
	/**
	 * ...
	 * @author bbjxl 2012
	 */
	public class FriendsRow extends BaseSpritePane
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _addBt:MovieClipButton; //加好友
		private var _showBt:MovieClipButton; //查看好友信息
		private var _settledBt:MovieClipButton; //占
		private var _saveBt:MovieClipButton; //救
		//private var _repairBt:MovieClipButton; //修
		private var _randomBt:MovieClipButton; //随
		private var _challengeBt:MovieClipButton; //挑战好友
		private var _nameText:TextField; //好友名字
		private var _levelText:TextField; //好友等级
		private var _noText:TextField; //列表中的序号
		private var _headImage:BaseIcoCellLoader; //头像
		private var _bonusId:int; //随机事件ＩＤ
		private var _yellowIco:YellowIco;
		//-----------------------数据---------------------------------
		private var _friendsModel:FriendsRowModel;
		
		//-----------------------事件--------------------------------
		public function FriendsRow()
		{
			setSpriteInstance("friendsRow");
			configerUiInstance();
		}
		
		private function configerUiInstance():void
		{
			_headImage = new BaseIcoCellLoader();
			_headImage.showBg = false;
			_headImage.setLocation(42, 4.5);
			_headImage.restrictHW = 32;
			addChild(_headImage);
			
			_addBt = getChild("addBt") as MovieClipButton;
			_addBt.visible = false;
			_showBt = getChild("showBt") as MovieClipButton;
			_settledBt = getChild("settledBt") as MovieClipButton;
			_saveBt = getChild("saveBt") as MovieClipButton;
			//_repairBt = getChild("repairBt") as MovieClipButton;
			_randomBt = getChild("randomBt") as MovieClipButton;
			_challengeBt = getChild("challengeBt") as MovieClipButton;
			_nameText = getChild("nameText") as TextField;
			_levelText = getChild("levelText") as TextField;
			_noText = getChild("noText") as TextField;
			
			_showBt.onClick = onClickHandler;
			_randomBt.onClick = onClickHandler;
			_settledBt.onClick = onClickHandler;
			_addBt.onClick = onClickHandler;
			_saveBt.onClick = onClickHandler;
			_challengeBt.onClick = onClickHandler;
			_challengeBt.toolTip = LocalConfig.LOCAL_LAN.FriendsPanel.ChallengeBtTip.@Text;
		}
		
		/**
		 * 更新
		 * @param	e
		 */
		public function updataUI(param:FriendsRowModel, no:int = 0,type=0):void
		{
			_friendsModel = param;
			
			_headImage.dispose();
			_headImage.ico = param.head;
			_nameText.text = param.name;
			
			//--------------------黄钻------------------------------------
			if (param.pfqq != null) {
				if (_yellowIco == null) {
					_yellowIco = new YellowIco();
					_yellowIco.x = 122.9;
					_yellowIco.y =-3.15;
					addChild(_yellowIco);
					_yellowIco.updataUI(param.pfqq);
					}else {
						_yellowIco.x = 122.9;
						_yellowIco.y = -3.15;
						_yellowIco.updataUI(param.pfqq);
						}
				}else {
					if (_yellowIco && contains(_yellowIco)) {
						_yellowIco.visible = false;
						}
					}
			
			//--------------------------------------------------------
			
			_levelText.text = "LV" + param.lv.toString();
			_noText.text = no.toString();
			
			if (type == 1) {
				//陌生人列表
				_randomBt.visible = false;
				_saveBt.visible = false;
				_settledBt.visible = false;
				_addBt.visible = false;
				return;
				}
				
			_addBt.visible = false;
			_randomBt.visible = (param.bonus == 0) ? false : true;
			_bonusId = param.bonus;
			if (param.holder == 0)
			{
				//没被奴仅
				_saveBt.visible = false;
				_settledBt.visible = true;
				
			}
			else if (param.holder == PlayerData.getInstance().userId)
			{
				//如果奴隶主是自己则不显示占跟救
				_saveBt.visible = false;
				_settledBt.visible = false;
			}
			else
			{
				_saveBt.visible = true;
				_settledBt.visible = false;
			}
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if (_friendsModel == null)
				return;
			switch (e.target)
			{
				case _addBt: 
					//加好友
					SMZTUIManager.getInstance().friendsBonusPanel.hide();
					Browser.visiteInfo(_friendsModel.snsid);
					break;
				case _showBt: 
					SMZTUIManager.getInstance().friendsBonusPanel.hide();
					SMZTController.getInstance().getUserDataById(_friendsModel.id, showFriendsInfoPanel);
					break;
				case _settledBt: 
					SMZTUIManager.getInstance().friendsInforPanel.hide();
					SMZTUIManager.getInstance().friendsBonusPanel.hide();
					//SMZTUIManager.getInstance().friendsPanel.close();//好友列表缩进
					SMZTUIManager.getInstance().friendsPanel._currentRowUserId = _friendsModel.id;
					BattleReadyPanel.getInstance().show(true);
					BattleReadyPanel.getInstance().initUIByBattleModel(4, BattleReadyPanel.ENSLAVE_FRIENDS_TYPE, false);
					
					break;
				case _saveBt: 
					SMZTUIManager.getInstance().friendsInforPanel.hide();
					SMZTUIManager.getInstance().friendsBonusPanel.hide();
					//SMZTUIManager.getInstance().friendsPanel.close();
					SMZTUIManager.getInstance().friendsPanel._currentRowMasterId = _friendsModel.holder;
					SMZTUIManager.getInstance().friendsPanel._currentRowUserId = _friendsModel.id;
					BattleReadyPanel.getInstance().show(true);
					BattleReadyPanel.getInstance().initUIByBattleModel(4, BattleReadyPanel.SAVE_FRIENDS_TYPE, false);
					
					break;
				/*case _repairBt:
				 break;*/
				case _randomBt: 
					SMZTUIManager.getInstance().friendsInforPanel.hide();
					SMZTController.getInstance().getBonusData(_friendsModel.id, showFriendsBonusPanel);
					break;
				case _challengeBt: 
					SMZTUIManager.getInstance().friendsInforPanel.hide();
					SMZTUIManager.getInstance().friendsBonusPanel.hide();
					//SMZTUIManager.getInstance().friendsPanel.close();
					SMZTUIManager.getInstance().friendsPanel._currentRowUserId = _friendsModel.id;
					BattleReadyPanel.getInstance().show(true);
					BattleReadyPanel.getInstance().initUIByBattleModel(4, BattleReadyPanel.CHALLENGE_FRIENDS_TYPE, false);
					break;
			}
		}
		
		
		private function showFriendsInfoPanel(param:Object):void
		{
			SMZTUIManager.getInstance().friendsInforPanel.show(false);
			FriendsInforModel.getInstance().updataData(param);
		}
		
		private function showFriendsBonusPanel(param:Object):void
		{
			_randomBt.visible = false;
			
			/*//随机事件面板暂时用文字提示
			FriendsBonusPanel.getInstance().show(false);
			FriendsBonusPanel.getInstance().updataUI(param, _friendsModel, _bonusId);*/
			var tempBM:BonusModel = new BonusModel();
			tempBM.setData(param.bonus);
			SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBM);
		}
		
		public function get friendsModel():FriendsRowModel
		{
			return _friendsModel;
		}
		
		public function set friendsModel(value:FriendsRowModel):void
		{
			_friendsModel = value;
		}
	
	}

}