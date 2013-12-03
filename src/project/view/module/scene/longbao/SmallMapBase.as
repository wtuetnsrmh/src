package project.view.module.scene.longbao 
{
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import project.config.LocalConfig;
	import project.controller.NewBieControler;
	import project.model.longBao.LongBaoModel;
	import project.model.longBao.vo.Difficulty;
	import project.model.longBao.vo.StoryLevel;
	import project.model.ModelLocator;
	import project.model.newBie.NewBieModelId;
	import project.view.base.BaseSprite;
	import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.BaseIcoCellLoader;
	import project.view.module.cell.BaseIcoCellLoaderByte;
	import project.view.module.helppane.NewbiePane;
	import project.view.module.loading.LockScreen;
	
	/**
	 * 小地图
	 * @author bbjxl 2013
	 */
	public class SmallMapBase extends BaseSprite 
	{
		//----------------------容器---------------------------------
		private var _passContainer:Sprite;
		private var _bg:Sprite;
		private var _tipContainer:Sprite;
		//-----------------------UI---------------------------------
		private var _bgImage:BaseIcoCellLoaderByte;
		
		//-----------------------数据---------------------------------
		private var _passedNum:int = 0;//噩梦通过次数
		private var _data:XML;
		private var _passes:Vector.<PassBase>;
		private var _getAwardNum:int = 0;//领取宝箱要通过的关数
		//-----------------------事件--------------------------------
		public function SmallMapBase() 
		{
			_bg = new Sprite();
			addChild(_bg);
			_bgImage = new BaseIcoCellLoaderByte();
			_bgImage.showBg = false;
			_bgImage._callBack = updataUI;
			_bgImage._progressFun = progressFun;
			_bg.addChild(_bgImage);
			_passContainer = new Sprite();
			addChild(_passContainer);
			
			_tipContainer = new Sprite();
			_tipContainer.mouseEnabled = false;
			_tipContainer.mouseChildren = false;
			addChild(_tipContainer);
			PassTipPanel.getInstance().container = _tipContainer;
			
			_getAwardNum = int(LocalConfig.LOCAL_LAN.LongBaoPane.AWardTip.@num);
		}
		
		private function progressFun(e:ProgressEvent):void 
		{
			//trace(e.bytesLoaded/e.bytesTotal)
			
		}
		
		/**
		 * 设置各小关卡相应的数据
		 */
		private var _tempBgUrl:String;
		
		public function setData():void {
			
			_data = LocalConfig.LOCAL_LAN.LongBaoPane.chapter.(@id == LongBaoModel.getInstance().currentChapter)[0];
			
			
			var tempBgImageUrl:String = ModelLocator.getInstance().staticURL + _data.@bgImage[0].toXMLString();
			
			
				
			
			if (_tempBgUrl != tempBgImageUrl) {
				LockScreen.getInstance().show(true);
				_bgImage.ico = tempBgImageUrl;
				_tempBgUrl = tempBgImageUrl;
				}else {
					updataUI();
					}
				
			}
		
		private function updataUI():void {
			//-------------------新手引导用-----------------------
		   if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
		   NewbiePane.getInstance().show();
		   }
		   //--------------------end--------------------
			
			
			LockScreen.getInstance().hide();
			
			while (_passContainer.numChildren > 0) {
				_passContainer.removeChildAt(0);
				}
				
			_passedNum = 0;
				
			if (_passes)_passes = null;
			_passes = new Vector.<PassBase>();
			var temp:XML;
			for each(temp in _data.pass) {
				var pass:PassBase = new PassBase();
				pass.level = int(temp.@id);
				pass.chapterId = LongBaoModel.getInstance().currentChapter;
				pass.passName = String(temp.@name);
				pass.x = Number(temp.@setX);
				pass.y = Number(temp.@setY);
				_passes.push(pass);
				_passContainer.addChild(pass);
				}
				
			//设置探索奖励信息数据
			var minLevel:int = 1;//最小可打关卡
			var searchLevels:Vector.<StoryLevel> = LongBaoModel.getInstance().search;
			for (var n:int = 0; n < searchLevels.length; n++) {
				if (minLevel < searchLevels[n].level) {
					minLevel = searchLevels[n].level;
					}
				for (var m:int = 0; m < _passes.length;m++ )
				if (searchLevels[n].level==_passes[m].level) {
					_passes[m].searchStoryLevel = searchLevels[n];
					}
				}
			
			
			var levels:Vector.<StoryLevel> = LongBaoModel.getInstance().levels;
			for (var i:String in levels) {
				
				for (var j:String in _passes) {
					if (_passes[j].level == levels[i].level) {
						_passes[j].storyLevel = levels[i];
						if (int(i) == levels.length - 1  && levels[i].difficulty==Difficulty.EASY) {
							//最后一个关卡如果难度是普通，表示剧情所在关
							_passes[j].isLastPass = true;
							}
						break;
						}
					}
				}
			//如果全都通关则都设为通过
			if (levels.length == 0) {
				minLevel = _passes.length;
				}
			//设置已经通过的关卡
			for (var n:int = 0; n < minLevel; n++ ) {
				if (_passes[n].storyLevel == null) {
					_passes[n].passed = true;
					_passedNum++;
					}
				}
				//--------------------------------------------------------
				//通过次数
				SmallMap.getInstance().passedNumText.text = _passedNum.toString();
				//宝箱状态
				if (_passedNum >=_getAwardNum) {
					//领取条件达到
					if (LongBaoModel.getInstance().earned) {
						//领过
						SmallMap.getInstance().bonusBox.setStatue(2);
						}else {
							SmallMap.getInstance().bonusBox.setStatue(1);
							}
					}else {
						SmallMap.getInstance().bonusBox.setStatue(0);
						}
				//--------------------------------------------------------
				
			
			}
			
			public function get passedNum():int 
			{
				return _passedNum;
			}
	}

}