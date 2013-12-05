package project.view.module.event.rechargeRank 
{
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import project.view.artplug.MovieClipButtonNoSound;
	import flash.text.TextField;
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class CardAndNumber extends Sprite 
	{
		private var _numText:TextField;
		public function CardAndNumber(card:*,callback:*) 
		{
			addChild(card);
			var temp:cardnumber = new cardnumber();
			_numText = temp["numtext"] as TextField;
			_numText.autoSize = TextFieldAutoSize.LEFT;
			_numText.text = "X"+card.getCardModel().number.toString();
			_numText.x = 68;
			_numText.y = 64 - _numText.textHeight >> 1;
			addChild(_numText);
			temp = null;
		}
		
	}

}