package project.view.module.scene.slave
{
	/**
	*描述：奴隶营地
	*
	*/
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.ItemConfig;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.slave.SlaveCamp;
	import project.model.slave.SlaveWork;
	import project.utils.CustomTool;
	import project.view.artplug.MovieClipButton;
	import project.view.controls.ManageShowBonus;
	import project.view.controls.ToolTip;
	import project.view.layout.BaseGridContainer;
	import project.view.module.alert.AlertSelectPane;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	import project.view.component.checkBox.CheckBox;
	import project.utils.Reflection;
	import com.bbjxl.utils.Tools;

    public class SlaveScene extends BaseGameScene
    {
        //----------------------容器---------------------------------
		private var _slotContainer:BaseGridContainer;
		private var _checkBox:BaseGridContainer;
		//-----------------------UI---------------------------------
		private var tt:ToolTip;
		private var _timeText:TextField;
		private var _slaveNumText:TextField;
		private var _slaveryNumText:TextField;
		private var _workNumText:TextField;
		private var _nameText:TextField;
		private var _stateAndText:TextField;
		private var _incomeText:TextField;
		
		private var _moneyType:MovieClip;
		
		private var _releaseBt:MovieClipButton;
		private var _haverstBt:MovieClipButton;//收获按钮
		private var _okBt:MovieClipButton;
		private var _headImage:BaseIcoCellLoader;//头像
		//-----------------------数据---------------------------------
		private var _timer:Timer = new Timer(1000);
		private var _secondNext:int = 0;//所剩余时间
		private var _canRefresh:Boolean = true;
		private var _slaveModel:SlaveCamp;
		
		private var _slots:Vector.<SlaveSlotPanel>;
		private var _checkBoxs:Vector.<CheckBox>;
		
		private var _currentSelectedSlotId:int = 0;//当前选中的槽
		private var _currentCheckBoxId:int = 0;//当前勾选的选项
		private var _currentUserId:int = 0;//当前选中的槽玩家ID
		//-----------------------事件--------------------------------
        
        public function SlaveScene()
        {
			
            rubishPosArr = [[360, 300], [411, 198], [646, 261]];
            sceneId =MainScene.SLAVE_SCENE;
            setSpriteInstance("slaveScene");
			configinstance();
			
			_slaveModel = SlaveCamp.getInstance();
			
            dataModel = _slaveModel;
            _timer.addEventListener(TimerEvent.TIMER, timerHandler);
            return;
        }// end function
		
		/**
		 * 倒计时
		 * @param	e
		 */
		private function timerHandler(e:TimerEvent=null):void 
		{
			if (_secondNext == 0) {
				_timer.stop();
				_stateAndText.htmlText = "<font color='#13CFEA'>" + _slots[_currentSelectedSlotId].stateText.text + "</font>";
				}else {
					_secondNext--;
					}
					
			
			
			_timeText.text = Tools.formatTime(_secondNext);
			_timeText.x = _stateAndText.x + _stateAndText.textWidth + 20;
			
			_incomeText.htmlText = "累积收入:   <font color='#fac302'>"+retrunIncome(_slots[_currentSelectedSlotId].slaveSlotModle.work)+"</font>";
			
			_moneyType.x = _incomeText.x + _incomeText.textWidth + 20;
			_haverstBt.x = _moneyType.x + _moneyType.width + 20;
			if (_slots[_currentSelectedSlotId].slaveSlotModle.finish) {
				_haverstBt.clickEnable = true;
				}else {
					_haverstBt.clickEnable = false;
					}
		}
		
		
		
		private function configinstance():void 
		{
			_slaveNumText = getChild("slaveNumText") as TextField;
			_slaveryNumText = getChild("slaveryNumText") as TextField;
			_workNumText = getChild("workNumText") as TextField;
			_nameText = getChild("nameText") as TextField;
			_stateAndText = getChild("stateAndText") as TextField;
			_timeText = getChild("timeText") as TextField;
			_incomeText = getChild("incomeText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.LEFT;
			_stateAndText.autoSize = TextFieldAutoSize.LEFT;
			_timeText.autoSize = TextFieldAutoSize.LEFT;
			_incomeText.autoSize = TextFieldAutoSize.LEFT;
			_moneyType = getChild("moneyType") as MovieClip;
			_releaseBt = getChild("releaseBt") as MovieClipButton;
			_haverstBt = getChild("haverstBt") as MovieClipButton;
			_okBt = getChild("okBt") as MovieClipButton;
			
			_releaseBt.onClick=clickHandler;
			_haverstBt.onClick=clickHandler;
			_okBt.onClick=clickHandler;
			
			_slotContainer = new BaseGridContainer(1, 5, 46, 91, 152);
			addChild(_slotContainer);
			_slotContainer.setLocation(55, 117.5);
			_slots = new Vector.<SlaveSlotPanel>();
			_checkBoxs = new Vector.<CheckBox>();
			
			_checkBox = new BaseGridContainer(5, 1, 10.3, 18, 18);
			addChild(_checkBox);
			_checkBox.setLocation(61.25, 409.75);
			
			for (var i:int = 0; i < 5; i++ ) {
				var tempCheckBox:CheckBox = new CheckBox(Reflection.createInstance("checkBoxUI") as MovieClip);
				_checkBox.appendChild(tempCheckBox);
				tempCheckBox.id = i + 1;//没有空闲所以以1
				_checkBoxs.push(tempCheckBox);
				tempCheckBox.addEventListener(MouseEvent.CLICK, checkBoxClickHandler);
				tempCheckBox = null;
				
				var tempSlot:SlaveSlotPanel = new SlaveSlotPanel();
				_slotContainer.appendChild(tempSlot);
				tempSlot.id = i;
				_slots.push(tempSlot);
				//tempSlot.addEventListener(MouseEvent.CLICK, slotClickHandler);
				tempSlot = null;
				}
			
			
			_headImage = new BaseIcoCellLoader();
			_headImage.restrictHW = 67;
			addChild(_headImage);
			_headImage.setLocation(52,290.55);
		}
		/**
		 * 单选选中
		 * @param	e
		 */
		private function checkBoxClickHandler(e:MouseEvent):void 
		{
			if (_slots[_currentSelectedSlotId].slaveSlotModle.work!=SlaveWork.FREE || _slots[_currentSelectedSlotId].slaveSlotModle.work == (e.currentTarget as CheckBox).id) return;
			//最后一项只有ＶＩＰ才能点
			if ((e.currentTarget as CheckBox).id ==SlaveWork.ATTENDANTS && !PlayerData.getInstance().ownVip) {
				return;
				}
				
			setCheckBoxById((e.currentTarget as CheckBox).id);
			if (_currentCheckBoxId != _slots[_currentSelectedSlotId].slaveSlotModle.work) {
				_okBt.clickEnable = true;
				}else {
					_okBt.clickEnable = false;
					}
		}
		
		/**
		 * 选中一个槽
		 * @param	e
		 */
		private function slotClickHandler(e:MouseEvent):void 
		{
			if (_currentSelectedSlotId == (e.currentTarget as SlaveSlotPanel).id) return;
			resetSlots();
			(e.currentTarget as SlaveSlotPanel).selected = true;
			_currentSelectedSlotId = (e.currentTarget as SlaveSlotPanel).id;
			_currentUserId = _slots[_currentSelectedSlotId].slaveSlotModle.user.userId;
			updataUI();
			timerHandler();
		}
		
		/**
		 * 更新界面
		 */
		private function updataUI():void 
		{
			_slots[_currentSelectedSlotId].selected = true;
			_releaseBt.clickEnable = true;
			//_haverstBt.clickEnable = true;
			_headImage.ico = _slots[_currentSelectedSlotId].slaveSlotModle.user.avatar;
			_nameText.htmlText = _slots[_currentSelectedSlotId].slaveSlotModle.user.nick + "   LV" + _slots[_currentSelectedSlotId].slaveSlotModle.user.level;
			_releaseBt.x = _nameText.x + _nameText.textWidth + 10;
			
			_stateAndText.htmlText = "<font color='#fac302'>" + _slots[_currentSelectedSlotId].stateText.text + "</font>";
			_secondNext = _slots[_currentSelectedSlotId].slaveSlotModle.time;
			if (!_timer.running) {
				_timer.start();
				}
			
			
			setCheckBoxById(_slots[_currentSelectedSlotId].slaveSlotModle.work);
			
			_okBt.clickEnable = false;//确定不可点
		}
		/**
		 * 指定勾选哪项
		 * @param	value
		 * @return
		 */
		private function setCheckBoxById(param:int = 0):void {
			
			
			resetCheckBox();
			if (param != 0) {
				_checkBoxs[param-1].selected =true;
				}
			_currentCheckBoxId = param;
			}
		/**
		 * 返回所有的勾选为未选中状态
		 * @param	value
		 * @return
		 */
		private function resetCheckBox():void {
			for (var i:String in _checkBoxs) {
				_checkBoxs[i].selected = false;
				}
			}
		
		/**
		 * 根据奴役类型跟时间返回累积收入
		 */
		private function retrunIncome(value:int = 0):int {
			var returnIncome:int = 0;
			var temp:int = SlaveWork.returnTimeByType(value);
			var ratio:int;
			if(value!=SlaveWork.FREE){
				 ratio= (ItemConfig.SLAVE_CONFIG.Works.Work.(@ID == value)).GoldRate;
				trace(ratio)
				}
			switch(value) {
				case SlaveWork.FREE:
					returnIncome=0;
					break;
				case SlaveWork.HORSE:
					returnIncome=Math.floor((temp - _slots[_currentSelectedSlotId].slaveSlotModle.time) / temp * _slots[_currentSelectedSlotId].slaveSlotModle.user.level*ratio);
					break;
				case SlaveWork.CLEAN_CAMP:
					returnIncome=Math.floor((temp - _slots[_currentSelectedSlotId].slaveSlotModle.time) / temp * _slots[_currentSelectedSlotId].slaveSlotModle.user.level*ratio);
					break;
				case SlaveWork.GUARD_DOOR:
					returnIncome=Math.floor((temp - _slots[_currentSelectedSlotId].slaveSlotModle.time) / temp * _slots[_currentSelectedSlotId].slaveSlotModle.user.level*ratio);
					break;
				case SlaveWork.HARD_WORK:
					returnIncome=Math.floor((temp - _slots[_currentSelectedSlotId].slaveSlotModle.time) / temp * _slots[_currentSelectedSlotId].slaveSlotModle.user.level*ratio);
					break;
				case SlaveWork.ATTENDANTS:
					returnIncome=Math.floor((temp - _slots[_currentSelectedSlotId].slaveSlotModle.time) / temp * _slots[_currentSelectedSlotId].slaveSlotModle.user.level*ratio);
					break;
				}
			return returnIncome;
			}
		
		/**
		 * 所有的槽都没选中
		 * @param	e
		 */
		private function resetSlots():void {
			for (var i:String in _slots) {
				_slots[i].selected = false;
				}
			}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _releaseBt:
					//释放
					var sendSaveUser:Function = function(okOrCancel:String):void {
						if (okOrCancel==AlertSelectPane.ALERT_YES) {
							SMZTController.getInstance().saveUser(_slots[_currentSelectedSlotId].slaveSlotModle.user.userId, null,function ():void {
							SMZTController.getInstance().getSlaveData(function (param:Object):void {
								_currentSelectedSlotId = 0;
								SlaveCamp.getInstance().setData(param);
								_timeText.text = "";
								SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
								});//刷新
							});
							}
						}
					AlertSelectPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.SlaveScene.ReleaseTip.@Text,sendSaveUser,true);
					
					break;
				case _haverstBt:
					//收获
					SMZTController.getInstance().getAcquireData(_slots[_currentSelectedSlotId].slaveSlotModle.user.userId, function(param:Object):void {
						var tempBonus:BonusModel = new BonusModel();
						tempBonus.setData(param);
						SMZTUIManager.getInstance().manageShowBonus.showBonusNoDataAndMoreThanOne(tempBonus);//显示奖励
						tempBonus = null;
						
						SMZTController.getInstance().getSlaveData(function (param:Object):void {
							SlaveCamp.getInstance().setData(param);
							SMZTUIManager.getInstance().mainPane.refreshSelfData();//更新个人信息
							});//刷新
						
						});
					break;
				case _okBt:
					//指定工作
					//trace("_currentCheckBoxId="+_currentCheckBoxId)
					SMZTController.getInstance().setSlaveWork(_slots[_currentSelectedSlotId].slaveSlotModle.user.userId,_currentCheckBoxId,function ():void {
						SMZTController.getInstance().getSlaveData(function (param:Object):void {
							SlaveCamp.getInstance().setData(param);
							});//刷新
						});
					break;
				}
		}

		/**
		 * 帮助点击
		 * @param	event
		 */
        override public function showHelp(event:MouseEvent = null) : void
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
        }// end function

        public function newbieOnly() : void
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
        }// end function

        

        override protected function onRemoveFromStage(event:Event) : void
        {
            
            return;
        }// end function

		/**
		 * 用户信息变化时
		 * @param	event
		 */
        private function onPlayerDataChange(event:SMZTDataChangeEvent) : void
        {
            
           
            return;
        }// end function

       

		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
            for (var i:int = 0; i < 5; i++ ) {
				//设置锁
				if (i < _slaveModel.max) {
					_slots[i]._lockIco.visible = false;
					}else {
						_slots[i]._lockIco.visible = true;
						_slots[i]._lockIco.gotoAndStop((i+1));
						}
						
				if (i < _slaveModel.slaves.length && _slaveModel.slaves[i] != null) {
					_slots[i].slaveSlotModle = _slaveModel.slaves[i];
					_slots[i].buttonMode = true;
					_slots[i].addEventListener(MouseEvent.CLICK, slotClickHandler);
					}else {
						
						_slots[i].buttonMode = false;
						_slots[i].removeEventListener(MouseEvent.CLICK, slotClickHandler);
						_slots[i].slaveSlotModle = null;
						}
				}
			_slaveNumText.text = _slaveModel.slaves.length+"/" + _slaveModel.max;
			_slaveryNumText.text = _slaveModel.enslaveSurplus.toString();
			_workNumText.text = _slaveModel.workSurplus.toString();
			
			reset();
			if (_currentUserId == 0) {
				_currentSelectedSlotId = 0;//刚开始默认选第一个
				}else {
					_currentSelectedSlotId=findUserIdByUserId();
					}
			_checkBox.visible = false;
			if (_slaveModel.slaves.length > 0 && _slaveModel.slaves[_currentSelectedSlotId] != null) {
				_checkBox.visible = true;
				updataUI();
				}
			
        }// end function
		
		/**
		 * 根据用户ID找到相应的槽ID，如果没有找到则默认选择第一个
		 * @return
		 */
		private function findUserIdByUserId():int 
		{
			var returnSlotId:int = 0;
			for (var i:String in _slaveModel.slaves) {
				if (_slaveModel.slaves[i].user.userId == _currentUserId) {
					returnSlotId = int(i);
					return returnSlotId;
					}
				}
			return returnSlotId;
		}
		
		/**
		 * 初始状态
		 */
		private function reset():void 
		{
			resetSlots();
			resetCheckBox();
			_okBt.clickEnable = false;
			_releaseBt.clickEnable = false;
			_haverstBt.clickEnable = false;
			
			_headImage.clearImgIco();
			_nameText.htmlText = "";
			_releaseBt.x = _nameText.x + _nameText.textWidth + 10;
			
			_stateAndText.htmlText = "";
			_timer.stop();
			_incomeText.htmlText = "累积收入:   <font color='#fac302'>"+"0"+"</font>";
			_moneyType.x = _incomeText.x + _incomeText.textWidth + 30;
			_haverstBt.x = _moneyType.x + _moneyType.width + 30;
		}


        public function get canRefresh() : Boolean
        {
            return this._canRefresh;
        }// end function

        public function set canRefresh(param1:Boolean) : void
        {
            this._canRefresh = param1;
            return;
        }// end function

    }
}
