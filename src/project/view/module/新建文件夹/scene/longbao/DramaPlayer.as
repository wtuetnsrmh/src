package project.view.module.scene.longbao
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import project.config.ApplicationConfig;
	import project.controller.NewBieControler;
	import project.core.SMZTUIManager;
	import project.model.longBao.LongBaoModel;
	import project.model.longBao.vo.StoryLevel;
	import project.model.longBao.vo.Talk;
	import project.model.newBie.NewBieModelId;
	import project.utils.Reflection;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSprite;
	import project.view.module.attack.AttackPanel;
	import project.view.module.attack.BattleReadyPanel;
	import project.view.module.helppane.NewbiePane;
	
	/**
	 *情节播放器
	 * @author bbjxl 2013
	 */
	
	/** 剧情播放完毕事件 */
	[Event(name="complete",type="flash.events.Event")]
	
	public class DramaPlayer extends BaseSprite
	{
		//----------------------容器---------------------------------
		private var _talkSp:Sprite;
		//-----------------------UI---------------------------------
		private var _dialog:Dialog;
		private var _skipBt:MovieClipButton; //跳过剧情
		//-----------------------数据---------------------------------
		private var _lastShowedIndex:Dictionary; //最后一句剧情显示完的索引
		private var _allTalkedIndex:Dictionary; //所有对话过的关卡对话索引
		private static const DRAMA_DELAY_TIME:int = 100;
		private var _currentStoryLevel:StoryLevel; //当前数据
		private var _talks:Vector.<Talk>;
		private var _index:int = 0;
		
		//-----------------------事件--------------------------------
		public function DramaPlayer()
		{
			
			_lastShowedIndex = new Dictionary();
			_allTalkedIndex = new Dictionary();
			_dialog = new Dialog();
			_dialog.onFinish = onDialogFinish;
			_dialog.useQuickFinish = true;
			_skipBt = Reflection.createInstance("skipBt") as MovieClipButton;
			_skipBt.x =614.6;
			_skipBt.y = 471.45;
			_skipBt.onClick = skipClick;
			_skipBt.visible = false;
			_talkSp = new Sprite();
			addChild(_talkSp);
			addChild(_skipBt);
		}
		
		/**
		 * 跳过剧情
		 * @param	e
		 */
		private function skipClick(e:MouseEvent):void
		{
			e.stopPropagation();
			skip();
		}
		
		private function onDialogFinish():void
		{
			
			this.addEventListener(MouseEvent.CLICK, onClick, true);
		}
		
		private function onClick(e:MouseEvent = null):void
		{
			if (e && e.target == _skipBt)
			{
				return
			}
			else
			{
				if(e) e.stopPropagation();
			}
			this.removeEventListener(MouseEvent.CLICK, onClick, true);
			
			//如果有战斗
			if (_dialog.talk.battle)
			{
				LongBaoModel.getInstance().currentChallengePassId = _currentStoryLevel.id;
				BattleReadyPanel.getInstance().show(true);
				BattleReadyPanel.getInstance().initUIByBattleModel(_currentStoryLevel.mode, BattleReadyPanel.LONG_BAO);
				//onDialogFinish();
				if (_talkSp.contains(_dialog))
				{
					_talkSp.removeChild(_dialog);
					_skipBt.visible = false;
				}
				
				//-------------------新手引导用-----------------------
				   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
				   NewbiePane.getInstance().show();
				   //NewBieControler.getInstance().nextStep();
				   }
				//--------------------end--------------------
				return;
			}
			
			index++;
			if (_talkSp.contains(_dialog))
			{
				_talkSp.removeChild(_dialog);
				_skipBt.visible = false;
			}
			
			start();
		}
		
		/**
		 * 战斗结束回调 
		 */
		public function attackOverCall():void {
			//如果当前所战斗完的关卡不是剧情所在的关卡,则刷新
			if (_currentStoryLevel==null || LongBaoModel.getInstance().currentChallengePassId != _currentStoryLevel.id) {
				dispatchEvent(new Event(Event.COMPLETE));
				return;
				}
			
			//如果没有剧情,就表示剧情结束
			if (_currentStoryLevel == null || _currentStoryLevel.talks==null || index>=_currentStoryLevel.talks.length-1) {
				//本关剧情结束
				dispatchEvent(new Event(Event.COMPLETE));
				return;
				}else if (AttackPanel.getInstance().result == 1) {
					//赢了剧情继续
					if (!_talkSp.contains(_dialog))
					{
						_talkSp.addChild(_dialog);
						_skipBt.visible = true;
					}
					index++;
					start();
					}else {
						//如果输了就自动体力减少
						LongBaoModel.getInstance().energy -= LongBaoModel.getInstance().challengCost;
						}
			}
		 
		/**
		 * 开始播放剧情
		 */
		public function start():void
		{
			
			if (_index > _talks.length-1)
			{
				//之前的剧情已经播放完时没战斗,现在再次进入判断是否有战斗（结尾有战斗）
				index = _talks.length;
				//如果有战斗
				if (_talks[_index-1].battle)
				{
					LongBaoModel.getInstance().currentChallengePassId = _currentStoryLevel.id;
					BattleReadyPanel.getInstance().show(true);
					BattleReadyPanel.getInstance().initUIByBattleModel(_currentStoryLevel.mode, BattleReadyPanel.LONG_BAO);
					//onDialogFinish();
					if (_talkSp.contains(_dialog))
					{
						_talkSp.removeChild(_dialog);
						_skipBt.visible = false;
					}
					
					//_index++;
					return;
				}
				//本关剧情结束
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}else {
				//之前剧情出现战斗时未战斗,现在再次进入时判断是否有战斗（中间有战斗）
				if (_talks[_index].battle && _talks[_index].showed)
				{
					LongBaoModel.getInstance().currentChallengePassId = _currentStoryLevel.id;
					BattleReadyPanel.getInstance().show(true);
					BattleReadyPanel.getInstance().initUIByBattleModel(_currentStoryLevel.mode, BattleReadyPanel.LONG_BAO);
					//onDialogFinish();
					if (_talkSp.contains(_dialog))
					{
						_talkSp.removeChild(_dialog);
						_skipBt.visible = false;
					}
					return;
				}else {
					_talks[_index].showed = true;
					_lastShowedIndex[_currentStoryLevel.id] = _index;
					_dialog.talk = _talks[_index];
					_dialog.startTalking();
					_talkSp.addChild(_dialog);
					_skipBt.visible = true;
					}
				}
			
		}
		
		/**
		 * 跳过剧情
		 */
		public function skip():void
		{
			_skipBt.visible = false;
			
			if (_talkSp.contains(_dialog))
				_talkSp.removeChild(_dialog);
			
			for (var i:int = index; i < _talks.length; i++)
			{
				//如果有战斗
				if (_talks[i].battle)
				{
					index = i;
					_talks[_index].showed = true;
					_lastShowedIndex[_currentStoryLevel.id] = _index;
					_dialog.talk = _talks[_index];
					_dialog.startTalking(true);
					
					//_talkSp.addChild(_dialog);
					onClick();
					//onDialogFinish(); //增加点击响应,防止出战设置直接关掉后可以点击场景再打开
					/*LongBaoModel.getInstance().currentChallengePassId = _currentStoryLevel.id;
					   BattleReadyPanel.getInstance().show(true);
					 BattleReadyPanel.getInstance().initUIByBattleModel(_currentStoryLevel.mode, BattleReadyPanel.LONG_BAO);*/
					return;
				}
			}
			
			//没有战斗则剧情结束
			_dialog.startTalking(true);
			index = _talks.length;
			start();
		}
		
		public function get currentStoryLevel():StoryLevel
		{
			return _currentStoryLevel;
		}
		
		public function set currentStoryLevel(value:StoryLevel):void
		{
			
			_currentStoryLevel = value;
			_talks = _currentStoryLevel.talks;
			//如果之前已经看过的剧情不再出现,直接跳过
			if (_allTalkedIndex[value.id])
			{
				_index = _allTalkedIndex[value.id];
			}
			else
			{
				index = 0;
			}
			
			//如果之前已经有显示过的剧情,则设置最后一条剧情为已显示
			if (_lastShowedIndex[value.id])
			{
				_talks[_lastShowedIndex[value.id]].showed = true;
			}
			
			start();
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
			_allTalkedIndex[_currentStoryLevel.id] = _index;
		}
	
	}

}