package project.view.module.platform 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import project.controller.SMZTController;
	import project.model.platform.AwardYellowInfo;
	import project.model.platform.PlatformQQ;
	import project.utils.Reflection;
	import project.view.base.BaseSprite;
	import project.view.controls.ToolTip;
	
	/**
	 * 黄钻图标
	 * @author bbjxl 2013
	 */
	public class YellowIco extends MovieClip 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _ico:MovieClip;
		private var _year:MovieClip;
		private var _tp:ToolTip;
		//-----------------------数据---------------------------------
		private var _enable:Boolean;//是否允许点击
		private var _level:int;
		private var _isYear:Boolean;//是否是年黄钻
		//-----------------------事件--------------------------------
		public function YellowIco() 
		{
			_ico = Reflection.createInstance("yellowLevel") as MovieClip;
			_year = _ico["year"] as MovieClip;
			addChild(_ico);
			enable = true;
			_tp = ToolTip.getInstance();
			
		}
		
		private function mouseOverHandler(e:MouseEvent):void 
		{
			_tp.autoSize = false;
			_tp.show(this, "查看黄钻特权","");
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function updataUI(value:PlatformQQ):void {
			if (value == null) { this.visible = false; return; }
			
			if (value.is_yellow_vip && value.yellow_vip_level != 0) {
				//是黄钻
				this.visible = true;
				_ico.gotoAndStop(value.yellow_vip_level);
				}else {
					this.visible = false;
					}
					
			if (value.is_yellow_year_vip) {
				//是年黄钻
				_year.visible = true;
				}else {
					_year.visible = false;
					}
			}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (value) {
				this.mouseEnabled = true;
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, clickHandler);
				this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				}else {
					this.mouseEnabled = false;
					this.buttonMode = false;
					this.removeEventListener(MouseEvent.CLICK, clickHandler);
					this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
					}
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			this.gotoAndStop(value);
		}
		
		public function get isYear():Boolean 
		{
			return _isYear;
		}
		
		public function set isYear(value:Boolean):void 
		{
			_isYear = value;
			_year.visible = value;
				
		}
		/**
		 * 点击图标跳转到黄钻面板
		 * @param	e
		 */
		private function clickHandler(e:MouseEvent):void 
		{
			
			SMZTController.getInstance().getAwardYellowData(function (param:Object):void {
				AwardYellowInfo.getInstance().setData(param);//更新礼包信息
				QQYellowPanel.getInstance().show(true);
				})
		}
		
	}

}