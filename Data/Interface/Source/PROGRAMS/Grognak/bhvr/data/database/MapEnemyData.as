package bhvr.data.database
{
	import flash.geom.Point;
	import bhvr.data.StoryConditionType;
	
	public class MapEnemyData extends MapObjectData
	{
		 
		
		public var name:String;
		
		public var locationName:String;
		
		public var activeStoryCondition:int;
		
		public var event:bhvr.data.database.CombatEvent;
		
		private var _paths:Vector.<bhvr.data.database.MapPath>;
		
		public function MapEnemyData()
		{
			this._paths = new Vector.<MapPath>();
			super();
			this.activeStoryCondition = StoryConditionType.NONE;
		}
		
		public function get paths() : Vector.<bhvr.data.database.MapPath>
		{
			return this._paths;
		}
		
		public function get recurring() : Boolean
		{
			return this.paths != null && this.paths.length > 1;
		}
		
		public function get mobile() : Boolean
		{
			if(this.paths == null)
			{
				return false;
			}
			for(var i:uint = 0; i < this.paths.length; i++)
			{
				if(this.paths[i].length > 1)
				{
					return true;
				}
			}
			return false;
		}
		
		public function addPath(path:bhvr.data.database.MapPath) : void
		{
			this.paths.push(path);
		}
		
		public function getPosition(pathId:uint, positionId:uint) : Point
		{
			if(this.paths == null || pathId >= this.paths.length || positionId >= this.paths[pathId].length)
			{
				return null;
			}
			return this.paths[pathId].getTilePosition(positionId);
		}
		
		public function getNextPositionId(pathId:uint, positionId:uint) : uint
		{
			if(this.paths == null || pathId >= this.paths.length || positionId >= this.paths[pathId].length)
			{
				return null;
			}
			if(positionId == this.paths[pathId].length - 1)
			{
				if(this.paths[pathId].looping)
				{
					return 0;
				}
				return positionId;
			}
			return positionId + 1;
		}
	}
}
