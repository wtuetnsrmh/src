package project.view.module.register
{
	/*
	* 描述：注册面板
	* 
	*/
	import project.config.ApplicationConfig;
	import project.config.ItemConfig;
    import project.config.LocalConfig;
    import project.controller.SMZTController;
	import project.core.SMZTSoundManager;
	import project.debug.Debug;
	import project.model.data.PlayerData;
	import project.model.ModelLocator;
	import project.utils.Rippler;
	import project.view.artplug.MovieClipButton;
    import project.view.base.BaseTitleWindow;
    import project.view.controls.ToolTip;
    import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertSelectPane;
    //import project.view.module.loading.LockScreen;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import mx.utils.*;
	import com.greensock.*;
    import com.greensock.easing.*;

    public class RegisterPane extends BaseTitleWindow
    {
		private var _currentSelectedHeroId:int = 0;//当前先的英雄ID
		
		private var _showEffect:Boolean = true;//是否显示缓动效果
		
		private var _currentSelectedRace:int = 0;//当前选择的种族,默认选择人族
		
		//private var _secen1:MovieClip;//场景1
		private var _secen2:MovieClip;//场景2
		
		
		private var _selectBt0:MovieClipButton;//北欧种族选择按钮
		private var _selectBt1:MovieClipButton;//人族
		private var _selectBt2:MovieClipButton;//希腊
		
		//private var _nordicRace:MovieClip;//北欧图标
		//private var _humanRace:MovieClip;//人族图标
		//private var _greeceRace:MovieClip;//希腊图标
		
		//private var _leftCard:MovieClip;//左边卡牌MC
		//private var _rightCard:MovieClip;//右边卡牌MC
		
		//private var _returnBt:MovieClipButton;//返回
		
		private var _selectedOptionLeft:MovieClip;//左边卡牌选中图标
		private var _selectedOptionRight:MovieClip;//右边卡牌选中图标
		
		private var _heroMc1:MovieClip;//选择的种族对应的英雄上半身
		private var _heroMc2:MovieClip;//选择的种族对应的英雄上半身
		
		
		private var _startBt:MovieClipButton;//开始游戏按钮
		
		private var _inforBar:MovieClip;//选择的英雄信息面板
		
		private var _titleText:TextField;
		private var _introText:TextField;//信息文本
		
		private var tt:ToolTip;

        private var toolTipStrig:String = "";
        //private var _mode:int = 1;//注册类型，一种是自动分配名字一种是手动输入
        //private var nameText:TextField;
        private static var registerPane:RegisterPane;

        public function RegisterPane()
        {
            if (registerPane != null)
            {
                throw new Error("Error");
            }
            setSpriteInstance("RegisterPane");
            this.configerUIInstance();
            this.tt = ToolTip.getInstance();
            this.tt.bgAlpha = 0.88;
            this.tt.cornerRadius = 12;
            this.tt.colors = [1642254, 1642254];
            this.tt.border = 16762389;
            this.tt.borderSize = 1;
            var _loc_1:TextFormat = new TextFormat(null, 12, ApplicationConfig.FONT_COLOR);
            this.tt.contentFormat = _loc_1;
            dragable = false;
            (spriteInstance as MovieClip).gotoAndStop(1);
            return;
        }// end function

        private function configerUIInstance() : void
        {
			_secen2 = getChild("secen2") as MovieClip;
			//_secen2.x = ApplicationConfig.STAGE_WIDTH;
			
			//_leftCard = _secen2["leftCard"] as MovieClip;
			//_rightCard = _secen2["rightCard"] as MovieClip;
			//_leftCard.buttonMode = true;
			//_rightCard.buttonMode = true;
			
			_selectedOptionLeft = _secen2["selectedOptionLeft"] as MovieClip;
			_selectedOptionRight = _secen2["selectedOptionRight"] as MovieClip;
			
			
			_heroMc1 = _secen2["heroMc1"] as MovieClip;
			_heroMc2 = _secen2["heroMc2"] as MovieClip;
			bodys = [_heroMc1, _heroMc2];
			
			_inforBar = _secen2["inforBar"] as MovieClip;

			_startBt = _secen2["startBt"] as MovieClipButton;
			
			_titleText = _inforBar["titleText"] as TextField;
			_introText = _inforBar["introText"] as TextField;
			
			//初始
			initSecen2();
			//_selectBt0.onClick = raceSelectedClickHandler;
			//_selectBt1.onClick = raceSelectedClickHandler;
			//_selectBt2.onClick = raceSelectedClickHandler;
			
			//_returnBt.onClick = enterSecen1;
			_startBt.onClick = registerUser;
			
            return;
        }// end function

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
                this.x =0;
                this.y =0;
                if (this._showEffect)
                {
                    this.alpha = 1;
                    TweenLite.from(this, 0.3, {alpha:0, y:this.y + 40});
                }
                this.isOpened = true;
                this.isPopUP = true;
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            }
            this.playShowSound();
            return;
        }// end function
		
		
		/**
		 * 根据种族与选左右边人物来显示英雄信息
		 */
		private function showInfoByRace(lr:String = "left"):void {
			var ahsArr:Array;
			var humanId:String;
					if (lr == "left") {
						bodyIndex =1;
						humanId = LocalConfig.LOCAL_LAN.RegisterPane.humanLeft.@ID;
						this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.humanLeft.@Desc;
						ahsArr = String(LocalConfig.LOCAL_LAN.RegisterPane.humanLeft.@ahs).split(",");
						_secen2["atkText"].text = ahsArr[0].toString();
						_secen2["hpText"].text = ahsArr[1].toString();
						_secen2["spText"].text = ahsArr[2].toString();
						_secen2["skillNameText"].text = LocalConfig.LOCAL_LAN.RegisterPane.humanLeft.@skill;
						}else {
							bodyIndex = 2;
							humanId = LocalConfig.LOCAL_LAN.RegisterPane.humanRight.@ID;
							this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.humanRight.@Desc;
							ahsArr = String(LocalConfig.LOCAL_LAN.RegisterPane.humanRight.@ahs).split(",");
							_secen2["skillNameText"].text = LocalConfig.LOCAL_LAN.RegisterPane.humanRight.@skill;
							_secen2["atkText"].text = ahsArr[0].toString();
							_secen2["hpText"].text = ahsArr[1].toString();
							_secen2["spText"].text = ahsArr[2].toString();
							}
					this._titleText.text = ItemConfig.CARD_CONFIG.Card.(@ID == humanId).@Name+"   人族";
					_currentSelectedHeroId = int(humanId);
					
					
				if (tarRole == null || curRole==tarRole || tarRole==bodys[bodyIndex - 1]) { 
					tarRole = bodys[bodyIndex - 1];
					tarRole.alpha = 1;
					return;
					}
				var _loc_7:MovieClip = bodys[bodyIndex-1];
                curRole = tarRole;
                tarRole = _loc_7;
				startRippler();
			}
		//--------------------------------------------------------
		private var speed:Number = 0.04;
		private var bodys:Array;//
		private var bodyIndex:int = 1;
		private var alphaFlag:Boolean = true;
		private var curRole:MovieClip;
		private var tarRole:MovieClip;
		private var curRip:Rippler;
		private var tarRip:Rippler;
		//private var centerArr:Array= [[185, 230], [285, 230], [185, 230], [285, 230], [185, 230], [285, 230]];
		private var centerArr:Array = [[285, 230], [200, 200]];// , [285, 230], [285, 230], [285, 230], [285, 230]];
		private function reAlpha() : void
        {
            if (tarRole.alpha < 0)
            {
                tarRole.alpha = 0;
            }
            if (tarRole.alpha > 1)
            {
                tarRole.alpha = 1;
            }
            if (curRole.alpha > 1)
            {
                curRole.alpha = 1;
            }
            if (curRole.alpha < 0)
            {
                curRole.alpha = 0;
            }
            return;
        }// end function
		private function startRippler() : void
        {
            killRip();
			
            tarRip = new Rippler(tarRole, 40, 6);
            //curRip = new Rippler(curRole, 40, 6);
            tarRip.drawRipple(centerArr[bodyIndex-1][0], centerArr[bodyIndex-1][1], 20, 1);
            //curRip.drawRipple(centerArr[bodyIndex-1][0], centerArr[bodyIndex-1][1], 20, 1);
            if (this.hasEventListener(Event.ENTER_FRAME) == false)
            {
                this.addEventListener(Event.ENTER_FRAME, doRippling);
            }
            else
            {
                if (curRole.alpha > 0.75)
                {
                    alphaFlag = true;
                }
                else
                {
                    alphaFlag = false;
                }
                reAlpha();
            }
            return;
        }// end function
		private function killRip() : void
        {
            var _loc_1:int = 0;
            if (tarRip != null)// && curRip != null)
            {
                tarRip.destroy();
                //curRip.destroy();
                _loc_1 = 0;
                while (_loc_1 < bodys.length)
                {
                    
                    if (bodys[_loc_1] != tarRole && bodys[_loc_1] != curRole)
                    {
                        bodys[_loc_1].filters = null;
                    }
                    _loc_1++;
                }
            }
            return;
        }// end function
		private function doRippling(event:Event) : void
        {
            var _loc_2:int = 0;
            if (tarRole)
            {
                if (curRole.alpha > -1)
                {
                    curRole.alpha = curRole.alpha - speed;
                }
                if (alphaFlag)
                {
                    tarRole.alpha = 1 - curRole.alpha - 0.25;
                }
                else if (tarRole.alpha < 1)
                {
                    tarRole.alpha = tarRole.alpha + speed;
                }
                _loc_2 = 0;
                while (_loc_2 < bodys.length)
                {
                    
                    if (bodys[_loc_2] != tarRole && bodys[_loc_2] != curRole)
                    {
                        bodys[_loc_2].alpha = bodys[_loc_2].alpha - speed * 2;
                        if (bodys[_loc_2].alpha < 0)
                        {
                            bodys[_loc_2].alpha = 0;
                        }
                    }
                    _loc_2++;
                }
            }
            return;
        }// end function
		//--------------------------------------------------------
		/**
		 * 初始化场景2
		 * 
		 */
		private function initSecen2():void {
			//_leftCard.gotoAndStop(_currentSelectedRace);
			//_rightCard.gotoAndStop(_currentSelectedRace);
			_selectedOptionLeft.gotoAndStop(2);
			_selectedOptionRight.gotoAndStop(1);
			_selectedOptionLeft.buttonMode = true;
			_selectedOptionRight.buttonMode = true;
			bodyIndex = 1;

			
				_selectedOptionLeft.addEventListener(MouseEvent.CLICK, leftCardClick);
			
				_selectedOptionRight.addEventListener(MouseEvent.CLICK, rightCardClick);
				leftCardClick();
			}
			
		/**
		 * 
		 * @param	e
		 */
		private function leftCardClick(e:MouseEvent=null):void {
			_selectedOptionLeft.gotoAndStop(2);
			_selectedOptionRight.gotoAndStop(1);
			showInfoByRace("left");
			}
		private function rightCardClick(e:MouseEvent):void {
			_selectedOptionLeft.gotoAndStop(1);
			_selectedOptionRight.gotoAndStop(2);
			showInfoByRace("right");
			}

      
        private function registerUser(event:MouseEvent) : void
        {
			Debug.log("_currentSelectedHeroId=" + _currentSelectedHeroId);
            SMZTController.getInstance().register(_currentSelectedHeroId, onRegisterCallBack);
			ModelLocator.getInstance().initHeroId = _currentSelectedHeroId;
			//onRegisterCallBack(null);
			//trace("_currentSelectedHeroId="+_currentSelectedHeroId)
			
            
            return;
        }// end function

		//注册完成
        private function onRegisterCallBack(param1:Object) : void
        {
			Debug.log("注册完成1");
			if (curRip) {
				curRip.destroy();
				curRip = null;
				}
			if (tarRip) {
				tarRip.destroy();
				tarRip = null;
				}
			if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, doRippling);
            }
            //LockScreen.getInstance().hide();
            playUISound("UI_WINDOW_OPEN");
            hide();
			dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function
		
		//关闭
        override public function hide(event:MouseEvent = null) : void
        {
			
			//Debug.log("hide1");
            if (rootContainer)
            {
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

       

        public static function getInstance() : RegisterPane
        {
            if (registerPane == null)
            {
                registerPane = new RegisterPane;
            }
            return registerPane;
        }// end function

		/**
		 * 获取字节长度，中文是两个字节长度
		 * @param	param1
		 * @return
		 */
        public static function getStringLength(param1:String) : uint
        {
            var _loc_2:ByteArray = new ByteArray();
            _loc_2.writeMultiByte(param1, "gb2312");
            return _loc_2.length;
        }// end function

    }
}
