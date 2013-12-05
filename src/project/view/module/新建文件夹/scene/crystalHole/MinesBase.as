package project.view.module.scene.crystalHole 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.config.LocalConfig;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.crystalHole.Mine;
	import project.model.crystalHole.MineType;
	import project.model.data.DataModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.events.SMZTDataChangeEvent;
	import project.view.controls.ToolTip;
	/**
	 * 矿体
	 * @author bbjxl 2013
	 */
	public class MinesBase extends BaseSpriteSetUI 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _canRob:MovieClipButton;
		private var _canOccupy:MovieClipButton;
		private var _isFreindsMc:MovieClipButton;
		private var _userNameText:TextField;
		private var tt:ToolTip;
		//-----------------------数据---------------------------------
		private var _mineModel:Mine;
		//-----------------------事件--------------------------------
		public function MinesBase() 
		{
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			
			this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.7;
            this.tt.cornerRadius = 0;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 4211070;
            this.tt.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_1;
		}
		/**
		 * 点击显示弹窗
		 * @param	e
		 */
		private function clickHandler(e:MouseEvent):void 
		{
			SMZTController.getInstance().getPointMine(_mineModel.id, function(param:Object):void { 
				var temp:Mine = new Mine();
				temp.setData(param);
				ShowHoleDetailWin.getInstance().show(true);
				ShowHoleDetailWin.getInstance().updataUI(temp);
				} );
			
		}
		
		public function setspriteInstance(param1:*):void
		{
			this._spriteInstance =param1;// SMZTResourceManager.getInstance().getRes(param1, SMZTDomainManager.getInstance().currentUIAppDomain) as Sprite;
			addChild(_spriteInstance);
			
			_canOccupy = getChild("canOccupy") as MovieClipButton;
			_canRob = getChild("canRob") as MovieClipButton;
			_isFreindsMc = getChild("isFreindsMc") as MovieClipButton;
			_canOccupy.buttonMode = false;
			_canRob.buttonMode = false;
			_isFreindsMc.buttonMode = false;
			_canOccupy.toolTip=LocalConfig.LOCAL_LAN.CrystalHolePane.OccupyTip.@Text;
			_canRob.toolTip= LocalConfig.LOCAL_LAN.CrystalHolePane.RobTip.@Text;
			_isFreindsMc.toolTip=LocalConfig.LOCAL_LAN.CrystalHolePane.FriendsTip.@Text;
			_userNameText = getChild("userNameText") as TextField;
			_userNameText.mouseEnabled = false;
			_userNameText.mouseWheelEnabled = false;
			
			spriteInstance["type"].addEventListener(MouseEvent.MOUSE_OVER, showMineTip);
		}
		
		private function showMineTip(event:MouseEvent):void {
			tt.autoSize = true;
			try {
				this.tt.show(this, "", "<font color='#ffffff'>"+MineType.returnTypeCName(_mineModel.type)+"</font>");
				}catch (e:TypeError) {
					//trace(e.message);
					}
			
			}
		
		/**
		 * 更新矿点UI
		 * @param	event
		 */
		public function updataUI(value:Mine):void
		{
			_mineModel = value;
			spriteInstance["type"].gotoAndStop(value.type);
			//宝石矿不开放
			if (value.type == MineType.GEM) {
				_isFreindsMc.visible = false;
				_canOccupy.visible = false;
				_canRob.visible = false;
				_userNameText.text = "未开放";
				return;
				}
			
			_isFreindsMc.visible = value.isFriend;
			_canOccupy.visible = (value.occupyCd == 0)?true:false;
			if (value.robCd == 0 && value.owner != null && value.occupyLeft != 0) {
				_canRob.visible = true;
				}else {
					_canRob.visible = false;
					}
			_userNameText.text = (value.owner == null)?ShowHoleDetailWin.replaceStr:value.owner.nick;
			return;
		} // end function
		
		public function get mineModel():Mine 
		{
			return _mineModel;
		}
		
		public function set mineModel(value:Mine):void 
		{
			_mineModel = value;
		}
	}

}