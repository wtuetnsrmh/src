package project.view.module.platform 
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import project.config.ApplicationConfig;
	import project.debug.Debug;
	import project.model.item.ItemModel;
	import project.view.module.cell.BaseIcoCell;
	import project.view.module.cell.BaseIcoCellLoader;
	import flash.filters.GradientGlowFilter;
    import flash.filters.GlowFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.text.TextField;
	/**
	 * 升级礼包奖励物品槽
	 * @author bbjxl 2013
	 */
	public class AwardItemIco extends BaseIcoCell 
	{
		private var _number:int;
		public function VipItemIco() 
		{
			setSpriteInstance("awardIcoBgBigUI");
            imgScale = 1;
            imgMode = 1;
            return;
		}
		/**
		 * 清空
		 * @param	param1
		 */
		public function clearIco():void {
			clearImgIco();
			spriteInstance.filters = null;
			while (txtLayer.numChildren > 0)
			{
				txtLayer.removeChildAt(0);
				}
			}
		//选中状态
        public function setOnChoose(param1:Boolean) : void
        {
            var _loc_2:GlowFilter = null;
            if (param1)
            {
                _loc_2 = new GlowFilter();
                _loc_2.color = 0xFFFF00;
                _loc_2.alpha = 1;
                _loc_2.blurX = 3;
                _loc_2.blurY = 3;
                _loc_2.quality = BitmapFilterQuality.MEDIUM;
                _loc_2.strength = 20;
                _imageLayer.filters = [_loc_2];
            }
            else
            {
                _imageLayer.filters = null;
            }
            return;
        }// end function


        public function get number() : int
        {
            return this._number;
        }// end function

        public function set number(param1:int) : void
        {
            return;
        }// end function

        override protected function setImgIco(param1:DisplayObject) : void
        {
            clearImgIco();
            param1.x = 0;
            param1.y = 0;
            if (_item)
            {
                _imageLayer.addChild(param1);
            }
            return;
        }// end function

        public function set itemIco(param1:*) : void
        {
            var _loc_2:TextField = null;
            var _loc_3:GlowFilter = null;
            var _loc_4:TextFormat = null;
            //var _loc_5:GlowFilter = null;
			
            if (param1)
            {
				//Debug.log("param1.ico=" + param1.ico);
                clearImgIco();
                //_item = param1;
				
				 ico = param1.ico;
                this._number = param1.number;
                _loc_2 = new TextField();//数量文字
                _loc_3 = new GlowFilter(0);
                _loc_2.filters = [_loc_3];
                _loc_2.selectable = false;
                _loc_2.mouseEnabled = false;
                _loc_4 = new TextFormat();
                _loc_4.color = ApplicationConfig.FONT_COLOR;
                _loc_4.size = 15;
				_loc_2.multiline = false;
                _loc_2.width = 51;
                //_loc_2.height = 14;
                _loc_2.x = 0;
                _loc_2.y = 31;
                if (this._number != 1)
                {
                    _loc_2.text = this._number.toString();
                }
                _loc_2.autoSize = "right";
                _loc_2.setTextFormat(_loc_4);
                while (txtLayer.numChildren > 0)
                {
                    
                    txtLayer.removeChildAt(0);
                }
                txtLayer.addChild(_loc_2);
				
            }
            else
            {
                //_item = null;
                ico = null;
                while (txtLayer.numChildren > 0)
                {
                    
                    txtLayer.removeChildAt(0);
                }
                clearImgIco();
            }
            return;
        }
		
		override public function set item(param1:ItemModel) : void
        {
            var _loc_2:TextField = null;
            var _loc_3:GlowFilter = null;
            var _loc_4:TextFormat = null;
            //var _loc_5:GlowFilter = null;
			
            if (param1)
            {
				//Debug.log("param1.ico=" + param1.ico);
                clearImgIco();
                _item = param1;
				
				 ico = param1.ico;
                this._number = param1.number;
                _loc_2 = new TextField();//数量文字
                _loc_3 = new GlowFilter(0);
                _loc_2.filters = [_loc_3];
                _loc_2.selectable = false;
                _loc_2.mouseEnabled = false;
                _loc_4 = new TextFormat();
                _loc_4.color = ApplicationConfig.FONT_COLOR;
                _loc_4.size = 15;
				_loc_2.multiline = false;
                _loc_2.width = 51;
                //_loc_2.height = 14;
                _loc_2.x = 0;
                _loc_2.y = 31;
                if (this._number != 1)
                {
                    _loc_2.text = this._number.toString();
                }
                _loc_2.autoSize = "right";
                _loc_2.setTextFormat(_loc_4);
                while (txtLayer.numChildren > 0)
                {
                    
                    txtLayer.removeChildAt(0);
                }
                txtLayer.addChild(_loc_2);
				
            }
            else
            {
                _item = null;
                ico = null;
                while (txtLayer.numChildren > 0)
                {
                    
                    txtLayer.removeChildAt(0);
                }
                clearImgIco();
            }
            return;
        }
	}

}