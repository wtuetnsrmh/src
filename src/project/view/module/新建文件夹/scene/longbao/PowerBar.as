package project.view.module.scene.longbao 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.view.base.BaseSprite;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * 体力栏
	 * @author bbjxl 2013
	 */
	public class PowerBar extends MovieClip 
	{
		/*energy	int	剩余体力值
			maxEnergy	int	最大体力值
			regenTime	int	下次增加体力值剩余秒数
			*/
		private var _energy:int;
		private var _maxEnergy:int;
		private var _ratioText:TextField = new TextField();
		private var _ui:MovieClip;
		public function PowerBar(uiView:MovieClip) 
		{
			_ui = uiView;
			_ratioText = _ui.getChildByName("ratioText") as TextField;
			_ratioText.autoSize = TextFieldAutoSize.RIGHT;
			_ui.stop();
		}
		
		public function updata():void {
			
			_ratioText.text = _energy +"/" + _maxEnergy;
			var ratio:int = Math.floor(_energy / _maxEnergy*100);
			_ui.gotoAndStop(ratio);
			}
		
		public function get energy():int 
		{
			return _energy;
		}
		
		public function set energy(value:int):void 
		{
			_energy = value;
			updata();
		}
		
		public function get maxEnergy():int 
		{
			return _maxEnergy;
		}
		
		public function set maxEnergy(value:int):void 
		{
			_maxEnergy = value;
		}
		
	}

}