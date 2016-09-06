package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	
	public class UIMap extends EventDispatcher
	{
		 
		
		private var _locationNameMc:MovieClip;
		
		private var _popupMc:MovieClip;
		
		private const PREFIX:String = "--== ";
		
		private const SUFFIX:String = " ==--";
		
		public function UIMap(assets:MovieClip)
		{
			super();
			this._locationNameMc = assets.locationNameMc;
			this._popupMc = assets.popupMc;
			this.setLocationName("");
			this.setPopupVisibility(false);
		}
		
		public function setLocationName(name:String) : void
		{
			this._locationNameMc.locationNameTxt.text = this.PREFIX + name + this.SUFFIX;
		}
		
		public function getPopupVisibility() : Boolean
		{
			return this._popupMc.visible;
		}
		
		public function setPopupVisibility(isVisible:Boolean) : void
		{
			this._popupMc.visible = isVisible;
		}
		
		public function setPopupData(info:String) : void
		{
			this._popupMc.descriptionTxt.text = info;
		}
		
		public function dispose() : void
		{
			this._locationNameMc = null;
			this._popupMc = null;
		}
	}
}
