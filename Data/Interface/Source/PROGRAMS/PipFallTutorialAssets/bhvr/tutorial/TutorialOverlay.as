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
			var _loc4_:Number = 700 / param2;
			var _loc5_:Number = param1 / 2;
			var _loc6_:MovieClip = this.mainMc.tutorialMc.joyStickTxtMc;
			var _loc7_:MovieClip = this.mainMc.tutorialMc.jumpTxtMc;
			var _loc8_:MovieClip = this.mainMc.tutorialMc.joyStickMc;
			var _loc9_:MovieClip = this.mainMc.tutorialMc.jumpMc;
			this.mainMc.tutorialMc.titleTxtMc.titleTxt.text = LocalizationStrings.TUTORIAL_TITLE;
			_loc6_.txtMc.txt.text = LocalizationStrings.TUTORIAL_JOYSTICK;
			_loc7_.txtMc.txt.text = LocalizationStrings.TUTORIAL_JUMP;
			_loc6_.x = (-_loc5_ * _loc4_ - _loc6_.width) / 2;
			_loc7_.x = (_loc5_ * _loc4_ - _loc7_.width) / 2;
			_loc8_.x = (-_loc5_ * _loc4_ - _loc8_.width) / 2 - 48;
			_loc9_.x = (_loc5_ * _loc4_ - _loc9_.width) / 2;
		}
	}
}
