package project.view.module.defence 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.core.SMZTUIManager;
	import project.debug.myDebug;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.DeckModel;
	import project.model.data.PlayerData;
	import project.model.defence.DefenceModel;
	import project.model.item.CardModel;
	import project.model.newBie.NewBieModelId;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.layout.BaseGridContainer;
	import project.view.module.attack.RaceIcoBar;
	import project.view.module.cell.Card;
	import project.view.module.DeckPane.AddDeckCell;
	import com.greensock.core.*;
	import com.greensock.easing.*;
	import com.greensock.*;
	import project.view.module.DeckPane.CreaCardGroupPane;
	/**
	 * 防御设置界面
	 * @author bbjxl 2012
	 */
	public class DefencePanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _v1:RaceIcoBar;
		private var _v2_0:RaceIcoBar;
		private var _v2_1:RaceIcoBar;
		private var _v3_0:RaceIcoBar;
		private var _v3_1:RaceIcoBar;
		private var _v3_2:RaceIcoBar;
		private var _v4_0:RaceIcoBar;
		private var _v4_1:RaceIcoBar;
		private var _v4_2:RaceIcoBar;
		private var _v4_3:RaceIcoBar;
		
		private var _editDefenceBt1:MovieClipButton;
		private var _editDefenceBt2:MovieClipButton;
		private var _editDefenceBt3:MovieClipButton;
		private var _editDefenceBt4:MovieClipButton;
		private var _editDeckBt:MovieClipButton;
		private var _armsCotainer:BaseGridContainer;//兵的容器
		private var _armsContent:MovieClip;//兵卡容器
		private var _totalBar:Array;//所有可放入图标的槽
		
		//-----------------------数据---------------------------------
		private var _defenceModel:DefenceModel;
		private var _currentSelctedIco:RaceIcoBar;//当前选中的种族图标
		private var _currentSelectedDeckModel:DeckModel;//当前选中的卡组模型
		private var _currentSelectedDeckHeroCard:Card;//当前选择的卡组英雄卡显示
		private var _sixArms:Vector.<Card>;//六个兵
		//-----------------------事件--------------------------------
		
		private static var _defencePanel:DefencePanel;
		
		public function DefencePanel() 
		{
			if (_defencePanel != null) {
				throw(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			setSpriteInstance("defencePanel");
			configerUIInstance();
			
			_defenceModel = DefenceModel.getInstance();
            dataModel = _defenceModel;
			PlayerData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, onPlayerDataRefresh);//用户个人数据刷新之后触发
		}
		//--------------------------------------------------------
		private function configerUIInstance():void {
			_armsContent = getChild("armsContent") as MovieClip;
			_currentSelectedDeckHeroCard = new Card();
			_currentSelectedDeckHeroCard._currentCardTye = 1;
			_currentSelectedDeckHeroCard.x = 71;
			_currentSelectedDeckHeroCard.y = 161;
			_currentSelectedDeckHeroCard.hideAll();
			addChild(_currentSelectedDeckHeroCard);
			_editDefenceBt1= getChild("editDefenceBt1") as MovieClipButton;
			_editDefenceBt2= getChild("editDefenceBt2") as MovieClipButton;
			_editDefenceBt3= getChild("editDefenceBt3") as MovieClipButton;
			_editDefenceBt4 = getChild("editDefenceBt4") as MovieClipButton;
			_editDefenceBt1.onClick = editDefenceClick;
			_editDefenceBt2.onClick = editDefenceClick;
			_editDefenceBt3.onClick = editDefenceClick;
			_editDefenceBt4.onClick = editDefenceClick;
			_editDeckBt = getChild("editDeckBt") as MovieClipButton;
			_editDeckBt.onClick = editDefenceClick;
			
			_v1 = getChild("v1") as RaceIcoBar;
			_v2_0 = getChild("v2_1") as RaceIcoBar;
			_v2_1 = getChild("v2_2") as RaceIcoBar;
			_v3_0 = getChild("v3_1") as RaceIcoBar;
			_v3_1 = getChild("v3_2") as RaceIcoBar;
			_v3_2 = getChild("v3_3") as RaceIcoBar;
			_v4_0 = getChild("v4_1") as RaceIcoBar;
			_v4_1 = getChild("v4_2") as RaceIcoBar;
			_v4_2 = getChild("v4_3") as RaceIcoBar;
			_v4_3 = getChild("v4_4") as RaceIcoBar;
			_totalBar = new Array();
			_totalBar.push(_v1,_v2_0,_v2_1,_v3_0,_v3_1,_v3_2,_v4_0,_v4_1,_v4_2,_v4_3);
			
			//兵
			_armsCotainer = new BaseGridContainer(1, 6, 15.5, ApplicationConfig.CARD_WIDTH / 2, ApplicationConfig.CARD_HEIGHT / 2);
			_armsCotainer.setLocation(48.8, 450)
			_armsContent.addChild(_armsCotainer);
			_sixArms = new Vector.<Card>();
			for (var i:uint = 0; i < 6; i++ ) {
				var tempArm:Card = new Card();
				tempArm.showTip = true;
				tempArm._currentCardTye = 1;
				tempArm.hideAll();
				tempArm.showMask();
				
				tempArm.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				tempArm.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				_armsCotainer.appendChild(tempArm);
				_sixArms.push(tempArm);
				}
			}
		//--------------------------------------------------------	
		/**
		 * 编辑防线点击
		 * @param	e
		 */
		private function editDefenceClick(e:MouseEvent):void {
			switch(e.currentTarget) {
				case _editDefenceBt1:
					EditDefencePanel.getInstance().show(true);
					EditDefencePanel.getInstance().initUIByBattleModel(1);
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.DEFFENCE]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
					break;
				case _editDefenceBt2:
					EditDefencePanel.getInstance().show(true);
					EditDefencePanel.getInstance().initUIByBattleModel(2);
					break;
				case _editDefenceBt3:
					EditDefencePanel.getInstance().show(true);
					EditDefencePanel.getInstance().initUIByBattleModel(3);
					break;
				case _editDefenceBt4:
					EditDefencePanel.getInstance().show(true);
					EditDefencePanel.getInstance().initUIByBattleModel(4);
					break;
				case _editDeckBt:
					SMZTUIManager.getInstance().editDeckPandl.oldDeckSoldiers = _currentSelectedDeckModel.soldierCard.concat(_currentSelectedDeckModel.talismanCard, _currentSelectedDeckModel.mitacCard);
					SMZTUIManager.getInstance().editDeckPandl.deckId = _currentSelectedDeckModel.id;
					SMZTUIManager.getInstance().editDeckPandl.show(true);
					break;
				default:
					myDebug.Console("ERROR:编辑防线点击");
					break;
				}
			}

		
		/**
		 * 种族图标点击
		 * @param	e
		 */
		private function raceIcoClickHandler(e:MouseEvent):void {
			if ((e.currentTarget as RaceIcoBar).deckId == -1) {
				//如果方框没有图标不能显示选中状态
				return;
				}
			
			if (_currentSelctedIco != (e.currentTarget as RaceIcoBar)) {
				_currentSelctedIco = (e.currentTarget as RaceIcoBar);
				}else {
					//重复点击
					return;
					}
			for (var i:String in _totalBar) {
				_totalBar[i].selected(false);
				}
			_currentSelctedIco.selected(true);
			_currentSelectedDeckModel = _defenceModel.findDeckModelByDeckId((e.currentTarget as RaceIcoBar).deckId);
			_currentSelectedDeckHeroCard.setCardModel(_currentSelectedDeckModel.heroCard);
			var arms:Vector.<CardModel> = _currentSelectedDeckModel.soldierCard.concat(_currentSelectedDeckModel.talismanCard, _currentSelectedDeckModel.mitacCard);
			for (var j:String in arms) {
				_sixArms[j].setCardModel(arms[j]);
				}
			arms = null;
			}
			
		
		//--------------------------------------------------------
		/**
		 * 所有的种族图标未嵌入状态
		 * @param	event
		 */
		private function resetTotalRaceIco():void {
			for (var i:String in _totalBar) {
				_totalBar[i].onlyShowBarBg();
				_totalBar[i].buttonMode = false;
				_totalBar[i].selected(false);
				_totalBar[i].removeEventListener(MouseEvent.CLICK, raceIcoClickHandler);
				}
			}
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - 748) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - 630.1) / 2 - 40;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
            }
            this.playShowSound();
            return;
        }// end function
		
		/**
		 * 数据更新
		 * @param	e
		 */
		private function onPlayerDataRefresh(e:SMZTDataChangeEvent):void {
			if (e.dataType == CreaCardGroupPane.CLASS_NAME) {
				onDataChange(null);
				}
			
			}
		
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			var findFlag:Boolean = false;//是否找到第一个种族图标
			resetTotalRaceIco();
			_currentSelectedDeckModel = _defenceModel.findFirstDeckFromDefences();
			_editDeckBt.clickEnable = (_currentSelectedDeckModel==null)?false:true;//编辑卡组是否可点
			if (_editDeckBt.clickEnable) {
				var i:String;
				for (i in _defenceModel.v1) {
					if (_defenceModel.v1[i].cards) {
						_v1.setIco(_defenceModel.v1[i].heroCard.race);
						_v1.deckId = _defenceModel.v1[i].id;
						_v1.buttonMode = true;
						_v1.addEventListener(MouseEvent.CLICK, raceIcoClickHandler);
						if (!findFlag && _defenceModel.v1[i].id == _currentSelectedDeckModel.id) {
							_currentSelctedIco = _v1;
							findFlag = true;
							}
						}
					}
				for (i in _defenceModel.v2) {
					if (_defenceModel.v2[i].cards) {
						this["_v2_"+i].setIco(_defenceModel.v2[i].heroCard.race);
						this["_v2_" + i].deckId = _defenceModel.v2[i].id;
						this["_v2_" + i].buttonMode = true;
						this["_v2_" + i].addEventListener(MouseEvent.CLICK, raceIcoClickHandler);
						if (!findFlag && _defenceModel.v2[i].id == _currentSelectedDeckModel.id) {
							_currentSelctedIco = this["_v2_" + i];
							findFlag = true;
							}
						}
					}
				for (i in _defenceModel.v3) {
					if (_defenceModel.v3[i].cards) {
						this["_v3_" + i].setIco(_defenceModel.v3[i].heroCard.race);
						this["_v3_" + i].deckId = _defenceModel.v3[i].id;
						this["_v3_" + i].buttonMode = true;
						this["_v3_" + i].addEventListener(MouseEvent.CLICK, raceIcoClickHandler);
						if (!findFlag && _defenceModel.v3[i].id == _currentSelectedDeckModel.id) {
							_currentSelctedIco = this["_v3_" + i];
							findFlag = true;
							}
						}
					}
				for (i in _defenceModel.v4) {
					if (_defenceModel.v4[i].cards) {
						this["_v4_" + i].setIco(_defenceModel.v4[i].heroCard.race);
						this["_v4_" + i].deckId = _defenceModel.v4[i].id;
						this["_v4_" + i].buttonMode = true;
						this["_v4_" + i].addEventListener(MouseEvent.CLICK, raceIcoClickHandler);
						if (!findFlag && _defenceModel.v4[i].id == _currentSelectedDeckModel.id) {
							_currentSelctedIco = this["_v4_" + i];
							findFlag = true;
							}
						}
					}
					
				_currentSelectedDeckHeroCard.setCardModel(_currentSelectedDeckModel.heroCard);
				_currentSelctedIco.selected(true);
				var arms:Vector.<CardModel> = _currentSelectedDeckModel.soldierCard.concat(_currentSelectedDeckModel.talismanCard, _currentSelectedDeckModel.mitacCard);
				for (var j:String in arms) {
					_sixArms[j].setCardModel(arms[j]);
					}
				arms = null;
				}else {
					//没有一个卡组时
					_currentSelectedDeckHeroCard.hideAll();
					for (var n:String in _sixArms) {
						_sixArms[n].hideAll();
						}
					}
            return;
        }// end function
		
		//--------------------------------------------------------
		private function rollOverHandler(e:MouseEvent):void {
			(e.currentTarget as Card).selected = true;
			}
		private function rollOutHandler(e:MouseEvent):void {
			(e.currentTarget as Card).selected = false;
			}
		//--------------------------------------------------------
		public static function getInstance() : DefencePanel
		{
			if (_defencePanel == null)
			{
			  _defencePanel = new DefencePanel;
			}
			return _defencePanel; 
		}// end function
	}

}