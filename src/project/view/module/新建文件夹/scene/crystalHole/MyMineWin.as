package project.view.module.scene.crystalHole
{
	import com.bbjxl.utils.Tools;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.model.crystalHole.CrystalHoleModel;
	import project.model.data.DataModel;
	import project.model.friends.BonusModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.events.SMZTDataChangeEvent;
	import project.view.controls.ManageShowBonus;
	import project.view.module.alert.AlertSelectPane;
	
	/**
	 * 我的矿体窗口
	 * @author bbjxl 2013
	 */
	public class MyMineWin extends BaseSpriteSetUI
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		
		private var _yieldText:TextField;
		private var _occupyTimeText:TextField;
		private var _freeWarTimeText:TextField;
		private var _yieldText1:TextField;
		private var _occupyTimeText1:TextField;
		private var _freeWarTimeText1:TextField;
		
		private var _type0:MovieClip;
		private var _type1:MovieClip;
		
		private var _harvestBt0:MovieClipButton;
		private var _harvestBt1:MovieClipButton;
		private var _giveUpBt0:MovieClipButton;
		private var _giveUpBt1:MovieClipButton;
		
		//private var _openBt:MovieClipButton;
		private var _closeBt:MovieClipButton;
		
		//-----------------------数据---------------------------------
		private var _isOpen:Boolean = true;
		private var _occupyLeftTime0:int; //剩余时间
		private var _occupyLeftTime1:int; //剩余时间
		private var _occupyCdTime0:int; //保护时间
		private var _occupyCdTime1:int; //保护时间
		
		private var _currentMyMinesNum:int; //当前我的矿体数
		
		private var _updataFlag:Boolean = false;
		//-----------------------事件--------------------------------
		public function MyMineWin()
		{
		
		}
		
		public function setspriteInstance(param1:*):void
		{
			this._spriteInstance = param1;// SMZTResourceManager.getInstance().getRes(param1, SMZTDomainManager.getInstance().currentUIAppDomain) as Sprite;
			addChild(_spriteInstance);
			
			_yieldText = getChild("yieldText") as TextField;
			_type0 = getChild("type0") as MovieClip;
			_type1 = getChild("type1") as MovieClip;
			_occupyTimeText = getChild("occupyTimeText") as TextField;
			_freeWarTimeText = getChild("freeWarTimeText") as TextField;
			_yieldText1 = getChild("yieldText1") as TextField;
			_occupyTimeText1 = getChild("occupyTimeText1") as TextField;
			_freeWarTimeText1 = getChild("freeWarTimeText1") as TextField;
			_harvestBt0 = getChild("harvestBt0") as MovieClipButton;
			_harvestBt1 = getChild("harvestBt1") as MovieClipButton;
			_giveUpBt0 = getChild("giveUpBt0") as MovieClipButton;
			_giveUpBt1 = getChild("giveUpBt1") as MovieClipButton;
			_harvestBt0.onClick = clickHandler;
			_harvestBt1.onClick = clickHandler;
			_giveUpBt0.onClick = clickHandler;
			_giveUpBt1.onClick = clickHandler;
			
			//_openBt = getChild("openBt") as MovieClipButton;
			_closeBt = getChild("closeBt") as MovieClipButton;
			//_openBt.onClick = clickHandler;
			_closeBt.onClick = clickHandler;
			
			SMZTUIManager.getInstance().crystalHoleScene.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		/**
		 * 有占领者返回00:00:00格式,没有占领者返回--格式
		 * @param	e
		 */
		private function retunrReplaceStr(id:int = 0):String {
			if (id == 0) {
				return  (CrystalHoleModel.getInstance().myMines.length==0)?ShowHoleDetailWin.replaceStr:ShowHoleDetailWin.replaceStr0;
				}else {
					return  (CrystalHoleModel.getInstance().myMines.length==2)?ShowHoleDetailWin.replaceStr0:ShowHoleDetailWin.replaceStr;
					}
			return  ShowHoleDetailWin.replaceStr;
			}
		
		private function timerHandler(e:TimerEvent):void
		{
			//trace("先计时?")
			if (!_updataFlag) return;
			if (_occupyLeftTime0 > 0)
			{
				_occupyLeftTime0--;
				_occupyTimeText.text = Tools.formatTime(_occupyLeftTime0);
			}
			else if (_occupyLeftTime0 == 0 && CrystalHoleModel.getInstance().myMines.length>0)
			{
				//已完成
				_giveUpBt0.clickEnable = false;
				_giveUpBt0.visible = false;
				_harvestBt0.clickEnable = true;
				_harvestBt0.visible = true;
				_occupyTimeText.text = retunrReplaceStr();
				_occupyLeftTime0--;
			}
			
			if (_occupyLeftTime1 > 0)
			{
				_occupyLeftTime1--;
				_occupyTimeText1.text = Tools.formatTime(_occupyLeftTime1);
			}
			else if (_occupyLeftTime1 == 0 && CrystalHoleModel.getInstance().myMines.length>1)
			{
				//已完成
				_giveUpBt1.clickEnable = false;
				_giveUpBt1.visible = false;
				_harvestBt1.clickEnable = true;
				_harvestBt1.visible = true;
				_occupyTimeText1.text = retunrReplaceStr(1);
				_occupyLeftTime1--;
			}
			
			if (_occupyCdTime0 > 0)
			{
				_occupyCdTime0--;
				_freeWarTimeText.text = Tools.formatTime(_occupyCdTime0);
				
			}else {
				_freeWarTimeText.text =retunrReplaceStr();
				}
			
			if (_occupyCdTime1 > 0)
			{
				_occupyCdTime1--;
				_freeWarTimeText1.text = Tools.formatTime(_occupyCdTime1);
			}else {
				_freeWarTimeText1.text = retunrReplaceStr(1);
				}
		
		}
		
		/**
		 * 刷新各按钮的状态
		 */
		private function refreshHavestAndGiveUp():void
		{
			var value:CrystalHoleModel = CrystalHoleModel.getInstance();
			for (var i:String in value.myMines)
			{
				if (int(i) == 0)
				{
					if (value.myMines[i].occupyLeft == 0)
					{
						//已完成
						_giveUpBt0.clickEnable = false;
						_giveUpBt0.visible = false;
						_harvestBt0.clickEnable = true;
						_harvestBt0.visible = true;
					}
					else
					{
						_giveUpBt0.clickEnable = true;
						_giveUpBt0.visible = true;
						_harvestBt0.clickEnable = false;
						_harvestBt0.visible = false;
					}
					_occupyCdTime0 = value.myMines[i].occupyCd;
					_occupyLeftTime0 = value.myMines[i].occupyLeft;
					_type0.visible = true;
					_type0.gotoAndStop(value.myMines[i].type);
				}
				else
				{
					if (value.myMines[i].occupyLeft == 0)
					{
						//已完成
						_giveUpBt1.clickEnable = false;
						_giveUpBt1.visible = false;
						_harvestBt1.clickEnable = true;
						_harvestBt1.visible = true;
					}
					else
					{
						_giveUpBt1.clickEnable = true;
						_giveUpBt1.visible = true;
						_harvestBt1.clickEnable = false;
						_harvestBt1.visible = false;
					}
					_occupyCdTime1 = value.myMines[i].occupyCd;
					_occupyLeftTime1 = value.myMines[i].occupyLeft;
					_type1.visible = true;
					_type1.gotoAndStop(value.myMines[i].type);
				}
				
			}
		value = null;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case _closeBt: 
					this.visible = false;
					isOpen = false;
					dispatchEvent(new SMZTDataChangeEvent(SMZTDataChangeEvent.ON_DATA_CHANGE));
					break;
				case _harvestBt0: 
					SMZTController.getInstance().harvestMine(CrystalHoleModel.getInstance().myMines[0].id, function(param:Object):void
						{
							var tempBonus:BonusModel = new BonusModel();
							tempBonus.setData(param);
							SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus);
							tempBonus = null;
							
							//更新场景
							SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
						});
					break;
				case _harvestBt1: 
					SMZTController.getInstance().harvestMine(CrystalHoleModel.getInstance().myMines[1].id, function(param:Object):void
						{
							var tempBonus:BonusModel = new BonusModel();
							tempBonus.setData(param);
							SMZTUIManager.getInstance().manageShowBonus.showBonus(tempBonus);
							tempBonus = null;
							
							//更新场景
							SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
						});
					break;
				case _giveUpBt0: 
					var sendGiveUp:Function = function(okOrCancel:String):void {
						if (okOrCancel==AlertSelectPane.ALERT_YES) {
							
								SMZTController.getInstance().giveUpMines(CrystalHoleModel.getInstance().myMines[0].id, function():void {
									//更新场景
									SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
									});
						}
					}
					AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CrystalHolePane.GiveUpTip.@Text, sendGiveUp, true);
					
					break;
				case _giveUpBt1: 
					var sendGiveUp:Function = function(okOrCancel:String):void {
						if (okOrCancel==AlertSelectPane.ALERT_YES) {
								SMZTController.getInstance().giveUpMines(CrystalHoleModel.getInstance().myMines[1].id, function():void {
									//更新场景
									SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
									});
						}
					}
					AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.CrystalHolePane.GiveUpTip.@Text, sendGiveUp, true);
					
					break;
			}
		
		}
		
		/**
		 * 更新界面
		 */
		public function updataUI(value:CrystalHoleModel):void
		{
			//trace("先更新?")
			
			reset();
			
			if (_currentMyMinesNum != value.myMines.length)
			{
				//我的矿体数变化时更新个人货币数据
				SMZTUIManager.getInstance().mainPane.refreshSelfData();
				
				_currentMyMinesNum = value.myMines.length;
			}
			
			//refreshHavestAndGiveUp();
			
			for (var i:String in value.myMines)
			{
				if (int(i) == 0)
				{
					if (value.myMines[i].occupyLeft == 0)
					{
						//已完成
						_giveUpBt0.clickEnable = false;
						_giveUpBt0.visible = false;
						_harvestBt0.clickEnable = true;
						_harvestBt0.visible = true;
					}
					else
					{
						_giveUpBt0.clickEnable = true;
						_giveUpBt0.visible = true;
						_harvestBt0.clickEnable = false;
						_harvestBt0.visible = false;
					}
					_occupyCdTime0 = value.myMines[i].occupyCd;
					_occupyLeftTime0 = value.myMines[i].occupyLeft;
					_type0.visible = true;
					_type0.gotoAndStop(value.myMines[i].type);
					_yieldText.text = value.myMines[i].yieldNow.toString();
				}
				else
				{
					if (value.myMines[i].occupyLeft == 0)
					{
						//已完成
						_giveUpBt1.clickEnable = false;
						_giveUpBt1.visible = false;
						_harvestBt1.clickEnable = true;
						_harvestBt1.visible = true;
					}
					else
					{
						_giveUpBt1.clickEnable = true;
						_giveUpBt1.visible = true;
						_harvestBt1.clickEnable = false;
						_harvestBt1.visible = false;
					}
					_occupyCdTime1 = value.myMines[i].occupyCd;
					_occupyLeftTime1 = value.myMines[i].occupyLeft;
					_type1.visible = true;
					_type1.gotoAndStop(value.myMines[i].type);
					_yieldText1.text = value.myMines[i].yieldNow.toString();
				}
				
			}
			value = null;
			_updataFlag = true;
		}
		
		/**
		 * 重置
		 */
		private function reset():void
		{
			_giveUpBt0.clickEnable = false;
			_giveUpBt1.clickEnable = false;
			_harvestBt0.clickEnable = false;
			_harvestBt1.clickEnable = false;
			_yieldText.text = ShowHoleDetailWin.replaceStr;
			_yieldText1.text = ShowHoleDetailWin.replaceStr;
			_occupyTimeText.text = ShowHoleDetailWin.replaceStr;
			_occupyTimeText1.text = ShowHoleDetailWin.replaceStr;
			_freeWarTimeText.text = ShowHoleDetailWin.replaceStr;
			_freeWarTimeText1.text = ShowHoleDetailWin.replaceStr;
			
			_type0.visible = false;
			_type1.visible = false;
			
			_occupyCdTime0 = 0;
			_occupyCdTime1 = 0;
			_occupyLeftTime1 = 0;
			_occupyLeftTime0 = 0;
		}
		
		public function get isOpen():Boolean
		{
			dispatchEvent(new SMZTDataChangeEvent(SMZTDataChangeEvent.ON_DATA_CHANGE));
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
		}
	}

}