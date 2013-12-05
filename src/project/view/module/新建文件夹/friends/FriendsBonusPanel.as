package project.view.module.friends 
{
	import com.bbjxl.load.MyImageLoad;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.ItemConfig;
	import project.config.LocalConfig;
	import project.controller.ApplicationController;
	import project.model.data.User;
	import project.model.friends.BonusModel;
	import project.model.friends.FriendsRowModel;
	import project.model.ModelLocator;
	import project.utils.CustomTool;
	import project.view.base.BaseTitleWindow;
	import project.view.module.cell.BaseIcoCellLoader;
	import com.greensock.core.*;
	import com.greensock.easing.*;
	import com.greensock.*;
	import flash.events.MouseEvent;
	/**
	 * .好友任务面板
	 * @author bbjxl 2012
	 */
	public class FriendsBonusPanel extends BaseTitleWindow 
	{
		private var _image:MyImageLoad;//任务图片
		private var _imageContainer:Sprite;//图片容器
		private var _nameText:TextField;//任务名称 
		private var _contentText:TextField;//任务内容
		private var _bonusText:TextField;//奖励
		private var _bonusModle:BonusModel;
		private var _id:int;//随机事件编号
		
		private static var _frendsBonusPanel:FriendsBonusPanel;
		
		
		public function FriendsBonusPanel() 
		{
			
			if (_frendsBonusPanel != null)
            {
                throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
            }
			setSpriteInstance("friendsBonusPanel");
			configerUIInstance();
		}
		//--------------------------------------------------------
		private function configerUIInstance():void 
		{
			_nameText = getChild("nameText") as TextField;
			_contentText = getChild("contentText") as TextField;
			_bonusText = getChild("bonusText") as TextField;
			var tf:TextFormat = new TextFormat();
			var a = Font.enumerateFonts(); 
			trace(a[0].fontName); 
			tf.font = a[0].fontName; 
			_bonusText.defaultTextFormat = tf;
			_bonusText.embedFonts = false;
			_bonusText.antiAliasType = FontType.DEVICE;
			
			_bonusText.defaultTextFormat = tf;
			
			_bonusModle = new BonusModel();
			
			_imageContainer = new Sprite();
			_imageContainer.x = 70.85;
			_imageContainer.y = 80.05;
			addChild(_imageContainer);
		}
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
				this.y = (ApplicationConfig.STAGE_HEIGHT -_spriteInstance.height) / 2 - 40;
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
		public function updataUI(param:Object, param2:FriendsRowModel,bonusId:int):void {
			_bonusModle.setData(param.bonus);
			_id = bonusId;
			_nameText.htmlText =LocalConfig.LOCAL_LAN.FriendBonuses.FriendBonus.(@ID == _id).Title;
			var tempContentStr:String=LocalConfig.LOCAL_LAN.FriendBonuses.FriendBonus.(@ID == _id).Desc;
			_contentText.htmlText = tempContentStr.replace("{UserName}", "<font color = \'#1BF725\'>" + param2.name + "</font>");
			_bonusText.text = _bonusModle.returnBonusText();
			
			//任务图片
			if (_image && _image._bitmap) {
				_image._bitmap.bitmapData.dispose();
				}
			while (_imageContainer.numChildren > 0) {
				if (_imageContainer.getChildAt(0) is Bitmap) {
					(_imageContainer.getChildAt(0) as Bitmap).bitmapData.dispose();
					}
				_imageContainer.removeChildAt(0);
				}
			_image = new MyImageLoad(ModelLocator.getInstance().staticURL+"images/FriendBonus/"+CustomTool.turn000Num(bonusId)+".jpg",162,127);
			_image.addEventListener(MyImageLoad.LOADIMAGEOVER,loadover);
			function loadover(e:Event):void {
				_imageContainer.addChild(_image._bitmap);
				}
			}
		
		//--------------------------------------------------------
		public static function getInstance() : FriendsBonusPanel
		{
			if (_frendsBonusPanel == null)
			{
			  _frendsBonusPanel = new FriendsBonusPanel;
			}
			return _frendsBonusPanel; 
		}// end function
	}

}