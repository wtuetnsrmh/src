package project.view.module.log
{
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.controller.AttackController;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.model.crystalHole.MineType;
	import project.model.data.DataModel;
	import project.model.data.User;
	import project.model.friends.BonusModel;
	import project.model.friends.FriendsInforModel;
	import project.model.item.CardModel;
	import project.model.log.EventLog;
	import project.model.lottery.LotteryModel;
	import project.model.ModelLocator;
	import project.model.rank.CardRankItem;
	import project.model.rank.RankType;
	import project.model.rank.TowerRankItem;
	import project.model.rank.UserRankItem;
	import project.utils.CustomTool;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.lottery.LotteryPanel;
	import project.view.module.chat.ClickPopCard;
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class LogRow extends BaseSpriteSetUI
	{
		private var _ico:BaseIcoCellLoader;
		private var _timeText:TextField;
		private var _descText:TextField;
		private var _battalBt:MovieClipButton;
		private var _lotteryBt:MovieClipButton;
		private var _eventLog:EventLog;
		//private var _userData:User;
		
		public function LogRow()
		{
			setSpriteInstance("logRowUI");
			configerInstance();
		}
		
		public function updataUI(dm:EventLog):void
		{
			_eventLog = dm;
			_timeText.text = dm.timer;
			try{
			switch (dm.type)
			{
				case 1: 
					//1	玩家升级	lv	int	等级
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/"+ CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{lv}",dm.log.lv);
					break;
				case 2: 
					/*2	挑战战争学院	user	User	对手信息
					   win	int	是否获胜，1-胜利，0-失败
					   bonus	Bonus	奖励内容
					   lotteryId	int	抽奖编号（可为空）
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 if (dm.log.win == 1) {
						 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@VText).replace("{userName}",BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick)).replace("{bonus}",dm.log.bonus.exp);
						 }else {
							  _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@FText).replace("{userName}",BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick)).replace("{bonus}",dm.log.bonus.exp);
							 }
					 
					break;
				case 3: 
					/*3	竞技场挑战	arena	string	竞技场名称
					   user	User	对手信息
					   win	int	是否获胜，1-胜利，0-失败
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL +"images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 if (dm.log.win == 1) {
						 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@VText).replace("{arena}",dm.log.arena).replace("{userName}",BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
						 }else {
							  _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@FText).replace("{arena}",dm.log.arena).replace("{userName}",BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
							 }
					break;
				case 4: 
					/*4	失去竞技场擂主	arena	string	竞技场名称
					   win	int	连胜次数
					   user	User	对手信息
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" +CustomTool.turn000Num(dm.type) + ".jpg";
					 //trace(BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick))
					 //trace(String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{arena}",dm.log.arena).replace("{win}",dm.log.win).replace("{userName}",BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick)))
					 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{arena}",dm.log.arena).replace("{win}",dm.log.win).replace("{userName}",BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
					break;
				case 5: 
					/*5	挑战宿命之塔	lv	int	宿命之塔塔层
					   win	int	是否获胜，1-胜利，0-失败
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 if(dm.log.win == 0){
					  _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{lv}", dm.log.lv);
					 }
					break;
				case 6: 
					/*6	好友挑战自己	user	User	对手信息
					   win	int	自己是否获胜，1-胜利，0-失败
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 if (dm.log.win == 1) {
						 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@VText).replace("{userName}", BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
						 }else {
							  _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@FText).replace("{userName}", BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
							 }
					break;
				case 7: 
					/*7	好友奴役自己	user	User	对手信息
					   win	int	是否获胜，1-胜利，0-失败
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					  if (dm.log.win == 1) {
						 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@VText).replace("{userName}", BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
						 }else {
							  _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@FText).replace("{userName}", BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick));
							 }
					break;
				case 8: 
					/* 8	好友解救自己	saver	User	发起解救的玩家信息
					   slaver	User	原奴隶主玩家信息
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{saverName}", BonusModel.returnAddHref(dm.log.saver.userId,dm.log.saver.nick)).replace("{slaverName}", BonusModel.returnAddHref(dm.log.slaver.userId,dm.log.slaver.nick));
					break;
				case 9: 
					/*9	好友解救我的奴隶	saver	User	发起解救的玩家信息
					   slave	User	奴隶玩家信息
					   win	int	是否解救成功，1-成功，0-失败
					 battleId	string	战斗编号*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{saverName}", BonusModel.returnAddHref(dm.log.saver.userId,dm.log.saver.nick)).replace("{slaveName}", BonusModel.returnAddHref(dm.log.slave.userId,dm.log.slave.nick));
					break;
				case 10: 
					/*10	奴隶工作完成奖励	slave	User	奴隶玩家信息
					 bonus	Bonus	奖励信息*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.gold);
					break;
				case 11: 
					/*11	奴隶被解救奖励	saver	User	发起解救的玩家信息
					   slave	User	奴隶玩家信息
					 bonus	Bonus	奖励信息*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.gold).replace("{slaverName}", BonusModel.returnAddHref(dm.log.slave.userId,dm.log.slave.nick));
					break;
				case 12: 
					//12	获得宿命之塔奖励	bonus	Bonus	奖励信息
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString());
					break;
				case 13: 
					//13	领取签到奖励	bonus	Bonus	奖励信息
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString());
					break;
				case 14: 
					//14	领取活跃宝箱	bonus	Bonus	奖励信息
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString());
					break;
				case 15: 
					//15	购买商品	bonus	Bonus	奖励信息
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString());
					break;
				case 16: 
					/*16	升级卡牌星数	card	int	卡牌编号
					 star	int	星级*/
					 _ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					 _descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{cardName}", BonusModel.returnAddHref(dm.log.card,BonusModel.returnCardNameByQuityNoNumber(dm.log.card),2)).replace("{star}", dm.log.star);
					break;
				case 17: 
					/* 现在没用到
					 * 17	卡牌进化	card1	int	原卡牌编号
					 card2	int	进化后的卡牌编号*/
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{card1Name}",BonusModel.returnAddHref(dm.log.card1,BonusModel.returnCardNameByQuityNoNumber(dm.log.card1),2)).replace("{card2Name}", BonusModel.returnAddHref(dm.log.card2,BonusModel.returnCardNameByQuityNoNumber(dm.log.card2),2));
					break;
				case 18: 
					//18	开启卡包	bonus	Bonus	奖励信息
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString());
					break;
				case 19: 
					//19	酒馆招募	card	int	卡牌编号
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type)+ ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{cardName}", BonusModel.returnAddHref(dm.log.card,BonusModel.returnCardNameByQuityNoNumber(dm.log.card),2));
					break;
				case 20: 
					//20	抽奖中获得
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString());
					break;
				case 21: 
					//21	好友协助我的矿点	user	User	好友信息
							//mine	MineType	矿点类型
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{userName}", BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick)).replace("{mineType}",MineType.returnTypeCName(dm.log.mine));
					break;
				case 22: 
				case 23: 
				case 24: 
					//22	矿点被掠夺
					//23	矿点被偷挖
					//24	矿点被抢占
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{userName}", BonusModel.returnAddHref(dm.log.user.userId,dm.log.user.nick)).replace("{bonus}", dm.log.bonus.ToString()).replace("{mineType}",MineType.returnTypeCName(dm.log.mine));
					break;
				case 25: 
					//25	收获矿点
					_ico.ico = ModelLocator.getInstance().staticURL + "images/eventlogs/" + CustomTool.turn000Num(dm.type) + ".jpg";
					_descText.htmlText = String((LocalConfig.LOCAL_LAN.LogPane.Log.(@Type == dm.type)).@Text).replace("{bonus}", dm.log.bonus.ToString()).replace("{mineType}",MineType.returnTypeCName(dm.log.mine));
					break;
			}
			ApplicationConfig.setAppTextFormat(_timeText);
			ApplicationConfig.setAppTextFormat(_descText);
			}catch (e:Error) {
				Debug.log("LOGROW:" + e.message);
				//trace("e.message");
				}
			//设置位置
			if ((dm.log.battleId && dm.log.battleId != "") && (dm.log.lotteryId && dm.log.lotteryId != 0)) {
				_timeText.y = 0;
				_battalBt.x = 50.8;
				_lotteryBt.x = 95.4;
				_battalBt.visible = true;
				_lotteryBt.visible = true;
				}else if ((dm.log.battleId && dm.log.battleId != "") && !(dm.log.lotteryId && dm.log.lotteryId != 0)) {//没抽奖
					_timeText.y = 0;
					_battalBt.x = 73.4;
					_lotteryBt.x = 95.4;
					_battalBt.visible = true;
					_lotteryBt.visible = false;
					}else if (!(dm.log.battleId && dm.log.battleId != "") && (dm.log.lotteryId && dm.log.lotteryId != 0)) {//没观战
						_timeText.y = 0;
						_battalBt.x = 50.8;
						_lotteryBt.x = 73.4;
						_battalBt.visible = false;
						_lotteryBt.visible = true;
						}else {
							_timeText.y = 11.95;
							_battalBt.x = 50.8;
							_lotteryBt.x = 95.4;
							_battalBt.visible = false;
							_lotteryBt.visible = false;
							}
		}
		
		
		private function configerInstance():void
		{
			_ico = new BaseIcoCellLoader();
			_ico.showBg = false;
			addChild(_ico);
			
			_timeText = getChild("timeText") as TextField;
			_descText = getChild("descText") as TextField;
			_battalBt = getChild("battalBt") as MovieClipButton;
			_lotteryBt = getChild("lotteryBt") as MovieClipButton;
			_battalBt.onClick = clickHandler;
			_lotteryBt.onClick = clickHandler;
			
			_descText.addEventListener(TextEvent.LINK, linkClickHandler, false, 0, true);
		}
		
		private function linkClickHandler(e:TextEvent):void 
		{
			var _type:Array = e.text.split("_");
			if (_type[0]==1) {
				//弹出个人信息面板
				SMZTController.getInstance().getUserDataById(int(_type[1]), showFriendsInfoPanel);
				}else if (_type[0] == 2) {
					//弹出卡片面板
					ClickPopCard.getInstance().currentCardId = int(_type[1]);
					ClickPopCard.getInstance().show(true);
					}
		}
		private function showFriendsInfoPanel(param:Object):void
		{
			SMZTUIManager.getInstance().friendsInforPanel.showCenter(false);
			FriendsInforModel.getInstance().updataData(param);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _battalBt:
					AttackController.getInstance().replayBattleById(_eventLog.log.battleId);
					break;
				case _lotteryBt:
					LotteryModel.getInstance().currentLotteryId =_eventLog.log.lotteryId;
					LotteryPanel.getInstance().show(true);
					break;
				}
		}
	
	}

}