package AutomatronAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class EnemyType5View_50 extends MovieClip
	{
		 
		
		public function EnemyType5View_50()
		{
			super();
			addFrameScript(9,this.frame10,21,this.frame22);
		}
		
		function frame10() : *
		{
			stop();
		}
		
		function frame22() : *
		{
			gotoAndPlay("walk");
		}
	}
}
