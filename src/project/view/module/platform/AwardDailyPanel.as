package project.view.module.platform 
{
	import com.adobe.serialization.json.JSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import project.controller.SMZTController;
	import project.core.SMZTDomainManager;
	import project.core.SMZTUIManager;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.item.ItemModel;
	import project.model.platform.PlatformQQ;
	import project.utils.Browser;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.model.platform.AwardYellowInfo;
	import project.view.base.BaseTitleWindow;
	import project.view.layout.BaseGridContainer;
	import project.view.module.bagpanel.BagPopPanel;
	import project.view.ui.MyScrollBar;
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class AwardDailyPanel extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;
		private var _scroll:MyScrollBar;
		//-----------------------UI---------------------------------
		private var _openYearBt:MovieClipButton;
		private var _openBt:MovieClipButton;
		private var _renewBt:MovieClipButton;//续黄钻
		private var _renewYearBt:MovieClipButton;
		
		private var _getBt:MovieClipButton;//立即领取
		private var _yearYellowBonus:YellowItemIco;//年费黄钻
		//-----------------------数据---------------------------------
		private var _rows:Vector.<DailyRowUI>;
		//-----------------------事件--------------------------------
		public function AwardDailyPanel() 
		{
			setSpriteInstance("awardDailyPanel");
			configerInstance();
			
		}
		
		public function updata():void {
			if (PlayerData.getInstance().pfqq && PlayerData.getInstance().pfqq.is_yellow_vip) {
				//是黄钻
				_renewBt.visible = true;
				_openBt.visible = false;
				}else {
					_renewBt.visible = false;
					_openBt.visible = true;
					}
			if (PlayerData.getInstance().pfqq && PlayerData.getInstance().pfqq.is_yellow_year_vip) {
				//是年黄钻
				_renewYearBt.visible = true;
				_openYearBt.visible = false;
				}else {
					_renewYearBt.visible = false;
					_openYearBt.visible = true;
					}
			if (PlayerData.getInstance().pfqq && (PlayerData.getInstance().pfqq.is_yellow_vip || PlayerData.getInstance().pfqq.is_yellow_year_vip)) {
				//是黄钻,年黄钻，未领取
				_getBt.clickEnable = !AwardYellowInfo.getInstance().dialyAwarded;
				}else {
					_getBt.clickEnable = false;
					}
					
			for (var i:int = 0; i < _rows.length; i++ ) {
				var temp:Object = new Object();
				temp.is_yellow_vip = 1;
				temp.is_yellow_year_vip = 0;
				temp.yellow_vip_level = i + 1;
				_rows[i].updata(new PlatformQQ(temp), AwardYellowInfo.getInstance().dialy[i]);
				temp = null;
				}
				
				var tempItemModel:ItemModel = new ItemModel({"item": AwardYellowInfo.getInstance().yearDialy.items[0].id,"stack":AwardYellowInfo.getInstance().yearDialy.items[0].number});
				_yearYellowBonus.item = tempItemModel;
				_yearYellowBonus.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver,false,0,true);	
			
			}
			
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			var _item:YellowItemIco = e.currentTarget as YellowItemIco;
			_item.setOnChoose(true);
			_item.showBg = true;
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point=new Point(_item.x - (251-_item.width)/2, _item.y - 125);
			BagPopPanel.getInstance().setData(_item.item, _item.parent.localToGlobal(temp));
			
			BagPopPanel.getInstance().show(false);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			e.currentTarget.setOnChoose(false);
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver,false,0,true);
			BagPopPanel.getInstance().hide();
		}
		
		private function configerInstance():void 
		{
			_yearYellowBonus = new YellowItemIco();
			addChild(_yearYellowBonus);
			_yearYellowBonus.setLocation(557.6, 237);
			
			_getBt = getChild("getBt") as MovieClipButton;
			_openYearBt = getChild("openYearBt") as MovieClipButton;
			_openBt = getChild("openBt") as MovieClipButton;
			_renewBt = getChild("renewBt") as MovieClipButton;
			_renewYearBt = getChild("renewYearBt") as MovieClipButton;
			_openYearBt.onClick = clickHandler;
			_openBt.onClick = clickHandler;
			_renewBt.onClick = clickHandler;
			_renewYearBt.onClick = clickHandler;
			_getBt.onClick = clickHandler;
			_grid = new BaseGridContainer(8, 1, 1,378,70);
			//_grid.setLocation(39.5,330);
			addChild(_grid);
			_rows = new Vector.<DailyRowUI>();
			for (var i:int = 0; i < 8; i++ ) {
				var row:DailyRowUI = new DailyRowUI();
				_grid.appendChild(row);
				_rows.push(row);
				row = null;
				}
				
			//增加滚动条控制
			if(!_scroll){
			_scroll=new MyScrollBar(_grid,"L",16,0,"L",1,15,true,true,_grid.width,273.05,231.05,Reflection.getClass("ScroStrye",SMZTDomainManager.getInstance().currentUIAppDomain));
			_scroll.x = 76;
			_scroll.y =  176.05;
			addChild(_scroll)
			}else {
				_scroll.setLocationByRate();
				}
		}
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _getBt:
					_getBt.clickEnable = false;
					SMZTController.getInstance().getAwardDialyYellow(function():void {
						AwardYellowInfo.getInstance().dialyAwarded = true;
						SMZTUIManager.getInstance().manageShowBonus.showBonus(AwardYellowInfo.getInstance().dialy[PlayerData.getInstance().pfqq.yellow_vip_level-1]);
						SMZTUIManager.getInstance().manageShowBonus.showBonus(AwardYellowInfo.getInstance().yearDialy);//年费黄钻
						})
					break;
				
				case _openBt:
				case _renewBt:
					Browser.openAndRenewYellow();
					break;
				case _renewYearBt:
				case _openYearBt:
					Browser.openAndRenewYearYellow();
					break;
				}
		}
		
	}

}