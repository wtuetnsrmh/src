package project.view.module.scene.cultivation 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.cultivation.CultivationModel;
	import project.model.cultivation.MixExpressModel;
	import project.model.cultivation.MixPanelModel;
	import project.model.cultivation.StarUpCard;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.item.CardModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.MovieClipController;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.view.layout.BaseGridContainer;
	import project.view.MainPane;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.cell.Card;
	import project.view.module.loading.LockScreen;
	import project.view.module.scene.main.MainScene;
	import project.view.common.FriendsControlPage;
	/**
	 * 合成面板
	 * @author bbjxl 2013
	 */
	public class MixPanel extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		//private var _grid:BaseGridContainer;
		private var _rowGrid:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var _controlPage:FriendsControlPage; //分页
		private var _MixBt:MovieClipButton;//合成按钮
		private var _targetCard:Card;//合成后的卡
		//-----------------------数据---------------------------------
		private var _rows:Vector.<ExpressRow>
		private static var PAGE_NUM:int = 3;
		private var _mixCards:Vector.<MixSmalCard>;//三张材料卡
		private var _mixDataModel:MixPanelModel;
		private var _currentPage:int = 1;//当前页
		private var _currentRow:ExpressRow;//当前选择的行
		private var _getDataOverFlag:Boolean = false;//合成请求是否已经返回
		private var _effectOverFlag:Boolean = false;//合成动画是否结束
		//-----------------------事件--------------------------------
		public function MixPanel() 
		{
			setSpriteInstance("MixPanelUI");
			configerInstance();
			_mixDataModel = new MixPanelModel();
			dataModel = _mixDataModel;
			BagData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, bagDataChanged);
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			_controlPage.starComputeNoInit(PAGE_NUM, (_mixDataModel.mixExps.length>0)?Math.ceil(_mixDataModel.mixExps.length / PAGE_NUM):1, updataRowsUI);
			if (_currentPage > _controlPage.totalPageNum) {
				//当前页码比总页码还大时，当前页为总页
				_currentPage = _controlPage.totalPageNum;
				}
				_controlPage.currentPageNum = _currentPage;
			return;
		} // end function

		/**
		 * 更新公式ＵＩ
		 */
		private function updataRowsUI():void 
		{
			_currentPage = _controlPage.currentPageNum;
			for (var i:int; i < _rows.length;i++) {
				var tempIndex:int = ((_currentPage-1) * PAGE_NUM + i);
				if ( tempIndex< _mixDataModel.mixExps.length) {
					if (_mixDataModel.mixExps[tempIndex]) {
						_rows[i].updata(_mixDataModel.mixExps[tempIndex]);
						_rows[i].visible = true;
						}else {
							_rows[i].visible = false;
							}
					}else {
						_rows[i].visible = false;
						}
				}
			//如果有公式，初始选择第一个
			if (_mixDataModel.mixExps.length > 0) {
				currentRow = _rows[0];
				}else {
					currentRow = null;
					}
			
		}
		
		/**
		 * 更新显示的几张材料卡和目标卡
		 */
		private function updataUI():void 
		{
			if (_currentRow == null) {
				_targetCard.hideAll();
				for (var j:String in _mixCards) {
					_mixCards[j].dispose();
					}
				_MixBt.clickEnable = false;
				return;
			}
			_targetCard.setCardModel(new CardModel(_currentRow.model.targetCardId));
			_MixBt.clickEnable = true;
			for (var i:String in _mixCards) {
				if (int(i) < _currentRow.model.cards.length) {
					_mixCards[i].updataCard(new CardModel(_currentRow.model.cards[int(i)].id), _currentRow.model.cards[int(i)].number);
					if (!_mixCards[i].card.enable) {
						//如果卡不足不能点合成按钮
						_MixBt.clickEnable = false;
						}
					}else {
						_mixCards[i].dispose();
						}
				}
			
		}

		/**
		 * 背包数据改变时
		 * @param	e
		 */
		private function bagDataChanged(e:SMZTDataChangeEvent):void 
		{
			if (SMZTUIManager.getInstance().mainPane.currentSceneId == MainScene.CULTIVATION_SCENE) {
				//如果处于修炼馆时更新
				_mixDataModel.updata();
				}
		}
		
		private function configerInstance():void 
		{
			_rowGrid = new BaseGridContainer(PAGE_NUM,1,7,230,46);
			_rowGrid.setLocation(490.1,392.6);
			addChild(_rowGrid);
			_rows = new Vector.<ExpressRow>();
			for (var j:int = 0; j < PAGE_NUM; j++ ) {
				var tempRow:ExpressRow = new ExpressRow();
				_rowGrid.appendChild(tempRow);
				_rows.push(tempRow);
				tempRow.addEventListener(MouseEvent.CLICK, rowClickHandler);
				tempRow = null;
				}
			
			
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(560.2, 552);
			_controlPage.updatLoc = updatLoc;
			_spriteInstance.addChild(_controlPage);
			
			_targetCard = new Card();
			_targetCard._currentCardTye = 1;
			_targetCard.showTip = true;
			_targetCard.setLocation(219.55,288.15);
			addChild(_targetCard);
			
			/*_grid = new BaseGridContainer(1, 3, 10, ApplicationConfig.CARD_WIDTH >> 1, ApplicationConfig.CARD_HEIGHT >> 1);
			_grid.setLocation(47, 286);
			addChild(_grid);*/
			var cardPoint:Array = [ { x:234.55, y:108.1 }, { x:92, y:350.15 }, { x:377.6, y:350.15 } ];
			_mixCards = new Vector.<MixSmalCard>();
			for (var i:int = 0; i < 3; i++ ) {
				var temp:MixSmalCard = new MixSmalCard();
				addChild(temp);
				temp.setLocation(cardPoint[i].x, cardPoint[i].y);
				_mixCards.push(temp);
				temp = null;
				}
			
			
			_MixBt = getChild("MixBt") as MovieClipButton;
			_MixBt.onClick = mixBtClickHandler;
			_MixBt.clickEnable = false;
			
			
		}
		
		
		
		private function rowClickHandler(e:MouseEvent):void 
		{
			
			currentRow = e.currentTarget as ExpressRow;
			
		}

		/**
		 * 更新位置
		 */
		private function updatLoc():void 
		{
			//_controlPage.setLocation(this.width - _controlPage.width >> 1, 494.1);
		}
		
		private function mixBtClickHandler(e:MouseEvent):void 
		{
			
			_getDataOverFlag = false;
			_effectOverFlag = false;
			
			if (_currentRow == null) return;
			var tempTargetCardId:int = _currentRow.model.targetCardId;
			var tempMc:MovieClip = Reflection.createInstance("MixEffect");
			tempMc.x = 211.1; 
			tempMc.y = 239.05;
			addChild(tempMc);
			//swapChildren(_targetCard, tempMc);
			MovieClipController.onMovieClipEnd(tempMc, function ():void {
				removeChild(tempMc);
				tempMc = null;
				_effectOverFlag = true;
				if (!_getDataOverFlag) {
					//如果请求未返回，则显示ＬＯＡＤＩＮＧ
					LockScreen.getInstance().show(true);
					LockScreen.getInstance().addEventListener(MouseEvent.CLICK, hidLock, false, 0, true);
					}else {
						SMZTController.getInstance().getBagData(false);//刷新背包数据,即更新界面
						StarUpSuccesShow.getInstance().currentCardId = tempTargetCardId;
						StarUpSuccesShow.getInstance().show(true);
						}
				} );
			SMZTController.getInstance().cardMix(_currentRow.model.targetCardId, function ():void {
				
				//合成完成，先去掉材料卡再加上新卡
				var tempArr:Array = _currentRow.model.cards;
				for (var i:String in tempArr) {
					PlayerData.getInstance().deleteOneCard(tempArr[i].id, false, tempArr[i].number);
					}
				PlayerData.getInstance().addOneCard(_currentRow.model.targetCardId);
				PlayerData.getInstance().updataTotalType();
				tempArr = null;
				
				CultivationModel.getInstance().updata();
				
				
				_getDataOverFlag = true;
				if (_effectOverFlag) {
					SMZTController.getInstance().getBagData(false);//刷新背包数据,即更新界面
					}
				});
		}
		/**
		 * ＬＯＡＤＩＮ点击ＨＩＤＥ
		 * @param	e
		 */
		private function hidLock(e:MouseEvent):void 
		{
			LockScreen.getInstance().hide();
			LockScreen.getInstance().removeEventListener(MouseEvent.CLICK, hidLock);
		}
		
		public function get mixDataModel():MixPanelModel 
		{
			return _mixDataModel;
		}
		
		public function set mixDataModel(value:MixPanelModel):void 
		{
			_mixDataModel = value;
		}
		
		public function get currentRow():ExpressRow 
		{
			return _currentRow;
		}
		
		public function set currentRow(value:ExpressRow):void 
		{
			_currentRow = value;
			if (value == null) { updataUI(); return;}
			for (var i:String in _rows) {
				_rows[i].selected = false;
				}
			_currentRow.selected = true;
			updataUI();
		}
		
	}

}