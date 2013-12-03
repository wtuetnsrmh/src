package project.view.module.scene.crystalHole 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import project.controller.SMZTController;
	import project.model.crystalHole.CrystalHoleModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.events.SMZTDataChangeEvent;
	/**
	 * 控制栏
	 * @author bbjxl 2013
	 */
	public class ControlBar extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _noText:TextField;
		private var _inputNoText:TextField;
		private var _preBt:MovieClipButton;
		private var _nextBt:MovieClipButton;
		private var _skipBt:MovieClipButton;
		private var _myMineBt:MovieClipButton;
		private var _ruleBt:MovieClipButton;
		//-----------------------数据---------------------------------
		private var _currentPage:int = 1;
		private var _crystalModel:CrystalHoleModel;
		//-----------------------事件--------------------------------
		
		public function ControlBar() 
		{
			_crystalModel = CrystalHoleModel.getInstance();
			dataModel = _crystalModel;
			_crystalModel.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onDataChange);
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			_noText.text = _crystalModel.page.toString();
			_inputNoText.text = _crystalModel.page.toString();
			if (_crystalModel.page==1) {
				_preBt.clickEnable = false;
				}else {
					_preBt.clickEnable = true;
					}
			if (_crystalModel.page==_crystalModel.maxPage) {
				_nextBt.clickEnable = false;
				}else {
					_nextBt.clickEnable = true;
					}
		} // end function
		
		public function setspriteInstance(param1:*):void
		{
			this._spriteInstance = param1;// SMZTResourceManager.getInstance().getRes(param1, SMZTDomainManager.getInstance().currentUIAppDomain) as Sprite;
			addChild(_spriteInstance);
			
			_noText = getChild("noText") as TextField;
			_inputNoText = getChild("inputNoText") as TextField;
			_inputNoText.maxChars = 1;
			_inputNoText.restrict = "0-9";
			_inputNoText.addEventListener(TextEvent.TEXT_INPUT, inputHandler);
			_preBt = getChild("preBt") as MovieClipButton;
			_nextBt = getChild("nextBt") as MovieClipButton;
			_skipBt = getChild("skipBt") as MovieClipButton;
			_myMineBt = getChild("myMineBt") as MovieClipButton;
			_ruleBt = getChild("ruleBt") as MovieClipButton;
			
			_preBt.onClick = clickHandler;
			_nextBt.onClick = clickHandler;
			_skipBt.onClick = clickHandler;
			_myMineBt.onClick = clickHandler;
			_ruleBt.onClick = clickHandler;
		}
		
		private function inputHandler(e:TextEvent):void 
		{
			if (int(_inputNoText.text) <= 0) {
				_inputNoText.text = "1";
				_preBt.clickEnable = false;
				}else {
					_preBt.clickEnable = true;
					}
			if (int(_inputNoText.text) > _crystalModel.maxPage) {
				_inputNoText.text = String(_crystalModel.maxPage);
				_nextBt.clickEnable = false;
				}else {
					_nextBt.clickEnable = true;
					}
			_inputNoText.setSelection(0, _inputNoText.length);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _ruleBt:
					HoleRuleWin.getInstance().show(true);
					break;
				case _preBt:
					skipAreaById(int(_inputNoText.text) - 1);
					break;
				case _nextBt:
					skipAreaById(int(_inputNoText.text) + 1);
					break;
				case _skipBt:
					if (int(_inputNoText.text) == 0) {
						_inputNoText.text = "1";
						}
					if (int(_inputNoText.text) > _crystalModel.maxPage) {
						_inputNoText.text = String(_crystalModel.maxPage);
						}
					skipAreaById(int(_inputNoText.text));
					break;
				case _myMineBt:
					SMZTController.getInstance().getMyMine(function(param:Object):void {
						if(CrystalHoleModel.getInstance().myMines.length>0){
							skipAreaById(Math.ceil(CrystalHoleModel.getInstance().myMines[0].id/CrystalHoleScene._minesNum),false);//跳转到我的第一矿体所在区
							}
						})
					break;
				}
		}
		
		/**
		 * 跳转到指定的区域
		 */
		private function skipAreaById(id:int,refreshMyMines:Boolean=true):void {
			SMZTController.getInstance().getAreaMines(id, function(param:Object):void {
				CrystalHoleModel.getInstance().updataAreaData(param);
				if (refreshMyMines && CrystalHoleModel.getInstance().existMyMienInCurrentArea()) {
					//所在的区域有我的矿体且要求刷新我的矿体信息
					SMZTController.getInstance().getMyMine();
					}
				} );
			}
	}

}