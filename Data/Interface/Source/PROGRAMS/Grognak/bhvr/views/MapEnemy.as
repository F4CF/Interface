package bhvr.views
{
	import bhvr.data.database.MapEnemyData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.data.GamePersistantData;
	
	public class MapEnemy extends MapObject
	{
		 
		
		private var _enemyData:MapEnemyData;
		
		private var _pathId:uint;
		
		private var _pathPositionId:uint;
		
		public function MapEnemy(flashRef:MovieClip, enemyData:MapEnemyData)
		{
			var position:Point = null;
			super(flashRef);
			this._enemyData = enemyData;
			if(this._enemyData.recurring)
			{
				this._pathId = GamePersistantData.getCompletedCombatEventCounter(this._enemyData.event) % this._enemyData.paths.length;
				if(this._enemyData.mobile)
				{
					this._pathPositionId = GamePersistantData.getRecurringEnemyPathId(this._enemyData) != this.pathId?uint(0):uint(GamePersistantData.getMobileEnemyPositionId(this._enemyData));
					GamePersistantData.setMobileEnemyPositionId(this._enemyData,this._pathPositionId);
				}
				else
				{
					this._pathPositionId = 0;
				}
				GamePersistantData.setRecurringEnemyPathId(this._enemyData,this._pathId);
				position = this._enemyData.getPosition(this._pathId,this._pathPositionId);
				_colId = position.x;
				_rowId = position.y;
			}
			else if(this._enemyData.mobile)
			{
				this._pathId = 0;
				this._pathPositionId = GamePersistantData.getMobileEnemyPositionId(this._enemyData);
				position = this._enemyData.getPosition(this._pathId,this._pathPositionId);
				_colId = position.x;
				_rowId = position.y;
			}
			else
			{
				_colId = enemyData.initialPosition.x;
				_rowId = enemyData.initialPosition.y;
			}
			loadAsset(flashRef,this._enemyData.image);
		}
		
		public function get enemyData() : MapEnemyData
		{
			return this._enemyData;
		}
		
		public function get pathId() : uint
		{
			return this._pathId;
		}
		
		public function get pathPositionId() : uint
		{
			return this._pathPositionId;
		}
		
		public function setTilePosition(colId:uint, rowId:uint, pathPositionId:uint) : void
		{
			_colId = colId;
			_rowId = rowId;
			this._pathPositionId = pathPositionId;
		}
		
		override public function dispose() : void
		{
			this._enemyData = null;
		}
	}
}
