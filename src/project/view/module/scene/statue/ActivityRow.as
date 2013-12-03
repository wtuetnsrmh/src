package project.view.module.scene.statue
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import project.events.SMZTDataChangeEvent;
	import project.model.data.DataModel;
	import project.model.statue.StatueRowModel;
	import project.view.artplug.MovieClipButton;
	import project.view.base.BaseSprite;
	import project.view.base.BaseSpriteSetUI;
	
	/**
	 *活跃度的每一行
	 * @author bbjxl 2013
	 */
	public class ActivityRow extends BaseSpriteSetUI
	{
		//----------------------容器---------------------------------
		
		//-----------------------UI---------------------------------
		private var _titleText:TextField;
		private var _decText:TextField;
		private var _progressText:TextField;
		private var _pointText:TextField;
		private var _gotoBt:MovieClipButton; //前往按钮
		
		//-----------------------数据---------------------------------
		
		//-----------------------事件--------------------------------
		public function ActivityRow()
		{
			setSpriteInstance("activityRowUI");
			configeInstance();
		}
		
		private function configeInstance():void
		{
			_titleText = getChild("titleText") as TextField;
			_progressText = getChild("progressText") as TextField;
			_pointText = getChild("pointText") as TextField;
			_gotoBt = getChild("gotoBt") as MovieClipButton;
			_gotoBt.onClick = clickHandler;
			_gotoBt.visible = false;
		}
		
		//本行数据模型改变时更新界面
		override public function set dataModel(param1:DataModel):void
		{
			this._dataModel = param1;
			if(!_dataModel.hasEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE)){
				this._dataModel.addEventListener(SMZTDataChangeEvent.ON_DATA_CHANGE, this.onDataChange);
				}
			updataUI();
			return;
		} // end function
		
		
		private function updataUI():void 
		{
			var tempModel:StatueRowModel = _dataModel as StatueRowModel;
			_titleText.text = tempModel.title;
			if (tempModel.finish)
			{
				_gotoBt.clickEnable = false;
				_progressText.htmlText = "<font color='#09e519'>" + tempModel.progress + "/" + tempModel.max + "</font>";
			}
			else
			{
				_gotoBt.clickEnable = true;
				_progressText.htmlText = "<font color='#ffffff'>" + tempModel.progress + "/" + tempModel.max + "</font>";
			}
			_pointText.text = "+" + tempModel.activity;
			
			if (tempModel.type == 0)
			{
				_gotoBt.visible = false;
			}
			else
			{
				_gotoBt.visible = true;
			}
			tempModel = null;
		}
		//
		override protected function onDataChange(event:SMZTDataChangeEvent):void
		{
			
		} // end function
		
		private function clickHandler(e:MouseEvent):void
		{
			ManageToSenceById.gotoSecne((_dataModel as StatueRowModel).type);
		}
	
	}

}