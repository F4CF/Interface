package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class PipboyAnimMc_53 extends MovieClip
	{
		 
		
		public var colliderMc:MovieClip;
		
		public var colliderPointMc:MovieClip;
		
		public function PipboyAnimMc_53()
		{
			super();
			addFrameScript(4,this.frame5,8,this.frame9,20,this.frame21,28,this.frame29,33,this.frame34,34,this.frame35,39,this.frame40,43,this.frame44,64,this.frame65,70,this.frame71,209,this.frame210,251,this.frame252,300,this.frame301,362,this.frame363,370,this.frame371,378,this.frame379);
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame9() : *
		{
			dispatchEvent(new Event("RunLeftFoot",true,true));
		}
		
		function frame21() : *
		{
			dispatchEvent(new Event("RunRightFoot",true,true));
		}
		
		function frame29() : *
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
		
		function frame65() : *
		{
			stop();
		}
		
		function frame71() : *
		{
			stop();
		}
		
		function frame210() : *
		{
			stop();
		}
		
		function frame252() : *
		{
			stop();
		}
		
		function frame301() : *
		{
			stop();
		}
		
		function frame363() : *
		{
			gotoAndPlay("runPA");
		}
		
		function frame371() : *
		{
			stop();
		}
		
		function frame379() : *
		{
			stop();
		}
	}
}
