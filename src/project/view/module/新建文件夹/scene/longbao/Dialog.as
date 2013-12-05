package project.view.module.scene.longbao 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.core.SMZTResourceManager;
	import project.core.SMZTUIManager;
	import project.model.longBao.vo.Talk;
	import project.model.ModelLocator;
	import project.utils.Reflection;
	import project.utils.XColor;
	import project.view.artplug.MovieClipButton;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.scene.longbao.Direction;
	import project.view.module.scene.longbao.RoleType;
	/** 
	 * 对话框组件
	 * @author
	 */ 
	
	public class Dialog extends Sprite 
	{ 
		/** 玩家姓名颜色 */
		public static const NAME_COLOR_PLAYER:uint = 0xF1D077;
		/** 敌人姓名颜色 */
		public static const NAME_COLOR_ENEMY:uint = 0xff0000;
		
		/** 当对话文字打印完毕后执行的回调函数 */
		public var onFinish:Function;
		
		private var _backgroundImage:DisplayObject;
		private var _direction:int = Direction.LEFT;
		
		private var _roleName:String;//角色名称
		private var _roleWords:String;//对话内容
		
		private var _roleHeadImage:Bitmap = new Bitmap();//左角色头像
		private var _roleHeadImageR:Bitmap = new Bitmap();//右角色头像
		private var _roleNameTF:TextField;//人物名称
		private var _mapName:TextField;//当前关卡名称
		private var _roleWordsTF:Typewriter = new Typewriter();//打字机
		private var _tfWidth:Number = 597.95;//对话文本宽度
		private var _useQuickFinish:Boolean;
		private var _hotArea:Sprite;//透明热区
		
		//private var _flipFlag:Boolean = true;//是否左边的角色头像要水平翻转
		//private var _headX:Number = 57;
		//private var _headW:Number = 192;
		//private var _headH:Number = 192;
		private var _talk:Talk;
		public function Dialog()
		{
			super();
			_hotArea = new Sprite();
			_hotArea.graphics.beginFill(0xffffff, 0);
			_hotArea.graphics.drawRect(0, 0, ApplicationConfig.STAGE_WIDTH, ApplicationConfig.STAGE_HEIGHT);
			_hotArea.graphics.endFill();
			addChild(_hotArea);
			
			addChild( _roleHeadImage );
			addChild( _roleHeadImageR );
			
			backgroundImage = Reflection.createInstance("dialogBg");
			_mapName = _backgroundImage["mapNameText"] as TextField;
			_roleNameTF = _backgroundImage["roleNameTF"] as TextField;
			
			_roleNameTF.autoSize = TextFieldAutoSize.LEFT;
			_roleNameTF.selectable = _roleNameTF.mouseEnabled = false;
			_mapName.selectable = _roleNameTF.mouseEnabled = false;
			
			
			//addChild( _roleNameTF );
			addChild( _roleWordsTF );
			//_roleNameTF.defaultTextFormat = new TextFormat("SimSun", 12, null, true);
			//_roleNameTF.textColor = 0xffff00;
			
			_roleWordsTF.width = _tfWidth;
			var format:TextFormat = new TextFormat("SimSun", 14, 0xffffff);
			format.leading = 5;
			_roleWordsTF.textfield.defaultTextFormat = format;
			
			updateDisplayList();
			
		}
		
		
		
		public function startTalking(quickFinish:Boolean = false ):void
		{
			
			if (quickFinish) {
				//跳过剧情时用,此时不需要回调onFinish()
				_roleWordsTF.removeEventListener(Event.COMPLETE, onComplete);
				_roleWordsTF.stopWriting(true);
				}else {
					_roleWordsTF.addEventListener(Event.COMPLETE, onComplete);
					_roleWordsTF.startWriting();
					}
			
		}

		private function onComplete( e:Event ):void
		{
			trace("对话完....")
			_roleWordsTF.removeEventListener(Event.COMPLETE, onComplete);
			
			if( onFinish != null )
				onFinish();
		}
		
		private function updateDisplayList():void
		{
			_backgroundImage.x = ApplicationConfig.STAGE_WIDTH - _backgroundImage.width >> 1;
			_backgroundImage.y = ApplicationConfig.STAGE_HEIGHT - _backgroundImage.height;
			if(_roleHeadImage.bitmapData){
			
			_roleHeadImage.x = 0;// -_roleHeadImage.width;
			_roleHeadImage.y = ApplicationConfig.STAGE_HEIGHT - _roleHeadImage.height;
			//_roleHeadImage.visible = true;
			}
			_roleWordsTF.x = _backgroundImage.x + 14.5;
			_roleWordsTF.y = _backgroundImage.y+_roleNameTF.y + 30;
			
			_roleHeadImageR.x = ApplicationConfig.STAGE_WIDTH - _roleHeadImageR.width;
			_roleHeadImageR.y =ApplicationConfig.STAGE_HEIGHT - _roleHeadImageR.height;
			
			
		}
		
		//水平翻转一个位图
        public static function flipHorizontal(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
        {
            var matrix:Matrix = new Matrix();
            matrix.a = -1;
            matrix.tx = bmpData.width;
            var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, transparent, fillColor);
            bmpData_.draw(bmpData, matrix);
            return bmpData_;
        }
        
        //垂直翻转一个位图
        public static function flipVertical(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
        {
            var matrix:Matrix = new Matrix();
            matrix.d = -1;
            matrix.ty = bmpData.height;
            var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, transparent, fillColor);
            bmpData_.draw(bmpData, matrix);
            return bmpData_;
        }
        
        //缩放位图
        public static function scaleBitmapData(bmpData:BitmapData, scaleX:Number, scaleY:Number):BitmapData
        {
            var matrix:Matrix = new Matrix();
            matrix.scale(scaleX, scaleY);
            var bmpData_:BitmapData = new BitmapData(scaleX * bmpData.width, scaleY * bmpData.height, true, 0);
            bmpData_.draw(bmpData, matrix);
            return bmpData_;
        }


		private function enableQuickFinish( enable:Boolean ):void
		{
			if( enable )
			{
				//if( this )
					this.addEventListener(MouseEvent.CLICK, onQuickFinish,true);
				this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
				this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			}
			else
			{
				//if( this )
					this.removeEventListener(MouseEvent.CLICK, onQuickFinish,true);
				this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
				this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			}
		}
		
		private function onAdded( e:Event ):void
		{
			this.addEventListener(MouseEvent.CLICK, onQuickFinish,true);
		}
		
		private function onRemoved( e:Event ):void
		{
			this.removeEventListener(MouseEvent.CLICK, onQuickFinish,true);
		}
		
		private function onQuickFinish( e:MouseEvent ):void
		{
			//e.stopPropagation();
			_roleWordsTF.stopWriting(true);
		}
		
		/** 背景图片 */
		public function get backgroundImage():DisplayObject
		{
			return _backgroundImage;
		}

		public function set backgroundImage(value:DisplayObject):void
		{
			
			if( value == null )
			{
				throw new Error("Dialog.backgroundImage can`t be null");
				return;
			}
			
			if( _backgroundImage != value )
			{
				if( _backgroundImage && this.contains(_backgroundImage) )
					this.removeChild(_backgroundImage);
				_backgroundImage = value;
				addChild( _backgroundImage );
				//_backgroundImage.y = ApplicationConfig.STAGE_HEIGHT - _backgroundImage.height;
			}
		}


		/** 人物头像 */
		/*public function set rolehead(value:BitmapData):void
		{
			_roleHeadImage.bitmapData = value;
			_roleHeadImage.width = _headW;
			_roleHeadImage.height = _headH;
			updateDisplayList();
			if( _backgroundImage )
			{
				_roleHeadImage.y = _backgroundImage.height - _roleHeadImage.height;
			}
		}*/

		/** 对话持续时间 */
		public function set talkDuration( value:Number ):void
		{
			_roleWordsTF.duration = value;
		}

		/** 角色姓名 */
		public function get roleName():String
		{
			return _roleName;
		}

		public function set roleName(value:String):void
		{
			_roleName = value;
			_roleNameTF.text = _roleName;
		}

		/** 对话文本 */
		public function get roleWords():String
		{
			return _roleWords;
		}

		public function set roleWords(value:String):void
		{
			_roleWords = value;
			_roleWordsTF.text = "     "+value;
		}

		public function set roleType(value:String):void
		{
			_roleNameTF.textColor = value == RoleType.ENEMY ? NAME_COLOR_ENEMY : NAME_COLOR_PLAYER;
		}

		/** 启用/关闭快速完成对话文字的打印工作。若启用，则会在点击鼠标时一次性打印完本次对话文字并执行onFinish方法(如果有的话) */
		public function get useQuickFinish():Boolean
		{
			return _useQuickFinish;
		}

		public function set useQuickFinish(value:Boolean):void
		{
			_useQuickFinish = value;
			
			enableQuickFinish(_useQuickFinish);
		}
		
		public function get talk():Talk 
		{
			return _talk;
		}
		//private var _leftPic:String;
		public function set talk(value:Talk):void 
		{
			
			_talk = value;
			roleWords = _talk.text;
			_roleNameTF.text = _talk.name;
			_mapName.text = _talk.mapName;
			
			XColor.reset(_roleHeadImage);
			XColor.reset(_roleHeadImageR);
			//_roleHeadImage.filters = null;
			_roleHeadImageR.bitmapData = null;
			_roleHeadImage.bitmapData = null;
			if (talk.rightPic) {
				loadHeadImage(talk.rightPic);
				}
			if (talk.leftPic) {
				loadHeadImage(talk.leftPic);
				}
			
		}
		
		private function loadHeadImage(loadImageUrl:String):void {
			SMZTResourceManager.getInstance().loadAssets(loadImageUrl, function addToContent(param:Loader,imageurl:String):void
				{
					if (imageurl==talk.rightPic) {
						//加载完成的是右边的头像
						_roleHeadImageR.bitmapData = flipHorizontal((param.content as Bitmap).bitmapData);
						if (talk.actor == 1) {
							
							XColor.setBrightness(_roleHeadImageR,-50);
							}
						}
					if (imageurl==talk.leftPic) {
						//加载完成的是左边的头像
						//_roleHeadImage.visible = false;
						_roleHeadImage.bitmapData = (param.content as Bitmap).bitmapData;
						if (talk.actor == 2) {
							XColor.setBrightness(_roleHeadImage,-50);
							}
						}
						
					updateDisplayList();
					}
					);
			}

	} 
} 