package project.view.module.chat 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import project.config.ApplicationConfig;
	import project.config.ErrorZhCn;
	import project.model.item.CardModel;
	import project.utils.Reflection;
	import project.view.base.BaseTitleWindow;
	import project.view.module.cell.Card;
	import com.greensock.*;
    import com.greensock.easing.*;
    import com.greensock.plugins.*;
	/**
	 *聊天广播信息点击弹出显示卡牌
	 * @author bbjxl 2013
	 */
	public class ClickPopCard extends BaseTitleWindow 
	{
		private var _currentCardId:int = 0;//当前显示的卡牌ID
		private var _front:Card;
		private var _bg:Card;
		//private var _effectStarup:MovieClip;//升星成功的动画效果
		
		private static var _clickPopCard:ClickPopCard;
		public function ClickPopCard() 
		{
			if (_clickPopCard != null) {
				throw(new Error(ErrorZhCn.SINGLETON_ERROR_MESSAGE));
				}
				
			//_effectStarup = Reflection.createInstance("MixEffect");
			//addChild(_effectStarup);
			//_effectStarup.visible = false;
			//_effectStarup.gotoAndStop(1);
			
			_front = new Card();
			_bg = new Card();
			addChild(_front);
			addChild(_bg);
			_bg.x = _front.x + ApplicationConfig.CARD_WIDTH;
			
			
		}
		public static function getInstance() : ClickPopCard
		{
			if (_clickPopCard == null)
			{
			  _clickPopCard = new ClickPopCard;
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
                rootContainer.addChild(this);
                this.x = (ApplicationConfig.STAGE_WIDTH - this.width) / 2;
                this.y = (ApplicationConfig.STAGE_HEIGHT - this.height) / 2 - 40;
                if (showEffect)
                {
                    this.alpha = 0.5;
                    TweenLite.to(this, 0.3, {alpha:1, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
				
                if (stage){
					stage.addEventListener(MouseEvent.CLICK, stageC);
					}
				
            }
            this.playShowSound();
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
		//关闭
        override public function hide(event:MouseEvent = null) : void
        {
			
			//trace("hide")
            if (rootContainer)
            {
				if (this.stage)
				{
					if (this.stage.hasEventListener(MouseEvent.CLICK))
					{
						this.stage.removeEventListener(MouseEvent.CLICK, this.stageC);
					}
				}
				
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