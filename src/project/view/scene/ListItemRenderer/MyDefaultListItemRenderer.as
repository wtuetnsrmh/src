/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package project.view.scene.ListItemRenderer
{
	import feathers.controls.List;
	import project.view.scene.ListItemRenderer.CustomItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import starling.events.Event;
	
	/**
	 * The default item renderer for List control. Supports up to three optional
	 * sub-views, including a label to display text, an icon to display an
	 * image, and an "accessory" to display a UI control or another display
	 * object (with shortcuts for including a second image or a second label).
	 * 
	 * @see feathers.controls.List
	 */
	public class MyDefaultListItemRenderer extends CustomItemRenderer implements IListItemRenderer
	{
		/**
		 * Constructor.
		 */
		public function MyDefaultListItemRenderer()
		{
			super();
		}
		
		/**
		 * @private
		 */
		protected var _index:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return List(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				List(this._owner).removeEventListener(Event.SCROLL, owner_scrollHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				const list:List = List(this._owner);
				this.isToggle = list.isSelectable;
				list.addEventListener(Event.SCROLL, owner_scrollHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected function owner_scrollHandler(event:Event):void
		{
			this.handleOwnerScroll();
		}
	}
}