package lzm.starling.gestures
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	/**
	 * 双击单击判断 
	 * @author lzm
	 * 
	 */	
	public class DoubleTapAndTapGestures extends Gestures
	{
		private var _flag:Boolean=false;
		public function DoubleTapAndTapGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touches:Vector.<Touch>):void{
			for each(var touch:Touch in touches){
				if(touch.phase == TouchPhase.BEGAN){
					startPoint = new Point(touch.globalX,touch.globalY);
					_flag=false;
				}
				if(touch.phase == TouchPhase.ENDED && touch.tapCount == 2){
					_flag=true;
					var buttonRect:Rectangle = _target.getBounds(_target.stage);
					if (touch.globalX < buttonRect.x ||
						touch.globalY < buttonRect.y ||
						touch.globalX > buttonRect.x + buttonRect.width ||
						touch.globalY > buttonRect.y+ buttonRect.height ){
						return;
					}
					
					if(_callBack){
						if(_callBack.length == 0){
							_callBack();
						}else{
							_callBack("双击");
						}
					}
				}else{
//					_flag=false;
				}
				
			}
			
			//单击
			var tempFuc:Function=function():void{
				if(_flag)return;
				for each(var touch:Touch in touches){
					/*if(touch.phase == TouchPhase.BEGAN){
						startPoint = new Point(touch.globalX,touch.globalY);
					}else if(touch.phase == TouchPhase.MOVED){
						//					isMoved = true;
					}else */if(touch.phase == TouchPhase.ENDED){
						
						var endPoint:Point = new Point(touch.globalX,touch.globalY);
						if(Point.distance(startPoint,endPoint) > 5){
							return;
						}
						
						//					if(isMoved){
						//						isMoved = false;
						//						return;
						//					}
						
						var buttonRect:Rectangle = _target.getBounds(_target.stage);
						if (touch.globalX < buttonRect.x ||
							touch.globalY < buttonRect.y ||
							touch.globalX > buttonRect.x + buttonRect.width ||
							touch.globalY > buttonRect.y+ buttonRect.height ){
							return;
						}
						
						if(_callBack){
							if(_callBack.length == 0){
								_callBack();
							}else{
								_callBack("单击");
								_flag=true;
							}
						}
					}
				}
			}
			Main.mStarling.juggler.delayCall(tempFuc,.8);
		}
		
	}
}