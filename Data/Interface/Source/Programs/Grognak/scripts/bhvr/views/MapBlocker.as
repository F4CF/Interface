package bhvr.views
{
	import bhvr.data.database.MapBlockerData;
	import flash.display.MovieClip;
	import bhvr.data.GamePersistantData;
	
	public class MapBlocker extends MapObject
	{
		 
		
		private var _blockerData:MapBlockerData;
		
		private var _unblocked:Boolean;
		
		private var _image:String;
		
		public function MapBlocker(flashRef:MovieClip, blockerData:MapBlockerData)
		{
			super(flashRef);
			this._blockerData = blockerData;
			_colId = blockerData.initialPosition.x;
			_rowId = blockerData.initialPosition.y;
			this._unblocked = GamePersistantData.isStoryConditionMet(blockerData.unblockedStoryCondition);
			this._image = !!this.unblocked?this._blockerData.unblockedImage:this._blockerData.image;
			loadAsset(flashRef,this._image);
		}
		
		public function get blockerData() : MapBlockerData
		{
			return this._blockerData;
		}
		
		public function get unblocked() : Boolean
		{
			return this._unblocked;
		}
		
		public function get hasVisual() : Boolean
		{
			return this._image != "";
		}
		
		override public function dispose() : void
		{
			this._blockerData = null;
		}
	}
}
