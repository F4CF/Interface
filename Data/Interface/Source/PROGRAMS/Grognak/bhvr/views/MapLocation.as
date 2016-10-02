package bhvr.views
{
	import bhvr.data.database.MapLocationData;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.GamePersistantData;
	import bhvr.data.database.InteractionEvent;
	import flash.display.MovieClip;
	
	public class MapLocation extends MapObject
	{
		 
		
		private var _locationData:MapLocationData;
		
		private var _cleared:Boolean;
		
		public function MapLocation(flashRef:MovieClip, locationData:MapLocationData)
		{
			super(flashRef);
			this._locationData = locationData;
			_colId = this._locationData.initialPosition.x;
			_rowId = this._locationData.initialPosition.y;
			this._cleared = GamePersistantData.isStoryConditionMet(locationData.clearedStoryCondition) || this.hasCombatEventCleared;
			var image:String = this.cleared && locationData.clearedImage != ""?locationData.clearedImage:locationData.image;
			loadAsset(flashRef,image);
		}
		
		public function get locationData() : MapLocationData
		{
			return this._locationData;
		}
		
		public function get cleared() : Boolean
		{
			return this._cleared;
		}
		
		public function get hasCombatEvent() : Boolean
		{
			return this.locationData.event is CombatEvent;
		}
		
		public function get hasCombatEventCleared() : Boolean
		{
			return this.hasCombatEvent && GamePersistantData.isCombatEventCompleted(CombatEvent(this.locationData.event));
		}
		
		public function get hasInteractionEvent() : Boolean
		{
			return this.locationData.event is InteractionEvent;
		}
		
		override public function dispose() : void
		{
			this._locationData = null;
		}
	}
}
