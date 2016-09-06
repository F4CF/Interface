package bhvr.data.database
{
	import flash.geom.Point;
	
	public class MapPath
	{
		 
		
		public var looping:Boolean;
		
		private var _tiles:Vector.<Point>;
		
		public function MapPath()
		{
			this._tiles = new Vector.<Point>();
			super();
			this.looping = false;
		}
		
		public function get tiles() : Vector.<Point>
		{
			return this._tiles;
		}
		
		public function get length() : uint
		{
			return this.tiles.length;
		}
		
		public function addPosition(colId:uint, rowId:uint) : void
		{
			this.tiles.push(new Point(colId,rowId));
		}
		
		public function getTilePosition(id:uint) : Point
		{
			if(id > this.tiles.length - 1)
			{
				throw new Error("MapPath::getTilePosition : Index " + id + " is out of range");
			}
			if(this._tiles.length > 0)
			{
				return this.tiles[id];
			}
			return null;
		}
	}
}
