package bhvr.tutorial
{
	import Holotapes.Common.tutorial.BaseTutorialOverlay;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import bhvr.data.LocalizationStrings;
	
	public class TutorialOverlay extends BaseTutorialOverlay
	{
		
		private static const LEFT_ZONE_WIDTH_IN_INCHES:Number = 0.625;
		
		private static const STAGE_HEIGHT:Number = 700;
		 
		
		public var mainMc:MovieClip;
		
		public function TutorialOverlay()
		{
			super();
		}
		
		override public function SetScreenInfo(param1:int, param2:int, param3:Number) : void
		{
			super.SetScreenInfo(param1,param2,param3);
			var _loc4_:Number = STAGE_HEIGHT / param2;
			var _loc5_:Number = param1 / 2;
			var _loc6_:TextField = this.mainMc.tutorialMc.zoneNamesMc.leftZoneNameMc;
			var _loc7_:TextField = this.mainMc.tutorialMc.zoneNamesMc.rightZoneNameMc;
			var _loc8_:TextField = this.mainMc.tutorialMc.zoneNamesMc.fireZoneNameMc;
			var _loc9_:MovieClip = this.mainMc.tutorialMc.linesAnimMc.linesMc.leftLineMc;
			var _loc10_:Number = param3 * LEFT_ZONE_WIDTH_IN_INCHES;
			var _loc11_:Number = -_loc5_;
			var _loc12_:Number = _loc10_ - _loc5_;
			var _loc13_:Number = param1 - _loc5_;
			this.mainMc.tutorialMc.titleTxt.text = LocalizationStrings.TUTORIAL_TITLE;
			_loc6_.text = LocalizationStrings.TUTORIAL_ZONE_LEFT;
			_loc7_.text = LocalizationStrings.TUTORIAL_ZONE_RIGHT;
			_loc8_.text = LocalizationStrings.TUTORIAL_ZONE_FIRE;
			if(_loc6_.width > _loc10_ * _loc4_)
			{
				_loc6_.scaleX = _loc6_.scaleY = _loc10_ * _loc4_ / _loc6_.width;
				_loc6_.y = _loc6_.y + _loc6_.textHeight * (1 - _loc6_.scaleY) / 2;
			}
			_loc9_.x = _loc12_ * _loc4_;
			_loc6_.x = ((_loc12_ + _loc11_) * _loc4_ - _loc6_.width) / 2;
			_loc7_.x = (_loc12_ * _loc4_ - _loc7_.width) / 2;
			_loc8_.x = (_loc13_ * _loc4_ - _loc8_.width) / 2;
		}
	}
}
