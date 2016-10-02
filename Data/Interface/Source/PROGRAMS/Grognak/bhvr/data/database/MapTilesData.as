package bhvr.data.database
{
	import flash.utils.Dictionary;
	
	public class MapTilesData
	{
		 
		
		public var tiles:Vector.<Vector.<uint>>;
		
		public var tileProperties:Dictionary;
		
		public function MapTilesData()
		{
			super();
			this.tileProperties = new Dictionary(true);
		}
		
		public function addTileProperty(id:uint, data:TileData) : void
		{
			if(this.tileProperties[id] != null)
			{
				throw new Error("MapTilesData: A Tile property already exists with id \'" + id + "\'.");
			}
			this.tileProperties[id] = data;
		}
	}
}
