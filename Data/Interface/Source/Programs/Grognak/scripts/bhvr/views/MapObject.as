package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.utils.FlashUtil;
	
	public class MapObject extends MovieClip
	{
		 
		
		protected var _colId:uint;
		
		protected var _rowId:uint;
		
		public var _visual:MovieClip;
		
		public function MapObject(flashRef:MovieClip)
		{
			super();
		}
		
		public function get colId() : uint
		{
			return this._colId;
		}
		
		public function get rowId() : uint
		{
			return this._rowId;
		}
		
		protected function loadAsset(flashRef:MovieClip, linkageId:String) : void
		{
			if(linkageId == "")
			{
				return;
			}
			this._visual = FlashUtil.getLibraryItem(flashRef,linkageId) as MovieClip;
			if(this._visual)
			{
				this.addChild(this._visual);
				return;
			}
			throw new Error("loadAsset: Can\'t find " + linkageId + " in Flash library.");
		}
		
		public function pause() : void
		{
			if(this._visual)
			{
				this._visual.stop();
			}
		}
		
		public function resume() : void
		{
			if(this._visual)
			{
				this._visual.play();
			}
		}
		
		public function dispose() : void
		{
			this._visual = null;
		}
	}
}
