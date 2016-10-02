package bhvr.data
{
	public class LevelsParser
	{
		 
		
		private var _levelsList:XMLList;
		
		public function LevelsParser(param1:XML)
		{
			super();
			this._levelsList = param1.elements("Levels").children();
		}
		
		public function parse() : Vector.<LevelData>
		{
			var _loc2_:LevelData = null;
			var _loc4_:XMLList = null;
			var _loc5_:uint = 0;
			var _loc1_:Vector.<LevelData> = new Vector.<LevelData>();
			var _loc3_:uint = 0;
			while(_loc3_ < this._levelsList.length())
			{
				_loc2_ = new LevelData();
				_loc2_.humansNum = this._levelsList[_loc3_].elements("Humans");
				_loc4_ = this._levelsList[_loc3_].elements("Enemies").children();
				_loc5_ = 0;
				while(_loc5_ < _loc4_.length())
				{
					_loc2_.enemiesNum[_loc4_[_loc5_].@id.toString()] = _loc4_[_loc5_];
					_loc5_++;
				}
				_loc1_.push(_loc2_);
				_loc3_++;
			}
			return _loc1_;
		}
		
		public function dispose() : void
		{
			this._levelsList = null;
		}
	}
}
