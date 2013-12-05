package project.view.module.bagpanel 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.model.item.ItemModel;
	import project.model.shop.GoodsModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseTitleWindow;
	
	/**
	 * 物品鼠标移上显示的提示框
	 * @author bbjxl 2012
	 */
	public class BagPopPanel extends BaseTitleWindow 
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _nameText:TextField;
		private var _decText:TextField;
		
		//-----------------------数据---------------------------------
		private var _item:ItemModel;
		private var _locPoint:Point;
		//-----------------------事件--------------------------------
		private static var _bagPopPanel:BagPopPanel;
		public function BagPopPanel() 
		{
			if (_bagPopPanel != null)
			{
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
			}
			setSpriteInstance("BagPopPanel");
			configUiInstance();
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		//--------------------------------------------------------
		/*override public function show(param1:Boolean = false) : void
        {
            playUISound("UI_MOUSE_OVER");
            rootContainer.addChild(this);
            if (this.stage.mouseX > (ApplicationConfig.STAGE_WIDTH-this.width-20))
            {
                setLocation(ApplicationConfig.STAGE_WIDTH-this.width-20, this.stage.mouseY - 30);
            }
            else if (mouseY > (ApplicationConfig.STAGE_HEIGHT-this.height))
            {
                setLocation(this.stage.mouseX - 30, ApplicationConfig.STAGE_HEIGHT - this.height);
            }
            else
            {
                setLocation(this.stage.mouseX - 30, this.stage.mouseY - 30);
            }
            isOpened = true;
            isPopUP = true;
            //addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            return;
        }// end function
		private function onMouseOver(event:MouseEvent) : void
        {
            spriteInstance.addEventListener(MouseEvent.ROLL_OUT, hide);
            return;
        }// end function
		override public function hide(event:MouseEvent = null) : void
        {
			spriteInstance.removeEventListener(MouseEvent.ROLL_OUT, hide);
            if (rootContainer.contains(this))
            {
                rootContainer.removeChild(this);
            }
            isOpened = false;
            isPopUP = false;
            removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            return;
        }// end function*/
		//--------------------------------------------------------
		override public function show(param1:Boolean = false) : void
        {
            rootContainer.addChild(this);
           /* if (this.stage.mouseX > (ApplicationConfig.STAGE_WIDTH-this.width-20))
            {
                setLocation(ApplicationConfig.STAGE_WIDTH-this.width-20, _locPoint.y);
            }
            else
            {
                setLocation(_locPoint.x, _locPoint.y);
            }*/
			 setLocation(_locPoint.x, _locPoint.y);
            isOpened = true;
            isPopUP = true;
            //addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            //addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            return;
        }// end function
		override public function hide(event:MouseEvent = null) : void
        {
			
            if (rootContainer.contains(this))
            {
                rootContainer.removeChild(this);
            }
            isOpened = false;
            isPopUP = false;
            return;
        }
		
		/**
		 * 商场用赋值
		 * @param	param
		 */
		public function setDataByShop(param:GoodsModel, locY:Point):void {
			_locPoint = (locY);
			
			//_item = param;
			_nameText.text = param.name;
			_decText.text = param.des;
			/*_usedBt.visible = param.canUse;
			_sellBt.visible = param.canSell;
			if (!param.canUse && param.canSell) {
				_sellBt.x = (spriteInstance.width - _sellBt.width) >> 1;
				return;
				}else if(param.canUse && !param.canSell) {
					_usedBt.x = (spriteInstance.width - _usedBt.width) >> 1;
					return;
					}else {
						_usedBt.x = 29.7;
						_sellBt.x = 174.5;
						}*/
			}
		
		/**
		 * 赋值
		 * @param	param
		 */
		public function setData(param:ItemModel, locY:Point):void {
			_locPoint = (locY);
			
			_item = param;
			_nameText.text = param.name;
			_decText.text = param.description;
			/*_usedBt.visible = param.canUse;
			_sellBt.visible = param.canSell;
			if (!param.canUse && param.canSell) {
				_sellBt.x = (spriteInstance.width - _sellBt.width) >> 1;
				return;
				}else if(param.canUse && !param.canSell) {
					_usedBt.x = (spriteInstance.width - _usedBt.width) >> 1;
					return;
					}else {
						_usedBt.x = 29.7;
						_sellBt.x = 174.5;
						}*/
			}
			
		private function configUiInstance():void 
		{
			_nameText = getChild("nameText") as TextField;
			_decText = getChild("decText") as TextField;
			/*_usedBt = getChild("usedBt") as MovieClipButton;
			_sellBt = getChild("sellBt") as MovieClipButton;
			_usedBt.onClick = onClikcHandler;
			_sellBt.onClick = onClikcHandler;*/
			
			_nameText.mouseEnabled = false;
			_decText.mouseEnabled = false;
			spriteInstance["bg"].mouseEnabled = false;
			spriteInstance.mouseEnabled = false;
			spriteInstance.mouseChildren = false;
		}
		
		/*private function onClikcHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case _usedBt:
					UseItemControler.userItem(_item.id, _item.itemId);
					break;
				case _sellBt:
					break;
				default:
					break;
				}
		}*/
		//--------------------------------------------------------
		public static function getInstance() : BagPopPanel
		{
			if (_bagPopPanel == null)
			{
			  _bagPopPanel = new BagPopPanel;
			}
			return _bagPopPanel; 
		}// end function
	}

}