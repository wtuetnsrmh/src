package project.view.module.scene.arena
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.arena.ArenaModel;
	import project.model.arena.ArenaSlotModel;
	import project.model.data.PlayerData;
	import project.model.friends.FriendsInforModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.cell.BaseIcoCellLoader;
	
	/**
	 * 竞技声中的擂主信息
	 * @author bbjxl 2012
	 */
	public class ChampionPanel extends BaseSpritePane
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _headImage:BaseIcoCellLoader; //头像
		private var _nameText:TextField; //名称
		private var _levelText:TextField; //等级
		private var _boundsText:TextField; //奖池
		private var _winNumText:TextField; //连胜场数
		private var _costText:TextField; //报名费
		private var _attackBt:MovieClipButton; //攻擂按钮
		private var _icoMc:MovieClip; //金币水晶图标
		//-----------------------数据---------------------------------
		private var _arenaSlotModel:ArenaSlotModel;
		
		//-----------------------事件--------------------------------
		public function ChampionPanel()
		{
			setSpriteInstance("championPanel");
			configerUIInstance();
		}
		
		private function configerUIInstance():void
		{
			//trace("ico")
			_headImage = new BaseIcoCellLoader();
			_headImage.showBg = false;
			_headImage.restrictHW = 67;
			_spriteInstance.addChild(_headImage);
			_headImage.setLocation(10, 3);
			_icoMc = getChild("icoMc") as MovieClip;
			_nameText = getChild("nameText") as TextField;
			_levelText = getChild("levelText") as TextField;
			_boundsText = getChild("boundsText") as TextField;
			_winNumText = getChild("winNumText") as TextField;
			_costText = getChild("costText") as TextField;
			ApplicationConfig.setDefaultTextFormat(_nameText,_levelText,_boundsText,_winNumText,_costText);
			
			_attackBt = getChild("attackBt") as MovieClipButton;
			_attackBt.onClick = attackOnClickHandler;
		}
		
		/**
		 * 攻擂
		 * @param	e
		 */
		private function attackOnClickHandler(e:MouseEvent):void
		{
			ArenaModel.getInstance().arenaId = _arenaSlotModel.id;
			ArenaModel.getInstance().championId = (_arenaSlotModel.champion == null) ? 0 : _arenaSlotModel.champion.userId;
			BattleReadyPanel.getInstance().show(true);
			BattleReadyPanel.getInstance().initUIByBattleModel(_arenaSlotModel.mode, BattleReadyPanel.ARENA_TYPE);
		}
		
		public function updata(param:ArenaSlotModel):void
		{
			reset();
			
			_arenaSlotModel = param;
			
			if (param.champion)
			{
				_headImage.ico = param.champion.avatar;
				_levelText.text = param.champion.level.toString();
				_nameText.htmlText = "<a href='event:" + param.champion.userId + "'><font color='#ffffff'>"+ param.champion.nick + "</font></a>";// param.champion.nick;
				if (param.champion.userId == PlayerData.getInstance().userId) {
					//是自己攻擂不能点
					_attackBt.clickEnable = false;
					}else {
						_attackBt.clickEnable = true;
						}
			}else {
				//如果为null表示还没人攻过，则可以攻擂
				_attackBt.clickEnable = true;
				}
			_icoMc.gotoAndStop(param.type);
			
			
			_boundsText.text = param.bonus.toString();
			_winNumText.text = param.win.toString();
			_costText.text = param.cost.toString();
			_nameText.addEventListener(TextEvent.LINK, linkHandler, false, 0, true);
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
		
		private function reset():void
		{
			_headImage.clearImgIco();
			_headImage.dispose();
			_levelText.text = "";
			_nameText.text = "";
			_boundsText.text = "";
			_winNumText.text = "";
			_costText.text = "";
		}
		
		//--------------------------------------------------------
		public function get arenaSlotModel():ArenaSlotModel
		{
			return _arenaSlotModel;
		} // end function
		
		public function set arenaSlotModel(param1:ArenaSlotModel):void
		{
			_arenaSlotModel = param1;
			return;
		} // end function
	}

}