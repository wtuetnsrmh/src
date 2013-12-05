package project.view.module.cell 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.FontType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.core.SMZTResourceManager;
	import project.model.item.CardModel;
	import project.utils.CardTipManager;
	import project.utils.Reflection;
	import project.utils.XColor;
	import project.view.base.BaseSprite;
	import project.view.base.BaseSpritePane;
	/**
	 * 卡牌
	 * 先设定_currentCardTye再赋值CardModel
	 * 
	 * var card:Card = new Card();
			var cardMod:CardModel = new CardModel(cardid, cardNumber);
			card._currentCardTye =cardType;
			card.setCardModel(cardMod);
			card.showTip = showTip
	 * @author bbjxl 2012
	 */
	public class Card extends BaseSprite 
	{
		private var _cardId:int;
		private var _cardModel:CardModel;
		private var _currentCardWidth:Number = 192;
		private var _currentCardHeight:Number = 270;
		
		private var _selected:Boolean = false;//是否选中
        private var _selectedColor:uint = 13408512;// 65280;//选中颜色
        private var _selectedWidth:uint = 21;//选中滤镜宽度
        private var _selGlowFilter:GlowFilter;
		private var _showTip:Boolean = false;//是否影响鼠标移上显示提示
		private var _enable:Boolean = true;//是否可用
		//==================sprit and mc==================================
		private var mc_mask:Sprite=new Sprite();//遮罩
		private var _backCard:Sprite;//卡的背面
		private var _lineMc:Sprite;//中间的线
		private var _qualityMc:MovieClip;//品质
		private var _bigBorder:MovieClip;//大卡框
		private var _smallBorder:MovieClip;//小卡框
		private var _star0:MovieClip;//星级1
		private var _star1:MovieClip;//星级2
		private var _star2:MovieClip;//星级3
		private var _star3:MovieClip;//星级4
		private var _star4:MovieClip;//星级5
		private var _cardBg:Sprite;//卡的背景图
		public var _smallCardBg:Sprite;//小卡的背景图
		
		public var mc_big_ready:MovieClip;//准备图标－大
		public var mc_ready:MovieClip;//准备图标－小
		
		private var _imageContent:MovieClip;//图片容器
		private var _smallImage:Sprite;//小图容器
		private var _middleImage:Sprite;//中图容器
		private var _bigImage:Sprite;//大图容器
		
		private var _lianManSp:Sprite;//放同盟图标容器
		
		private var _spriteInstance:Sprite;
		private var instanceLayer:Sprite;
		private var _ahsMc:Sprite;//atk,hp,sp
		//===================text=================================
		private var _nameBigText:TextField;//卡牌名字 大字体，在中卡时显示
		private var _nameText:TextField;//卡牌名字
		private var _allyText:TextField;//带兵数
		private var _talismanText:TextField;//法宝数
		private var _mitacText:TextField;//神通数
		public var _atkText:TextField;//攻击值
		public var _hpText:TextField;//生命值
		public var _spText:TextField;//等待值
		private var _skill1Text:TextField;//技能名称1
		private var _bigskill1Text:TextField;//技能名称1
		private var _skill2Text:TextField;//技能名称2
		private var _bigskill2Text:TextField;//技能名称2
		private var _classText:TextField;//职业
		private var _skillDesText:TextField;//技能描述
		private var _cardDesText:TextField;//卡牌描述
		private var _for1Text:TextField;//进化阶段1
		private var _for2Text:TextField;//进化阶段2
		private var _for3Text:TextField;//进化阶段3
		
		public var smallSpText:TextField;//战斗时小卡的等待时间
		private var _size:TextFormat = new TextFormat();
		//================value====================================
		private var _filter:GlowFilter;
		private var _isLeader:Boolean = false;
		private var _state:int=1;//卡的当前状态  休眠区，等待区，战斗区，装备区,死亡区
		private const SKILL_DESC_POINT:Point = new Point(9.5,6.05);//技能描述坐标
		private const SKILL_DES_WIDTH:Number = 180.55;//技能描述宽度
		private const FOR1_POINT:Point = new Point(35.9, 101.6);
		private const FOR2_POINT:Point = new Point(92.6, 101.6);
		private const FOR3_POINT:Point = new Point(153.15, 101.6);
		
		private var _uniquesId:String;//战斗中的唯一ID
		
		private var _oldPoint:Point;//原始坐标
		//private var _oldCardImageUrl:String="";//之前的卡（用于判断是否要重新加载图片）
		//private var _canDrageAreaId:int = 0;//在哪个嵌入的框中（编辑卡组界面用）
		
		public var _currentCardTye:int = 1;//当前卡处于大中小卡的哪个状态 大：0，中：1，小：2 ,3:只显示技能描述
		
		//====================================================

		public function Card() 
		{
			_spriteInstance = Reflection.createInstance("CardPanel");
			instanceLayer = new Sprite();
			addChild(instanceLayer);
			instanceLayer.addChild(_spriteInstance);
			//setSpriteInstance("CardPanel");
			configerUIInstance();
			
		}
		//======================fun==============================
		public function get spriteInstance() : Sprite
		 {
		   return _spriteInstance;
		}// end function
		
		public function set spriteInstance(param1:Sprite) : void
		{
		  _spriteInstance= param1;
		  return;
		}// end function
		private function getChild(param1:String) :DisplayObject
        {
            return this._spriteInstance[param1] as DisplayObject;
        }// end function
		/**
		 * 初始化UI
		 * @param	value
		 */
		private function configerUIInstance():void {
			//var a = Font.enumerateFonts(); 
			//var tf:TextFormat = new TextFormat(); 
			//tf.font = a[0].fontName; 
			
			this._selGlowFilter = new GlowFilter(this._selectedColor, 1, this._selectedWidth, this._selectedWidth);
            _cardModel = new CardModel();
           
            this.mouseChildren = false;
			this.mouseEnabled = true;
			
			_imageContent = getChild("imageContent") as MovieClip;
            this._bigImage = this._imageContent.bigImage;
            this._smallImage = this._imageContent.smallImage;
            this._middleImage = this._imageContent.middleImage;
			_lianManSp = getChild("lianManSp") as Sprite;
			_lineMc = getChild("lineMc") as Sprite;
			_backCard = getChild("backCard") as Sprite;
			_qualityMc = getChild("qualityMc") as MovieClip;
			_bigBorder = getChild("bigBorder") as MovieClip;
			_ahsMc = _bigBorder["ahsMc"] as Sprite;
			
			_smallBorder = getChild("smallBorder") as MovieClip;
			_cardBg = getChild("cardBg") as MovieClip;
			_smallCardBg = getChild("smallCardBg") as MovieClip;
			_star0 = getChild("star0") as MovieClip;
			_star1 = getChild("star1") as MovieClip;
			_star2 = getChild("star2") as MovieClip;
			_star3 = getChild("star3") as MovieClip;
			_star4 = getChild("star4") as MovieClip;
			mc_big_ready = getChild("big_ready") as MovieClip;
			mc_ready = getChild("ready") as MovieClip;
			_allyText = getChild("allyText") as TextField;
			_talismanText = getChild("talismanText") as TextField;
			_mitacText = getChild("mitacText") as TextField;
			_atkText = getChild("atkText") as TextField;
			_hpText = getChild("hpText") as TextField;
			_spText = getChild("spText") as TextField;
			_atkText.y=(ApplicationConfig._os == "Windows XP")?195.7:198.2;
			_hpText.y=(ApplicationConfig._os == "Windows XP")?195.7:198.2;
			_spText.y=(ApplicationConfig._os == "Windows XP")?195.7:198.2;
			_ahsMc.y=(ApplicationConfig._os == "Windows XP")?163.4:167.4;
			
			smallSpText = getChild("SmallSpText") as TextField;
			smallSpText.visible = false;
			_skill1Text = getChild("skill1Text") as TextField;
			
			_skill2Text = getChild("skill2Text") as TextField;
			//_bigskill1Text = getChild("bigskill1Text") as TextField;
			_filter = new GlowFilter();
			_filter.color = 0x040404;
			_filter.alpha = 1;
			_filter.blurX = 2;
			_filter.blurY = 2;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			var dynamcTF:TextFormat = new TextFormat();
			dynamcTF.font = ApplicationConfig.FONT;
			dynamcTF.color = ApplicationConfig.FONT_COLOR;
			dynamcTF.size = (ApplicationConfig._os == "Windows XP")?12:9;
			
			_bigskill1Text = new TextField();
			_bigskill1Text.x = 21.1;
			_bigskill1Text.y = (ApplicationConfig._os == "Windows XP")?108:106.4;
			_bigskill1Text.autoSize = TextFieldAutoSize.LEFT;
			
			_bigskill2Text = new TextField();
			_bigskill2Text.x = 0;
			_bigskill2Text.y =(ApplicationConfig._os == "Windows XP")?119:116.65;
			_bigskill2Text.width = (ApplicationConfig._os == "Windows XP")?ApplicationConfig.CARD_WIDTH>>1:88.25;
			_bigskill2Text.autoSize = TextFieldAutoSize.RIGHT;
			
			_bigskill2Text.defaultTextFormat = dynamcTF;
			_bigskill1Text.defaultTextFormat = dynamcTF;
			_bigskill2Text.filters = [_filter];
			_bigskill1Text.filters = [_filter];
			//_bigskill2Text = getChild("bigskill2Text") as TextField;
			_classText = getChild("classText") as TextField;
			//_classText.embedFonts = true; 
			//_classText.antiAliasType = FontType.DEVICE;
			//_classText.setTextFormat(tf);
			
			_skillDesText = getChild("skillDesText") as TextField;
			_cardDesText = getChild("cardDesText") as TextField;
			_nameBigText = getChild("nameBigText") as TextField;
			
			addChild(_nameBigText);
			(ApplicationConfig._os == "Windows XP")?setSizeFun(_nameBigText):setSizeFun(_nameBigText,10);
			
			
			addChild(_bigskill2Text);
			addChild(_bigskill1Text);
			_nameText = getChild("nameText") as TextField;
			_for1Text = getChild("for1Text") as TextField;
			_for2Text = getChild("for2Text") as TextField;
			_for3Text = getChild("for3Text") as TextField;
			
			
			_for1Text.autoSize = TextFieldAutoSize.CENTER;
			_for1Text.wordWrap = false;
			_for2Text.autoSize = TextFieldAutoSize.CENTER;
			_for2Text.wordWrap = false;
			_for3Text.autoSize = TextFieldAutoSize.CENTER;
			_for3Text.wordWrap = false;
			_for1Text.multiline = false;
			_for2Text.multiline = false;
			_for3Text.multiline = false;
			
            _lineMc.x = ApplicationConfig.CARD_WIDTH - _lineMc.width >> 1;
			_lineMc.visible = false;
			_backCard.visible = false;
			_qualityMc.visible = false;
			_smallBorder.visible = false;
			mc_big_ready.visible = false;
			mc_ready.visible = false;
			
			
			
			var _tf:TextFormat = new TextFormat();
			_tf.font = ApplicationConfig.FONT;
			_tf.color = ApplicationConfig.FONT_COLOR;
			_tf.size = 12;
			_tf.leading = 3;
			
			_cardDesText = new TextField();
			_cardDesText.x=SKILL_DESC_POINT.x;
			_cardDesText.y = SKILL_DESC_POINT.y;
			_cardDesText.width = SKILL_DES_WIDTH;
			_cardDesText.autoSize = TextFieldAutoSize.LEFT;
			_cardDesText.wordWrap = true;
			_cardDesText.selectable = false;
			_cardDesText.defaultTextFormat = _tf;
			_lineMc.y = _cardDesText.y + _cardDesText.textHeight + 10;
			_skillDesText = new TextField();
			_skillDesText.x = SKILL_DESC_POINT.x;
			_skillDesText.y = _lineMc.y +_lineMc.height + 10;
			_skillDesText.width = SKILL_DES_WIDTH;
			_skillDesText.autoSize = TextFieldAutoSize.LEFT;
			_skillDesText.wordWrap = true;
			_skillDesText.selectable = false;
			_skillDesText.defaultTextFormat = _tf;
			
			_skillDesText.visible = false;
			_cardDesText.visible = false;
			
            doubleClickEnabled = true;
			addChild(_skillDesText);
			addChild(_cardDesText);
			
			instanceLayer.mask = mc_mask;
			instanceLayer.addChild(mc_mask);
			
			}
		
		/**
		 * 设置不同的字体大小
		 * @param	param
		 * @param	param1
		 */	
		
		public function setSizeFun(t:TextField, s:int = 12):void {
			_size.size = s;
			t.defaultTextFormat=_size;
			}
		 
		/**
		 * 改变速度，攻击力，生命值时触发
		 * @param	value
		 * @param	是否为0里显示－－还是0
		 */	
		public function updataDataModel(param:CardModel,param1:Boolean=false):void {
			/*if (param.sp != _cardModel.sp) {
				//等待时间改变时显示小卡时的等待时间
				smallSpText.text = String(param.sp);
				smallSpText.visible = true;
				}else {
					smallSpText.visible = false;
					}*/
			_cardModel = param;
			if (param1) {
				_atkText.text = String((_cardModel.ap==0)?"0":_cardModel.ap);
				_hpText.text = String((_cardModel.hp==0)?"0":_cardModel.hp);
				}else {
					_atkText.text = String((_cardModel.ap==0)?"--":_cardModel.ap);
					_hpText.text = String((_cardModel.hp==0)?"--":_cardModel.hp);
					}
			
			_spText.text = String(_cardModel.sp);
			smallSpText.text = String(_cardModel.sp);
			}
			
		/**
		 * updatFlag 是否重新加载图片
		 * 设置数据模型
		 * 
		 */
		public function setCardModel(value:CardModel,updatFlag:Boolean=true):void {
			
			_cardModel = value;
			_cardId = value.id;
			//是英雄则显示有带兵数，法宝数，神通数等，边框也相应的显示
			if (isLeader) {
				_allyText.visible = true;
				_talismanText.visible = true;
				_mitacText.visible = true;
				_bigBorder.gotoAndStop((value.race) * 2 - 1);
				_smallBorder.gotoAndStop((value.race) * 2 - 1);
				}else {
					_allyText.visible = false;
					_talismanText.visible = false;
					_mitacText.visible = false;
					_bigBorder.gotoAndStop((value.race)*2);
					_smallBorder.gotoAndStop((value.race)*2);
					}
					
			_allyText.text = String(value.ally);
			_talismanText.text = String(value.talisman);
			_mitacText.text = String(value.mitac);
			_nameBigText.text = value.name;
			_nameText.text = value.name;
			
			//只有传说，吏诗，魔神才显示
			/*if(value.quality>3){
			_qualityMc.gotoAndStop(value.quality);
			_qualityMc.visible = true;
			}*/
			
			_atkText.text = String((value.ap==0)?"--":value.ap);
			_hpText.text = String((value.hp==0)?"--":value.hp);
			_spText.text = String(value.sp);
			smallSpText.text = String(value.sp);
			_classText.text = value.className;
			
			
			_skill1Text.text = "";
			_bigskill1Text.text = "";
			_skill2Text.text = "";
			_bigskill2Text.text = "";
			if (value.skills.length>0) {
				_skill1Text.text = value.skills[0].name;
				_bigskill1Text.text = value.skills[0].name;
				}
			if (value.skills.length>1) {
				_skill2Text.text = value.skills[1].name;
				_bigskill2Text.text = value.skills[1].name;
				}
			
			_cardDesText.htmlText = "";//先还原
			_cardDesText.htmlText = "<font color='#04f5d6'>"+value.description+"</font>";
			ApplicationConfig.setAppTextFormat(_cardDesText);
			var skillDes:String="";
			for (var n:String in value.skills) {
				skillDes+="<font color='#ea7d08'>"+value.skills[n].name+":</font>"+value.skills[n].description + "\n";
				}
			_skillDesText.htmlText = "";//先还原
			_skillDesText.htmlText = skillDes;
			
			_lineMc.y = _cardDesText.y + _cardDesText.textHeight + 10;
			
			//是否有进化，如果没有就隐藏线
			if (value.for1 == "" && value.for2 == "" && value.for3 == "") {
				_lineMc.visible = false;
				_for1Text.text = "";
				_for2Text.text = "";
				_for3Text.text = "";
				_skillDesText.y = _lineMc.y;
				}else if(value.for3=="") {
					//只有两个阶段
					_lineMc.visible = true;
					_for1Text.text = value.for1;
					_for2Text.text = "";
					_for3Text.text = value.for2;
					_for1Text.x = FOR1_POINT.x - _for1Text.textWidth / 2+4;
					_for3Text.x = FOR3_POINT.x - _for3Text.textWidth / 2-4;
					_for1Text.y = _for3Text.y = _lineMc.y + _lineMc.height;
					_skillDesText.y = _for1Text.y+_for1Text.height;
					}else {
						//三个阶段
						_lineMc.visible = true;
						_for1Text.text = value.for1;
						_for2Text.text = value.for2;
						_for3Text.text = value.for3;
						_for1Text.x = FOR1_POINT.x - _for1Text.textWidth / 2;
						_for2Text.x = FOR2_POINT.x - _for2Text.textWidth / 2;
						_for3Text.x = FOR3_POINT.x - _for3Text.textWidth / 2;
						_for1Text.y = _for2Text.y = _for3Text.y = _lineMc.y + _lineMc.height;
						_skillDesText.y = _for1Text.y+_for1Text.height;
						}
			
			
			
			//加载图片
			loadImage(updatFlag);
			checkVisible();
			showMask();
			enable = (_cardModel.number == 0)?false:true;
			
			ApplicationConfig.setAppTextFormat(_skill1Text,_bigskill1Text,_skill2Text,_bigskill2Text,_skillDesText,_nameBigText,_nameText,_for1Text,_for2Text,_for3Text);
			}
			
		/**
		 * 加载图片只有卡容器中没有时才去加载
		 */	
        public function loadImage(updatFlag:Boolean=true) : void
        {
            if (_currentCardTye == 0)
            {
				showBigImage(updatFlag);
				return;
            }
			//====================中卡================================
            else if (_currentCardTye == 1)
            {
				showMiddleImage(updatFlag);
				return;
            }
			//=====================小卡===============================
            else if (_currentCardTye == 2)
            {
				showSmallImage();
				return;
            }
			//=====================技能描述===============================
			else if (_currentCardTye == 3) {
				spriteInstance.scaleX = spriteInstance.scaleY = 1;
				return;
				}
            
        }// end function
		
		/**
		 * 只显示背景,技能描述
		 */
		public function showCardDes():void {
			spriteInstance.scaleX = spriteInstance.scaleY = 1;
			hideAll();
			_lineMc.visible = true;
			_for1Text.visible = true;
			_for2Text.visible = true;
			_for3Text.visible = true;
			_skillDesText.visible = true;
			_cardDesText.visible = true;
			_backCard.visible = true;
			if (_for1Text.text == "" && _for2Text.text == "" && _for3Text.text == "") {
				_lineMc.visible = false;
			}
			}
		
		/**
		 * 显示小图
		 */
		public function showSmallImage() : void
        {
			spriteInstance.scaleX = spriteInstance.scaleY = 1;
			_smallCardBg.visible = true;
			_cardBg.visible = false;
            _smallImage.visible = true;
			_middleImage.visible = false;
			_bigImage.visible = false;
			getImageByType("s");
        }// end function
		
		/**
		 * 显示中图
		 * @param	是否需要重装加载图片
		 */
		public function showMiddleImage(updataFlag:Boolean=false) : void
        {
			
			_cardBg.visible = true;
			spriteInstance.scaleX = spriteInstance.scaleY = .5;
            _smallImage.visible = false;
			if (_middleImage.numChildren == 0)
			{
				_middleImage.visible = true;
				_bigImage.visible = false;
				
				getImageByType("m");
			}else
			{
				if (updataFlag) {
					getImageByType("m");
					}
				_bigImage.visible = false;
				_middleImage.visible = true;
				
			}
        }// end function

		/**
		 * 显示大图
		 */
        public function showBigImage(updataFlag:Boolean=false) : void
        {
			_cardBg.visible = true;
			spriteInstance.scaleX = spriteInstance.scaleY =1;
            //最开始时大检查大中卡容器中是否有卡，大卡时，先请求中大卡都去请求，之后拉成大卡的尺寸，最后大卡加载好了之后隐藏中卡
				
				_smallImage.visible = false;
				
                if (_middleImage.numChildren == 0)
                {
                    _middleImage.visible = true;
                    getImageByType("m");
                }else
                {
					////trace("ssss")
					if (updataFlag) {
						
						getImageByType("m");
						}
					_middleImage.visible = true;
					
                }
               
                if (_bigImage.numChildren == 0)
                {
					getImageByType("b", function () : void
					{
						_bigImage.visible = true;
						_middleImage.visible = false;
						return;
					}// end function
					);
                }
                else
                {
					if (updataFlag) {
						getImageByType("b", function () : void
						{
							_bigImage.visible = true;
							_middleImage.visible = false;
							return;
						}// end function
						);
						}
                    _bigImage.visible = true;
					_middleImage.visible = false;
                }
        }// end function
		
		/**
		 * 检查哪些元素在当前卡状态下要显示的
		 * @param	type
		 * @param	param3
		 */
		public function checkVisible() : void
        {
			hideAll();
			if (_cardModel == null) return;
            if (_currentCardTye==0 || _currentCardTye==1)
            {
				_cardBg.visible = true;//显示大卡初始图
				
				//只有传说，吏诗，魔神才显示
				if(_cardModel.quality>3){
				_qualityMc.gotoAndStop(_cardModel.quality);
				_qualityMc.visible = true;
				}
				_bigBorder.visible = true;
				if (_currentCardTye == 0) {
					//大卡
					_nameText.visible = true;
					_bigImage.visible = true;
					_skill1Text.visible = true;
					_skill2Text.visible = true;
					}else {
						//中卡
						_nameBigText.visible = true;
						_middleImage.visible = true;
						_bigskill1Text.visible = true;
						_bigskill2Text.visible = true;
						}
				_classText.visible = true;
				_atkText.visible = true;
				_hpText.visible = true;
				_spText.visible = true;
				
				//是英雄（有带兵数）
				if (isLeader) {
					_allyText.visible = true;
					_talismanText.visible = true;
					_mitacText.visible = true;
					_bigBorder.gotoAndStop((_cardModel.race) * 2 - 1);
					_smallBorder.gotoAndStop((_cardModel.race) * 2 - 1);
					}else {
						_allyText.visible = false;
						_talismanText.visible = false;
						_mitacText.visible = false;
						_bigBorder.gotoAndStop((_cardModel.race)*2);
						_smallBorder.gotoAndStop((_cardModel.race)*2);
						}
				showStarByType("m");
				
				return;
            }
            else if (_currentCardTye==2)
            {
				_smallCardBg.visible = true;
				_cardBg.visible = false;//小卡时隐藏大卡的初始图
				_smallBorder.gotoAndStop((_cardModel.race) * 2 - 1);
                _smallBorder.visible = true;
			    _smallImage.visible = true;
			    showStarByType("s");
				return;
            }
            else if (_currentCardTye==3)
            {
               _backCard.visible = true;
			   _skillDesText.visible = true;
			   _cardDesText.visible = true;
			   _lineMc.visible = true;
			   _for1Text.visible = true;
			   _for2Text.visible = true;
			   _for3Text.visible = true;
			   return;
            }
            return;
        }// end function
		 
		/**
		 * 大中卡的星级位置一样
		 * 显示星级
		 */
		private function showStarByType(typ:String = "m"):void {
			_star0.visible = false;
			_star1.visible = false;
			_star2.visible = false;
			_star3.visible = false;
			_star4.visible = false;
			//设置星级
			for (var i:uint = 0; i < _cardModel.maxStar; i++ ) {
				this["_star" + i].visible = true;
				this["_star" + i].gotoAndStop(1);
				}
			for (var j:uint = 0; j < _cardModel.star; j++ ) {
				this["_star" + j].gotoAndStop(2);
				this["_star" + j].visible = true;
				}
				
			if (typ == "m" || typ == "b") {
				_star0.x = 31.95;
				_star0.y = 251.25;
				_star1.x = 34;
				_star1.y = 236.6;
				_star2.x = 28.6;
				_star2.y = 222.5;
				_star3.x = 15.2;
				_star3.y = 215.6;
				_star4.x = 1.3;
				_star4.y = 219.25;
				}else {
					_star0.x =0;
					_star0.y = 46.2;
					_star1.x = 15.55;
					_star1.y =46.2;
					_star2.x = 31.1;
					_star2.y =46.2;
					_star3.x = 46.85;
					_star3.y = 46.2;
					_star4.x = 46.85;
					_star4.y =33.05
					}
			}
		
		/**
		 * 全部隐藏中有背景图片
		 * @param	type
		 * @param	param3
		 */
		public function hideAll(showBg:Boolean = false):void {
			smallSpText.visible = false;
			_smallCardBg.visible = false;
			if (showBg) {
				_cardBg.visible = true;
				//_smallCardBg.visible = true;
				}else {
					_cardBg.visible = false;
					//_smallCardBg.visible = false;
					}
			
			_backCard.visible = false;
			_lineMc.visible = false;
			_qualityMc.visible = false;
			_bigBorder.visible = false;
			_smallBorder.visible = false;
			_star0.visible = false;
			_star1.visible = false;
			_star2.visible = false;
			_star3.visible = false;
			_star4.visible = false;
			mc_big_ready.visible = false;
			mc_ready.visible = false;
			_middleImage.visible = false;
			_smallImage.visible = false;
			_bigImage.visible = false;
			_nameBigText.visible = false;
			_nameText.visible = false;
			_allyText.visible = false;
			_talismanText.visible = false;
			_mitacText.visible = false;
			_atkText.visible = false;
			_hpText.visible = false;
			_spText.visible = false;
			_skill1Text.visible = false;
			_bigskill1Text.visible = false;
			_skill2Text.visible = false;
			_bigskill2Text.visible = false;
			_classText.visible = false;
			_skillDesText.visible = false;
			_cardDesText.visible = false;
			_for1Text.visible = false;
			_for2Text.visible = false;
			_for3Text.visible = false;
			}
		/**
		 * 只显示小图背景图
		 */
		public function onlyShowSmallbg():void {
			hideAll();
			_smallCardBg.visible = true;
			this.scaleX = this.scaleY = 1;
			}
		/**
		 * 根据要显示的大中小的哪一种而把加载的图片放到相应的容器中
		 *
		 * @param	type 标志
		 * @param	param3 回调
		 */
		private function getImageByType(type:String="m", param3:Function = null) : void
        {
			var loadImageUrl:String;
			loadImageUrl = retunCardImageUrl(type);
			
			if (_cardModel && _cardModel.id > 0) {
				var temp:Sprite = retunCardContent(type);
				SMZTResourceManager.getInstance().loadAssets(loadImageUrl, function addToContent(param:Loader,imageurl:String):void
					{
						if (retunCardImageUrl(type) != imageurl) {
							return;
							}
						if (temp.numChildren != 0) {
							clearImgIco(temp);
							}
						temp.addChild(param);
						//加载中卡图片时
						if (type == "m") {
							temp.width = ApplicationConfig.CARD_WIDTH;
							temp.height=ApplicationConfig.CARD_HEIGHT;
							}
						if (param3 != null)
							{
								param3();
							}
						}
						);
					
				}
			
		}
		
		/*清除图标
		* @ param
		* @ param
		*/
        protected function clearImgIco(parma:Sprite) : void
        {
            while (parma.numChildren > 0)
            {
                if (parma.getChildAt(0) is Loader) {
					if ((parma.getChildAt(0) as Loader).content is Bitmap) {
						((parma.getChildAt(0) as Loader).content as Bitmap).bitmapData.dispose();
						} 
					(parma.getChildAt(0) as Loader).unload();
					}
                parma.removeChildAt(0);
                parma.filters = null;
            }
            parma.filters = null;
            return;
        }// end function
		//====================================================
		private function retunCardContent(parma:String = "m"):Sprite {
			var cardContent:Sprite=_middleImage;
			switch(parma) {
				case "b":
					cardContent = _bigImage;
					break;
				case "m":
					cardContent = _middleImage;
					break;
				case "s":
					cardContent = _smallImage;
					break;
				default:
					break;
				}
			clearImgIco(cardContent);
			return cardContent;
			}
		private function retunCardImageUrl(parma:String = "m"):String {
			if (_cardModel == null) return null;
			var imageUrlStr:String=_cardModel.middleCardImage;
			switch(parma) {
				case "b":
					imageUrlStr = _cardModel.bigCardImage;
					break;
				case "m":
					imageUrlStr = _cardModel.middleCardImage;
					break;
				case "s":
					imageUrlStr = _cardModel.smallCardImage;
					break;
				default:
					break;
				}
			return imageUrlStr;
			}
		//====================================================
		/**
		 * 克隆该卡的什么状态（大中小背）
		 * @param	param
		 * @return
		 */
		public function clone(param:int=0) : Card
        {
			
            var _loc_1:Card = new Card();
			_loc_1._currentCardTye = param;
            _loc_1.setCardModel(_cardModel);
            return _loc_1;
        }// end function
		/**
		 * 获取数据模型
		 */
		public function getCardModel():CardModel {
			return _cardModel;
			}
		/**
		 * 只设数据模型不加载图片
		 * @param	arg
		 */
		public function setCardModelDontLoadImage(arg:CardModel):void {
			_cardModel=arg;
			}	
		public function showMask() : void
        {
            this.mc_mask.graphics.clear();
            this.mc_mask.graphics.beginFill(0, 1);
            //this.mc_mask.graphics.drawRect(-14, -14, currentCardWidth+14, currentCardHeight+14);
            this.mc_mask.graphics.drawRect(0, 0, currentCardWidth, currentCardHeight);
            this.mc_mask.graphics.endFill();
			//mc_mask.mouseChildren = true;
			//mc_mask.mouseEnabled = true;
            return;
        }// end function

        public function hideMask() : void
        {
            this.mc_mask.graphics.clear();
            return;
        }// end function
		//================get set====================================
		public function get currentCardWidth() : Number
		 {
			if (_currentCardTye == 0 || _currentCardTye == 3) {
				_currentCardWidth = ApplicationConfig.CARD_WIDTH;
				}else if (_currentCardTye == 1) {
					_currentCardWidth = ApplicationConfig.CARD_WIDTH >> 1;
					}else {
						_currentCardWidth = ApplicationConfig.SMALL_CARD_WH;
						}
		   return _currentCardWidth;
		}// end function
		
		public function set currentCardWidth(param1:Number) : void
		{
		  _currentCardWidth= param1;
		  return;
		}// end function
		
		public function get currentCardHeight() : Number
		 {
			if (_currentCardTye == 0 || _currentCardTye == 3) {
				_currentCardHeight = ApplicationConfig.CARD_HEIGHT;
				}else if (_currentCardTye == 1) {
					_currentCardHeight = ApplicationConfig.CARD_HEIGHT >> 1;
					}else {
						_currentCardHeight = ApplicationConfig.SMALL_CARD_WH;
						}
		   return _currentCardHeight;
		}// end function
		
		public function set currentCardHeight(param1:Number) : void
		{
		  _currentCardHeight= param1;
		  return;
		}// end function
		
		public function get enable() :Boolean
		 {
		   return _enable;
		}// end function
		
		public function set enable(param1:Boolean) : void
		{
		  _enable = param1;
		  if (!_enable) {
			  XColor.removeColor(this);
			  }else {
				  this.filters = null;
				  }
		  return;
		}// end function
		
		public function get selectedColor() : uint
        {
            return this._selectedColor;
        }// end function

        public function set selectedColor(param1:uint) : void
        {
            this._selectedColor = param1;
            this._selGlowFilter.color = this._selectedColor;
            return;
		}
		
		public function get selectedWidth() : uint
        {
            return this._selectedWidth;
        }// end function

        public function set selectedWidth(param1:uint) : void
        {
            this._selectedWidth = param1;
            this._selGlowFilter.blurX = this._selectedWidth;
            this._selGlowFilter.blurY = this._selectedWidth;
            return;
        }// end function
		
		public function get selected() : Boolean
        {
            return this._selected;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            if (param1)
            {
				
				if (enable) {
					//selectedColor = 65280;
					//enable = true;
					
					}else {
						//selectedColor = 88888;
						enable = false;
						}
                this.filters = this.filters.concat([this._selGlowFilter]);
            }
            else
            {
				
				this.filters = [];
                if (!enable) {
					enable = false;
					}else {
						enable = true;
						}
            }
            return;
        }// end function
		
		public function get showTip() : Boolean
		 {
		   return _showTip;
		}// end function
		
		public function set showTip(param1:Boolean) : void
		{
		  _showTip = param1;
		  if (_showTip) {
			  CardTipManager.getInstance().showTip(this);
			  
			  }else {
				  CardTipManager.getInstance().hideTip(this);
				  }
		  
		  return;
		}// end function
		
		
		//====================================================
		public function get lianManSp() : Sprite
		 {
		   return _lianManSp;
		}// end function
		
		public function set lianManSp(param1:Sprite) : void
		{
		  _lianManSp= param1;
		  return;
		}// end function
		
		
		public function get isLeader() : Boolean
		 {
			if (getCardModel().ally > 0) {
				_isLeader = true;
				}else { 
				_isLeader = false;
				}
		   return _isLeader;
		}// end function
		
		public function set isLeader(param1:Boolean) : void
		{
		  _isLeader= param1;
		  
		}// end function

		
		public function get oldPoint() : Point
		 {
		   return _oldPoint;
		}// end function
		
		public function set oldPoint(param1:Point) : void
		{
		  _oldPoint= param1;
		  return;
		}// end function
		public function get state() : int
		{
			 return _state;
			}// end function
		public function get uniquesId() : String
			 {
			   return _uniquesId;
			}// end function
			
		public function set uniquesId(param1:String) : void
			{
			  _uniquesId= param1;
			  return;
			}// end function	
		public function set state(param1:int) : void
		{
			_state= param1;
			 return;
			}// end function	
		
		public function get cardId() : int
		{
		   return _cardModel.id;
		}// end function
		
		public function set cardId(param1:int) : void
		{
		  _cardId= _cardModel.id=param1;
		  return;
		}// end function
		//====================================================
		private function removeText(txt:TextField):void {
			if (txt.parent) {
				txt.parent.removeChild(txt);
				txt = null;
				}
			}
		public function disposeBM():void {
			clearImgIco(_bigImage);
			clearImgIco(_smallImage);
			clearImgIco(_middleImage);
			this.filters = null;
			//--------------------------------------------------------
			removeText(_nameBigText);
			removeText(_nameText);
			removeText(_allyText);
			removeText(_talismanText);
			removeText(_mitacText);
			removeText(_atkText);
			removeText(_hpText);
			removeText(_spText);
			removeText(_skill1Text);
			removeText(_bigskill1Text);
			removeText(_skill2Text);
			removeText(_bigskill2Text);
			removeText(_classText);
			removeText(_skillDesText);
			removeText(_cardDesText);
			removeText(_for1Text);
			removeText(_for2Text);
			removeText(_for3Text);
			removeText(smallSpText);
			
			//--------------------------------------------------------
			while (spriteInstance.numChildren > 0) {
				
				spriteInstance.removeChildAt(0);
				}
			/*while (this.instanceLayer.numChildren > 0)
            {
                this.instanceLayer.removeChildAt(0);
            }*/
			}
			
		override public function dispose():void {
			while (this.numChildren > 0) {
				this.removeChildAt(0);
				}
			if (parent) {
				parent.removeChild(this);
				}
			_cardModel = null;
			
			}
	}

}