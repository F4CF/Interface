package PipFallAssets_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class PipFallAnimMc_149 extends MovieClip
	{
		 
		
		public function PipFallAnimMc_149()
		{
			super();
			addFrameScript(4,this.frame5,8,this.frame9,20,this.frame21,29,this.frame30,33,this.frame34,34,this.frame35,39,this.frame40,43,this.frame44,63,this.frame64,69,this.frame70,208,this.frame209,250,this.frame251,299,this.frame300);
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame9() : *
		{
			dispatchEvent(new Event("RunLeftLeg",true,true));
		}
		
		function frame21() : *
		{
			dispatchEvent(new Event("RunRightLeg",true,true));
		}
		
		function frame30() : *
		{
			gotoAndPlay("run");
		}
		
		function frame34() : *
		{
			gotoAndPlay("stand");
		}
		
		function frame35() : *
		{
			dispatchEvent(new Event("ClimbLeftLeg",true,true));
		}
		
		function frame40() : *
		{
			dispatchEvent(new Event("ClimbRightLeg",true,true));
		}
		
		function frame44() : *
		{
			gotoAndPlay("climbLeftLeg");
		}
		
		function frame64() : *
		{
			stop();
		}
		
		function frame70() : *
		{
			stop();
		}
		
		function frame209() : *
		{
			stop();
		}
		
		function frame251() : *
		{
			stop();
		}
		
		function frame300() : *
		{
			stop();
		}
	}
}
