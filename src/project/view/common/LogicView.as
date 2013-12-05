package project.view.common
{
	import com.greensock.easing.Quad;
	import khaos.interfaces.IamView;
	import khaos.view.ViewMgr;
	import starling.core.Starling;
	
	import project.view.scene.BaseScene;
	
	import starling.display.Sprite;
	
	public class LogicView extends BaseScene implements IamView
	{
		private var _showEffect:Boolean = false;//是否显示缓动效果
		private var _viewParam:* = null; //面板显示参数
		
		protected var container:Sprite = null;
		
		protected var _viewType:int = -1;
		
		protected var _isAtBottom:Boolean;
		protected var modal:Sprite;//鼠标不响应区域
		protected var _maskQuad:Quad;
		public function LogicView(viewType_:int, bottom:Boolean = false)
		{
			super();
			_viewType = viewType_;
			_isAtBottom = bottom;
			container = ViewMgr.getInstance().getContainer(_viewType) as Sprite;
			this.visible = false;
			initUI();
		
		}
		
		//初始化UI
		public function initUI():void
		{
		
		}
		
		//如果当前模块有单独的ui tx则这里构建此tx相关的ui界面,每次internalShow都要调用
		protected function cardTexturUI():void
		{
		
		}
		
		protected function disposeTexturUI():void
		{
		
		}
		
		protected function internalHide():void
		{
			throw new ArgumentError("This function is not implemented!");
		}
		
		protected function internalShow():void
		{
			throw new ArgumentError("This function is not implemented!");
		}
		
		public function show(param1:Boolean = false):void
		{
			if (this.visible)
				return;
			if (param1)
			{
				drawModalRect();
			}
			registerMe();
			this.visible = true;
			internalShow();
			if (this.parent != null)
			{
				this.parent.setChildIndex(this, this.parent.numChildren - 1); //最上面
			}
			if (this._showEffect)
			{
				this.alpha = 0.5;
				Starling.juggler.tween(this, 0.2, { alpha:1, y:this.y + 40 });
				//TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
			}
		}
		
		//屏蔽鼠标响应的sprite
        protected function drawModalRect() : void
        {
            if (this.modal == null)
            {
                this.modal = new Sprite();
				_maskQuad = new Quad(ApplictionConfig.STAGE_WIDTH, ApplictionConfig.STAGE_HEIGHT, 0x000000);
				_maskQuad.alpha = 0.3;
            }
			modal.addChild(_maskQuad);
            this.addChildAt(modal, 0);
        }// end function
		
		public function hide():void
		{
			internalHide();
			this.visible = false;
		
		}
		
		public function set viewType(value:int):void
		{
			_viewType = value;
		}
		
		public function get viewType():int
		{
			return _viewType;
		}
		
		public function set showParam(value:Object):void
		{
			_viewParam = value;
		}
		
		public function get showParam():Object
		{
			return _viewParam;
		}
		
		protected function registerMe():void
		{
			/*if(container.contains(this))
			   {
			   this.visible = false;
			   }
			 */
			if (!container.contains(this))
			{
				if (_isAtBottom)
					container.addChildAt(this, 0);
				else
					container.addChild(this);
			}
		}
		
		public function moveTop():void
		{
			container.addChild(this);
		}
		
		public function isVisible():Boolean
		{
			return this.visible;
		}
		
		public function get posx():Number
		{
			return this.x;
		}
		
		public function get posy():Number
		{
			return this.y;
		}
		
		public function get showEffect():Boolean 
		{
			return _showEffect;
		}
		
		public function set showEffect(value:Boolean):void 
		{
			_showEffect = value;
		}
	}
}