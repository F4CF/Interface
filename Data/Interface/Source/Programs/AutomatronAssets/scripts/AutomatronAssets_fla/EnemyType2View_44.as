package AutomatronAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class EnemyType2View_44 extends MovieClip
	{
		 
		
		public function EnemyType2View_44()
		{
			super();
			addFrameScript(9,this.frame10,22,this.frame23);
		}
		
		function frame10() : *
		{
			stop();
		}
		
		function frame23() : *
		{
			gotoAndPlay("walk");
		}
	}
}
