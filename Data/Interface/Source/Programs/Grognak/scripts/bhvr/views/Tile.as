package bhvr.views
{
	import bhvr.data.database.TileData;
	import flash.display.MovieClip;
	
	public class Tile extends bhvr.views.MapObject
	{
		 
		
		private var _tileData:TileData;
		
		private var _type:uint;
		
		private var _mapObject:bhvr.views.MapObject;
		
		private var _mapBlocker:bhvr.views.MapBlocker;
		
		public function Tile(flashRef:MovieClip, tileData:TileData, type:uint, colId:uint, rowId:uint)
		{
			super(flashRef);
			this._tileData = tileData;
			this._type = type;
			_colId = colId;
			_rowId = rowId;
			this._mapObject = null;
			this._mapBlocker = null;
			loadAsset(flashRef,this._tileData.assetLink);
		}
		
		public function get tileData() : TileData
		{
			return this._tileData;
		}
		
		public function get type() : uint
		{
			return this._type;
		}
		
		public function get mapObject() : bhvr.views.MapObject
		{
			return this._mapObject;
		}
		
		public function get hasMapObject() : Boolean
		{
			return this._mapObject != null;
		}
		
		public function get mapBlocker() : bhvr.views.MapBlocker
		{
			return this._mapBlocker;
		}
		
		public function get hasMapBlocker() : Boolean
		{
			return this._mapBlocker != null;
		}
		
		public function assignMapObject(obj:bhvr.views.MapObject) : void
		{
			this._mapObject = obj;
		}
		
		public function unassignMapObject() : void
		{
			this._mapObject = null;
		}
		
		public function assignMapBlocker(obj:bhvr.views.MapBlocker) : void
		{
			this._mapBlocker = obj;
		}
		
		override public function dispose() : void
		{
			this._tileData = null;
			this._mapObject = null;
			this._mapBlocker = null;
		}
	}
}
