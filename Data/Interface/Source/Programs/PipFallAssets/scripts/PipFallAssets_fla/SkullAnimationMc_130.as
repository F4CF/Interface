package PipFallAssets_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class SkullAnimationMc_130 extends MovieClip
	{
		 
		
		public function SkullAnimationMc_130()
		{
			super();
			addFrameScript(7,this.frame8,9,this.frame10,26,this.frame27,44,this.frame45);
		}
		
		function frame8() : *
		{
			stop();
		}
		
		function frame10() : *
		{
			dispatchEvent(new Event("CraneJump",true,true));
		}
		
		function frame27() : *
		{
			dispatchEvent(new Event("CraneJump",true,true));
		}
		
		function frame45() : *
		{
			stop();
		}
	}
}
