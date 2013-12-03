package project.view.module.scene.crystalHole
{
	/**
	*描述：水晶矿洞
	*
	*/
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.core.SMZTUIManager;
	import project.events.SMZTDataChangeEvent;
	import project.model.crystalHole.CrystalHoleModel;
	import project.model.data.PlayerData;
	import project.view.artplug.MovieClipButton;
	import project.view.artplug.MovieClipButtonNoSound;
	import project.view.controls.ToolTip;
	import project.view.module.scene.base.BaseGameScene;
	import project.view.module.scene.main.MainScene;

    public class CrystalHoleScene extends BaseGameScene
    {
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _openBt:MovieClipButton;
		private var _staminaText:TextField; //当前剩余活力
		private var _assistText:TextField; //当前剩余协助次数
		
		private var _myMineUI:Sprite;
		private var _controlBarUI:Sprite;
		private var _mines:Vector.<MinesBase>;
		
		private var _myMine:MyMineWin;//我的矿体
		private var _controlBar:ControlBar;//控制面板
		//-----------------------数据---------------------------------
		public static var firstLoad:Boolean = true;//是否是第一次加载
		private var _crystalHoleModel:CrystalHoleModel;
		public static const _minesNum:int = 12;
		private var _timer:Timer = new Timer(1000);
		
		private var _currentAreaId:int = 1;//当前矿区（页码）
		//-----------------------事件--------------------------------
        public function CrystalHoleScene()
        {
			
            rubishPosArr = [[360, 300], [411, 198], [646, 261]];
            sceneId =MainScene.CRYSTAL_HOLE_SCENE;
            setSpriteInstance("crystalHoleScene");
			
			_crystalHoleModel = CrystalHoleModel.getInstance();
			dataModel = _crystalHoleModel;
			dataModel.addEventListener(SMZTDataChangeEvent.ON_DATA_REFRESH, updataMyMineUI);
			
			SMZTUIManager.getInstance().crystalHoleScene = this;
			configinstance();
            return;
        }// end function
		
		/**
		 * 更新我的矿体界面
		 * @param	e
		 */
		private function updataMyMineUI(e:SMZTDataChangeEvent):void 
		{
			_staminaText.text = _crystalHoleModel.stamina.toString();
			_assistText.text = _crystalHoleModel.assist.toString();
			
			_myMine.updataUI(_crystalHoleModel);
			
		}
		
		private function configinstance():void 
		{
			ShowHoleDetailWin.getInstance().rootContainer = SMZTUIManager.getInstance().mainPane.rootLayer;
			HoleRuleWin.getInstance().rootContainer= SMZTUIManager.getInstance().mainPane.rootLayer;
			
			_openBt = getChild("openBt") as MovieClipButton;
			//_openBt.visible = false;
			_openBt.onClick = openMyMine;
			_staminaText = getChild("staminaText") as TextField;
			_assistText = getChild("assistText") as TextField;
			
			//12个矿体
			_mines = new Vector.<MinesBase>(_minesNum);
			for (var i:int = 0; i < _minesNum; i++ ) {
				var temp:MinesBase = new MinesBase();
				temp.setspriteInstance(getChild("mines" + i));
				addChild(temp);
				_mines[i] = temp;
				temp = null;
				}
			
			//我的矿体
			_myMineUI = getChild("myMineUI") as Sprite;
			_myMine = new MyMineWin();
			_myMine.setspriteInstance(_myMineUI);
			_myMine.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, myMinePanelChange);
			_myMine.visible = false;
			addChild(_myMine);
			
			//控制面板
			_controlBarUI = getChild("controlBarUI")  as Sprite;
			_controlBar = new ControlBar();
			_controlBar.setspriteInstance(_controlBarUI);
			addChild(_controlBar);
		}
		
		private function openMyMine(e:MouseEvent):void 
		{
			_openBt.visible = false;
			_myMine.visible = true;
		}
		
		private function myMinePanelChange(e:SMZTDataChangeEvent):void 
		{
			_openBt.visible = true;
		}

		
		/**
		 * 自身数据模型变化时
		 * @param	event
		 */
        override protected function onDataChange(event:SMZTDataChangeEvent) : void
        {
			_currentAreaId = _crystalHoleModel.page;
			
            for (var i:int = 0; i < _crystalHoleModel.mines.length; i++ ) {
				_mines[i].updataUI(_crystalHoleModel.mines[i]);
				}
				
			if (!_timer.running) {
				_timer.start();
				}
        }// end function
		
		/**
		 * 帮助点击
		 * @param	event
		 */
        override public function showHelp(event:MouseEvent = null) : void
        {

        }// end function

        public function newbieOnly() : void
        {
            return;
        }// end function
		
		public function get timer():Timer 
		{
			return _timer;
		}
		
		public function set timer(value:Timer):void 
		{
			_timer = value;
		}
		
		public function get currentAreaId():int 
		{
			return _currentAreaId;
		}
		
		public function set currentAreaId(value:int):void 
		{
			_currentAreaId = value;
		}


    }
}
