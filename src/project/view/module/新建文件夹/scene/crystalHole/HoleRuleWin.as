package project.view.module.scene.crystalHole 
{
	import project.config.ErrorZhCn;
	import project.view.base.BaseTitleWindow;
	
	/**
	 * 矿洞说明弹窗
	 * @author bbjxl 2013
	 */
	public class HoleRuleWin extends BaseTitleWindow 
	{
		private static var _holeRuleWin:HoleRuleWin;
		public function HoleRuleWin() 
		{
			if (_holeRuleWin != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			setSpriteInstance("holeRuleWinUI");
		}
		
		public static function getInstance() : HoleRuleWin
		{
			if (_holeRuleWin == null)
			{
			  _holeRuleWin = new HoleRuleWin;
			}
			return _holeRuleWin; 
		}// end function
		
	}

}