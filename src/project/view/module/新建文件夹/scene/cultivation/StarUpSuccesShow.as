package project.view.module.scene.cultivation 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.controller.NewBieControler;
	import project.core.SMZTUIManager;
	import project.model.item.CardModel;
	import project.model.newBie.NewBieModelId;
	import project.utils.Reflection;
	import project.utils.XColor;
	import project.view.base.BaseTitleWindow;
	import project.view.module.cell.Card;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	import project.view.module.helppane.NewbiePane;
	/**
	 *升星成功弹出显示卡牌
	 * @author bbjxl 2013
	 */
	public class StarUpSuccesShow extends BaseTitleWindow 
	{
		private var _currentCardId:int = 0;//当前显示的卡牌ID
		private var _front:Card;
		private var _bg:Card;
		private var _effectStarup:MovieClip;//升星成功的动画效果
		private var _startUpEffectBg:MovieClip;//升星成功的动画效果背景
		private var _cardContent:Sprite;
		
		private static var _clickPopCard:StarUpSuccesShow;
		public function StarUpSuccesShow() 
		{
			if (_clickPopCard != null) {
				throw(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
				
			_effectStarup = Reflection.createInstance("StarUPEffect");
			_startUpEffectBg = Reflection.createInstance("startUpEffectBg");
			
			_startUpEffectBg.visible = false;
			_startUpEffectBg.gotoAndStop(1);
			_startUpEffectBg.x = (ApplicationConfig.STAGE_WIDTH)>>1;
			_startUpEffectBg.y = (ApplicationConfig.STAGE_HEIGHT) >> 1;
			addChild(_startUpEffectBg);
			
			_effectStarup.visible = false;
			_effectStarup.gotoAndStop(1);
			_effectStarup.x = (ApplicationConfig.STAGE_WIDTH)>>1;
			_effectStarup.y = (ApplicationConfig.STAGE_HEIGHT) >> 1;
				
			_front = new Card();
			_bg = new Card();
			_bg.x = _front.x + ApplicationConfig.CARD_WIDTH;
			_cardContent = new Sprite();
			_cardContent.addChild(_front);
			_cardContent.addChild(_bg);
			addChild(_cardContent);
			
			addChild(_effectStarup);
			
			
		}
		public static function getInstance() : StarUpSuccesShow
		{
			if (_clickPopCard == null)
			{
			  _clickPopCard = new StarUpSuccesShow;
			}
			return _clickPopCard; 
		}// end function
		
		
		
		//--------------------------------------------------------
		override public function show(param1:Boolean = false) : void
        {
            if (isOpened)
            {
            }
            else if (rootContainer)
            {
                if (param1)
                {
                    drawModalRect();
                }
				//根据合成还是升星显示不同的颜色
				if (SMZTUIManager.getInstance().cultivationScene.currentSlectedTab == 0) {
					_effectStarup.gotoAndStop(2);
					}else {
						_effectStarup.gotoAndStop(1);
						}
				
                rootContainer.addChild(this);
				this.y = 0;
                _cardContent.x = (ApplicationConfig.STAGE_WIDTH - _cardContent.width) / 2;
                _cardContent.y = (ApplicationConfig.STAGE_HEIGHT - _cardContent.height) / 2;
                if (showEffect)
                {
                    TweenLite.from(_cardContent, .5, {x:ApplicationConfig.STAGE_WIDTH>>1,y:ApplicationConfig.STAGE_HEIGHT>>1,scaleX:0,scaleY:0});
                    TweenLite.from(_effectStarup, .5, {x:ApplicationConfig.STAGE_WIDTH>>1,y:ApplicationConfig.STAGE_HEIGHT>>1,scaleX:0,scaleY:0});
                    TweenLite.from(_startUpEffectBg, .5, {x:ApplicationConfig.STAGE_WIDTH>>1,y:ApplicationConfig.STAGE_HEIGHT>>1,scaleX:0,scaleY:0});
                }
                this.isOpened = true;
                this.isPopUP = true;
				
                if (stage){
					stage.addEventListener(MouseEvent.CLICK, stageC);
					}
					
				_effectStarup.visible = true;
				_startUpEffectBg.visible = true;
				_effectStarup.gotoAndPlay(1);
				_startUpEffectBg.gotoAndPlay(1);
            }
            this.playShowSound();
            return;
        }// end function
		
		//关闭
        override public function hide(event:MouseEvent = null) : void
        {
            if (rootContainer)
            {
				if (this.stage)
				{
					if (this.stage.hasEventListener(MouseEvent.CLICK))
					{
						this.stage.removeEventListener(MouseEvent.CLICK, this.stageC);
					}
				}
				//-------------------新手引导用-----------------------
				if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET]) {
					//NewBieControler.getInstance().nextStep();
					NewbiePane.getInstance().show();
					}
				//--------------------end--------------------
                if (modal != null && rootContainer.contains(modal))
                {
                    rootContainer.removeChild(modal);
                    modal = null;
                }
                if (showEffect)
                {
                    TweenLite.to(this, 0.3, {alpha:0.2, y:this.y - 40, onComplete:this.onTweenClose});
                }
                else
                {
                    if (rootContainer.contains(this))
                    {
                        rootContainer.removeChild(this);
                    }
                    this.isOpened = false;
                    this.isPopUP = false;
                }
            }
            playUISound("UI_WINDOW_CLOSE");
            return;
        }// end function
		
		/**
		 * 场景点击就隐藏
		 * @param	event
		 */
        protected function stageC(event:MouseEvent) : void
        {
            if (this.stage)
            {
                if (this.stage.hasEventListener(MouseEvent.CLICK))
                {
                    this.stage.removeEventListener(MouseEvent.CLICK, this.stageC);
                }
            }
            this.hide();
            return;
        }// end function
		
		//--------------------------------------------------------
		
		
		public function get currentCardId():int 
		{
			return _currentCardId;
		}
		
		public function set currentCardId(value:int):void 
		{
			_currentCardId = value;
			var temp:CardModel = new CardModel(value);
			_front.hideAll(true);
			_front._currentCardTye = 0;
			_front.setCardModel(temp);
			_bg.hideAll(true);
			_bg._currentCardTye = 3;
			_bg.setCardModel(temp);
			_bg.showCardDes();
			
			temp = null;
		}
	}

}