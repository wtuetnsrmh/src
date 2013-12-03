package project.view.module.event.rechargeRank
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import project.model.event.rechargeRank.RechargeRank;
	import project.view.artplug.MovieClipButtonNoSound;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class RankPanel extends Sprite
	{
		protected var _getAwardBt:MovieClipButtonNoSound;
		protected var _closeBt:MovieClipButtonNoSound;
		protected var _callBack:*;
		
		public function RankPanel()
		{
			_closeBt = getChildByName("closeBt") as MovieClipButtonNoSound;
			_closeBt.onClick = close;
			_getAwardBt = getChildByName("getRankAwardBt") as MovieClipButtonNoSound;
			_getAwardBt.clickEnable = false;
			_getAwardBt.mouseEnabled = false;
			_getAwardBt.onClick = getAward;
		}
		
		protected function getAward(e:MouseEvent):void
		{
			_callBack.getAward(function():void { _getAwardBt.clickEnable = false;_getAwardBt.mouseEnabled = false; } );
		}
		
		public function setData(rank:Vector.<RechargeRank>, name:String, crystal:int, mincrystal:int, callBack:*):void
		{
			_callBack = callBack;
			for (var i:int = 0; i < rank.length; i++)
			{
				if (rank[i].user)
				{
					this["nameText" + i]["nameText"].text = rank[i].user.nick;
					this["nameText" + i]["crystalText"].text = rank[i].crystal.toString();
				}
				else
				{
					this["nameText" + i]["nameText"].text = "－－";
					this["nameText" + i]["crystalText"].text = "0";
				}
			}
			
			this["nameText"]["nameText"].text = name;
			this["nameText"]["crystalText"].text = (crystal >= mincrystal) ? "已激活" : "未激活";
		
		}
		
		protected function close(e:MouseEvent):void
		{
			this.visible = false;
			dispatchEvent(new Event("START_TIMER",true));
		}
		
		public function get getAwardBt():MovieClipButtonNoSound
		{
			return _getAwardBt;
		}
		
		public function set getAwardBt(value:MovieClipButtonNoSound):void
		{
			_getAwardBt = value;
		}
	}

}