package project.view.module.event.rechargeRank 
{
	import flash.display.Sprite;
	
	import project.view.artplug.MovieClipButtonNoSound;
	
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class GetCard extends Sprite 
	{
		private const _gap:int = 5;
		
		public function GetCard(cards:Array,callback:*) 
		{
			var tempCard:CardAndNumber;
			for (var i:String in cards) {
				tempCard = new CardAndNumber(cards[i],callback);
				tempCard.x = int(i) * 90+ int(i) * _gap;
				addChild(tempCard);
				tempCard = null;
				}
			
		}
		
	}

}