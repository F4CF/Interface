package
{
	public dynamic class PerkClip52403 extends PerkAnimHolder
	{
		 
		
		public function PerkClip52403()
		{
			super();
			addFrameScript(0,this.frame1,200,this.frame201);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame201() : *
		{
			gotoAndPlay(2);
		}
	}
}
