package project.view.module.platform 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.data.PlayerData;
	import project.model.item.CardModel;
	import project.model.platform.AwardYellowInfo;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.base.BaseSpriteSetUI;
	import project.view.base.BaseTitleWindow;
	import project.view.module.cell.Card;
	
	/**
	 * 新手礼包
	 * @author bbjxl 2013
	 */
	public class AwardNewBiePanel extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _goldText:TextField;
		private var _honorText:TextField;
		private var _card1:Card;
		private var _card2:Card;
		private var _getBt:MovieClipButton;//立即领取
		private var _openYearBt:MovieClipButton;
		private var _openBt:MovieClipButton;
		private var _renewBt:MovieClipButton;//续黄钻
		private var _renewYearBt:MovieClipButton;
		//-----------------------数据---------------------------------
		
		//-----------------------事件--------------------------------
		public function AwardNewBiePanel() 
		{
			setSpriteInstance("awardNewBiePanel");
			configerInstance();
			
		}
		
		public function updata():void {
			_card1.setCardModel(new CardModel(AwardYellowInfo.getInstance().newbie.cards[0].id));
			_card2.setCardModel(new CardModel(AwardYellowInfo.getInstance().newbie.cards[1].id));
			
			_goldText.text = AwardYellowInfo.getInstance().newbie.gold.toString();
			_honorText.text = AwardYellowInfo.getInstance().newbie.honor.toString();
			
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
				_getBt.clickEnable = !AwardYellowInfo.getInstance().newbieAwarded;
				}else {
					_getBt.clickEnable = false;
					}
			}
		
		private function configerInstance():void 
		{
			
			
			_openYearBt = getChild("openYearBt") as MovieClipButton;
			_openBt = getChild("openBt") as MovieClipButton;
			_renewBt = getChild("renewBt") as MovieClipButton;
			_renewYearBt = getChild("renewYearBt") as MovieClipButton;
			_getBt = getChild("getBt") as MovieClipButton;
			_getBt.clickEnable = false;
			_openYearBt.onClick = clickHandler;
			_openBt.onClick = clickHandler;
			_renewBt.onClick = clickHandler;
			_renewYearBt.onClick = clickHandler;
			_getBt.onClick = clickHandler;
			_goldText = getChild("goldText") as TextField;
			_honorText = getChild("honorText") as TextField;
			_card1 = new Card();
			_card2 = new Card();
			_card1.showTip = true;
			_card2.showTip = true;
			_card1._currentCardTye = 1;
			_card2._currentCardTye = 1;
			_card1.setLocation(101.5, 215.5);
			_card2.setLocation(243.45, 215.5);
			addChild(_card1);
			addChild(_card2);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _getBt:
					_getBt.clickEnable = false;
					SMZTController.getInstance().getAwardNewBieYellow(function():void {
						AwardYellowInfo.getInstance().newbieAwarded = true;
						SMZTUIManager.getInstance().manageShowBonus.showBonus(AwardYellowInfo.getInstance().newbie);
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