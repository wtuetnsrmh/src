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
	import project.view.artplug.MovieClipButton;
    import project.view.base.BaseTitleWindow;
    import project.view.controls.ToolTip;
    import project.view.module.alert.AlertConfirmPane;
	import project.view.module.alert.AlertSelectPane;
    import project.view.module.loading.LockScreen;
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
		
		private var _secen1:MovieClip;//场景1
		private var _secen2:MovieClip;//场景2
		
		
		private var _selectBt0:MovieClipButton;//北欧种族选择按钮
		private var _selectBt1:MovieClipButton;//人族
		private var _selectBt2:MovieClipButton;//希腊
		
		private var _nordicRace:MovieClip;//北欧图标
		private var _humanRace:MovieClip;//人族图标
		private var _greeceRace:MovieClip;//希腊图标
		
		private var _leftCard:MovieClip;//左边卡牌MC
		private var _rightCard:MovieClip;//右边卡牌MC
		
		private var _returnBt:MovieClipButton;//返回
		
		private var _selectedOptionLeft:MovieClip;//左边卡牌选中图标
		private var _selectedOptionRight:MovieClip;//右边卡牌选中图标
		
		private var _heroMc:MovieClip;//选择的种族对应的英雄上半身
		
		private var _startBt:MovieClipButton;//开始游戏按钮
		
		private var _inforBar:MovieClip;//选择的英雄信息面板
		
		private var _titleText:TextField;
		private var _introText:TextField;//信息文本
		
		private var tt:ToolTip;

        private var toolTipStrig:String = "";
        //private var _mode:int = 1;//注册类型，一种是自动分配名字一种是手动输入
        //private var nameText:TextField;
        private static var registerPane:RegisterPane;
		
        /*private static const QING_LONG_DES:String = LocalConfig.LOCAL_LAN.RegisterPane.Seiryu.@Text;//青龙信息
        private static const BAI_HU_DES:String = LocalConfig.LOCAL_LAN.RegisterPane.Byakko.@Text;
        private static const ZHU_QUE_DES:String = LocalConfig.LOCAL_LAN.RegisterPane.Suzaku.@Text;
        private static const XUAN_WU_DES:String = LocalConfig.LOCAL_LAN.RegisterPane.Genbu.@Text;
        private static const EL_INTRO_ARR:Array = [LocalConfig.LOCAL_LAN.RegisterPane.Jin.@Text, LocalConfig.LOCAL_LAN.RegisterPane.Mu.@Text, LocalConfig.LOCAL_LAN.RegisterPane.Shui.@Text, LocalConfig.LOCAL_LAN.RegisterPane.Huo.@Text, LocalConfig.LOCAL_LAN.RegisterPane.Tu.@Text, LocalConfig.LOCAL_LAN.RegisterPane.WuXing.@Text];*/

        public function RegisterPane()
        {
            //this.avPosArr = [];
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
			_secen1 = getChild("secen1") as MovieClip;
			_secen2 = getChild("secen2") as MovieClip;
			_secen2.x = ApplicationConfig.STAGE_WIDTH;
			
			_selectBt0 = _secen1["selectBt0"] as MovieClipButton;
			_selectBt1 = _secen1["selectBt1"] as MovieClipButton;
			_selectBt2 = _secen1["selectBt2"] as MovieClipButton;
			
			_nordicRace = _secen1["nordicRace"] as MovieClip;
			_humanRace = _secen1["humanRace"] as MovieClip;
			_greeceRace = _secen1["greeceRace"] as MovieClip;
			
			_leftCard = _secen2["leftCard"] as MovieClip;
			_rightCard = _secen2["rightCard"] as MovieClip;
			_leftCard.buttonMode = true;
			_rightCard.buttonMode = true;
			
			_selectedOptionLeft = _secen2["selectedOptionLeft"] as MovieClip;
			_selectedOptionRight = _secen2["selectedOptionRight"] as MovieClip;
			
			_returnBt = _secen2["returnBt"] as MovieClipButton;
			
			_heroMc = _secen2["heroMc"] as MovieClip;
			_inforBar = _secen2["inforBar"] as MovieClip;

			_startBt = _secen2["startBt"] as MovieClipButton;
			
			_titleText = _inforBar["titleText"] as TextField;
			_introText = _inforBar["introText"] as TextField;
			
			/*_nordicRace.buttonMode = true;
			_humanRace.buttonMode = true;
			_greeceRace.buttonMode = true;*/
			//初始
			_selectBt0.onClick = raceSelectedClickHandler;
			_selectBt1.onClick = raceSelectedClickHandler;
			_selectBt2.onClick = raceSelectedClickHandler;
			
			_returnBt.onClick = enterSecen1;
			_startBt.onClick = registerUser;
			
			/*_nordicRace.gotoAndStop(1);
			_humanRace.gotoAndStop(2);
			_greeceRace.gotoAndStop(1);
			_selectedRaceCard.gotoAndStop(2);
			_heroMc.gotoAndStop(2);
			var humanId:String = LocalConfig.LOCAL_LAN.RegisterPane.human.@ID;
            this._titleText.text =ItemConfig.CARD_CONFIG.Card.(@ID==humanId).@Name;
			this._raceText.text = LocalConfig.LOCAL_LAN.Characters.race.@Label+"   "+LocalConfig.LOCAL_LAN.Characters.Race.(@id==ItemConfig.CARD_CONFIG.Card.(@ID==humanId).@Race).@Text;
			this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.human.@Desc;
           
            
            
            
            this._nordicRace.addEventListener(MouseEvent.CLICK, this.avClick);
            this._humanRace.addEventListener(MouseEvent.CLICK, this.avClick);
            this._greeceRace.addEventListener(MouseEvent.CLICK, this.avClick);*/
            
            /*this.avatar1.addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            this.avatar2.addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            this.avatar3.addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            this.avatar4.addEventListener(MouseEvent.ROLL_OVER, this.onMouseOver);
            this.avatar1.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOutt);
            this.avatar2.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOutt);
            this.avatar3.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOutt);
            this.avatar4.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOutt);
            this.avatar1["ac"].mouseChildren = false;
            this.avatar2["ac"].mouseChildren = false;
            this.avatar3["ac"].mouseChildren = false;
            this.avatar4["ac"].mouseChildren = false;
            this.avatar1["ac"].mouseEnabled = false;
            this.avatar2["ac"].mouseEnabled = false;
            this.avatar3["ac"].mouseEnabled = false;
            this.avatar4["ac"].mouseEnabled = false;
            this.ele0.buttonMode = true;
            this.ele1.buttonMode = true;
            this.ele2.buttonMode = true;
            this.ele3.buttonMode = true;
            this.ele4.buttonMode = true;
            this.ele0.addEventListener(MouseEvent.CLICK, this.eleClick);
            this.ele1.addEventListener(MouseEvent.CLICK, this.eleClick);
            this.ele2.addEventListener(MouseEvent.CLICK, this.eleClick);
            this.ele3.addEventListener(MouseEvent.CLICK, this.eleClick);
            this.ele4.addEventListener(MouseEvent.CLICK, this.eleClick);
            this.ele0.addEventListener(MouseEvent.MOUSE_OVER, this.showElTip);
            this.ele1.addEventListener(MouseEvent.MOUSE_OVER, this.showElTip);
            this.ele2.addEventListener(MouseEvent.MOUSE_OVER, this.showElTip);
            this.ele3.addEventListener(MouseEvent.MOUSE_OVER, this.showElTip);
            this.ele4.addEventListener(MouseEvent.MOUSE_OVER, this.showElTip);
            this.ele0.gotoAndStop(2);
            this.nameText = getChild("namet") as TextField;*/
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
		 * 第一场景种族选择后
		 * @param	event
		 */
			private function raceSelectedClickHandler(e:MouseEvent):void {
				switch(e.target) {
					case this._selectBt0:
						_currentSelectedRace = 1;
						showInfoByRace(_currentSelectedRace);
						break;
					case this._selectBt1:
						_currentSelectedRace = 2;
						showInfoByRace(_currentSelectedRace);
						break;
					case this._selectBt2:
						_currentSelectedRace = 3;
						showInfoByRace(_currentSelectedRace);
						break;
					default :
						break;
						
					}
				initSecen2();	
				enterSecen2();
				}
		
		/**
		 * 根据种族与选左右边人物来显示英雄信息
		 */
		private function showInfoByRace(raceId:int, lr:String = "left"):void {
			
			switch(raceId) {
				case 1:
					var nordicId:String;
					if (lr == "left") {
						_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 1);//1.3.5
						nordicId = LocalConfig.LOCAL_LAN.RegisterPane.nordicLeft.@ID;
						
						this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.nordicLeft.@Desc;
						}else {
							_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 2);//1.3.5
							nordicId = LocalConfig.LOCAL_LAN.RegisterPane.nordicRight.@ID;
							this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.nordicRight.@Desc;
							}
					this._titleText.text =ItemConfig.CARD_CONFIG.Card.(@ID==nordicId).@Name;
					_currentSelectedHeroId = int(nordicId);
					break;
				case 2:
					var humanId:String;
					if (lr == "left") {
						_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 1);//1.3.5
						humanId = LocalConfig.LOCAL_LAN.RegisterPane.humanLeft.@ID;
						this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.humanLeft.@Desc;
						}else {
							_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 2);//1.3.5
							humanId = LocalConfig.LOCAL_LAN.RegisterPane.humanRight.@ID;
							this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.humanRight.@Desc;
							}
					this._titleText.text = ItemConfig.CARD_CONFIG.Card.(@ID == humanId).@Name;
					_currentSelectedHeroId = int(humanId);
					break;
				case 3:
					var greeceId:String;
					if (lr == "left") {
						_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 1);//1.3.5
						greeceId = LocalConfig.LOCAL_LAN.RegisterPane.greeceLeft.@ID;
						this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.greeceLeft.@Desc;
						}else {
							_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 2);//1.3.5
							greeceId = LocalConfig.LOCAL_LAN.RegisterPane.greeceRight.@ID;
							this._introText.htmlText = LocalConfig.LOCAL_LAN.RegisterPane.greeceRight.@Desc;
							}
					this._titleText.text = ItemConfig.CARD_CONFIG.Card.(@ID == greeceId).@Name;
					_currentSelectedHeroId = int(greeceId);
					break;
				default :
					break;
				}
			}
				
		/**
		 * 初始化场景2
		 * 
		 */
		private function initSecen2():void {
			_leftCard.gotoAndStop(_currentSelectedRace);
			_rightCard.gotoAndStop(_currentSelectedRace);
			_selectedOptionLeft.gotoAndStop(2);
			_selectedOptionRight.gotoAndStop(1);
			
			_heroMc.gotoAndStop((_currentSelectedRace-1) * 2 + 1);//1.3.5
			
			
			
			if (!_leftCard.hasEventListener(MouseEvent.CLICK)) {
				_leftCard.addEventListener(MouseEvent.CLICK, leftCardClick);
				}
			if (!_rightCard.hasEventListener(MouseEvent.CLICK)) {
				_rightCard.addEventListener(MouseEvent.CLICK, rightCardClick);
				}
			}
			
		/**
		 * 
		 * @param	e
		 */
		private function leftCardClick(e:MouseEvent):void {
			_selectedOptionLeft.gotoAndStop(2);
			_selectedOptionRight.gotoAndStop(1);
			showInfoByRace(_currentSelectedRace, "left");
			}
		private function rightCardClick(e:MouseEvent):void {
			_selectedOptionLeft.gotoAndStop(1);
			_selectedOptionRight.gotoAndStop(2);
			showInfoByRace(_currentSelectedRace, "right");
			}
				
		/**
		 * 进入第1场景
		 * @param	event
		 */	
		private function enterSecen1(e:MouseEvent=null):void {
			TweenLite.to(_secen1, 0.4, {x:0});
            TweenLite.to(_secen2, 0.4, {x:ApplicationConfig.STAGE_WIDTH});
            SMZTSoundManager.playSimpleSound("UI_SHUA");
			}
			
		/**
		 * 进入第2场景
		 * @param	event
		 */	
		private function enterSecen2():void {
			TweenLite.to(_secen2, 0.4, {x:0});
            TweenLite.to(_secen1, 0.4, {x:-ApplicationConfig.STAGE_WIDTH});
            SMZTSoundManager.playSimpleSound("UI_SHUA");
			}
				
		/*鼠标移上提示
		*/
       /* private function showElTip(event:MouseEvent) : void
        {
            var _loc_2:int = int(String(event.currentTarget.name).substr((String(event.currentTarget.name).length - 1), 1));
            this.tt.show(event.currentTarget as DisplayObject, "", "<font color = \'#FFFFFF\'>" + EL_INTRO_ARR[_loc_2] + "</font>");//金：克制木属性，提升水属性。...
            playUISound("UI_MOUSE_OVER");
            return;
        }// end function

        private function onMouseOutt(event:MouseEvent) : void
        {
            (event.currentTarget as MovieClip)["mm2"].gotoAndPlay(1);
            if ((event.currentTarget as MovieClip).currentFrame != 3)
            {
                (event.currentTarget as MovieClip).gotoAndStop(1);
                (event.currentTarget as MovieClip)["ac"].gotoAndStop(1);
            }
            this.stopUISound();
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            var _loc_2:String = "";
            (event.currentTarget as MovieClip)["mm2"].gotoAndPlay(2);
            switch(event.currentTarget)
            {
                case this.avatar1:
                {
                    _loc_2 = QING_LONG_DES;
                    if (this.avatar1.currentFrame != 3)
                    {
                        this.avatar1.gotoAndStop(2);
                        this.avatar1["ac"].gotoAndPlay(2);
                    }
                    if (this.avatar2.currentFrame != 3)
                    {
                        this.avatar2.gotoAndStop(1);
                        this.avatar2["ac"].gotoAndStop(1);
                    }
                    if (this.avatar3.currentFrame != 3)
                    {
                        this.avatar3.gotoAndStop(1);
                        this.avatar3["ac"].gotoAndStop(1);
                    }
                    if (this.avatar4.currentFrame != 3)
                    {
                        this.avatar4.gotoAndStop(1);
                        this.avatar4["ac"].gotoAndStop(1);
                    }
                    playUISound("REG_QINGLONG");
                    break;
                }
                case this.avatar2:
                {
                    _loc_2 = BAI_HU_DES;
                    if (this.avatar1.currentFrame != 3)
                    {
                        this.avatar1.gotoAndStop(1);
                        this.avatar1["ac"].gotoAndStop(1);
                    }
                    if (this.avatar2.currentFrame != 3)
                    {
                        this.avatar2.gotoAndStop(2);
                        this.avatar2["ac"].gotoAndPlay(2);
                    }
                    if (this.avatar3.currentFrame != 3)
                    {
                        this.avatar3.gotoAndStop(1);
                        this.avatar3["ac"].gotoAndStop(1);
                    }
                    if (this.avatar4.currentFrame != 3)
                    {
                        this.avatar4.gotoAndStop(1);
                        this.avatar4["ac"].gotoAndStop(1);
                    }
                    playUISound("REG_BAIHU");
                    break;
                }
                case this.avatar3:
                {
                    _loc_2 = ZHU_QUE_DES;
                    if (this.avatar1.currentFrame != 3)
                    {
                        this.avatar1.gotoAndStop(1);
                        this.avatar1["ac"].gotoAndStop(1);
                    }
                    if (this.avatar2.currentFrame != 3)
                    {
                        this.avatar2.gotoAndStop(1);
                        this.avatar2["ac"].gotoAndStop(1);
                    }
                    if (this.avatar3.currentFrame != 3)
                    {
                        this.avatar3.gotoAndStop(2);
                        this.avatar3["ac"].gotoAndPlay(2);
                    }
                    if (this.avatar4.currentFrame != 3)
                    {
                        this.avatar4.gotoAndStop(1);
                        this.avatar4["ac"].gotoAndStop(1);
                    }
                    playUISound("REG_ZHUQUE");
                    break;
                }
                case this.avatar4:
                {
                    _loc_2 = XUAN_WU_DES;
                    if (this.avatar1.currentFrame != 3)
                    {
                        this.avatar1.gotoAndStop(1);
                        this.avatar1["ac"].gotoAndStop(1);
                    }
                    if (this.avatar2.currentFrame != 3)
                    {
                        this.avatar2.gotoAndStop(1);
                        this.avatar2["ac"].gotoAndStop(1);
                    }
                    if (this.avatar3.currentFrame != 3)
                    {
                        this.avatar3.gotoAndStop(1);
                        this.avatar3["ac"].gotoAndStop(1);
                    }
                    if (this.avatar4.currentFrame != 3)
                    {
                        this.avatar4.gotoAndStop(2);
                        this.avatar4["ac"].gotoAndPlay(2);
                    }
                    playUISound("REG_XUANWU");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function eleClick(event:MouseEvent) : void
        {
            playUISound("UI_MOUSE_CLICK");
            switch(event.currentTarget)
            {
                case this.ele0:
                {
                    this.el = "金";
                    this.currentSelectedElement = 0;
                    this.ele0.gotoAndStop(2);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    break;
                }
                case this.ele1:
                {
                    this.el = "木";
                    this.currentSelectedElement = 1;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(2);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    break;
                }
                case this.ele2:
                {
                    this.el = "水";
                    this.currentSelectedElement = 2;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(2);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    break;
                }
                case this.ele3:
                {
                    this.el = "火";
                    this.currentSelectedElement = 3;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(2);
                    this.ele4.gotoAndStop(1);
                    break;
                }
                case this.ele4:
                {
                    this.el = "土";
                    this.currentSelectedElement = 4;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function*/

        

        private function registerUser(event:MouseEvent) : void
        {
			LockScreen.getInstance().show(true);
            SMZTController.getInstance().register(_currentSelectedHeroId,onRegisterCallBack);
			//onRegisterCallBack(null);
			//trace("_currentSelectedHeroId="+_currentSelectedHeroId)
			
            /*if (this.currentSelectedJob == 0)
            {
                AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.RegisterPane.NoJob.@Text);//请选择角色职业
            }
            if (this._mode == 1)
            {
                LockScreen.getInstance().show(true);
                SMZTController.getInstance().register(this.currentSelectedJob, this.currentSelectedElement, null, this._mode, this.onRegisterCallBack);
            }
            else if (this._mode == 2)
            {
                if (StringUtil.trim(this.nameText.text) == "")
                {
					//没昵称
                    //AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.RegisterPane.NoNickName.@Text);
                    return;
                }
                if (getStringLength(StringUtil.trim(this.nameText.text)) > 12)
                {
					//太长
                    //AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.RegisterPane.NoMore6.@Text);
                    return;
                }
                if (getStringLength(StringUtil.trim(this.nameText.text)) < 4)
                {
					//太短
                    //AlertConfirmPane.getInstance().showMessage(LocalConfig.LOCAL_LAN.RegisterPane.NoLess2.@Text);
                    return;
                }
                LockScreen.getInstance().show(true);
                //SMZTController.getInstance().register(this.currentSelectedJob, this.currentSelectedElement, StringUtil.trim(this.nameText.text), this._mode, this.onRegisterCallBack);
            }*/
            return;
        }// end function

        private function onSelect(param1:String) : void
        {
            if (param1 == AlertSelectPane.ALERT_YES)
            {
                LockScreen.getInstance().show(true);
            }
            return;
        }// end function

		//注册完成
        private function onRegisterCallBack(param1:Object) : void
        {
            LockScreen.getInstance().hide();
            dispatchEvent(new Event(Event.COMPLETE));
            playUISound("UI_WINDOW_OPEN");
            hide();
            return;
        }// end function

        /*public function get mode() : int
        {
            return this._mode;
        }// end function

        public function set mode(param1:int) : void
        {
            this._mode = param1;
            (spriteInstance as MovieClip).gotoAndStop(this._mode);
            if (this._mode == 1)
            {
                this.nameText.visible = false;
            }
            else if (this._mode == 2)
            {
                this.nameText.visible = true;
            }
            else
            {
                this.nameText.visible = false;
            }
            return;
        }// end function*/

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
