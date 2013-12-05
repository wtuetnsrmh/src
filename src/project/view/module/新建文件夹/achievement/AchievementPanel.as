package project.view.module.achievement 
{
	import com.ming.ui.controls.Text;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import project.config.ErrorZhCn;
	import project.config.ItemConfig;
	import project.controller.ApplicationController;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.achievement.AchievementModel;
	import project.model.achievement.AchievementRowModel;
	import project.model.data.PlayerData;
	import project.model.item.ItemModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.component.comboBox.AchivComboBox;
	import project.view.layout.BaseGridContainer;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.ui.SpecialScroll;
	import project.view.controls.TabNavigator;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 * 成就面板
	 * @author bbjxl 2013
	 */
	public class AchievementPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _rowGrid:BaseGridContainer;
		private var tabNvigator:TabNavigator;
		//-----------------------UI---------------------------------
		private var _bt0:MovieClipButton;
		private var _bt1:MovieClipButton;
		private var _bt2:MovieClipButton;
		private var _bt3:MovieClipButton;
		private var _bt4:MovieClipButton;
		private var _bt5:MovieClipButton;
		private var _bt6:MovieClipButton;
		
		private var _combox:AchivComboBox;
		private var _cirremtTitleText:TextField;//当前称号
		//private var _nameText:TextField;//名字
		private var _totalPointText:TextField;//总成就点数
		private var _selectedTypeTotalPointText:TextField;//当前所选的分类总成就点数
		
		private var _getBt:MovieClipButton;//领取奖励按钮
		private var _scroll:SpecialScroll;//滚动条
		private var _categoryProgress:Sprite;//当前所选行的进度条
		//private var _currentSelectedCategoryProgressText:TextField;
		private var _edge:Sprite;//四角
		private var _currentSelectedRowProgress:CurrentRowProgressBar;
		private var _item:BaseIcoCellLoader;//物品图片
		private var _gold:TextField;
		private var _crystal:TextField;
		private var _honor:TextField;
		
		//-----------------------数据---------------------------------
		private var _rows:Vector.<AchievementRow>;
		private var _achievementModel:AchievementModel;
		private var _currentSeclectedRowModel:AchievementRowModel;//当前选中行的数据模型
		//-----------------------事件--------------------------------
		
		private static var _instance:AchievementPanel;
		private var _currentSelectedType:int;
		public function AchievementPanel() 
		{
			if (_instance != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			_achievementModel = AchievementModel.getInstance();
			dataModel = _achievementModel;
			setSpriteInstance("achievementUI");
			configerUI();
		}
		
		private function configerUI():void 
		{
			
			
			_rows = new Vector.<AchievementRow>();
			_rowGrid = new BaseGridContainer(5, 1, 2, 447, 55);
			_rowGrid.setLocation(198, 233.1);
			for (var i:uint = 0; i < 5; i++ ) {
				var tempRow:AchievementRow = new AchievementRow();
				_rowGrid.appendChild(tempRow);
				tempRow.addEventListener(MouseEvent.CLICK, rowClickHandler);
				_rows.push(tempRow);
				tempRow = null;
				}
			addChild(_rowGrid);
			
			_bt0 = getChild("bt0") as MovieClipButton;
			_bt1 = getChild("bt1") as MovieClipButton;
			_bt2 = getChild("bt2") as MovieClipButton;
			_bt3 = getChild("bt3") as MovieClipButton;
			_bt4 = getChild("bt4") as MovieClipButton;
			_bt5 = getChild("bt5") as MovieClipButton;
			_bt6 = getChild("bt6") as MovieClipButton;
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_bt0, _bt1, _bt2, _bt3, _bt4, _bt5, _bt6);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			_edge = getChild("edge") as Sprite;
			_honor = getChild("honor") as TextField;
			_crystal = getChild("crystal") as TextField;
			_gold = getChild("gold") as TextField;
			_cirremtTitleText = getChild("cirremtTitleText") as TextField;
			//_nameText = getChild("nameText") as TextField;
			_totalPointText = getChild("totalPointText") as TextField;
			_selectedTypeTotalPointText = getChild("selectedTypeTotalPointText") as TextField;
			
			_getBt = getChild("getBt") as MovieClipButton;
			_getBt.clickEnable = false;
			_getBt.onClick = getClickHandler;
			_categoryProgress = getChild("categoryProgress") as Sprite;
			_categoryProgress.visible = false;
			_currentSelectedRowProgress = new CurrentRowProgressBar(_categoryProgress);
			
			_item = new BaseIcoCellLoader();
			addChild(_item);
			_item.restrictHW = 42.05;
			_item.toolTipEnabled = false;
			_item.showBg = false;
			_item.setLocation(40,471);
			
			addChild(_edge);
			
			_combox = new AchivComboBox("achivComBoxUI",141);
			addChild(_combox);
			_combox.x = 359.05;
			_combox.y = 197;
			_combox.dataModel = ["最近获得", "完成进度", "成就点数(高到低)", "有称号优先", "未完成优先"];
			
			_scroll= new SpecialScroll();
			_scroll.setUIAndData(null,5,Reflection.createInstance("specialScrollUI"));
			addChild(_scroll);
			_scroll.x = 641.15;
			_scroll.y = 191.05;
			_scroll.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, refreshHandler);
		}
		
		private function getClickHandler(e:MouseEvent):void 
		{
			SMZTController.getInstance().achievementAward(_currentSeclectedRowModel.id, function():void {
				//-------------------新手引导用-----------------------
					/*if (!NewBieControler.getInstance().finishDic[NewBieModelId.ACHIVEVEMENT2]) {
						NewBieControler.getInstance().nextStep();
						}*/
				//--------------------end--------------------
				//已领取的行模型设为已领
				_getBt.clickEnable = false;
				_achievementModel.setRowAwardById(_currentSeclectedRowModel.id);
				//把奖品放入奖品显示队列显示在舞台中间
				SMZTUIManager.getInstance().manageShowBonus.showBonus(_currentSeclectedRowModel.bounds);
				});
		}
		
		//关闭
        override public function hide(event:MouseEvent = null) : void
        {
			
			
            if (rootContainer)
            {
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
                if (showEffect)
                {
                    TweenLite.to(this, 0.3, {alpha:0.2, y:this.y - 40, onComplete:this.onTweenClose});
                }
                else
                {
                    if (rootContainer.contains(this))
                    {
                        rootContainer.removeChild(this);
                    }
                    this.isOpened = false;
                    this.isPopUP = false;
                }
				//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
						NewBieControler.getInstance().nextStep();
						}
				//--------------------end--------------------
					
				if (closeButton) {
					ApplicationController.removeAtWin(this);
					}
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		/**
		 * 刷新界面
		 * @param	e
		 */
		private function refreshHandler(e:SMZTDataChangeEvent):void 
		{
			for (var i:String in _rows) {
				if ((e.dataObject).length > int(i)) {
					_rows[i].visible = true;
					_rows[i].rowDataModel = (e.dataObject)[i];
					}else {
						_rows[i].visible = false;
						}
				}
			if(_rows[0].visible){
				selectedRow(_rows[0]);
			}else {
				_getBt.clickEnable = false;
				}
		}
		
		private function selectedRow(row:AchievementRow):void {
			for (var i:String in _rows) {
				_rows[i].selected(false);
				}
				
			row.selected();
			_currentSelectedRowProgress.setProgress(row.rowDataModel.progress, row.rowDataModel.total);
			_currentSeclectedRowModel = row.rowDataModel;
			
			if(_currentSeclectedRowModel.bounds.items){
					var tempItemModel:ItemModel = new ItemModel({"item": _currentSeclectedRowModel.bounds.items[0].id});
					_item.imgMode = -1; //图片ＵＲＬ为ＩＣＯ
					_item.item = tempItemModel;
					_item.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
					}else {
						_item.clearImgIco();
						}
			_gold.text = _currentSeclectedRowModel.bounds.gold.toString();
			_honor.text = _currentSeclectedRowModel.bounds.honor.toString();
			_crystal.text = _currentSeclectedRowModel.bounds.crystal.toString();
			if (_currentSeclectedRowModel.finish && _currentSeclectedRowModel.award == 0) {
				//如果已完成,没领取奖励
				_getBt.clickEnable = true;
				}else {
					_getBt.clickEnable = false;
					}
			}
		
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			_item.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point = new Point(_item.x + _item.width+10, _item.y - (125-_item.height)/2);
			SMZTUIManager.getInstance().bagPopPanel.setData(_item.item, this.localToGlobal(temp));
			SMZTUIManager.getInstance().bagPopPanel.show(false);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
			SMZTUIManager.getInstance().bagPopPanel.hide();
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			switch(e.dataObject) {
				case _bt0:
					_currentSelectedType = AchievementModel.TOTAL;
					_scroll.dataProvider = _achievementModel.rows;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "总成就:" + _achievementModel.totalStr;
					break;
				case _bt1:
					_currentSelectedType = AchievementModel.BATTLES;
					_scroll.dataProvider = _achievementModel.battles;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "战斗荣誉:" + _achievementModel.batlleStr;
					break;
				case _bt2:
					_currentSelectedType = AchievementModel.ITEMS;
					_scroll.dataProvider = _achievementModel.items;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "物品收集:" + _achievementModel.itemStr;
					break;
				case _bt3:
					_currentSelectedType = AchievementModel.AREANS;
					_scroll.dataProvider = _achievementModel.areans;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "竞技对决:" + _achievementModel.areanStr;
					break;
				case _bt4:
					_currentSelectedType = AchievementModel.FRIENDS;
					_scroll.dataProvider = _achievementModel.friends;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "好友互动:" + _achievementModel.friendStr;
					break;
				case _bt5:
					_currentSelectedType = AchievementModel.EVENTS;
					_scroll.dataProvider = _achievementModel.events;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "官方活动:" + _achievementModel.eventStr;
					break;
				case _bt6:
					_currentSelectedType = AchievementModel.OTHERS;
					_scroll.dataProvider = _achievementModel.others;
					_scroll.currentPage = 0;
					_selectedTypeTotalPointText.text = "其他:" + _achievementModel.otherStr;
					break;
				
				}
				
				sortByType(_combox.currentIndex);
				
			
		}
		
		/**
		 * 根据当前选择的排序方式显示
		 * @param	event
		 */
		
		public function sortByType(type:int = 0):void {
			var tempd:Number = new Date().getTime();
			//trace("sort"+tempd)
			
			var temp:*= _scroll.dataProvider;
			switch(type){
				case 0:
					quickSort(temp, 0, temp.length - 1, sort0);
					break;
				case 1:
					quickSort(temp, 0, temp.length - 1, sort1);
					break;
				case 2:
					quickSort(temp, 0, temp.length - 1, sort2);
					break;
				case 3:
					quickSort(temp, 0, temp.length - 1, sort3);
					break;
				case 4:
					quickSort(temp, 0, temp.length - 1, sort4);
					break;
				}
			_scroll.dataProvider = temp;
			_scroll.currentPage = 0;
			
			_scroll.moveUP();
			
			//trace("sortover"+(new Date().getTime()-tempd))
			}
			
		/**
		 * 快速排序
		 * @param	a
		 * @param	a_low
		 * @param	a_high
		 */
		public function quickSort(a:Vector.<AchievementRowModel>, a_low:int, a_high:int,fun:Function):void
		{
			var low:int = a_low;
			var high:int = a_high;
			if (low >= high)
			{
				return;
			}
			var transfer:Boolean = true;
			while (low != high)
			{
				if (fun(a[low], a[high]))
				{
					var temp:AchievementRowModel = a[low];
					a[low] = a[high];
					a[high] = temp;
					transfer = (transfer == true) ? false : true;
				}
				transfer ? high-- : low++;
			}
			low--;
			high++;
			quickSort(a, a_low, low,fun);
			quickSort(a, high, a_high,fun);
		}
		
		//"最近获得",  
		private function sort0(arg1:AchievementRowModel, arg2:AchievementRowModel):Boolean
		{
			var returnFalg:Boolean = false;
			if (arg1.time < arg2.time)
			{
				returnFalg = true;
				return returnFalg;
			}
			return returnFalg;
		}
		//"完成进度",
		private function sort1(arg1:AchievementRowModel, arg2:AchievementRowModel):Boolean
		{
			var returnFalg:Boolean = false;
			if (arg1.progress/arg1.total < arg2.progress/arg2.total)
			{
				returnFalg = true;
				return returnFalg;
			}
			return returnFalg;
		}
		//"成就点数(高到低)",
		private function sort2(arg1:AchievementRowModel, arg2:AchievementRowModel):Boolean
		{
			var returnFalg:Boolean = false;
			if (arg1.point < arg2.point)
			{
				returnFalg = true;
				return returnFalg;
			}
			return returnFalg;
		}
		// "有称号优先", 
		private function sort3(arg1:AchievementRowModel, arg2:AchievementRowModel):Boolean
		{
			var returnFalg:Boolean = false;
			if (arg1.title=="" && arg2.title!="")
			{
				returnFalg = true;
				return returnFalg;
			}
			return returnFalg;
		}
		//"未完成优先"
		private function sort4(arg1:AchievementRowModel, arg2:AchievementRowModel):Boolean
		{
			var returnFalg:Boolean = false;
			if (arg1.finish && !arg2.finish)
			{
				returnFalg = true;
				return returnFalg;
			}
			return returnFalg;
		}
		
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			if (PlayerData.getInstance().title != 0) {
				var temp:XMLList = ItemConfig.ACHV_CONFIG.Achievement.(@ID == PlayerData.getInstance().title);
				_cirremtTitleText.text = temp.Title[0][0];
				}else {
					_cirremtTitleText.text = "";
					}
			
			//_nameText.text = PlayerData.getInstance().nick;
			_totalPointText.text = _achievementModel.totalPoint.toString();

			//初始选第一分类
			tabNvigator.selectedByIndex(0);
			return;
		} // end function
		
		/**
		 * 行点击
		 * @param	e
		 */
		private function rowClickHandler(e:MouseEvent):void 
		{
			var temp:AchievementRow = e.currentTarget as AchievementRow;
			/*_currentSelectedRowProgress.setProgress(temp.rowDataModel.progress, temp.rowDataModel.total);
			_currentSeclectedRowModel = temp.rowDataModel;*/
			selectedRow(temp);
			temp = null;
		}
		//--------------------------------------------------------
		public function setCurrentTitle(value:String):void {
			_cirremtTitleText.text = value;
			}
		
		//--------------------------------------------------------
		public static function getInstance() : AchievementPanel
		{
			if (_instance == null)
			{
			  _instance = new AchievementPanel;
			}
			return _instance; 
		}// end function
		
	}

}