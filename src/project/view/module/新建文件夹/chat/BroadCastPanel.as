package project.view.module.chat 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import project.config.ErrorZhCn;
	import project.config.ItemConfig;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.achievement.AchievementModel;
	import project.model.chat.Broadcast;
	import project.model.chat.BroadcastModel;
	import project.model.chat.HrefInfo;
	import project.model.crystalHole.MineType;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.item.CardModel;
	import project.view.base.BaseSpritePane;
	import project.view.controls.ManageShowBonus;
	import project.view.module.scene.main.MainScene;
	
	/**
	 * 广播
	 * @author bbjxl
	 */
	public class BroadCastPanel extends BaseSpritePane 
	{
		//----------------------容器---------------------------------
				
		//-----------------------UI---------------------------------
		private var _contentText:TextField;
		private var _titleText:TextField;
		private var _contentBg:Sprite;
		private var _titleBg:Sprite;
		private var _bt:MovieClip;
		//-----------------------数据---------------------------------
		private var _broadcastModel:BroadcastModel;
		private var _records:Array;
		private var _timer:Timer=new Timer(100);
		private var _rec:Rectangle;
		//-----------------------事件--------------------------------
		private static var _broadCastPanel:BroadCastPanel;
		public function BroadCastPanel() 
		{
			if (_broadCastPanel != null)
			{
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
			}
			
			setSpriteInstance("BroadcastUI");
			this.configerUIInstance();
			
			setLocation(495.45, 5);
			
			_broadcastModel = BroadcastModel.getInstance();
			dataModel = _broadcastModel;
			_records = new Array();
			
			_contentBg.visible = false;
			_contentText.visible = false;
			
			_rec = new Rectangle(0, 0, 181.05, 20);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
		}
		
		override public function show(param1:Boolean = false):void
		{
			_rootContainer.addChild(this);
			return;
		} // end function
		
		private function timerHandler(e:TimerEvent):void 
		{
			if (_rec.x > _titleText.textWidth+5) {
				_rec.x = -10;
				}
			_rec.x++;
			_titleText.scrollRect = _rec;
		}
		
		private function configerUIInstance():void 
		{
			_contentText = getChild("contentText") as TextField;
			_titleText = getChild("titleText") as TextField;
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.size = 12;
			_titleText.defaultTextFormat = tf;
			//tf.leading = 5;
			_contentText.defaultTextFormat = tf;
			_titleText.autoSize = TextFieldAutoSize.LEFT;
			_contentText.autoSize = TextFieldAutoSize.LEFT;
			_contentText.width = 178;
			_titleText.mouseWheelEnabled = false;
			_contentText.mouseWheelEnabled = false;
			_contentBg = getChild("contentBg") as Sprite;
			_titleBg = getChild("titleBg") as Sprite;
			_titleBg.mouseEnabled = false;
			_contentBg.mouseEnabled = false;
			_bt = getChild("bt") as MovieClip;
			_bt.addEventListener(MouseEvent.CLICK, clickHandler);
			_bt.buttonMode = true;
			
			_contentText.addEventListener(TextEvent.LINK, linkHandler,false,0,true);
			_titleText.addEventListener(TextEvent.LINK, linkHandler,false,0,true);
		}
		
		private function linkHandler(e:TextEvent):void 
		{
			var temp:HrefInfo = new HrefInfo();
			temp.decode(e.text);
			
			if (temp.type == HrefInfo.PLAYER) {
				//不能对自己私聊
				if (temp.userId == PlayerData.getInstance().userId) return;
				ManagerPopMenu.getInstance().showMenu(temp);
				}else if(temp.type==HrefInfo.CARD){
					ClickPopCard.getInstance().currentCardId = temp.cardId;
					ClickPopCard.getInstance().show(true);
					}else if (temp.type == HrefInfo.MINES && temp.userId!=PlayerData.getInstance().userId) {
						//协助矿
						SMZTController.getInstance().assetsMines(temp.mineId, function(param:Object):void {
							var tempBonus:BonusModel = new BonusModel();
							tempBonus.setData(param);
							SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus);
							tempBonus = null;
							if(SMZTUIManager.getInstance().mainPane.currentSceneId==MainScene.CRYSTAL_HOLE_SCENE){
							SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
							}
							});
						}
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if ((e.currentTarget as MovieClip).currentFrame == 1) {
				(e.currentTarget as MovieClip).gotoAndStop(2);
				open();
				}else {
					(e.currentTarget as MovieClip).gotoAndStop(1);
					ManagerPopMenu.getInstance().hideMenu();
					close();
					}
			
		}
		
		private function close():void 
		{
			_contentBg.visible = false;
			_contentText.visible = false;
			_titleBg.visible = true;
			_titleText.visible = true;
			
			_rec.x = 0;
			_titleText.scrollRect = _rec;
			
			if (_titleText.textWidth > 178) {
				if (!_timer.running) {
					_timer.start();
					}
				}
		}
		
		private function open():void 
		{
			_timer.stop();
			
			_contentBg.visible = true;
			_contentText.visible = true;
			_titleBg.visible = false;
			_titleText.visible = false;
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			if (_broadcastModel.broadcasts.length > 0)
			{
				showOneMes(_broadcastModel.broadcasts.shift());
			}
			return;
		} // end function
		
		private function showOneMes(param:Broadcast):void 
		{
			if (_records.length >= _broadcastModel.maxNum) {
				_records.splice(0, 1);
				}
			
			var tempStr:String = LocalConfig.LOCAL_LAN.BroadcastPanel.Broadcast.(@type == param.type).@Text;
			
			switch(param.type) {
				case Broadcast.ALLSERVER:
					//全服公告
					tempStr = param.msg;
					SMZTUIManager.getInstance().manageShowBonus.showServerNode(tempStr);
					return;
					break;
				case Broadcast.GETCARD:
					
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{cardName}", returnAddHref(param,2));
					
					break;
				case Broadcast.GETACHV:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{achvName}", AchievementModel.getInstance().returnTitleById(param.achvId));//成就
					break;
				case Broadcast.ARENA_WIN:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{win}", param.win).replace("{arenaName}", param.arena);
					break;
				case Broadcast.ARENA_CHALLENGE:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{loseName}", returnAddHref(param,3)).replace("{arenaName}", param.arena);;
					break;
				case Broadcast.USER_CARDS:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{itemName}", getItemNameByItemId(param.itemId)).replace("{cardName}", returnAddHref(param,2));
					break;
				case Broadcast.TAVERN:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{cardName}", returnAddHref(param,2));
					break;
				case Broadcast.TOWER:
					tempStr = tempStr.replace("{userName}", returnAddHref(param, 1)).replace("{lv}", param.lv);
					break;
				case Broadcast.STARUP:
					tempStr = tempStr.replace("{userName}", returnAddHref(param, 1)).replace("{cardName}", returnAddHref(param, 2)).replace("{star}", param.star);
					break;
				case Broadcast.MIX:
					tempStr = tempStr.replace("{userName}", returnAddHref(param, 1)).replace("{cardName}", returnAddHref(param, 2));
					break;
				case Broadcast.EVENT:
					tempStr = tempStr.replace("{userName}", returnAddHref(param, 1)).replace("{eventName}", param.eventName).replace("{cardName}", returnAddHref(param, 2));
					break;
				case Broadcast.VIP:
					tempStr = tempStr.replace("{userName}", returnAddHref(param, 1)).replace("{vipLevel}", param.vip).replace("{cardName}", returnAddHref(param, 2));
					break;
				case Broadcast.OCCUPY_EMPTY:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{mineType}", MineType.returnTypeCName(param.mine)).replace("{mineId}", param.mineId).replace("{userId}", param.user.userId);
					break;
				case Broadcast.OCCUPY:
					tempStr = tempStr.replace("{userName1}", returnAddHref(param,1)).replace("{userName2}", returnAddHref(param,4)).replace("{mineType}", MineType.returnTypeCName(param.mine)).replace("{mineId}", param.mineId).replace("{userId}", param.user.userId);
					break;
				case Broadcast.HARVEST:
					tempStr = tempStr.replace("{userName}", returnAddHref(param,1)).replace("{mineType}", MineType.returnTypeCName(param.mine)).replace("{bonus}", param.bonus.ToString());
					break;
				}
			_titleText.htmlText = tempStr;
			if (_titleText.textWidth > 178 && _bt.currentFrame == 1) {
				//打开且超宽时滚动
				if (!_timer.running) {
					_timer.start();
					}
				}else {
					_timer.stop();
					_rec.x = 0;
					_titleText.scrollRect = _rec;
					}
				
			_records.push(tempStr);
			tempStr = null;
			_contentText.htmlText = returnMaxBorad();
			_contentText.mouseWheelEnabled = false;
			_contentText.scrollRect = new Rectangle(0, 0, 178.5, 161.5);
			
		}
		/**
		 * 根据物品ID获取物品名称
		 */
		private function getItemNameByItemId(value:int):String 
		{
			return ItemConfig.ITEM_CONFIG.Item.(@ID == value).@Name;
		}
		
		/**
		 * 返回相应的加链接字符
		 * @param	temp
		 * @param	type
		 * @return
		 */
		private function returnAddHref(param:Broadcast, type:int = 1):String {
			var returnStr:String = "";
			var temp:Object = new Object();
			var tempMe:String;
			switch(type) {
				case 1:
					//返回名字
					temp.type = HrefInfo.PLAYER;
					temp.userId = param.user.userId;
					temp.userName = param.user.nick;
					//temp.snsName = param.user.snsName;
					tempMe = returnSplitString(temp);
					returnStr= "<a href='event:" + tempMe +"'>" + temp.userName + "</a>";
					break;
				case 2:
					//返回加了链接的卡牌名字
					temp.type = HrefInfo.CARD;
					temp.cardId = param.cardId;
					tempMe= returnSplitString(temp,2);
					
					returnStr = "<a href='event:" + tempMe +"'>" + CardModel.returnColorCardNameById(param.cardId)+ "</a>";
					
					break;
				case 3:
					//返回擂主名字
					temp.type = HrefInfo.PLAYER;
					temp.userId = param.loser.userId;
					temp.userName = param.loser.nick;
					//temp.snsName = param.loser.snsName;
					tempMe = returnSplitString(temp);
					returnStr= "<a href='event:" + tempMe +"'>" + temp.userName + "</a>";
					break;
				case 4:
					//返回矿洞第二个名字
					temp.type = HrefInfo.PLAYER;
					temp.userId = param.user2.userId;
					temp.userName = param.user2.nick;
					//temp.snsName = param.user.snsName;
					tempMe = returnSplitString(temp);
					returnStr= "<a href='event:" + tempMe +"'>" + temp.userName + "</a>";
					break;
				}
				temp = null;
			return returnStr;
			}
		
		/**
		 * 以_分割对象
		 * @param	channel
		 */
		private function returnSplitString(temp:Object, type:int = 1):String {
			var str:String;
			switch(type) {
				case 1:
					//玩家名称
					str = temp.type + "_" + temp.userId+ "_" + temp.userName;
					break;
				case 2:
					//卡片名称
					str = temp.type + "_" + temp.cardId;
					break;
				
				}
			return str;
			}
			
		/**
		 * 返回当前前面的最大条数广播
		 * @return
		 */
		private function returnMaxBorad():String {
			var temp:String = "";
			for (var i:int = _records.length - 1; i >= 0; i-- ) {
				temp += _records[i] + "<br>";
				}
			return temp;
			}
		
		public static function getInstance() : BroadCastPanel
		{
			if (_broadCastPanel == null)
			{
			  _broadCastPanel = new BroadCastPanel;
			}
			return _broadCastPanel; 
		}// end function
	}

}