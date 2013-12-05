package project.view.module.defence
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.controller.AttackController;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTDomainManager;
	import project.debug.Debug;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.defence.DefenceModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.layout.BaseGridContainer;
	import project.view.module.attack.RaceIcoBar;
	import project.view.module.cell.Card;
	import project.view.module.DeckPane.AddDeckCell;
	import project.view.ui.MyScrollBar;
	import com.greensock.easing.*;
	import com.greensock.*;
	
	/**
	 * 编辑防线界面
	 * @author bbjxl 2012
	 */
	public class EditDefencePanel extends BaseTitleWindow
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _settledBt:MovieClipButton; //入驻按钮
		private var _cancelBt:MovieClipButton; //撤销按钮
		private var _deffendBt:MovieClipButton; //驻守按钮
		private var _armsContent:MovieClip; //兵卡容器
		
		/*
		   "人族" id="3"
		   "希腊神族" id="4"
		   "北欧神族" id="5"
		   "异界神族" id="6"
		
		 */
		private var _ico0:RaceIcoBar;
		private var _ico1:RaceIcoBar;
		private var _ico2:RaceIcoBar;
		private var _ico3:RaceIcoBar;
		
		private var _gridContainer:BaseGridContainer; //卡组英雄卡
		private var _armsCotainer:BaseGridContainer; //兵的容器
		private var _heroGrid:Sprite; //卡组英雄卡容器
		private var _scroll:MyScrollBar; //滚动条类
		//-----------------------数据---------------------------------
		private var _battleModel:int = 0; //战斗模式 1:1v1， 2:2v2， 3:3v3， 4:4v4
		private var _totalDeckHeroCardArr:Array; //所有的卡组英雄
		private var _crrentSelectedDeck:AddDeckCell; //当前选中的卡组
		private var _sixArms:Vector.<Card>; //六个兵
		private var _currentCreaDeckId:int = 0; //当前要创建的卡组ID
		private static const MAX_DECK:int = 20; //总共20个槽
		
		private var _currentSelectedHero:RaceIcoBar; //当前选中的已入驻种族图标槽
		private var _totalBar:Array; //所有可放入图标的槽
		private var _currentV:Array; //当前战斗模式对应的卡组数组
		
		private var playerData:PlayerData;
		//-----------------------事件--------------------------------
		
		private static var _instance:EditDefencePanel = null;
		
		public function EditDefencePanel()
		{
			if (_instance != null)
			{
				throw(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
			}
			setSpriteInstance("editDefencePanel");
			configerUIInstance();
			this.playerData = PlayerData.getInstance();
			this.playerData.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, this.onPlayerDataRefresh);//用户个人数据刷新之后触发
			//System.gc();
		}
		
		//--------------------------------------------------------
		/**
		 * 数据更新
		 * @param	e
		 */
		private function onPlayerDataRefresh(e:SMZTDataChangeEvent):void {
			if (e.dataType == "CreaCardGroupPanel") {
				updataUI();
				}
			
			}
		/**
		 * 入驻
		 */
		private function settledClickHandler(e:MouseEvent):void
		{
			_settledBt.clickEnable = false; //入驻按钮不可点
			var tempArr:Array = returnBarArrByBattleModel();
			if (judgestSetteled(tempArr))
			{
				//已经入驻
				return;
			}
			for (var i:String in tempArr)
			{
				if (tempArr[i].deckId == -1)
				{
					//如果有空槽则放入种族图标
					(tempArr[i] as RaceIcoBar).setIco(returnCurrentDeckHeroRaceFrame());
					tempArr[i].buttonMode = true;
					tempArr[i].addEventListener(MouseEvent.CLICK, raceIcoClickHandler);
					tempArr[i].deckId = _crrentSelectedDeck.deckId;
					
					//图标选中,撤销可点
					_currentSelectedHero = tempArr[i];
					_currentSelectedHero.selected(true);
					_cancelBt.clickEnable = true;
					
					setDefenceBtClickEnable();
					return;
				}
			}
		}
		
		/**
		 * 判断驻守是否可点
		 * @param	tempArr
		 * @return
		 */
		private function setDefenceBtClickEnable():void
		{
			var tempLen:int = 0;
			var tempArr:Array = returnBarArrByBattleModel();
			for (var i:String in tempArr)
			{
				if (tempArr[i].deckId != -1)
				{
					tempLen++;
				}
			}
			if (tempLen >= tempArr.length)
			{
				//全满出击按钮可点
				_deffendBt.clickEnable = true;
				
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.DEFFENCE]) {
					NewBieControler.getInstance().nextStep();
					}
				//--------------------end--------------------
			}
			else
			{
				_deffendBt.clickEnable = false;
			}
			tempArr = null;
		}
		
		/**
		 * 判断要入驻的卡组是否已经入驻,当前是否还有空的槽可以入驻
		 * @param	e
		 */
		private function judgestSetteled(tempArr:Array):Boolean
		{
			if (_crrentSelectedDeck == null)
				return true;
			
			var setteled:Boolean = false;
			var tempLen:int = 0;
			for (var i:String in tempArr)
			{
				if (tempArr[i].deckId == _crrentSelectedDeck.deckId)
				{
					setteled = true;
					return setteled;
				}
				if (tempArr[i].deckId != -1)
				{
					tempLen++;
				}
			}
			if (tempLen >= tempArr.length)
			{
				//全满
				return true;
			}
			return setteled;
		}
		
		/**
		 * 如果当前选中的卡组已经入驻则已入驻图标为选中状态
		 */
		private function setSettledStateBySelectedDeck():void
		{
			var tempArr:Array = returnBarArrByBattleModel();
			for (var i:String in tempArr)
			{
				if (tempArr[i].deckId == _crrentSelectedDeck.deckId)
				{
					_currentSelectedHero = tempArr[i];
					for (var j:String in _totalBar)
					{
						_totalBar[j].selected(false);
					}
					_cancelBt.clickEnable = true;
					_currentSelectedHero.selected(true);
					return;
				}
			}
			for (var n:String in tempArr)
			{
				tempArr[n].selected(false);
			}
			_currentSelectedHero = null;
			_cancelBt.clickEnable = false;
			
			tempArr = null;
		}
		
		/**
		 * 判断入驻按钮当前是否可点击
		 * @param	e
		 */
		private function settledBtClickEnable():void
		{
			var tempArr:Array = returnBarArrByBattleModel();
			if (judgestSetteled(tempArr))
			{
				_settledBt.clickEnable = false; //已入驻
			}
			else
			{
				_settledBt.clickEnable = true; //入驻可以点击
				
			}
			if (_crrentSelectedDeck.card==null) {
				_settledBt.clickEnable = false; //已入驻
				}
			tempArr = null;
		}
		
		private function raceIcoClickHandler(e:MouseEvent):void
		{
			if ((e.currentTarget as RaceIcoBar).deckId == -1)
			{
				//如果方框没有图标不能显示选中状态
				return;
			}
			for (var i:String in _totalBar)
			{
				_totalBar[i].selected(false);
			}
			_currentSelectedHero = e.currentTarget as RaceIcoBar;
			trace(_currentSelectedHero.deckId);
			setLocationByDeckId(_currentSelectedHero.deckId);
			_cancelBt.clickEnable = true;
			_currentSelectedHero.selected(true);
		}
		
		/**
		 * 根据卡组ID定位到相应的卡组
		 * @param 卡组ID
		 */
		private function setLocationByDeckId(param:int):void
		{
			for (var i:String in _totalDeckHeroCardArr)
			{
				if (_totalDeckHeroCardArr[i].deckId == param)
				{
					_crrentSelectedDeck = _totalDeckHeroCardArr[i];
					selectedDeck(null);
					_scroll.setLocationByRate(returnScorlLoc(Math.floor((_crrentSelectedDeck.deckId - 1) / 4)));
					return;
				}
			}
		}
		
		//根据行返回定位的比例
		private function returnScorlLoc(row:int = 0):Number
		{
			var loc:Array = [0, 0.2, 0.5, 0.8, 1.05];
			return loc[row];
		}
		
		/**
		 * 返回当前选择的卡组英雄种族对应的帧数
		 * @return
		 */
		private function returnCurrentDeckHeroRaceFrame():uint
		{
			return _crrentSelectedDeck.card.getCardModel().race;
		}
		
		/**
		 * 根据战斗模式返回相应的方框数组
		 * @param	e
		 */
		private function returnBarArrByBattleModel():Array
		{
			var tempArr:Array = new Array();
			switch (_battleModel)
			{
				case 1: 
					tempArr.push(_ico0);
					break;
				case 2: 
					tempArr.push(_ico0);
					tempArr.push(_ico1);
					break;
				case 3: 
					tempArr.push(_ico0);
					tempArr.push(_ico1);
					tempArr.push(_ico2);
					
					break;
				case 4: 
					tempArr.push(_ico0);
					tempArr.push(_ico1);
					tempArr.push(_ico2);
					tempArr.push(_ico3);
					break;
			}
			return tempArr;
		}
		
		/**
		 * 取消
		 */
		private function cancelClickHandler(e:MouseEvent):void
		{
			if (_currentSelectedHero == null)
				return;
			_currentSelectedHero.deckId = -1;
			_currentSelectedHero.selected(false);
			if (_currentSelectedHero.hasEventListener(MouseEvent.CLICK))
			{
				_currentSelectedHero.removeEventListener(MouseEvent.CLICK, selectedDeck);
			}
			
			_currentSelectedHero.buttonMode = false;
			_currentSelectedHero.removeEventListener(MouseEvent.CLICK, raceIcoClickHandler);
			
			_currentSelectedHero = null;
			_cancelBt.clickEnable = false;
			
			settledBtClickEnable();
			setDefenceBtClickEnable();
		
		}
		
		/**
		 * 驻守
		 */
		private function defenceClickHandler(e:MouseEvent):void
		{
			var tempArr:Array = returnBarArrByBattleModel();
			var defenceDeck:Array = new Array();
			for (var i:String in tempArr)
			{
				defenceDeck.push(tempArr[i].deckId);
			}
			switch (_battleModel)
			{
				case 1: 
					DefenceModel.getInstance().v1 = defenceDeck;
					break;
				case 2: 
					DefenceModel.getInstance().v2 = defenceDeck;
					break;
				case 3: 
					DefenceModel.getInstance().v3 = defenceDeck;
					break;
				case 4: 
					DefenceModel.getInstance().v4 = defenceDeck;
					break;
			}
			SMZTController.getInstance().setDefenceData(_battleModel, function():void
				{
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.DEFFENCE]) {
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
					
					hide();
					SMZTController.getInstance().getDefenceData(function():void
						{
						//DefencePanel.getInstance().show(true);
						})
				});
		}
		
		//--------------------------------------------------------
		override public function show(param1:Boolean = false):void
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
					TweenLite.to(this, 0.3, {alpha: 1, y: this.y + 40});
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
		} // end function
		
		//--------------------------------------------------------
		private function configerUIInstance():void
		{
			_armsContent = getChild("armsContent") as MovieClip;
			
			_settledBt = getChild("settledBt") as MovieClipButton;
			//_settledBt.clickEnable = false;//默认先不可点
			_settledBt.onClick = settledClickHandler;
			_cancelBt = getChild("cancelBt") as MovieClipButton;
			_cancelBt.onClick = cancelClickHandler;
			_cancelBt.clickEnable = false; //默认先不可点
			_deffendBt = getChild("deffendBt") as MovieClipButton;
			_deffendBt.clickEnable = false; //默认先不可点
			_deffendBt.onClick = defenceClickHandler;
			_ico0 = getChild("ico0") as RaceIcoBar;
			_ico1 = getChild("ico1") as RaceIcoBar;
			_ico2 = getChild("ico2") as RaceIcoBar;
			_ico3 = getChild("ico3") as RaceIcoBar;
			_totalBar = new Array();
			_totalBar.push(_ico0);
			_totalBar.push(_ico1);
			_totalBar.push(_ico2);
			_totalBar.push(_ico3);
			
			_crrentSelectedDeck = new AddDeckCell();
			_sixArms = new Vector.<Card>();
			_totalDeckHeroCardArr = new Array();
			//增加卡组英雄卡区
			var temprow:int = 5;
			
			this._gridContainer = new BaseGridContainer(temprow, 4, 2, 110, 154);
			this._gridContainer.setLocation(232, 51);
			_heroGrid = new Sprite();
			addChild(_heroGrid);
			_heroGrid.addChild(this._gridContainer);
			
			//兵
			_armsCotainer = new BaseGridContainer(1, 6, 15.5, ApplicationConfig.CARD_WIDTH / 2, ApplicationConfig.CARD_HEIGHT / 2);
			_armsCotainer.setLocation(48.8, 450)
			_armsContent.addChild(_armsCotainer);
			for (var i:uint = 0; i < 6; i++)
			{
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
		private function rollOverHandler(e:MouseEvent):void
		{
			(e.currentTarget as Card).selected = true;
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			(e.currentTarget as Card).selected = false;
		}
		
		//--------------------------------------------------------
		/**
		 * 根据战斗模式更新界面
		 * @param	bm 战斗模式
		 */
		public function initUIByBattleModel(bm:int):void
		{
			for (var i:String in _totalBar)
			{
				_totalBar[i].deckId = -1;
				_totalBar[i].selected(false);
				_totalBar[i].buttonMode = false;
				_totalBar[i].onlyShowBarBg();
				_totalBar[i].visible = false;
				if (_totalBar[i].hasEventListener(MouseEvent.CLICK))
				{
					_totalBar[i].removeEventListener(MouseEvent.CLICK, selectedDeck);
				}
			}
			_currentSelectedHero = null;
			_currentCreaDeckId = 0;
			_cancelBt.clickEnable = false;
			_deffendBt.clickEnable = false;
			
			_battleModel = bm;
			
			switch (bm)
			{
				case 1: 
					_ico0.visible = true;
					_ico0.x = 87.55;
					_ico0.y = 82.45;
					_currentV = DefenceModel.getInstance().v1;
					break;
				case 2: 
					_ico0.visible = true;
					_ico0.x = 33.55;
					_ico0.y = 155.95;
					_ico1.visible = true;
					_ico1.x = 142.55;
					_ico1.y = 155.95;
					_currentV = DefenceModel.getInstance().v2;
					break;
				case 3: 
					_ico0.visible = true;
					_ico1.visible = true;
					_ico2.visible = true;
					_ico0.x = 87.55;
					_ico0.y = 82.45;
					_ico1.x = 33.55;
					_ico1.y = 155.95;
					_ico2.x = 142.55;
					_ico2.y = 155.95;
					_currentV = DefenceModel.getInstance().v3;
					break;
				case 4: 
					_ico0.visible = true;
					_ico1.visible = true;
					_ico2.visible = true;
					_ico3.visible = true;
					_ico0.x = 35.55;
					_ico0.y = 101.95;
					_ico1.x = 140.55;
					_ico1.y = 101.95;
					_ico2.x = 35.55;
					_ico2.y = 179.45;
					_ico3.x = 140.55;
					_ico3.y = 179.45;
					_currentV = DefenceModel.getInstance().v4;
					break;
				default: 
					//trace("没有这个战斗模式！");
					break;
			}
			
			var tempArr:Array = returnBarArrByBattleModel();
			for (var n:String in _currentV)
			{
				if (_currentV[n].cards)
				{
					if (tempArr[n].deckId == -1)
					{
						(tempArr[n] as RaceIcoBar).setIco(_currentV[n].heroCard.race);
						tempArr[n].buttonMode = true;
						tempArr[n].addEventListener(MouseEvent.CLICK, raceIcoClickHandler);
						tempArr[n].deckId = _currentV[n].id;
					}
					
				}
			}
			_currentV = null;
			
			//updataUI();
			settledBtClickEnable();
			setSettledStateBySelectedDeck();
		}
		
		//--------------------------------------------------------
		//刷新UI
		private function updataUI():void
		{
			var playerData:PlayerData = PlayerData.getInstance();
			//清空之前的
			_gridContainer.removeAll();
			if (_totalDeckHeroCardArr.length > 0)
			{
				for (var j:String in _totalDeckHeroCardArr)
				{
					(_totalDeckHeroCardArr[j] as AddDeckCell).card.disposeBM();
					(_totalDeckHeroCardArr[j] as AddDeckCell).card.dispose();
					if ((_totalDeckHeroCardArr[j] as AddDeckCell).hasEventListener(MouseEvent.CLICK))
					{
						(_totalDeckHeroCardArr[j] as AddDeckCell).removeEventListener(MouseEvent.CLICK, selectedDeck);
					}
				}
			}
			_totalDeckHeroCardArr = new Array();
			
			for (var i:uint = 0; i < MAX_DECK; i++)
			{
				var tempCell:AddDeckCell = new AddDeckCell();
				tempCell.deckId = playerData.decks[i].id;
				tempCell.cards = playerData.decks[i].cards;
				tempCell.locked = 0; //不显示加锁图标
				if (tempCell.cards)
				{
					tempCell.addCard();
					_totalDeckHeroCardArr.push(tempCell);
					tempCell.buttonMode = true;
					tempCell.addEventListener(MouseEvent.CLICK, selectedDeck);
					tempCell.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickDeck);
				}
				_gridContainer.appendChild(tempCell);
				tempCell = null;
			}
			
			//增加滚动条控制
			if (!_scroll)
			{
				var offerX:Number = 0;
				if (_gridContainer.width > 447)
				{
					//表示最右边有卡，（大卡的宽度算上了）
					////trace("_gridContainer.width=" + _gridContainer.width);
					////trace("getBounds.width=" + this.getBounds(_gridContainer).width);
					offerX = -82;
				}
				else
				{
					offerX = 5;
				}
				_scroll = new MyScrollBar(_gridContainer, "R", offerX, -27, "L", 1, 15, true, true, _gridContainer.width, 310, 176, Reflection.getClass("ScroStrye", SMZTDomainManager.getInstance().currentUIAppDomain));
				_scroll.x = 0;
				_scroll.y = 46;
				addChild(_scroll)
			}
			
			//如果有卡组，默认选择第一个卡组
			if (_totalDeckHeroCardArr.length > 0)
			{
				_crrentSelectedDeck = _totalDeckHeroCardArr[0];
				selectedDeck(null);
				_armsCotainer.visible = true;
			}
			else
			{
				currentCreaDeckId = 0;
				_armsCotainer.visible = false; //隐藏下面的六张图
			}
		}
		
		//--------------------------------------------------------
		/**
		 * 双击卡组入驻
		 * @param	e
		 */
		private function doubleClickDeck(e:MouseEvent):void
		{
			_crrentSelectedDeck = e.currentTarget as AddDeckCell;
			settledClickHandler(null);
		}
		
		//选择卡组时，对应的显示他们所带的兵
		private function selectedDeck(e:MouseEvent):void
		{
			
			if (e)
			{
				if (_crrentSelectedDeck)
				{
					if (_crrentSelectedDeck != (e.currentTarget as AddDeckCell))
					{
						//当前点击不是之前的英雄
						_crrentSelectedDeck = (e.currentTarget as AddDeckCell);
						//判断要入驻的卡组是否已经入驻
						settledBtClickEnable();
						setSettledStateBySelectedDeck();
					}else {
						return;
						}
				}
			}
			resetHeroCardSelectState();
			
			_crrentSelectedDeck.card.selected = true;
			for (var i:String in _crrentSelectedDeck.arms)
			{
				_sixArms[i].setCardModel(_crrentSelectedDeck.arms[i]);
			}
			
			_currentCreaDeckId = _crrentSelectedDeck.deckId;
		}
		
		//所有英雄卡未选中状态
		private function resetHeroCardSelectState():void
		{
			for (var i:String in _totalDeckHeroCardArr)
			{
				_totalDeckHeroCardArr[i].card.selected = false;
			}
		}
		
		//--------------------------------------------------------
		
		public function get currentCreaDeckId():int
		{
			return _currentCreaDeckId;
		} // end function
		
		public function set currentCreaDeckId(param1:int):void
		{
			_currentCreaDeckId = param1;
			return;
		} // end function
		
		public function get battleModel():int
		{
			return _battleModel;
		} // end function
		
		public function set battleModel(param1:int):void
		{
			_battleModel = param1;
			return;
		} // end function
		
		//--------------------------------------------------------
		public static function getInstance():EditDefencePanel
		{
			if (_instance == null)
			{
				_instance = new EditDefencePanel;
			}
			return _instance;
		} // end function
	}

}