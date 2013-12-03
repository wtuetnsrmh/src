package project.view.module.scene.cultivation
{
	import flash.text.TextField;
	import project.model.cultivation.MixExpressModel;
	import project.view.base.BaseSpriteSetUI;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	/**
	 * 公式卷轴
	 * @author bbjxl 2013
	 */
	public class ExpressRow extends BaseSpriteSetUI
	{
		private var _nameText:TextField;
		private var _model:MixExpressModel;
		private var _selected:Boolean;
		private var _filter:GlowFilter;
		public function ExpressRow()
		{
			_filter = new GlowFilter();
			_filter.color = 0xFFFF00;
			_filter.alpha = 1;
			_filter.blurX = 2;
			_filter.blurY = 2;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			
			setSpriteInstance("ExpressRowUI");
			configerInstance();
			this.buttonMode = true;
		}
		
		private function configerInstance():void
		{
			_nameText = getChild("nameText") as TextField;
			_nameText.mouseEnabled = false;
		}
		
		public function updata(value:MixExpressModel):void
		{
			_model = value;
			_nameText.text = _model.itemName;
		
		}
		
		public function get model():MixExpressModel
		{
			return _model;
		}
		
		public function set model(value:MixExpressModel):void
		{
			_model = value;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (value) {
				this.filters = [_filter];
				}else {
					this.filters = null;
					}
		}
	
	}

}