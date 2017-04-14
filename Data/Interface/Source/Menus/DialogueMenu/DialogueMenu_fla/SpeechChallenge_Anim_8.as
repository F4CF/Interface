package DialogueMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class SpeechChallenge_Anim_8 extends MovieClip
	{
		 
		
		public var BaseClip_mc:MovieClip;
		
		public function SpeechChallenge_Anim_8()
		{
			super();
			addFrameScript(0,this.frame1,5,this.frame6,6,this.frame7,69,this.frame70);
		}
		
		function frame1() : *
		{
			visible = false;
		}
		
		function frame6() : *
		{
			stop();
		}
		
		function frame7() : *
		{
			this.BaseClip_mc.gotoAndPlay("ThumbsUp");
			visible = true;
		}
		
		function frame70() : *
		{
			dispatchEvent(new Event("OnSpeechChallengeAnimComplete"));
			visible = false;
			stop();
		}
	}
}
