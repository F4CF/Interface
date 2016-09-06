package bhvr.data
{
	import flash.utils.Dictionary;
	
	public class EnemiesParser
	{
		 
		
		private var _enemiesList:XMLList;
		
		public function EnemiesParser(param1:XML)
		{
			super();
			this._enemiesList = param1.elements("Enemies").children();
		}
		
		public function parse() : Dictionary
		{
			var _loc2_:EnemyData = null;
			var _loc1_:Dictionary = new Dictionary(true);
			var _loc3_:uint = 0;
			while(_loc3_ < this._enemiesList.length())
			{
				_loc2_ = this.parseEnemyData(XMLList(this._enemiesList[_loc3_]));
				_loc1_[_loc2_.id] = _loc2_;
				_loc3_++;
			}
			return _loc1_;
		}
		
		private function parseEnemyData(param1:XMLList) : EnemyData
		{
			var _loc2_:EnemyData = null;
			_loc2_ = new EnemyData();
			_loc2_.id = param1.elements("Id");
			_loc2_.linkageId = param1.elements("LinkageId");
			_loc2_.name = param1.elements("Name");
			_loc2_.speed = param1.elements("Speed");
			_loc2_.points = param1.elements("Points");
			if(_loc2_.points > 0)
			{
				_loc2_.displayPointsOnScreen = param1.elements("Points").@displayOnScreen == "true";
			}
			_loc2_.mustBeKilled = param1.elements("MustBeKilled") == "true";
			if(param1.hasOwnProperty("Bullet"))
			{
				_loc2_.bulletData.linkageId = param1.elements("Bullet").elements("LinkageId");
				_loc2_.bulletData.speedMin = param1.elements("Bullet").elements("SpeedMin");
				_loc2_.bulletData.speedMax = param1.elements("Bullet").elements("SpeedMax");
				_loc2_.bulletData.speedMod = param1.elements("Bullet").elements("SpeedMod");
				_loc2_.bulletData.points = param1.elements("Bullet").elements("Points");
				_loc2_.bulletData.fireMinDelay = param1.elements("Bullet").elements("FireDelayMin");
				_loc2_.bulletData.fireMaxDelay = param1.elements("Bullet").elements("FireDelayMax");
				_loc2_.bulletData.fireDelayOffsetMax = param1.elements("Bullet").elements("FireDelayOffsetMax");
				_loc2_.bulletData.fireDelayOffsetMod = param1.elements("Bullet").elements("FireDelayOffsetMod");
				_loc2_.bulletData.reactionDelay = param1.elements("Bullet").elements("ReactionDelay");
				_loc2_.bulletData.anticipationChances = param1.elements("Bullet").elements("AnticipationChances");
			}
			else
			{
				_loc2_.bulletData = null;
			}
			if(param1.hasOwnProperty("Spawn"))
			{
				_loc2_.spawnData.id = param1.elements("Spawn").elements("Id");
				_loc2_.spawnData.spawnMinDelay = param1.elements("Spawn").elements("DelayMin");
				_loc2_.spawnData.spawnMaxDelay = param1.elements("Spawn").elements("DelayMax");
				_loc2_.spawnData.spawnDelayOffsetMax = param1.elements("Spawn").elements("DelayOffsetMax");
				_loc2_.spawnData.spawnDelayOffsetMod = param1.elements("Spawn").elements("DelayOffsetMod");
			}
			else
			{
				_loc2_.spawnData = null;
			}
			if(param1.hasOwnProperty("Path"))
			{
				_loc2_.pathData.id = param1.elements("Path").elements("Id");
				_loc2_.pathData.speedMin = param1.elements("Path").elements("SpeedMin");
				_loc2_.pathData.speedMax = param1.elements("Path").elements("SpeedMax");
				_loc2_.pathData.speedMod = param1.elements("Path").elements("SpeedMod");
				_loc2_.pathData.allowStop = param1.elements("Path").elements("AllowStop") == "true";
				_loc2_.pathData.changeDirAfterStopDelay = param1.elements("Path").elements("ChangeDirectionAfterStopDelay");
				_loc2_.pathData.changeDirMinDelay = param1.elements("Path").elements("ChangeDirectionDelayMin");
				_loc2_.pathData.changeDirMaxDelay = param1.elements("Path").elements("ChangeDirectionDelayMax");
				_loc2_.pathData.aggroRadius = param1.elements("Path").elements("AggroRadius");
				_loc2_.pathData.canHuntHumans = param1.elements("Path").elements("HuntHumans") == "true";
			}
			return _loc2_;
		}
		
		public function dispose() : void
		{
			this._enemiesList = null;
		}
	}
}
