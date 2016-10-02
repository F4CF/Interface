package
{
	import scaleform.clik.controls.Button;
	
	public dynamic class PauseIcon extends Button
	{
		 
		
		public function PauseIcon()
		{
			super();
			addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40);
		}
		
		function frame10() : *
		{
			stop();
		}
		
		function frame20() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			stop();
		}
		
		function frame40() : *
		{
			stop();
		}
	}
}
