package project.view.module.scene.statue 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.config.ErrorZhCn;
	import project.controller.SMZTController;
	import project.core.SMZTDomainManager;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.lottery.LotteryModel;
	import project.model.statue.AwardBoxModel;
	import project.model.statue.SignModel;
	import project.model.statue.StatueModel;
	import project.utils.Reflection;
	import project.view.base.BaseTitleWindow;
	import project.view.controls.ManageShowBonus;
	import project.view.layout.BaseGridContainer;
	import project.view.module.lottery.LotteryPanel;
	import project.view.ui.MyScrollBar;
	
	/**
	 * 女神像模块
	 * @author bbjxl 2013
	 */
	public class StatuePanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		private var _grid:BaseGridContainer;//列表容器
		//-----------------------UI---------------------------------
		private var _barMc:Sprite;//进度条
		private var _pointText:TextField;//今日活跃度
		private var _scroll:MyScrollBar;
		
		//-----------------------数据---------------------------------
		public static const boxsNum:uint = 5;//宝箱个数
		public static const signBoxsNum:uint = 7;//签到宝箱个数
		private var _boxs:Vector.<AwardBox>;//五个宝箱
		private var _statueModel:StatueModel;
		private var _rows:Vector.<ActivityRow>;
		private var _signModel:SignModel;//签到模型
		private var _signBoxs:Vector.<SignBox>;
		//-----------------------事件--------------------------------
		private static var _statuePanel:StatuePanel;
		
		public function StatuePanel() 
		{
			if (_statuePanel != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			_statueModel = StatueModel.getInstance();
			_signModel = SignModel.getInstance();
			dataModel = _statueModel;
			_signModel.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, signModelChanged);
			setSpriteInstance("statueUI");
			confingerInstance();
		}
		//更新签到
		private function signModelChanged(e:SMZTDataChangeEvent):void 
		{
			if (_signModel.opened) {
				_signBoxs[_signModel.days - 1].state = SignBox.OPENED;
				}else {
					_signBoxs[_signModel.days - 1].state = SignBox.CANOPEND;
					_signBoxs[_signModel.days - 1].addEventListener(MouseEvent.CLICK, signBoxClickHandler);
					}
		}
		//领取签到奖励
		private function signBoxClickHandler(e:MouseEvent):void 
		{
			(e.currentTarget).removeEventListener(MouseEvent.CLICK, signBoxClickHandler);
			SMZTController.getInstance().openSignBoxById(_signModel.days, function (param:Object):void {
				LotteryModel.getInstance().currentLotteryId = param.lotteryId;
				LotteryPanel.getInstance().state = LotteryPanel.STATUE_SIGN;//不显示稍后抽奖按钮
				LotteryPanel.getInstance().show(true);
				});
		}
		
		private function confingerInstance():void 
		{
			_signBoxs = new Vector.<SignBox>();
			for (var n:int = 0; n < signBoxsNum; n++ ) {
				var tempSignBox:SignBox = new SignBox();
				tempSignBox.setUI(getChild("signBox" + n));
				tempSignBox.state = SignBox.NOACTIVITY;
				_signBoxs.push(tempSignBox);
				addChild(tempSignBox);
				tempSignBox = null;
				}
			
			_grid = new BaseGridContainer(_statueModel.rows.length, 1, 1, 484.5,30);
			//_grid.setLocation(39.5,330);
			addChild(_grid);
			_rows = new Vector.<ActivityRow>();
			for (var i:int = 0; i < _statueModel.rows.length; i++ ) {
				var row:ActivityRow = new ActivityRow();
				_grid.appendChild(row);
				_rows.push(row);
				row = null;
				}
				
			_barMc = getChild("barMc") as Sprite;
			_pointText = getChild("pointText") as TextField;
			
			_boxs = new Vector.<AwardBox>();
			for (var j:int = 0; j < boxsNum; j++ ) {
				var tempBox:AwardBox = new AwardBox();
				tempBox.setUI(getChild("box" + j));
				_boxs.push(tempBox);
				(_boxs[j] as AwardBox).index = j;
				addChild(tempBox);
				
				_boxs[j].addEventListener(MouseEvent.CLICK, boxClickHandler);
				tempBox = null;
				}
			
			if(!_scroll){
			_scroll=new MyScrollBar(_grid,"R",16,0,"L",1,15,true,true,_grid.width,205,220.55,Reflection.getClass("ScroStrye",SMZTDomainManager.getInstance().currentUIAppDomain));
			_scroll.y = 262;
			_scroll.x = 18;
			addChild(_scroll)
			}else {
				_scroll.setLocationByRate();
				}
		}
		
		/**
		 * 宝箱点击
		 * @param	e
		 */
		private function boxClickHandler(e:MouseEvent):void 
		{
			var tempDatamodel:AwardBoxModel = (e.currentTarget as AwardBox).dataModel;
			if ((e.currentTarget as AwardBox).state == AwardBox.CANOPEND) {
				SMZTController.getInstance().getBoxAward(tempDatamodel.id, function ():void {
					//把当前宝箱的奖品放入奖品显示队列显示在舞台中间
					SMZTUIManager.getInstance().manageShowBonus.showBonus(tempDatamodel.bounds);
					tempDatamodel = null;
					SMZTController.getInstance().getActivityListData(function (param:Object):void {
						StatueModel.getInstance().setData(param);
						StatuePanel.getInstance().show(true);
						});
					})
				}
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			for (var i:String in _rows) {
				_rows[i].dataModel = _statueModel.rows[i];
				}
				
			_pointText.text = _statueModel.point.toString();
			
			_barMc.scaleX = _statueModel.point / _statueModel.totalPoint;
			
			//设置当前各宝箱的状态
			for (var j:String in _boxs) {
				if (judgestBoxOpenState(_boxs[j].dataModel.id)) {
					_boxs[j].state = AwardBox.OPENED;
					}else {
						//如果分数够了则为可以打开状态
						if (_statueModel.point >= _boxs[j].openPoint) {
							_boxs[j].state = AwardBox.CANOPEND;
							}else {
								_boxs[j].state = AwardBox.NOACTIVITY;
								}
						}
				
				}
			
			
			return;
		} // end function
		/**
		 * 返回当前ＩＤ宝箱是处于打开状态
		 * @return
		 */
		private function judgestBoxOpenState(value:int):Boolean {
			if (_statueModel.opened && _statueModel.opened.length > 0) {
				for (var i:String in  _statueModel.opened) {
					if (value == _statueModel.opened[i]) {
						return true;
						}
					}
				}else{
					return false;
					}
				return false;
			}
		
		public static function getInstance() : StatuePanel
		{
			if (_statuePanel == null)
			{
			  _statuePanel = new StatuePanel;
			}
			return _statuePanel; 
		}// end function
		
	}

}