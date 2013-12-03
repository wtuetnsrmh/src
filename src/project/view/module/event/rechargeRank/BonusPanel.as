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
	public class BonusPanel extends Sprite 
	{
		private const _getXY:Array = [ { "x":148.5, "y":82.7 }, { "x":148.5, "y":148.2 }, { "x":148.5, "y":214.2 }, { "x":148.5, "y":280.2 } ];
		private var _closeBt:MovieClipButtonNoSound;
		public function BonusPanel() 
		{
			_closeBt = getChildByName("closeBt") as MovieClipButtonNoSound;
			_closeBt.onClick = close;
		}
		
		public function setData(cards:Array,callBack:*):void {
		
			for (var j:int = 0; j < 4; j++ ) {
				var tempGetBt:GetCard = new GetCard(cards[j],callBack);
				tempGetBt.x = _getXY[j].x+(322-cards[j].length*90)/2;
				tempGetBt.y = _getXY[j].y;
				addChild(tempGetBt);
				}
			
			}
		
		private function close(e:MouseEvent):void {
			this.visible = false;
			dispatchEvent(new Event("START_TIMER",true));
			}
	}

}