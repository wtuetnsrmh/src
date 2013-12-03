package project.view.module.rank
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.rank.RankModel;
	import project.model.rank.RankType;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.common.FriendsControlPage;
	import project.view.controls.TabNavigator;
	import project.view.layout.BaseGridContainer;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	/**
	 * 排行榜面板
	 * @author bbjxl 2013
	 */
	public class RankPanel extends BaseTitleWindow
	{
		//----------------------容器---------------------------------
		private var _rowGrid:BaseGridContainer;
		private var tabNvigator:TabNavigator;
		//-----------------------UI---------------------------------
		private var _levelBt:MovieClipButton;
		private var _deckBt:MovieClipButton;
		private var _towerBt:MovieClipButton;
		//private var _heroBt:MovieClipButton;
		private var _myRankBt:MovieClipButton;
		private var _controlPage:FriendsControlPage; //分页
		private var _typeMc:MovieClip;
		
		private var _descText:TextField;//标题说明
		//private var _pointDesc:Sprite;//点数说明
		//-----------------------数据---------------------------------
		private var _rankModel:RankModel;
		private var _maxRow = 10;
		private var _totalRow:Vector.<RankRow>;
		//-----------------------事件--------------------------------
		
		private static var _rankPanel:RankPanel;
		
		public function RankPanel()
		{
			if (_rankPanel != null)
			{
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
			}
			_rankModel = RankModel.getInstance();
			dataModel = _rankModel;
			setSpriteInstance("rankPanelUI");
			confingerInstance();
			
			
		}
		
		private function confingerInstance():void
		{
			//_pointDesc = getChild("pointDesc") as Sprite;
			
			_descText = getChild("descText") as TextField;
			//_descText.autoSize = TextFieldAutoSize.CENTER;
			//_descText.width = 378.7;
			
			_typeMc = getChild("typeMc") as MovieClip;
			_typeMc.stop();
			
			_levelBt = getChild("levelBt") as MovieClipButton;
			_deckBt = getChild("deckBt") as MovieClipButton;
			_towerBt = getChild("towerBt") as MovieClipButton;
			//_heroBt = getChild("heroBt") as MovieClipButton;
			//_heroBt.clickEnable = false;
			_myRankBt = getChild("myRankBt") as MovieClipButton;
			_myRankBt.onClick = myRankBtClick;
			
			tabNvigator = new TabNavigator();
			tabNvigator.setTab(_levelBt, _deckBt, _towerBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			_controlPage = new FriendsControlPage();
			_controlPage.setLocation(234.25, 547);
			_spriteInstance.addChild(_controlPage);
			
			_rowGrid = new BaseGridContainer(_maxRow, 1, 8, 347.35, 22);
			_rowGrid.setLocation(63.55, 234);
			
			_totalRow = new Vector.<RankRow>
			for (var i:int = 0; i < _maxRow; i++)
			{
				var tempRow:RankRow = new RankRow();
				_rowGrid.appendChild(tempRow);
				_totalRow.push(tempRow);
				tempRow = null;
			}
			
			addChild(_rowGrid);
		}
		
		/**
		 * 我的排名点击
		 * @param	e
		 */
		private function myRankBtClick(e:MouseEvent):void 
		{
			getRankList(_rankModel.me);
		}
		
		/**
		 * 分页改变
		 */
		public function controlpageChange():void
		{
			getRankList(_controlPage.currentPageNum);
		}
		
		private function getRankList(page:int):void
		{
			SMZTController.getInstance().getRankListData(_rankModel.currentType, page, function(param1:Object):void
				{
					if (page != param1.page)
						return;
					_rankModel.setData(param1);
					_controlPage.updataUI(_rankModel.page, _rankModel.max); //更新服务端返回的页码跟总页数
					_controlPage.setLocation(_spriteInstance.width - _controlPage.width >> 1, 547);
				});
		}
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void
		{
			
			
			switch (e.dataObject)
			{
				case _levelBt: 
					//_pointDesc.visible = false;
					_rankModel.currentType = RankType.LEVEL;
					_descText.htmlText = LocalConfig.LOCAL_LAN.RankPanel.LevelTip.@Text;
					break;
				case _deckBt: 
					//_pointDesc.visible = true;
					_rankModel.currentType = RankType.CARD;
					_descText.htmlText = LocalConfig.LOCAL_LAN.RankPanel.DeckTip.@Text;
					break;
				case _towerBt: 
					//_pointDesc.visible = false;
					_rankModel.currentType = RankType.TOWER;
					_descText.htmlText = LocalConfig.LOCAL_LAN.RankPanel.TowerTip.@Text;
					break;
			}
		
			_typeMc.gotoAndStop(_rankModel.currentType);
			
			//显示第一页
			_controlPage.starCompute(_maxRow, 1, controlpageChange);
		}
		
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
				this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
				this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
				if (showEffect)
				{
					this.alpha = 0.5;
					TweenLite.to(this, 0.3, {alpha: 1, y: this.y + 40});
				}
				this.isOpened = true;
				this.isPopUP = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				
				//初始选第一分类
				tabNvigator.selectedByIndex(0);
				
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
			}
			this.playShowSound();
			return;
		} // end function
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			for (var i:int = 0; i < _totalRow.length; i++)
			{
				if (i < _rankModel.currentList.length)
				{
					_totalRow[i].visible = true;
					(_totalRow[i] as RankRow).updataUI(_rankModel.currentList[i], _rankModel.currentType);
				}
				else
				{
					_totalRow[i].visible = false;
				}
			}
			
			return;
		} // end function
		
		public static function getInstance():RankPanel
		{
			if (_rankPanel == null)
			{
				_rankPanel = new RankPanel;
			}
			return _rankPanel;
		} // end function
	}

}