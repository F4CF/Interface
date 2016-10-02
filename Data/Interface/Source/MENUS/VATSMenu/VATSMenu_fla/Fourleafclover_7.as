package VATSMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Fourleafclover_7 extends MovieClip
	{
		 
		
		public function Fourleafclover_7()
		{
			super();
			addFrameScript(5,this.frame6,70,this.frame71);
		}
		
		function frame6() : *
		{
			stop();
		}
		
		function frame71() : *
		{
			this.visible = false;
			this["OnCritAnimationComplete"]();
			stop();
		}
	}
}
