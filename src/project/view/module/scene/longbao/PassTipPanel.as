package project.view.module.scene.longbao
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.config.LocalConfig;
	import project.model.longBao.LongBaoModel;
	import project.utils.Reflection;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * ...
	 * @author bbjxl 2013
	 */
	public class PassTipPanel extends BaseSpriteSetUI
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _ui:Sprite;
		private var _reportText:TextField;
		private var _passReportText:TextField;//过关条件
		private var _difficultText:TextField;
		private var _passBonusText:TextField;//过关奖励
		private var _goldBonusText:TextField;//探索金币荣誉奖励
		private var _bonusText:TextField;//探索奖励
		//-----------------------数据---------------------------------
		private var _passReport:String; //过关条件
		private var _report:String; //当前评价
		private var _difficult:String; //当前难度
		private var _bonus:String; //当前奖励信息
		private var _goldBonus:String; //探索金币荣誉奖励
		private var _passBonus:String; //当前奖励信息
		private var _container:DisplayObjectContainer;
		//-----------------------事件--------------------------------
		private static var _passTipPanel:PassTipPanel;
		
		public function PassTipPanel()
		{
			if (_passTipPanel != null)
			{
				throw new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE);
			}
			configerinstance();
		}
		
		public static function getInstance() : PassTipPanel
		{
			if (_passTipPanel == null)
			{
			  _passTipPanel = new PassTipPanel;
			}
			return _passTipPanel; 
		}// end function
		public function show():void
		{
			if (_container)
			{
				_container.addChild(this);
				var _data:XML = LocalConfig.LOCAL_LAN.LongBaoPane.chapter.(@id == LongBaoModel.getInstance().currentChapter)[0];
				this.y = Number(_data.@tipY);
				this.x =  Number(_data.@tipX);
			}
		}
		
		public function hide():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		private function configerinstance():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_ui = Reflection.createInstance("passTipPanelUI") as Sprite;
			addChild(_ui);
			_passReportText = _ui.getChildByName("passReportText") as TextField;
			_reportText = _ui.getChildByName("reportText") as TextField;
			_difficultText = _ui.getChildByName("difficultText") as TextField;
			_bonusText = _ui.getChildByName("bonusText") as TextField;
			_goldBonusText = _ui.getChildByName("goldBonusText") as TextField;
			_passBonusText = _ui.getChildByName("passBonusText") as TextField;
		}
		
		public function get report():String
		{
			return _report;
		}
		
		public function set report(value:String):void
		{
			_report = value;
			_reportText.text = value;
		}
		
		public function get difficult():String
		{
			return _difficult;
		
		}
		
		public function set difficult(value:String):void
		{
			_difficult = value;
			_difficultText.text = value;
		}
		
		public function get bonus():String
		{
			return _bonus;
		}
		
		public function set bonus(value:String):void
		{
			_bonus = value;
			_bonusText.htmlText = value;
		}
		
		public function get container():DisplayObjectContainer
		{
			return _container;
		}
		
		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}
		
		public function get passBonus():String 
		{
			return _passBonus;
		}
		
		public function set passBonus(value:String):void 
		{
			_passBonus = value;
			_passBonusText.htmlText = value;
		}
		
		public function get goldBonus():String 
		{
			return _goldBonus;
		}
		
		public function set goldBonus(value:String):void 
		{
			_goldBonus = value;
			_goldBonusText.htmlText = value;
		}
		
		public function get passReport():String 
		{
			return _passReport;
		}
		
		public function set passReport(value:String):void 
		{
			_passReport = value;
			_passReportText.htmlText = value;
		}
	
	}

}