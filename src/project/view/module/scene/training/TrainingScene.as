package project.view.module.scene.training
{
	/**
	 *描述：战争学院
	 *
	 */
	import com.bbjxl.utils.Tools;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.config.SpecialItemIdConfig;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.ModelLocator;
	import project.model.training.TrainingModel;
	import project.utils.CustomTool;
	import project.view.artplug.MovieClipButton;
	import project.view.layout.BaseGridContainer;
	import project.view.module.bagpanel.UseItemControler;
	import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;
	
	public class TrainingScene extends BaseGameScene
	{
		
		//----------------------容器---------------------------------
		private var _gidContent:BaseGridContainer; //放挑战对手信息面板
		private var _heroImageSp:Sprite;//英雄头像容器
		//-----------------------UI---------------------------------
		private var _residuelText:TextField; //剩余场次
		private var _timeText:TextField; //再过多久增加一场
		private var _limitText:TextField; //最多增加5场，当前已经增加了几场
		private var _addBt:MovieClipButton; //增加一场
		private var _refreshBt:MovieClipButton; //刷新按钮
		private var _vipBt:MovieClipButton; //成为VIP
		private var _heroImageMc:BaseIcoCell; //英雄图像
		//-----------------------数据---------------------------------
		private var _slots:Array;
		private var _trainingModel:TrainingModel;
		private var _rectimer:Timer=new Timer(1000);
		private var _secondNext:int;//下次增加场次剩余的时间，单位为秒，若不能增加则没有这个字段
		
		private var _userId:int;//挑战的玩家编号
		//-----------------------事件--------------------------------
		public function TrainingScene()
		{
			rubishPosArr = [[360, 300], [411, 198], [646, 261]];
			sceneId = MainScene.TRAINING_SCENE;
			setSpriteInstance("TrainingPanel");
			configerUIInstance();
			
			_trainingModel = TrainingModel.getInstance();
			dataModel = _trainingModel;
			//PlayerData.getInstance().addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onPlayerDataChange);
			_rectimer.addEventListener(TimerEvent.TIMER, timerHandler);
			return;
		} // end function
		/**
		 * 控制时间
		 * @param	e
		 */
		public function setTimer(value:Boolean = false):void {
			if (value) {
				_rectimer.start();
				}else {
					_rectimer.stop();
					}
			
			}
		//每秒倒计时
		private function timerHandler(e:TimerEvent):void 
		{
			if (_secondNext == 0) {
				_rectimer.stop();
				refreshBtOnClickHandler();
				}else {
					_secondNext--;
					}
			_timeText.text = Tools.formatTime(_secondNext);
		}
		
		private function configerUIInstance():void
		{
			_gidContent = new BaseGridContainer(2, 2, 8, 238, 221);
			_gidContent.setLocation(261.55, 133.55);
			_residuelText = getChild("residuelText") as TextField;
			_timeText = getChild("timeText") as TextField;
			_limitText = getChild("limitText") as TextField;
			_addBt = getChild("addBt") as MovieClipButton;
			_refreshBt = getChild("refreshBt") as MovieClipButton;
			_vipBt = getChild("vipBt") as MovieClipButton;
			_vipBt.visible = false;//暂时不要这个功能
			_heroImageSp = getChild("heroImageSp") as MovieClip;
			
			_heroImageMc = new BaseIcoCell();
			_heroImageMc.showBg = false;
			_heroImageMc.setLocation(0,89.55);
			_heroImageSp.addChild(_heroImageMc);
			
			_vipBt.onClick = vipBtClickHandler;
			_addBt.onClick = addBtOnClickHandler;
			_addBt.tipAutoSize = false;
			_addBt.toolTip = LocalConfig.LOCAL_LAN.TrainingScene.AddBtTip.@Text;
			_refreshBt.onClick = refreshBtOnClickHandler;
			
			_slots = new Array();
			for (var i:int = 0; i < 4; i++)
			{
				var temp:TrainingSlotPanel = new TrainingSlotPanel();
				temp.setNVN(i);
				_slots.push(temp);
				_gidContent.appendChild(temp);
				temp = null;
			}
			
			addChild(_gidContent);
		}
		
		/**
		 * 成为VIP
		 */
		private function vipBtClickHandler(e:MouseEvent = null):void
		{
		
		}
		
		/**
		 * 刷新按钮
		 */
		private function refreshBtOnClickHandler(e:MouseEvent = null):void
		{
			//如果是时间到刷新则不显示LOADING
			SMZTController.getInstance().getTrainingData(function(param:Object):void
				{
					TrainingModel.getInstance().setData(param.training);
				},(e==null)?false:true); //获取战争学院信息
		}
		
		/**
		 * 增加一场
		 * @param	e
		 */
		private function addBtOnClickHandler(e:MouseEvent):void
		{
			UseItemControler.userItemNew(SpecialItemIdConfig.TRAINING);
		}
		
		/**
		 * 更新界面
		 * @param	e
		 */
		private function updataUI():void
		{
			for (var i:int = 0; i < _trainingModel.slots.length; i++)
			{
				if(_trainingModel.slots[i]!=null){
					(_slots[i] as TrainingSlotPanel).updataUI(_trainingModel.slots[i]);
					_slots[i].visible = true;
				}else {
					//为null则隐藏
					_slots[i].visible = false;
					}
			}
			_residuelText.text = String(_trainingModel.left);
			_limitText.text = String(_trainingModel.extra + "/" + _trainingModel.extraMax);
			updataTimer();
			
			_heroImageMc.ico=ModelLocator.getInstance().staticURL+"images/characters/"+  CustomTool.turn000Num(_trainingModel.hero) + ".png";//英雄大图像地址
		}
		
		private function updataTimer():void
		{
			_secondNext = _trainingModel.next;
			if (_secondNext >= 0) {
				_rectimer.start();
				}else {
					_rectimer.stop();
					}
		}
		
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
		
		/**
		 * 用户信息变化时
		 * @param	event
		 */
		private function onPlayerDataChange(event:SMZTDataChangeEvent):void
		{
			
			return;
		} // end function
		
		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			updataUI();
		} // end function
		
		public function get userId():int 
		{
			return _userId;
		}
		
		public function set userId(value:int):void 
		{
			_userId = value;
		}
	
	}
}
