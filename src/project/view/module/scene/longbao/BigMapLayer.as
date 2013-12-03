package project.view.module.scene.longbao
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import project.core.SMZTDomainManager;
	import project.core.SMZTResourceManager;
	import project.core.SMZTSoundManager;
	import project.model.longBao.LongBaoModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpritePane;
	import project.view.base.BaseSpriteSetUI;
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * 大地图层
	 * @author bbjxl 2013
	 */
	public class BigMapLayer extends BaseSpriteSetUI
	{
		//----------------------容器---------------------------------
		private var _mapSp:Sprite;
		//-----------------------UI---------------------------------
		private var _nextBt:MovieClipButton;
		private var _prevBt:MovieClipButton;
		//-----------------------数据---------------------------------
		private static const BIG_MAP_CONTENT_PASS:Array = [[0, 1, 2, 3], [4, 5, 6, 7]];//世界地图中各张地图包含的章
		private var _bigMaps:Vector.<BigMapBase>;
		private var _currentBigMap:BigMapBase;
		//private var _oldBigMap:BigMapBase;
		private var _currentChapter:int;//以0开始
		private var bigmapIndex:int;
		
		//-----------------------事件--------------------------------
		public function BigMapLayer()
		{
			setSpriteInstance("bigMapUI");
			configerInstance();
		}
		
		private function configerInstance():void
		{
			_nextBt = getChild("nextBt") as MovieClipButton;
			_prevBt = getChild("prevBt") as MovieClipButton;
			_prevBt.onClick = btClickHandler;
			_nextBt.onClick = btClickHandler;
			_nextBt.visible = _prevBt.visible = false;
			_mapSp = new Sprite();
			addChildAt(_mapSp,0);
			_bigMaps = new Vector.<BigMapBase>();
			_bigMaps.push(SMZTResourceManager.getInstance().getRes("bigMap1", SMZTDomainManager.getInstance().currentUIAppDomain) as BigMapBase)
			_bigMaps.push(SMZTResourceManager.getInstance().getRes("bigMap2", SMZTDomainManager.getInstance().currentUIAppDomain) as BigMapBase);
			_mapSp.addChild(_bigMaps[0]);
		}
		
		private function btClickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case _nextBt: 
					if (bigmapIndex < _bigMaps.length - 1)
					{
						bigmapIndex++;
						_currentBigMap = _bigMaps[bigmapIndex];
						tweenScene(_currentBigMap,1);
					}
					break;
				case _prevBt: 
					if (bigmapIndex >0)
					{
						bigmapIndex--;
						_currentBigMap = _bigMaps[bigmapIndex];
						tweenScene(_currentBigMap);
					}
					break;
			}
			
			setBtStatue();
		}
		
		/*显示指定场景
		 * @ param
		 * @ param
		 */
		public function tweenScene(param1:DisplayObject,type:int=0):void
		{
			var oldScene:DisplayObject;
			var onTweenSceneComplete:Function;
			var toDisplayScene:DisplayObject = param1;
			onTweenSceneComplete = function():void
			{
				_mapSp.removeChild(oldScene);
				//checkLoadInfo(toDisplayScene);
				toDisplayScene.x = 0;
				return;
			} // end function
			
			if (_mapSp.numChildren > 1)
			{
				return;
			}
			oldScene = _mapSp.getChildAt(0);
			switch(type) {
				case 0:
					toDisplayScene.x = -760;
					_mapSp.addChild(toDisplayScene);
					TweenLite.to(toDisplayScene, 0.4, {x: 0});
					TweenLite.to(oldScene, 0.4, {x: 760, onComplete: onTweenSceneComplete});
					break;
				case 1:
					toDisplayScene.x = 760;
					_mapSp.addChild(toDisplayScene);
					TweenLite.to(toDisplayScene, 0.4, {x: 0});
					TweenLite.to(oldScene, 0.4, {x: -760, onComplete: onTweenSceneComplete});
					break;
				}
			
			SMZTSoundManager.playSimpleSound("UI_SHUA");
			return;
		} // end function
		
		public function updata():void
		{
			if (LongBaoModel.getInstance().currentChapter == 0) return;
			
			_currentChapter = LongBaoModel.getInstance().chapter - 1;
			_currentChapter = (_currentChapter < 0)?0:_currentChapter;
			bigmapIndex = returnBigMapIndex(_currentChapter);
			while (_mapSp.numChildren > 0)
			{
				_mapSp.removeChildAt(0);
			}
			//if(_oldBigMap==null)_oldBigMap=_bigMaps[bigmapIndex];
			_currentBigMap = _bigMaps[bigmapIndex];
			_currentBigMap.x = 0;
			_mapSp.addChild(_currentBigMap);
			
			setPassStatue();
			
			setBtStatue();
		}
		
		/**
		 * 设置各关卡入口状态
		 * 当前关卡之后的关卡为未激活
		 */
		private function setPassStatue():void 
		{
			var temp:Array = BIG_MAP_CONTENT_PASS[bigmapIndex];
			for (var i:int = 0; i < temp.length; i++ ) {
				if (temp[i] <= _currentChapter) {
					(_currentBigMap["pass" + temp[i]] as BigPassBase).enable = true;
					}else {
						(_currentBigMap["pass" + temp[i]] as BigPassBase).enable = false;
						}
				}
			
		}
		
		private function setBtStatue():void
		{
			//设置上下按钮的状态	
			if (bigmapIndex == _bigMaps.length - 1)
			{
				_nextBt.visible = false;
				_prevBt.visible = true;
			}
			else if (bigmapIndex == 0)
			{
				_nextBt.visible = true;
				_prevBt.visible = false;
			}
			else
			{
				_nextBt.visible = true;
				_prevBt.visible = true;
			}
		}
		
		/**
		 * 根据当前章的ID返回相应所在的大地图ID
		 */
		private function returnBigMapIndex(chapterId:int):int
		{
			for (var i:int = 0; i < BIG_MAP_CONTENT_PASS.length; i++ ) {
				var temp:Array = BIG_MAP_CONTENT_PASS[i];
				var tempL:int = temp.length;
				if (chapterId <=temp[tempL-1]) {
					return i;
					}
				}
			
			return 0;
		}
	}

}