package project.view.module.friends 
{
	import flash.display.MovieClip;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.ItemConfig;
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.PlayerData;
	import project.model.friends.FriendsInforModel;
	import project.model.ModelLocator;
	import project.utils.Browser;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	import project.view.module.cell.BaseIcoCellLoader;
	import com.greensock.core.*;
	import com.greensock.easing.*;
	import com.greensock.*;
	import flash.events.MouseEvent;
	import project.view.module.chat.ChatPane;
	import project.view.module.platform.YellowIco;
	/**
	 * 好友个人信息面板
	 * @author bbjxl 2012
	 */
	public class FriendsInfoPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _headImage:BaseIcoCellLoader;//头像
		private var _chatBt:MovieClipButton;//私聊
		private var _enterBt:MovieClipButton;
		private var _nameText:TextField;
		private var _leveText:TextField;
		private var _expText:TextField;
		private var _nickText:TextField;//称号
		private var _achiText:TextField;//成就
		private var _layerText:TextField;
		private var _skycityText:TextField;
		//private var _deckNameText:TextField;
		private var _star5Text:TextField;
		private var _star4Text:TextField;
		private var _star3Text:TextField;
		private var _star2Text:TextField;
		private var _csText:TextField;
		private var _msText:TextField;
		private var _ssText:TextField;
		private var _vipico:MovieClip;//VIP图标
		private var _expBar:MovieClip;//进度条
		
		private var _yellowIco:YellowIco;
		//-----------------------数据---------------------------------
		private var _friendsInforModel:FriendsInforModel;
		//-----------------------事件--------------------------------
		private static var _friendsInfoPanel:FriendsInfoPanel;
		public function FriendsInfoPanel() 
		{
			if (_friendsInfoPanel != null) {
				throw Error(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
			setSpriteInstance("friendsInforPanel");
			configerUiInstance();
			_friendsInforModel = FriendsInforModel.getInstance();
			dataModel = _friendsInforModel;
		}
		/**
		 * 居中显示
		 * @param	param1
		 */
		public function showCenter(param1:Boolean = false):void
		{
			if (isOpened)
			{
			}
			else if (rootContainer)
			{
				if (param1)
				{
					drawModalRect();
				}
				rootContainer.addChild(this);
				this.x = ApplicationConfig.STAGE_WIDTH - _spriteInstance.width >> 1;
				this.y = ((ApplicationConfig.STAGE_HEIGHT -_spriteInstance.height) >>1) - 40;
				if (showEffect)
				{
					this.alpha = 0.5;
					TweenLite.to(this, 0.3, {alpha: 1, y: this.y + 40});
				}
				this.isOpened = true;
				this.isPopUP = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
			}
			this.playShowSound();
			return;
		} // end function
		override public function show(param1:Boolean = false):void
		{
			if (isOpened)
			{
			}
			else if (rootContainer)
			{
				if (param1)
				{
					drawModalRect();
				}
				rootContainer.addChild(this);
				this.x = 63;
				this.y = ((ApplicationConfig.STAGE_HEIGHT -_spriteInstance.height)>>1) - 40;
				if (showEffect)
				{
					this.alpha = 0.5;
					TweenLite.to(this, 0.3, {alpha: 1, y: this.y + 40});
				}
				this.isOpened = true;
				this.isPopUP = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
				
				if (closeButton) {
					ApplicationController.pushWin(this);
					}
			}
			this.playShowSound();
			return;
		} // end function
		
		private function configerUiInstance():void 
		{
			_headImage = new BaseIcoCellLoader();
			_headImage.showBg=false;
			_headImage.restrictHW=67;
			_headImage.setLocation(51.1, 47.85);
			addChild(_headImage);
			
			_chatBt = getChild("chatBt") as MovieClipButton;
			_enterBt = getChild("enterBt") as MovieClipButton;
			_enterBt.visible = false;
			_chatBt.onClick = clickHandler;
			_chatBt.toolTip = "私聊";
			_enterBt.onClick = clickHandler;
			_nameText = getChild("nameText") as TextField;
			_nameText.autoSize = TextFieldAutoSize.LEFT;
			_leveText = getChild("leveText") as TextField;
			_expText = getChild("expText") as TextField;
			_nickText = getChild("nickText") as TextField;
			_achiText = getChild("achiText") as TextField;
			_layerText = getChild("layerText") as TextField;
			//_deckNameText = getChild("deckNameText") as TextField;
			_skycityText = getChild("skycityText") as TextField;
			_star5Text = getChild("star5Text") as TextField;
			_star4Text = getChild("star4Text") as TextField;
			_star3Text = getChild("star3Text") as TextField;
			_star2Text = getChild("star2Text") as TextField;
			_csText = getChild("csText") as TextField;
			_msText = getChild("msText") as TextField;
			_ssText = getChild("ssText") as TextField;
			_vipico = getChild("vipico") as MovieClip;
			var vipX:Number = _nameText.x + _nameText.textWidth + 10;
			_vipico.x =vipX;
			/*if(vipX<(_nameText.x +121)){
			_vipico.x =vipX;
			}else {
				_vipico.x =_nameText.x +121;
				}*/
			_expBar = getChild("expBar") as MovieClip;
			
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _chatBt:
					//私聊
					ChatPane.getInstance().comboBox.selectedCellById(1);
					ChatPane.getInstance().currentPrivateChatUserId = _friendsInforModel.user.userId;
					ChatPane.getInstance().currentPrivateChatUserName = _friendsInforModel.user.nick;
					if (!ChatPane.getInstance().currentOpened) {
						ChatPane.getInstance().openBtClickHandler();
						}
					hide();
					break;
				case _enterBt:
					Browser.visiteInfo(_friendsInforModel.user.snsName);
					break;
				}
		}
		//--------------------------------------------------------
		override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			if (_friendsInforModel.user.userId == PlayerData.getInstance().userId) {
				_chatBt.visible = false;
				}else {
					_chatBt.visible = true;
					}
			
			_expBar.gotoAndStop(_friendsInforModel.user.expRatio);
			_headImage.ico = _friendsInforModel.user.avatar;
			_nameText.text = _friendsInforModel.user.nick;
			_nameText.width = 76.8;
			
			_leveText.text = _friendsInforModel.user.level.toString();
			_expText.text = _friendsInforModel.user.expStr;
			var tempTitle:String = (ItemConfig.ACHV_CONFIG.Achievement.(@ID == _friendsInforModel.user.title)).Title;
			_nickText.text = (_friendsInforModel.user.title==0)?"无":(tempTitle=="")?"无":tempTitle;
			_achiText.text = _friendsInforModel.statistics.achv.toString();
			_layerText.text = _friendsInforModel.statistics.tower.toString();
			//_deckNameText.text = _friendsInforModel.statistics.tower;
			_skycityText.text = _friendsInforModel.statistics.ladder.toString();
			_star5Text.text = _friendsInforModel.statistics.stars[4].toString();
			_star4Text.text = _friendsInforModel.statistics.stars[3].toString();
			_star3Text.text = _friendsInforModel.statistics.stars[2].toString();
			_star2Text.text = _friendsInforModel.statistics.stars[1].toString();
			_csText.text = _friendsInforModel.statistics.qualities[5].toString();
			_msText.text = _friendsInforModel.statistics.qualities[4].toString();
			_ssText.text = _friendsInforModel.statistics.qualities[3].toString();
			var vipX:Number = _nameText.x + _nameText.textWidth + 10;
			_vipico.x =vipX;
			/*if(vipX<(_nameText.x +76)){
			_vipico.x =vipX;
			}else {
				_vipico.x =_nameText.x +76;
				}*/
				
			if (_friendsInforModel.user.vipLevel > 0) {
				_vipico.visible = true;
				_vipico.gotoAndStop(_friendsInforModel.user.vipLevel);
				}else {
					_vipico.visible = false;
					}	
					
			//--------------------黄钻------------------------------------
			if (_friendsInforModel.user.pfqq != null) {
				if (_yellowIco == null) {
					_yellowIco = new YellowIco();
					addChild(_yellowIco);
					_yellowIco.updataUI(_friendsInforModel.user.pfqq);
					}else {
						_yellowIco.updataUI(_friendsInforModel.user.pfqq);
						}
					if (_vipico.visible) {
						_yellowIco.x = _vipico.x + _vipico.width;
						_yellowIco.y = 42.35;
						}else {
							_yellowIco.x = _vipico.x;
							_yellowIco.y = 42.35;
							}
					
				}else {
					if (_yellowIco && contains(_yellowIco)) {
						_yellowIco.visible = false;
						}
					}
			//--------------------------------------------------------
			
			ApplicationConfig.setAppTextFormat(_nameText,_leveText,_expText,_nickText,_achiText,_layerText,_skycityText,_star5Text,_star4Text,_star3Text,_star2Text,_csText,_msText,_ssText);
			
            return;
        }// end function
		
		//--------------------------------------------------------
		public static function getInstance() : FriendsInfoPanel
		{
			if (_friendsInfoPanel == null)
			{
			  _friendsInfoPanel = new FriendsInfoPanel;
			}
			return _friendsInfoPanel; 
		}// end function
	}

}