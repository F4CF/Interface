package bhvr.views
{
	import bhvr.data.database.MapShipData;
	import bhvr.data.GamePersistantData;
	import flash.display.MovieClip;
	
	public class MapShip extends MapObject
	{
		 
		
		private var _shipData:MapShipData;
		
		public function MapShip(flashRef:MovieClip, shipData:MapShipData)
		{
			super(flashRef);
			this._shipData = shipData;
			_colId = !!this.hasInitialPositionFromSavedGame?uint(GamePersistantData.shipInitialPosition.x):uint(shipData.initialPosition.x);
			_rowId = !!this.hasInitialPositionFromSavedGame?uint(GamePersistantData.shipInitialPosition.y):uint(shipData.initialPosition.y);
			loadAsset(flashRef,shipData.image);
		}
		
		public function get shipData() : MapShipData
		{
			return this._shipData;
		}
		
		private function get hasInitialPositionFromSavedGame() : Boolean
		{
			return GamePersistantData.shipInitialPosition.x >= 0 && GamePersistantData.shipInitialPosition.y >= 0;
		}
		
		public function setTilePosition(colId:uint, rowId:uint) : void
		{
			if(colId != _colId)
			{
				this.scaleX = colId > _colId?Number(1):Number(-1);
			}
			_colId = colId;
			_rowId = rowId;
		}
		
		override public function dispose() : void
		{
			this._shipData = null;
		}
	}
}
