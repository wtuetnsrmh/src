package project.view.module.event.rechargeRank
{
	
	import com.bbjxl.utils.Tools;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.debug.Debug;
	import project.model.data.DataModel;
	import project.model.event.rechargeRank.RechargeRank;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButtonNoSound;
	import flash.system.Security;
	import project.view.module.event.EventBase;
	/**
	 * 充值排名活动面板
	 * ranks	array[RechargeRank]	可兑换商品列表
		begin	int	活动开始日期时间戳
		end	string	活动结束日期时间戳
		crystal string 当前玩家已充值水晶
	 * @author bbjxl 2013
	 */
	public class RechargeRandkEventPanel extends EventBase
	{
		
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _ui:Sprite;
		private var _rankBt:MovieClipButtonNoSound;
		private var _bonusBt:MovieClipButtonNoSound;
		private var _rechargeBt:MovieClipButtonNoSound;
		private var _crystalText:TextField;//已充水晶
		private var _counDownText:TextField;//倒计时
		private var _bonusPanel:BonusPanel;
		private var _rankPanel:RankPanel;
		//-----------------------数据---------------------------------
		private var _name:String;
		private var _counDownTimer:Timer = new Timer(1000);
		private var _timer:int;
		private var _minBonusCardId:Vector.<Object>;
		private var _minCrystal:int;
		private var _begin:String;
		private var _end:String;
		private var _crystal:int;
		private var _ranks:Vector.<RechargeRank>;
		private var _callbackObj:*;
		private var _levelArr:Array = [1, 5, 10, 20, 30, 50, 80, 100, 150];
		
		//-----------------------事件--------------------------------
		public function RechargeRandkEventPanel()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//this.addEventListener(Event.ADDED_TO_STAGE, addtoStage);
			init();
		}
		private function addtoStage(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, addtoStage);
			//init();
		}
		private function init():void
		{
			
			_ui = new RechargeRankEventPanelUI();
			addChild(_ui);
			
			_rankBt = _ui["rankBt"] as MovieClipButtonNoSound;
			_bonusBt = _ui["bonusBt"] as MovieClipButtonNoSound;
			_rechargeBt = _ui["rechargeBt"] as MovieClipButtonNoSound;
			_rankBt.onClick = rankBtClick;
			_bonusBt.onClick = bonusBtClick;
			_rechargeBt.onClick = rechargeClick;
			
			_counDownText = _ui["counDownText"] as TextField;
			_crystalText = _ui["crystalText"] as TextField;
			
			_bonusPanel = new BonusPanel();
			_rankPanel = new RankPanel();
			_bonusPanel.visible = _rankPanel.visible = false;
			_bonusPanel.x = _rankPanel.x = 70.5;
			_bonusPanel.y = _rankPanel.y = 97.8;
			addChild(_bonusPanel);
			addChild(_rankPanel);
			
			_counDownTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			
		}
		
		private function bonusBtClick(e:MouseEvent):void 
		{
			_bonusPanel.visible = true;
			_rankPanel.visible = false;
			dispatchEvent(new Event("STOP_TIMER"));
		}
		
		private function rankBtClick(e:MouseEvent):void 
		{
			_bonusPanel.visible = false;
			_rankPanel.visible = true;
			dispatchEvent(new Event("STOP_TIMER"));
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			if (_timer <= 0) {
				if(_crystal>=_minCrystal){
				_rankPanel.getAwardBt.mouseEnabled = true;
				_rankPanel.getAwardBt.clickEnable = true;
				}
				_counDownTimer.stop();
				_counDownTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_counDownText.text = "0天0小时0分";
				return;
				}else {
					_timer--;
					}
			_counDownText.text = Tools.formatTime_day(_timer);
		}
		

		
		/**
		 * 充值
		 * @param	e
		 */
		private function rechargeClick(e:MouseEvent):void
		{
           navigateToURL(new URLRequest("pay.aspx"), "_self");
		}
		
		
		/**
		 * 传入接口对象
		 * @return
		 */
		override public function setData(value:*):void
		{
			_callbackObj = value;
			
			refresh();
		}
		
		private function updataUI(param:Object,cards:Array):void
		{
			_name = param.name;
			_begin = param.begin;
			_end = param.end;
			_crystal = param.crystal;
			_timer = param.timer;
			Debug.log("_timer="+_timer)
			_minCrystal = param.minCrystal;
			_crystalText.text = _crystal.toString()+"水晶";
			
			/*var _bonus:Object = param["minBonus"];
			if (_bonus)
			{
				var tempCard:Object = _bonus["cards"];
				if (tempCard != null)
				{
					_minBonusCardId = new Vector.<Object>();
					for (var j:String in tempCard)
					{
						var temp:Object = new Object();
						temp.id = int(j);
						temp.number = tempCard[j];
						_minBonusCardId.push(temp);
						temp = null;
					}
				}
				_bonus = null;
				tempCard = null;
			}*/
			
			_ranks = new Vector.<RechargeRank>();
			for (var i:int = 0; i < param.ranks.length; i++)
			{
				var tempRank:RechargeRank = new RechargeRank();
				tempRank.setData(param.ranks[i]);
				_ranks.push(tempRank);
				tempRank = null;
			}
			
			_bonusPanel.setData(cards,_callbackObj);
			_rankPanel.setData(_ranks, _name,_crystal,_minCrystal,_callbackObj);
			
			_counDownTimer.start();
		}
		
		/**
		 * 刷新
		 */
		private function refresh():void
		{
			_callbackObj.getEventInfor(updataUI);
		}
		

	}

}