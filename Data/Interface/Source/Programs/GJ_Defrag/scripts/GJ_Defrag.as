package
{
	import flash.display.MovieClip;
	
	public class GJ_Defrag extends MovieClip
	{
		 
		
		public var BGSCodeObj:Object;
		
		protected const DEFRAG_SOUND:uint = 0;
		
		public function GJ_Defrag()
		{
			super();
			addFrameScript(4,this.frame5,19,this.frame20,24,this.frame25,29,this.frame30,34,this.frame35,52,this.frame53,56,this.frame57,59,this.frame60,75,this.frame76,79,this.frame80);
			this.BGSCodeObj = new Object();
		}
		
		public function InitProgram() : *
		{
			this.BGSCodeObj.registerSound("UIGamePipboyDefragHardDriveSpinLPM");
			this.BGSCodeObj.playRegisteredSound(this.DEFRAG_SOUND);
		}
		
		public function PlayReadSoundA() : *
		{
			this.BGSCodeObj.playSound("UIGamePipboyDefragHardDriveReadA");
		}
		
		public function PlayReadSoundB() : *
		{
			this.BGSCodeObj.playSound("UIGamePipboyDefragHardDriveReadB");
		}
		
		function frame5() : *
		{
			this.PlayReadSoundA();
		}
		
		function frame20() : *
		{
			this.PlayReadSoundB();
		}
		
		function frame25() : *
		{
			this.PlayReadSoundA();
		}
		
		function frame30() : *
		{
			this.PlayReadSoundB();
		}
		
		function frame35() : *
		{
			this.PlayReadSoundA();
		}
		
		function frame53() : *
		{
			this.PlayReadSoundB();
		}
		
		function frame57() : *
		{
			this.PlayReadSoundA();
		}
		
		function frame60() : *
		{
			this.PlayReadSoundB();
		}
		
		function frame76() : *
		{
			this.PlayReadSoundA();
		}
		
		function frame80() : *
		{
			this.PlayReadSoundB();
			gotoAndPlay(1);
		}
	}
}
