package project.view.module.lottery
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import project.config.LocalConfig;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.model.item.ItemModel;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSprite;
	import project.view.module.cell.BaseIcoCellLoader;
	import flash.filters.BitmapFilterQuality;
	/**
	 * 抽奖去掉栏
	 * @author bbjxl 2013
	 */
	public class RemoveLotterySlot extends BaseSprite
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _removeBt:MovieClipButton;
		private var _spriteinstance:Sprite;
		private var _itemImage:BaseIcoCellLoader; //道具图片
		private var _discard:Sprite; //丢弃
		private var _resetBt:MovieClipButton; //还原按钮
		//-----------------------数据---------------------------------
		private var _item:ItemModel;
		private var _id:int; //数组下标
		private var _discardFlag:Boolean = false; //是否去掉
		private var _loc_2:GlowFilter = null;
		
		//-----------------------事件--------------------------------
		public function RemoveLotterySlot()
		{
			_spriteinstance = SMZTResourceManager.getInstance().getRes("removeLotterySlot", SMZTDomainManager.getInstance().currentUIAppDomain) as Sprite;
			_removeBt = getChild("removeBt") as MovieClipButton;
			_resetBt = getChild("resetBt") as MovieClipButton;
			_discard = getChild("discard") as Sprite;
			_discard.visible = false;
			_itemImage = new BaseIcoCellLoader();
			_itemImage.showBg = false;
			_itemImage.setLocation(4.85, 2.4);
			_itemImage.restrictHW = 51;
			_spriteinstance.addChild(_itemImage);
			_spriteinstance.swapChildren(_itemImage, _discard);
			_removeBt.onClick = removeClick;
			_removeBt.tipAutoSize = false;
			_removeBt.toolTip = LocalConfig.LOCAL_LAN.LotteryPanel.RemoveTip.@Text;
			_resetBt.onClick = resetClick;
			_resetBt.visible = false;
			addChild(_spriteinstance);
			
			_loc_2 = new GlowFilter();
			_loc_2.color = 0xFFFF00;
			_loc_2.alpha = 1;
			_loc_2.blurX = 3;
			_loc_2.blurY = 3;
			_loc_2.quality = BitmapFilterQuality.MEDIUM;
			_loc_2.strength = 20;
		}
		
		public function selected(value:Boolean = false):void
		{
			if (value) {
				_itemImage.filters = [_loc_2];
			}else {
				_itemImage.filters =null;
				}
			
		}
		
		//还原
		private function resetClick(e:MouseEvent):void
		{
			_discardFlag = false;
			_resetBt.visible = false;
			_removeBt.visible = true;
			_discard.visible = false;
			LotteryPanel.getInstance().updataUI();
		}
		
		//去掉
		private function removeClick(e:MouseEvent):void
		{
			_discardFlag = true;
			_resetBt.visible = true;
			_removeBt.visible = false;
			_discard.visible = true;
			LotteryPanel.getInstance().updataUI();
		}
		
		private function getChild(param1:String):DisplayObject
		{
			return _spriteinstance[param1] as DisplayObject;
		} // end function
		
		public function get item():ItemModel
		{
			return _item;
		}
		
		public function set item(value:ItemModel):void
		{
			_discardFlag = false;
			_resetBt.visible = false;
			//_resetBt.clickEnable = true;
			_removeBt.visible = true;
			//_removeBt.clickEnable = true;
			_discard.visible = false;
			
			_item = value;
			_itemImage.ico = value.ico;
			if (!_itemImage.hasEventListener(MouseEvent.ROLL_OVER))
				_itemImage.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get discardFlag():Boolean
		{
			return _discardFlag;
		}
		
		public function set discardFlag(value:Boolean):void
		{
			_discardFlag = value;
		}
		
		public function get removeBt():MovieClipButton
		{
			return _removeBt;
		}
		
		public function set removeBt(value:MovieClipButton):void
		{
			_removeBt = value;
		}
		
		public function get resetBt():MovieClipButton 
		{
			return _resetBt;
		}
		
		public function set resetBt(value:MovieClipButton):void 
		{
			_resetBt = value;
		}
		
		/**
		 * 物品提示信息
		 * @param	e
		 */
		private function rollOverHandler(e:MouseEvent):void
		{
			_itemImage.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			var temp:Point = new Point(_itemImage.x - 100, _itemImage.y + 59);
			SMZTUIManager.getInstance().bagPopPanel.setData(_item, this.localToGlobal(temp));
			SMZTUIManager.getInstance().bagPopPanel.show(false);
			temp = null;
			_itemImage.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			_itemImage.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_itemImage.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			SMZTUIManager.getInstance().bagPopPanel.hide();
		}
	}

}