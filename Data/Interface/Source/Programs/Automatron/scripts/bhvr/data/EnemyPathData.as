package bhvr.data
{
	import bhvr.ai.Path;
	
	public class EnemyPathData
	{
		 
		
		public var id:uint;
		
		public var speedMin:Number;
		
		public var speedMod:Number;
		
		public var speedMax:Number;
		
		public var allowStop:Boolean;
		
		public var changeDirMinDelay:Number;
		
		public var changeDirMaxDelay:Number;
		
		public var changeDirAfterStopDelay:Number;
		
		public var aggroRadius:Number;
		
		public var canHuntHumans:Boolean;
		
		public function EnemyPathData()
		{
			super();
			this.id = Path.NO_PATH;
			this.speedMin = 0;
			this.speedMod = 0;
			this.speedMax = 0;
			this.allowStop = false;
			this.changeDirMinDelay = 10000;
			this.changeDirMaxDelay = this.changeDirMinDelay;
			this.changeDirAfterStopDelay = 0;
			this.aggroRadius = 0;
			this.canHuntHumans = false;
		}
	}
}
