package project.view.module.scene.training
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.NewBieControler;
	import project.core.SMZTUIManager;
	import project.model.item.CardModel;
	import project.model.newBie.NewBieModelId;
	import project.model.training.TrainingModel;
	import project.model.training.TrainingSlotModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSprite;
	import project.view.base.BaseSpritePane;
	import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.cell.Card;
	
	/**
	 * ...
	 * @author bbjxl 2012
	 */
	public class TrainingSlotPanel extends BaseSpritePane
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _headImage:BaseIcoCellLoader;
		private var _levelText:TextField;
		private var _nameText:TextField;
		private var _challengeBt:MovieClipButton; //挑战
		private var _visitBt:MovieClipButton;
		private var _nextBt:MovieClipButton;
		private var _preBt:MovieClipButton;
		private var _NVN:MovieClip;
		private var _heroes:Card; //英雄卡
		//-----------------------数据---------------------------------
		private var _currentHeroId:int = 0;
		private var _model:TrainingSlotModel;
		
		//-----------------------事件--------------------------------
		public function TrainingSlotPanel()
		{
			setSpriteInstance("TrainingSlotPanel");
			configerUIInstance();
		
		}
		
		public function updataUI(param:TrainingSlotModel):void
		{
			_currentHeroId = 0;
			_model = param;
			_headImage.ico = param.user.avatar;
			_levelText.text = String(param.user.level);
			_nameText.text = String(param.user.nick);
			updataHero();
			
		}
		
		private function updataHero():void
		{
			
			if (_currentHeroId == 0)
			{
				_preBt.clickEnable = false;
			}else {
				_preBt.clickEnable = true;
				}
			if (_currentHeroId >= _model.heroes.length - 1)
			{
				_nextBt.clickEnable = false;
			}else {
				_nextBt.clickEnable = true;
				}
				
				
			if (_model.heroes.length == 0) {
				return;
				}
			var tempCardModel:CardModel = new CardModel(_model.heroes[_currentHeroId]);
			_heroes.setCardModel(tempCardModel);
			tempCardModel = null;
		}
		
		private function configerUIInstance():void
		{
			_NVN = getChild("NVN") as MovieClip;
			_NVN.stop();
			
			_headImage = new BaseIcoCellLoader();
			_headImage.restrictHW = 63;
			addChild(_headImage);
			_headImage.setLocation(143, 51);
			
			_heroes = new Card();
			addChild(_heroes);
			_heroes.setLocation(21.25, 43.5);
			
			_levelText = getChild("levelText") as TextField;
			_nameText = getChild("nameText") as TextField;
			_challengeBt = getChild("challengeBt") as MovieClipButton;
			_nextBt = getChild("nextBt") as MovieClipButton;
			_preBt = getChild("preBt") as MovieClipButton;
			_visitBt = getChild("visitBt") as MovieClipButton;
			_nextBt.onClick = ClickHandler;
			_preBt.onClick = ClickHandler;
			_visitBt.onClick = ClickHandler;
			_challengeBt.onClick = ClickHandler;
		}
		
		private function ClickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case _preBt: 
					if (_currentHeroId > 0)
					{
						_currentHeroId--;
					}
					updataHero();
					break;
				case _nextBt:
					if (_currentHeroId < (_model.heroes.length-1))
					{
						_currentHeroId++;
					}
					updataHero();
					break;
				case _visitBt:
					Browser.visiteInfo(_model.user.snsName);
					break;
				case _challengeBt:
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.TRAINING]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
					
					if (TrainingModel.getInstance().left > 0) {
						SMZTUIManager.getInstance().trainingScene.userId = _model.user.userId;
						BattleReadyPanel.getInstance().show(true);
						BattleReadyPanel.getInstance().initUIByBattleModel(_NVN.currentFrame, BattleReadyPanel.TRAINING_TYPE, true, returnCurrentDeckHeroRaces());
						}else {
							AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.TrainingScene.NoSessionTip.@Text);
							AlertConfirmPane.getInstance().type = 3;
							}
					
					break;
			
			}
			
		}
		
		/**
		 * 返回当前挑战对手的卡组英雄种族数组
		 * @param	param
		 */
		private function returnCurrentDeckHeroRaces():Array {
			var tempCardModel:CardModel;
			var returnArr:Array = new Array();
			for (var i:String in _model.heroes) {
				tempCardModel = new CardModel(_model.heroes[i]);
				returnArr.push(tempCardModel.race);
				tempCardModel = null;
				}
			return returnArr;
			}
		
		public function setNVN(param:int = 0):void
		{
			_NVN.gotoAndStop(param + 1);
		}
	
	}

}