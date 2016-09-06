package
{
	import flash.display.MovieClip;
	
	public dynamic class EnemyType1 extends MovieClip
	{
		 
		
		public var viewMc:MovieClip;
		
		public function EnemyType1()
		{
			super();
			addFrameScript(1,this.frame2,7,this.frame8,15,this.frame16);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame8() : *
		{
			gotoAndPlay("damage");
		}
		
		function frame16() : *
		{
			stop();
		}
	}
}
