package project.view.module.DeckPane 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.model.data.DeckModel;
	import project.model.data.PlayerData;
	import project.model.editDeck.EditDeckModel;
	import project.model.item.CardModel;
	import project.model.newBie.NewBieModelId;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import project.view.common.ControlPage;
	import project.view.layout.BaseGridContainer;
	import project.view.module.cell.Card;
	/**
	 * 队伍设置界面－种族选择界面
	 * @author bbjxl 2012
	 */
	public class SelecteRacePanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _deckCotainer:BaseGridContainer;
		
		private var _deckArr:Array;//四个卡框
		//-----------------------UI---------------------------------
		private var _okBt:MovieClipButton;//确认按钮
		private var _bt0:MovieClipButton;//北欧选项
		private var _bt1:MovieClipButton;//希腊按钮
		private var _bt2:MovieClipButton;//人类按钮
		private var _bt3:MovieClipButton;//其他按钮
		
		private var _num0:TextField;//英雄数量
		private var _num1:TextField;//英雄数量
		private var _num2:TextField;//英雄数量
		private var _num3:TextField;//英雄数量
		
		
		private var _controlPage:ControlPage;//上下页控制组件
		//-----------------------数据---------------------------------
		private var _playData:PlayerData;
		
		private var _heroData1:Vector.<CardModel>;//所有人类英雄
		private var _heroData2:Vector.<CardModel>;//所有希腊英雄
		private var _heroData3:Vector.<CardModel>;//所有北欧英雄
		private var _heroData4:Vector.<CardModel>;//所有其他英雄
		
		private var _currentCardId:int = 0;//所选的英雄卡ID
		private var _currentCreaDeckId:int = 0;//当前所选的卡组ID
		//-----------------------事件--------------------------------
		
		private static var _instance:SelecteRacePanel;
		
		public function SelecteRacePanel() 
		{
			
			if (_instance != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("selecteRacePanel");
			configerUIInstance();
			_playData = PlayerData.getInstance();
			
			_controlPage = new ControlPage();
			_controlPage.setLocation(225.6, 546);
			_spriteInstance.addChild(_controlPage);
		}
		
		private function configerUIInstance():void {
			_num1 = getChild("num1") as TextField;
			_num2 = getChild("num2") as TextField;
			_num3 = getChild("num3") as TextField;
			_num0 = getChild("num0") as TextField;
			
			_okBt = getChild("okBt") as MovieClipButton;
			_bt0 = getChild("bt0") as MovieClipButton;
			_bt1 = getChild("bt1") as MovieClipButton;
			_bt2 = getChild("bt2") as MovieClipButton;
			_bt3 = getChild("bt3") as MovieClipButton;
			
			//建四个英雄框
			_deckArr = new Array();
			_deckCotainer = new BaseGridContainer(1, 4, 27.1, ApplicationConfig.CARD_WIDTH / 2, ApplicationConfig.CARD_HEIGHT / 2);
			_deckCotainer.setLocation(49.1, 386);
			addChild(_deckCotainer);
			for (var i:uint = 0; i < 4; i++ ) {
				var tempArm:Card = new Card();
				tempArm.showTip = true;
				tempArm.addEventListener(MouseEvent.CLICK, clickCardHandler);
				tempArm.visible = false;//默认隐藏
				_deckCotainer.appendChild(tempArm);
				_deckArr.push(tempArm);
				}
			
			_okBt.onClick = onClickHandler;
			_bt0.onClick = onClickHandler;
			_bt1.onClick = onClickHandler;
			_bt2.onClick = onClickHandler;
			_bt3.onClick = onClickHandler;
			/*_bt0.clickEnable = true;
			_bt1.clickEnable = true;
			_bt2.clickEnable = true;
			_bt3.clickEnable = true;*/
			
			}
			
		//鼠标选中所点的卡
		private function clickCardHandler(e:MouseEvent):void {
			resetTotalCardState();
			(e.currentTarget as Card).selected = true;
			currentCardId = (e.currentTarget as Card).cardId;
			
			//-------------------新手引导用-----------------------
			if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
				NewBieControler.getInstance().nextStep();
				}
			//--------------------end--------------------
			}
		//还原四张卡为未选中状态
		private function resetTotalCardState():void {
			for (var i:String in _deckArr) {
				_deckArr[i].selected = false;
				}
			}
		//--------------------------------------------------------
		/**
		 * 初始设置种族选项状态
		 */
		private function initSelecteBtState():void {
			//数量为0
			_num0.text = "";
			_num1.text = "";
			_num2.text = "";
			_num3.text = "";
			
			currentCardId = 0;
			
			//从数量不为0的英雄卡中按种族返回相应的卡
			_heroData1 = PlayerData.retunCardsByRace(1, PlayerData.removeCannotUseCard(_playData.HeroCards));
			_heroData2 = PlayerData.retunCardsByRace(2, PlayerData.removeCannotUseCard(_playData.HeroCards));
			_heroData3 = PlayerData.retunCardsByRace(3, PlayerData.removeCannotUseCard(_playData.HeroCards));
			_heroData4 = PlayerData.retunCardsByRace(4, PlayerData.removeCannotUseCard(_playData.HeroCards));
			_bt2.clickEnable = (_heroData1.length > 0)?true:false;//如果所选种族选项没有英雄卡则为灰不可点
			_bt1.clickEnable = (_heroData2.length > 0)?true:false;
			_bt0.clickEnable = (_heroData3.length > 0)?true:false;
			_bt3.clickEnable = (_heroData4.length > 0)?true:false;
			
			resetTotalOptionNoSelected();
			
			for (var i:String in _deckArr) {
				_deckArr[i].visible = false;
				}
			}
		//-------------------还原所有的种族选项为未选中状态-------------------------------------
		private function resetTotalOptionNoSelected():void {
			currentCardId = 0;
			
			_bt0.setSelected(false);
			_bt1.setSelected(false);
			_bt2.setSelected(false);
			_bt3.setSelected(false);
			}
		
		//--------------------------------------------------------
		private function onClickHandler(e:MouseEvent):void {
			
			switch (e.currentTarget) 
			{
				case _okBt:
					////trace("确认显示第三个界面");
					this.hide();
					
					EditDeckPanel.getInstance().deckId = currentCreaDeckId;
					EditDeckPanel.getInstance().show(true);
					
					
				break;
				case _bt0:
				//北欧
					//trace("北欧")
					resetTotalOptionNoSelected();
					_bt0.setSelected(true);
					_controlPage.starCompute(_heroData3, updataUI);
					break;
				case _bt1:
					//希腊
					resetTotalOptionNoSelected();
					_bt1.setSelected(true);
					_controlPage.starCompute(_heroData2, updataUI);
					break;
				case _bt2:
					//人类
					resetTotalOptionNoSelected();
					_bt2.setSelected(true);
					_controlPage.starCompute(_heroData1, updataUI);
					break;
				case _bt3:
					//其他
					resetTotalOptionNoSelected();
					_bt3.setSelected(true);
					_controlPage.starCompute(_heroData4, updataUI);
					break;
				default:
					break;
			}
		}
		
		//--------------------------------------------------------
		//--------------------------------------------------------
		/**
		 * 更新界面
		 * @param	param1
		 */
		private function updataUI(arg:Vector.<CardModel>):void {
			currentCardId = 0;
			
			for (var i:String in arg) {
				if (arg[i] != null) {
					_deckArr[i].visible = true;
					(_deckArr[i] as Card).setCardModel(arg[i]);
					(_deckArr[i] as Card).showMiddleImage(true);//重新加载图片
					this["_num" + i].text = String(arg[i].number) + EditDeckPanel.CANUSER;
					
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET] && !NewBieControler.getInstance()._newBieSelecteRace) {
						NewBieControler.getInstance()._newBieSelecteRace = true;
						NewBieControler.getInstance().nextStep();
						}
					//--------------------end--------------------
					
					}else {
						this["_num" + i].text = "";
						_deckArr[i].visible = false;
						}
				}
			}
			
		//--------------------------------------------------------	
		/**
		 * 显示的时候刷新数据
		 * @param	param1
		 */
		override public function show(param1:Boolean = false) : void
        {
			initSelecteBtState();
			//_controlPage.starCompute(PlayerData.retunCardsByRace(3, _playData.HeroCards), updataUI);//默认选第一个北欧
			
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
                this.x = (ApplicationConfig.STAGE_WIDTH - _spriteInstance.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
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
		//--------------------------------------------------------
		public function get currentCreaDeckId() : int
		 {
		   return _currentCreaDeckId;
		}// end function
		
		public function set currentCreaDeckId(param1:int) : void
		{
		  _currentCreaDeckId= param1;
		  return;
		}// end function
		public function get currentCardId() : int
		 {
		   return _currentCardId;
		}// end function
		
		public function set currentCardId(param1:int) : void
		{
		  _currentCardId = param1;
		  if (_currentCardId == 0) {
			  _okBt.visible = false;
			  }else {
				  _okBt.visible = true;
				  }
		  return;
		}// end function
		//--------------------------------------------------------	
		
		public static function getInstance() : SelecteRacePanel
        {
            if (_instance == null)
            {
                _instance = new SelecteRacePanel();
            }
            return _instance;
        }// end function
	}

}