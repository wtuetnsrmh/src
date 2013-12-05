package project.view.module.achievement
{
	import com.ming.ui.controls.Text;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import project.config.ApplicationConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.events.SMZTDataChangeEvent;
	import project.model.achievement.AchievementRowModel;
	import project.model.data.DataModel;
	import project.model.data.PlayerData;
	import project.model.newBie.NewBieModelId;
	import project.utils.XColor;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 * 成就中的每一行
	 * @author bbjxl 2013
	 */
	public class AchievementRow extends BaseSpriteSetUI
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _achievementNameText:TextField; //成就名
		private var _titleText:TextField; //称号
		private var _desText:TextField; //描述
		private var _pointText:TextField; //分数
		private var _dateText:TextField; //日期
		private var _setBt:MovieClipButton; //装备按钮
		//-----------------------数据---------------------------------
		private var _rowDataModel:AchievementRowModel;
		private var _filter:GlowFilter;
		
		//-----------------------事件--------------------------------
		public function AchievementRow()
		{
			setSpriteInstance("achievementRowUI");
			configerInstance();
			_filter = new GlowFilter();
			_filter.color = 0xFFFF00;
			_filter.alpha = 1;
			_filter.blurX = 2;
			_filter.blurY = 2;
			_filter.quality = BitmapFilterQuality.LOW;
			_filter.strength = 5;
			this.buttonMode = true;
		}
		
		public function selected(value:Boolean = true):void
		{
			if (value)
			{
				this.filters = null;
				if (_rowDataModel.finish)
				{
					
					this.filters = [_filter];
				}
				else
				{
					
					XColor.removeColor(this);
					this.filters=this.filters.concat(_filter);
				}
			}
			else
			{
				this.filters = null;
				if (!_rowDataModel.finish)
				{
					XColor.removeColor(this);
				}
				
			}
		}
		
		private function configerInstance():void
		{
			_achievementNameText = getChild("achievementNameText") as TextField;
			_titleText = getChild("titleText") as TextField;
			_desText = getChild("desText") as TextField;
			_pointText = getChild("pointText") as TextField;
			_dateText = getChild("dateText") as TextField;
			
			
			_achievementNameText.mouseEnabled = false;
			_titleText.mouseEnabled = false;
			_desText.mouseEnabled = false;
			_pointText.mouseEnabled = false;
			_dateText.mouseEnabled = false;
			
			_setBt = getChild("setBt") as MovieClipButton;
			_setBt.onClick = setBtClick;
			
			ApplicationConfig.setDefaultTextFormat(_achievementNameText,_titleText,_desText,_pointText,_dateText);
		}
		
		private function setBtClick(e:MouseEvent):void
		{
			if (PlayerData.getInstance().title == _rowDataModel.id)
			{
				return;
			}
			SMZTController.getInstance().equipAchievement(_rowDataModel.id, function():void
				{
					AchievementPanel.getInstance().setCurrentTitle(_titleText.text);
					PlayerData.getInstance().title = _rowDataModel.id;
					//-------------------新手引导用-----------------------
					if (!NewBieControler.getInstance().finishDic[NewBieModelId.ACHIVEVEMENT2]) {
						NewBieControler.getInstance().refreshByValue(NewBieModelId.ACHIVEVEMENT2, 0, 0);
						}
					//--------------------end--------------------
				})
		}
		
		public function get rowDataModel():AchievementRowModel
		{
			return _rowDataModel;
		}
		
		public function set rowDataModel(value:AchievementRowModel):void
		{
			_rowDataModel = value;
			//dataModel = value;
			_achievementNameText.text = _rowDataModel.name;
			_titleText.text = _rowDataModel.title;
			if (_rowDataModel.title == "")
			{
				_setBt.visible = false;
			}
			else
			{
				_setBt.visible = true;
				if (_rowDataModel.finish)
				{
					_setBt.clickEnable = true;
					
				}
				else
				{
					_setBt.clickEnable = false;
					
				}
			}
			if (_rowDataModel.finish)
			{
				
				this.filters = null;
			}
			else
			{
				
				XColor.removeColor(this);
			}
			_desText.text = _rowDataModel.desc;
			_pointText.text = _rowDataModel.point.toString();
			_dateText.text = turnTimerFM(_rowDataModel.time);
		}
		private var nowData:Date;
		
		private function turnTimerFM(ti:Number):String
		{
			if (ti == 0)
				return "";
			nowData = new Date(ti * 1000);
			var year:String = nowData.fullYearUTC.toString();
			var month:String = (nowData.monthUTC + 1 >= 10) ? String(nowData.monthUTC + 1) : "0" + String(nowData.monthUTC + 1);
			var day:String = (nowData.dateUTC >= 10) ? String(nowData.dateUTC) : "0" + String(nowData.dateUTC);
			var result:String = year + '.' + month + '.' + day;
			return result;
		}
		
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			
			return;
		} // end function
	
	}

}