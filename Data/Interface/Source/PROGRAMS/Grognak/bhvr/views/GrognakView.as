package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.data.database.MapHeroData;
	import bhvr.data.GamePersistantData;
	
	public class GrognakView extends MapObject
	{
		 
		
		public function GrognakView(flashRef:MovieClip, mapHeroData:MapHeroData)
		{
			super(flashRef);
			loadAsset(flashRef,mapHeroData.assetLink);
			_colId = GamePersistantData.prevHeroPosition.x;
			_rowId = GamePersistantData.prevHeroPosition.y;
		}
		
		public function setTilePosition(colId:uint, rowId:uint) : void
		{
			_colId = colId;
			_rowId = rowId;
		}
	}
}
