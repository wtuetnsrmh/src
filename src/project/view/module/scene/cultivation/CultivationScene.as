package project.view.module.scene.cultivation
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.controller.NewBieControler;
	import project.events.SMZTDataChangeEvent;
	import project.model.cultivation.CultivationModel;
	import project.model.data.PlayerData;
	import project.model.newBie.NewBieModelId;
	import project.view.artplug.MovieClipButton;
	import project.view.controls.TabNavigator;
	import project.view.module.cell.Card;
	import project.view.module.chat.ChatPane;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	
	/**
	 *描述：修炼馆
	 *
	 */
	
	public class CultivationScene extends BaseGameScene
	{
		//----------------------容器---------------------------------
		public var tabNvigator:TabNavigator;
		//-----------------------UI---------------------------------
		private var _starUpBt:MovieClipButton;//进阶
		private var _mixBt:MovieClipButton;//合成
		
		private var _starUpPanle:StarUpPanel;//进阶面板
		private var _mixPanle:MixPanel;//合成面板
		//-----------------------数据---------------------------------
		private var _currentSlectedTab:int = 0;//当前选的选项ＩＤ
		//-----------------------事件--------------------------------
		private var _cultivationModel:CultivationModel;
		
		public function CultivationScene()
		{
			
			rubishPosArr = [[360, 300], [411, 198], [646, 261]];
			sceneId = MainScene.CULTIVATION_SCENE;
			setSpriteInstance("composeUI");
			configinstance();
			
			_cultivationModel = CultivationModel.getInstance();
			dataModel = _cultivationModel;
			
			return;
		} // end function
		
		private function configinstance():void 
		{
			_mixPanle = new MixPanel();
			_mixPanle.setLocation(0,0);
			addChild(_mixPanle);
			_mixPanle.visible = false;
			
			_starUpPanle = new StarUpPanel();
			_starUpPanle.setLocation(0,0);
			addChild(_starUpPanle);
			
			tabNvigator = new TabNavigator();
			_starUpBt = getChild("starUpBt") as MovieClipButton;
			_mixBt = getChild("mixBt") as MovieClipButton;
			//addChild(_starUpBt);
			//addChild(_mixBt);
			
			tabNvigator.setTab(_starUpBt, _mixBt);
			tabNvigator.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, tabNavigatorChanger);
			
			//this.addEventListener(MouseEvent.CLICK, cardClickHandler);
			
		}
		
		/**
		 * 如果点击的是卡牌且按了shift则显示到聊天窗口
		 * @param	e
		 */
		/*private function cardClickHandler(e:MouseEvent):void 
		{
			if (e.target is Card && ApplicationConfig._ctrlKeyDown) {
				ChatPane.getInstance().sendCardInfo((e.target as Card).cardId + "_bbjxl_" + (e.target as Card).getCardModel().name+"_bbjxl_"+(e.target as Card).getCardModel().quality);
				}
		}*/
		
		private function tabNavigatorChanger(e:SMZTDataChangeEvent):void 
		{
			switch (e.dataObject)
			{
				case _starUpBt: 
					_currentSlectedTab = 0;
					_starUpPanle.visible = true;
					_mixPanle.visible = false;
					break;
				case _mixBt: 
					_currentSlectedTab = 1;
					_starUpPanle.visible = false;
					_mixPanle.visible = true;
					
					break;
				
			}
			updataUI();
		}
		
		/**
		 * 初始刷新界面
		 */
		public function updataUI():void 
		{
			switch(_currentSlectedTab) {
				case 0:
					_starUpPanle.updata();
					break;
				case 1:
					_mixPanle.mixDataModel.updata();
					break;
					
				}
		}
		
		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			//初始选第一分类
			tabNvigator.selectedByIndex(_currentSlectedTab);
			
		} // end function
		
		
		/**
		 * 帮助点击
		 * @param	event
		 */
		override public function showHelp(event:MouseEvent = null):void
		{
		/*HelpPane.getInstance().playInstance("NEWBIE_SHOW_OFFICE_HELP");
		   if (HelpPane.getInstance().isOpened)
		   {
		   helpBtn.gotoAndPlay(2);
		   }
		   else
		   {
		   helpBtn.gotoAndStop(1);
		   }
		   this.newbieOnly();
		 return;*/
		} // end function
		
		public function newbieOnly():void
		{
			/*if (this.officerContainer.selectedOfficerBox && this.officerContainer.selectedOfficerBox.item)
			   {
			   OfficerDisplayer.getInstance().show();
			   OfficerDisplayer.getInstance().setData(this.officerContainer.selectedOfficerBox.item);
			   }
			   else
			   {
			   this.officerContainer.setDefaultDisplay();
			 }*/
			return;
		} // end function
		
		override protected function onRemoveFromStage(event:Event):void
		{
			clearRubish();
			
			return;
		} // end function
		
		public function get currentSlectedTab():int 
		{
			return _currentSlectedTab;
		}
		
		public function set currentSlectedTab(value:int):void 
		{
			_currentSlectedTab = value;
		}
		
	
	}
}
