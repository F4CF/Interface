package bhvr.data
{
	public class EnemyBulletData
	{
		 
		
		public var linkageId:String;
		
		public var speedMin:Number;
		
		public var speedMod:Number;
		
		public var speedMax:Number;
		
		public var points:int;
		
		public var fireMinDelay:Number;
		
		public var fireMaxDelay:Number;
		
		public var fireDelayOffsetMod:Number;
		
		public var fireDelayOffsetMax:Number;
		
		public var reactionDelay:Number;
		
		public var anticipationChances:Number;
		
		public function EnemyBulletData()
		{
			super();
			this.linkageId = "None";
			this.speedMin = 0;
			this.speedMod = 0;
			this.speedMax = 0;
			this.points = 0;
			this.fireMinDelay = 10000;
			this.fireMaxDelay = this.fireMinDelay;
			this.fireDelayOffsetMod = 0;
			this.fireDelayOffsetMax = 0;
			this.reactionDelay = 0;
			this.anticipationChances = 0;
		}
	}
}
