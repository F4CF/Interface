package
{
	import flash.display.MovieClip;
	
	public dynamic class EnemyType5 extends MovieClip
	{
		 
		
		public var viewMc:MovieClip;
		
		public function EnemyType5()
		{
			super();
			addFrameScript(1,this.frame2,7,this.frame8,21,this.frame22);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame8() : *
		{
			gotoAndPlay("damage");
		}
		
		function frame22() : *
		{
			stop();
		}
	}
}
