package bhvr.tutorial
{
	import Holotapes.Common.tutorial.BaseTutorialOverlay;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class TutorialOverlay extends BaseTutorialOverlay
	{
		 
		
		public var mainMc:MovieClip;
		
		public function TutorialOverlay()
		{
			super();
		}
		
		override public function SetScreenInfo(param1:int, param2:int, param3:Number) : void
		{
			super.SetScreenInfo(param1,param2,param3);
			this.mainMc.tutorialMc.titleTxt.text = LocalizationStrings.TUTORIAL_TITLE;
			this.mainMc.tutorialMc.tapMc.tapTxtMc.txt.text = LocalizationStrings.TUTORIAL_TAP;
		}
	}
}
