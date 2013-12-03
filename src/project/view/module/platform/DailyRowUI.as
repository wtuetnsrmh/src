package project.view.module.platform
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import project.model.friends.BonusModel;
	import project.model.item.ItemModel;
	import project.model.platform.PlatformQQ;
	import project.utils.Reflection;
	import project.view.base.BaseSprite;
	import project.view.layout.BaseGridContainer;
	import project.view.module.bagpanel.BagPopPanel;
	import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.BaseIcoCellLoader;
	
	/**
	 * 每日礼包一行
	 * @author bbjxl 2013
	 */
	public class DailyRowUI extends BaseSprite
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var _ui:Sprite;
		private var _yellowIco:YellowIco;
		private var _bagPopPanel:BagPopPanel;
		//-----------------------数据---------------------------------
		private var _gap:int = 30;
		
		//-----------------------事件--------------------------------
		public function DailyRowUI()
		{
			_ui = Reflection.createInstance("dailyRowUI");
			addChild(_ui);
			_yellowIco = new YellowIco();
			_yellowIco.enable = false;
			addChild(_yellowIco);
			_yellowIco.x = 16.55;
			_yellowIco.y = 20.95;
			_bagPopPanel = BagPopPanel.getInstance();
		}
		
		public function updata(value:PlatformQQ, b:BonusModel):void
		{
			_yellowIco.updataUI(value);
			if (!_grid)
			{
				_grid = new BaseGridContainer(1, b.items.length, _gap, 43, 43);
				_grid.x = _yellowIco.width + _gap;
				addChild(_grid);
				_grid.setLocation(_yellowIco.x+_yellowIco.width+10,_ui.height-54>>1);
			}
			else
			{
				_grid.removeAll();
			}
			for (var i:int = 0; i < b.items.length; i++)
			{
				var temp:YellowItemIco = new YellowItemIco();
				var tempItemModel:ItemModel = new ItemModel({"item": b.items[i].id,"stack":b.items[i].number});
				temp.item = tempItemModel;
				temp.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver,false,0,true);
				_grid.appendChild(temp);
			}
		}
		
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			var _item:YellowItemIco = e.currentTarget as YellowItemIco;
			_item.setOnChoose(true);
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			var temp:Point=new Point(_item.x - (251-_item.width)/2, _item.y - 125);
			_bagPopPanel.setData(_item.item, _item.parent.localToGlobal(temp));
			
			_bagPopPanel.show(false);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			e.currentTarget.setOnChoose(false);
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver,false,0,true);
			_bagPopPanel.hide();
		}
	
	}

}