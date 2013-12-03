package project.view.module.scene.slave 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import project.config.LocalConfig;
	import project.events.SMZTDataChangeEvent;
	import project.model.slave.SlaveSlot;
	import project.view.base.BaseSprite;
	import project.view.base.BaseSpritePane;
	import project.view.module.cell.BaseIcoCellLoader;
	
	/**
	 * 奴隶槽
	 * @author bbjxl 2013
	 */
	public class SlaveSlotPanel extends BaseSpritePane 
	{
		//----------------------容器---------------------------------
		private var _headImage:Sprite;
		//-----------------------UI---------------------------------
		private var _head:BaseIcoCellLoader;
		private var _nameText:TextField;
		private var _stateText:TextField;
		private var _ico:MovieClip;
		public var _lockIco:MovieClip;
		//-----------------------数据---------------------------------
		private var _slaveSlotModle:SlaveSlot;
		private var _id:int = 0;
		private var _selected:Boolean = false;//是否选中
		//-----------------------事件--------------------------------
		public function SlaveSlotPanel() 
		{
			_slaveSlotModle = new SlaveSlot();
			dataModel = _slaveSlotModle;
			setSpriteInstance("slaveSlotPanel");
			configinstance();
		}
		
		private function configinstance():void 
		{
			_headImage = getChild("headImage") as Sprite;
			_nameText = getChild("nameText") as TextField;
			_stateText = getChild("stateText") as TextField;
			_nameText.mouseEnabled = false;
			_stateText.mouseEnabled = false;
			_ico = getChild("ico") as MovieClip;
			_lockIco = getChild("lockIco") as MovieClip;
			_lockIco.stop();
			
			_head = new BaseIcoCellLoader();
			_head.showBg = false;
			_headImage.addChild(_head);
			_head.restrictHW =67;
			
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
           if (_slaveSlotModle.finish) {
				_stateText.text = "工作完成";
				_stateText.textColor = 0x13CFEA;
				return;
				}
        }// end function
		
		public function get slaveSlotModle():SlaveSlot 
		{
			return _slaveSlotModle;
		}
		
		public function set slaveSlotModle(value:SlaveSlot):void 
		{
			if (value == null) {
				_head.clearImgIco();
				_nameText.text = "";
				_stateText.text = "";
				_ico.gotoAndStop(1);
				return;
				}
				
			_slaveSlotModle = value;
			_head.ico = _slaveSlotModle.user.avatar;
			_nameText.text = _slaveSlotModle.user.nick;
			if (_slaveSlotModle.finish) {
				_stateText.text = "工作完成";
				_stateText.textColor = 0x13CFEA;
				return;
				}
				
			_stateText.text = LocalConfig.LOCAL_LAN.SlaveScene.SlaveWork.(@Id == _slaveSlotModle.work).@Text;
			_stateText.textColor = 0xfac302;
			
			_slaveSlotModle.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, onDataChange);
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			(value)?_ico.gotoAndStop(2):_ico.gotoAndStop(1);
			
		}
		
		public function get stateText():TextField 
		{
			return _stateText;
		}
		
		public function set stateText(value:TextField):void 
		{
			_stateText = value;
		}
		
	}

}