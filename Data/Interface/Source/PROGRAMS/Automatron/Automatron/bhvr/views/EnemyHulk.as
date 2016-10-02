package bhvr.views
{
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.data.EnemyData;
	
	public class EnemyHulk extends Enemy
	{
		 
		
		public function EnemyHulk(param1:MovieClip, param2:EnemyData, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
		
		public function fightOff(param1:int) : void
		{
			var _loc2_:Number = position.x;
			var _loc3_:Number = position.y;
			var _loc4_:Number = GameConstants.enemyFightOffFactor * speed;
			switch(param1)
			{
				case Character.LEFT_DIRECTION:
					_loc2_ = position.x + _loc4_;
					_loc3_ = position.y;
					break;
				case Character.RIGHT_DIRECTION:
					_loc2_ = position.x - _loc4_;
					_loc3_ = position.y;
					break;
				case Character.UP_DIRECTION:
					_loc2_ = position.x;
					_loc3_ = position.y + _loc4_;
					break;
				case Character.DOWN_DIRECTION:
					_loc2_ = position.x;
					_loc3_ = position.y - _loc4_;
			}
			setPosition(_loc2_,_loc3_);
		}
	}
}
