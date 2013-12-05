package project.view.module.platform 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import project.config.ErrorZhCn;
	import project.core.SMZTUIManager;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.item.ItemModel;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.module.bagpanel.BagPopPanel;
	
	/**
	 * 升级礼包面板
	 * @author bbjxl 2013
	 */
	public class AwardLevelUpPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _itemSp:Sprite;
		//-----------------------UI---------------------------------
		private var _glodText:TextField;
		private var _honorText:TextField;
		private var _year_goldText:TextField;
		private var _year_honorText:TextField;
		private var _titleText:TextField;
		private var _openBt:MovieClipButton;//开通黄钻
		private var _renewBt:MovieClipButton;//续费黄钻
		private var _getBt:MovieClipButton;//领取
		private var _getYearBt:MovieClipButton;//领取黄钻奖励
		private var _bagPopPanel:BagPopPanel;
		//-----------------------数据---------------------------------
		private var _items:Vector.<AwardItemIco>;
		private var _yearItems:Vector.<AwardItemIco>;//年费黄钻升级物品
		private var yellowVip:BonusModel;
		private var noVip:BonusModel;
		//-----------------------事件--------------------------------
		private static var _awardLevelUpPanel:AwardLevelUpPanel;
		public function AwardLevelUpPanel() 
		{
			if (_awardLevelUpPanel != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE))
				}
			setSpriteInstance("awardLevelUpPanelUI");
			confingerInstance();
			this.rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
		}
		
		public function updata(value:Object, titleStr:String):void {
			if (PlayerData.getInstance().pfqq != null) {
				//腾讯平台
				if (PlayerData.getInstance().pfqq.is_yellow_vip) {
					//是黄钻
					_getYearBt.visible = true;
					_getBt.visible = false;
					_renewBt.visible = true;
					_openBt.visible = false;
					}else {
						_getYearBt.visible = false;
						_getBt.visible = true;
						_renewBt.visible = false;
						_openBt.visible = true;
						}
				}else {
					return;
					}
			
			_titleText.htmlText = titleStr;
			
			while (_itemSp.numChildren > 0) {
				removeChildAt(0);
				}
			var tempItem:AwardItemIco;
			if (value["noVip"]) {
				noVip = new BonusModel();
				noVip.setData(value["noVip"]);
				_glodText.text = noVip.gold.toString();
				_honorText.text = noVip.honor.toString();
				for (var i:int = 0; i < noVip.items.length; i++ ) {
					tempItem = new AwardItemIco();
					tempItem.item = new ItemModel(noVip.items[i]);
					tempItem.x = 35.85+(176 - 49 * noVip.items.length) >> 1;
					tempItem.y = 196.45;
					_itemSp.addChild(tempItem);
					tempItem.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
					tempItem = null;
					}
				}
				
			if (value["yellowVip"]) {
				 yellowVip= new BonusModel();
				yellowVip.setData(value["yellowVip"]);
				_year_goldText.text = yellowVip.gold.toString();
				_year_honorText.text = yellowVip.honor.toString();
				for (var j:int = 0; j < yellowVip.items.length; j++ ) {
					tempItem = new AwardItemIco();
					tempItem.item = new ItemModel(yellowVip.items[j]);
					tempItem.x = 259.9+(176 - 49 * yellowVip.items.length) >> 1;
					tempItem.y = 196.45;
					tempItem.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
					_itemSp.addChild(tempItem);
					tempItem = null;
					}
				}
			}
			
		//鼠标移上物品显示提示面板
		private function bagIcoBoxRollOver(e:MouseEvent):void
		{
			var _item:AwardItemIco = e.currentTarget as AwardItemIco;
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
			e.currentTarget.addEventListener(MouseEvent.ROLL_OVER, bagIcoBoxRollOver);
			_bagPopPanel.hide();
		}
		
		private function confingerInstance():void 
		{
			_itemSp = new Sprite();
			addChild(_itemSp);
			_openBt = getChild("openBt") as MovieClipButton;
			_renewBt = getChild("renewBt") as MovieClipButton;
			_getBt = getChild("getBt") as MovieClipButton;
			_getYearBt = getChild("getYearBt") as MovieClipButton;
			_openBt.onClick = clickHandler;
			_renewBt.onClick = clickHandler;
			_getBt.onClick = clickHandler;
			_getYearBt.onClick = clickHandler;
			
			_titleText = getChild("titleText") as TextField;
			_glodText = getChild("glodText") as TextField;
			_honorText = getChild("honorText") as TextField;
			_year_goldText = getChild("year_goldText") as TextField;
			_year_honorText = getChild("year_honorText") as TextField;
			_bagPopPanel = BagPopPanel.getInstance();
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _openBt:
					Browser.openAndRenewYellow();
					break;
				case _renewBt:
					Browser.openAndRenewYellow();
					break;
				case _getBt:
					hide();
					SMZTUIManager.getInstance().manageShowBonus.showBonusNoDataAndMoreThanOne(noVip);
					SMZTUIManager.getInstance().mainPane.refreshSelfData();
					break;
				case _getYearBt:
					hide();
					SMZTUIManager.getInstance().manageShowBonus.showBonusNoDataAndMoreThanOne(noVip);
					SMZTUIManager.getInstance().manageShowBonus.showBonusNoDataAndMoreThanOne(yellowVip);
					SMZTUIManager.getInstance().mainPane.refreshSelfData();
					break;
				}
		}
		
		public static function getInstance() : AwardLevelUpPanel
		{
			if (_awardLevelUpPanel == null)
			{
			  _awardLevelUpPanel = new AwardLevelUpPanel;
			}
			return _awardLevelUpPanel; 
		}// end function
	}

}