package project.view.scene.soldierLib
{
	/**
	 *佣兵团 
	 */	
	import flash.display3D.textures.Texture;
	import flash.system.System;
	import project.model.data.PlayerData;
	
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import khaos.view.ViewType;
	
	import lzm.starling.display.ScrollContainer;
	
	import project.Cellcard.Card;
	import project.model.item.CardModel;
	import project.utils.CardFactary;
	import project.view.bottonBar.BottonBar;
	import project.view.common.LogicView;
	import project.view.common.MyButton;
	import project.view.layout.BaseGridContainer;
	import project.view.scene.IScene;
	import project.view.scene.editDeckPanel.DeckItem;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class SoldierLibScene extends LogicView implements IScene
	{
		private var _bgLayer:Sprite;
		private var _cardList:Vector.<Card>;
		private var _cardDecBg:Image;
		private var _editDeckBt:MyButton;
		private var _deleteDeckBt:MyButton;
		private var _returnBt:MyButton;
		private var _deckName:TextField;
		private var _deckItems:Vector.<DeckItem>;
		
		private var _deckgrid:BaseGridContainer;
		private var _grid:BaseGridContainer;
		private var _scrollCont:ScrollContainer;
		public function SoldierLibScene()
		{
			super(ViewType.MULTI_DIALOG);
		}
		
		public function updata():void
		{
		}
		
		/**
		 *只建立公共材质里有的UI界面 -初始化时调用，早于show()
		 * 
		 */		
		override public function initUI():void
		{
			_bgLayer=new Sprite();
			addChild(_bgLayer);
			
			var bg:Scale9Image=ApplictionConfig.createS9Image(855.95,640,1);
			_bgLayer.addChild(bg);
			creadBarbg(593.9,268.05,57.05,122.95);
			creadBarbg(213,48.35,271.95,62.75);
			creadBarbg(807.2,191.5,28.45,404.7);
			
			_returnBt=new MyButton("returnBt");
			_returnBt.x=721.95;
			_returnBt.y=0;
			_bgLayer.addChild(_returnBt);
			_returnBt.addEventListener(Event.TRIGGERED, backClick);
			
			_editDeckBt=new MyButton("buttonBg","编辑卡组");
			_editDeckBt.x=662;
			_editDeckBt.y=201.55;
			_bgLayer.addChild(_editDeckBt);
			
			_deleteDeckBt=new MyButton("buttonBg","解散卡组");
			_deleteDeckBt.x=662;
			_deleteDeckBt.y=303.55;
			_bgLayer.addChild(_deleteDeckBt);
			
			_bgLayer.flatten();
			
			
			_deckItems = new Vector.<DeckItem>();
			_deckgrid = new BaseGridContainer(2, 4, 10, 100, 100);
			addChild(_deckgrid);
			for (var i:int = 0; i < 8; i++ ) {
				var tempDeckItem:DeckItem = new DeckItem();
				_deckgrid.appendChild(tempDeckItem);
				_deckItems.push(tempDeckItem);
				tempDeckItem = null;
				}
			
			
			this.x=ApplictionConfig.STAGE_WIDTH-this.width>>1;
			this.y=ApplictionConfig.STAGE_HEIGHT-this.height>>1;
		}
		
		private function backClick(e:Event):void
		{
//			Root.vmgr.showView(SoldierLibScene);return;
			if(BottonBar._sceneList.length>0){
				(Root.vmgr.getView(BottonBar) as BottonBar).showScene(BottonBar._sceneList.pop());
				
			}
		}
		
		private function creadBarbg(w:Number,h:Number,_x:Number,_y:Number):void{
			var barbg:Scale9Image=ApplictionConfig.createS9Image(w,h,2);
			barbg.x=_x;barbg.y=_y;
			_bgLayer.addChild(barbg);
		}
		
		override protected function internalHide():void
		{
			//删除UI层以外的对象
			if(this.visible){
				/*_scrollCont.reset(true);
				_scrollCont.dispose();
				_scrollCont=null;*/
				
				for (var i:String in _deckItems) {
					_deckItems[i].cardId = -1;
					}
				
				for(var j:int = 0; j <_cardList.length; j++){
					_cardList[j].dispose();
				}
				_cardList=null;
				_grid.removeAll(true);
				_grid.dispose();
				_grid=null;
			}
			
		}
		override protected function internalShow():void
		{
			if(this.visible){
				System.gc();
				/*_scrollCont = new ScrollContainer();
				_scrollCont.width = (ApplictionConfig.MIDDLE_CARD_WIDTH+5)*4;
				_scrollCont.height = ApplictionConfig.MIDDLE_CARD_HEIGHT+10;
				//_scrollCont.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
				var layout:HorizontalLayout = new HorizontalLayout();
				//			layout.useVirtualLayout = false;//为true时将渲染整个区域
				layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
				layout.gap = 10;
				layout.paddingLeft = 0;
				layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
				layout.manageVisibility = true;
				
				for (var i:int = 0; i < 8; i++ ) {
					_scrollCont.addScrollContainerItem(new DeckItem(i+1));
				}
				
				if(!this.contains(_scrollCont)){
					addChild(_scrollCont);
					_scrollCont.layout = layout;
					_scrollCont.x=98.6;
					_scrollCont.y=170.6;
				}*/
				for (var j:int = 0; j < _deckItems.length; j++ ) {
					if (PlayerData.getInstance().decks[j]) {
						_deckItems[j].locked = (PlayerData.getInstance().decks[j].locked==0)?false:true;
						_deckItems[j].cardId = PlayerData.getInstance().decks[j].heroCard.id;
						}
					/*_deckItems[j].locked = false;
					_deckItems[j].cardId = Math.random()*10+1;*/
					}
				
				_cardList=new Vector.<Card>();
				_grid=new BaseGridContainer(1,6,10,ApplictionConfig.MIDDLE_CARD_WIDTH,ApplictionConfig.MIDDLE_CARD_HEIGHT);
				if(!this.contains(_grid)){
				_grid.x=41.05;
				_grid.y=414.6;
				addChild(_grid);
				}
				for(var i:int=0;i<6;i++){
					var tempCard:Card=CardFactary.creaCard(i+10);
					_cardList.push(tempCard);
					_grid.appendChild(tempCard);
				}
			}
			
			
			
		}
	}
}