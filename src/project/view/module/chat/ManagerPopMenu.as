package project.view.module.chat
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.core.AppliactionManager;
	import project.core.SMZTUIManager;
	import project.model.chat.HrefInfo;
	import com.riaidea.text.TextRenderer;
	/**
	 * 名字点击弹出菜单管理类
	 * @author bbjxl
	 */
	public class ManagerPopMenu
	{
		private var _menu:PopMenu;
		private var _currentRrefInfo:HrefInfo;
		private var _bg:Sprite;
		private static var _managePopMenu:ManagerPopMenu;
		
		public function ManagerPopMenu()
		{
			if (_managePopMenu != null)
			{
				throw(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
			}
			_menu = new PopMenu();
			/*_bg = new Sprite();
			_bg.graphics.beginFill(0xffffff, 0);
			_bg.graphics.drawRect(0, 0, ApplicationConfig.STAGE_WIDTH, ApplicationConfig.STAGE_HEIGHT);
			_bg.graphics.endFill();*/
			
			
		
		}
		
		private function rollOutHandler(e:MouseEvent):void 
		{
			//ChatPane.getInstance().addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_menu.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			//_menu.removeEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			hideMenu();
		}
		
		public function showMenu(param:HrefInfo):void
		{
			_menu.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			//ChatPane.getInstance().addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			//_menu.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			_currentRrefInfo = param;
			_menu.x = AppliactionManager.stage.mouseX-2;
			_menu.y = AppliactionManager.stage.mouseY-2;
			
			//SMZTUIManager.getInstance().mainPane.topLayer.addChild(_bg);
			//_bg.addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			SMZTUIManager.getInstance().mainPane.topLayer.addChild(_menu);
			//AppliactionManager.stage.addEventListener(MouseEvent.CLICK, stageClickHandler,true);
		}
		
		private function stageClickHandler(e:MouseEvent):void 
		{
			trace(e.type)
			//_bg.removeEventListener(MouseEvent.CLICK, stageClickHandler);
			//ManagerPopMenu.getInstance().hideMenu();
			
		}
		
		public function hideMenu():void
		{
			if(SMZTUIManager.getInstance().mainPane.topLayer.contains(_menu))
			SMZTUIManager.getInstance().mainPane.topLayer.removeChild(_menu);
			//if(SMZTUIManager.getInstance().mainPane.topLayer.contains(_bg))
			//SMZTUIManager.getInstance().mainPane.topLayer.removeChild(_bg);
		}
		
		public static function getInstance():ManagerPopMenu
		{
			if (!_managePopMenu)
			{
				_managePopMenu = new ManagerPopMenu;
			}
			return _managePopMenu;
		} // end function
		
		public function get currentRrefInfo():HrefInfo 
		{
			return _currentRrefInfo;
		}
		
		public function set currentRrefInfo(value:HrefInfo):void 
		{
			_currentRrefInfo = value;
		}
	}

}