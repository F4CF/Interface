package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ActionPointMeter extends MovieClip
	{
		 
		
		public var Bracket_mc:MovieClip;
		
		public var MeterBar_mc:MovieClip;
		
		public var Optional_mc:MovieClip;
		
		public var ActionPointSegments_mc:MovieClip;
		
		public var DisplayText_tf:TextField;
		
		private var TotalBarWidth:Number;
		
		private const SegmentBorder:Number = 2.0;
		
		public function ActionPointMeter()
		{
			super();
			while(this.ActionPointSegments_mc.numChildren > 0)
			{
				this.ActionPointSegments_mc.removeChildAt(0);
			}
			this.TotalBarWidth = this.MeterBar_mc.width;
			addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
			this.__setProp_Optional_mc_ActionPointMeter_Optional_mc_0();
			this.__setProp_MeterBar_mc_ActionPointMeter_MeterBar_mc_0();
		}
		
		public function AddSegments(param1:Array) : *
		{
			var _loc4_:ActionPointBarSegment = null;
			var _loc5_:Number = NaN;
			while(this.ActionPointSegments_mc.numChildren > 0)
			{
				this.ActionPointSegments_mc.removeChildAt(0);
			}
			var _loc2_:Number = 0;
			var _loc3_:uint = 0;
			while(_loc3_ < param1.length)
			{
				_loc4_ = new ActionPointBarSegment();
				_loc5_ = param1[_loc3_] * this.TotalBarWidth;
				_loc4_.width = _loc5_ - 2 * this.SegmentBorder;
				_loc4_.x = _loc2_ + this.SegmentBorder;
				this.ActionPointSegments_mc.addChild(_loc4_);
				_loc2_ = _loc2_ + _loc5_;
				_loc3_++;
			}
		}
		
		public function OnEnterFrame(param1:Event) : *
		{
			this.ActionPointSegments_mc.x = -this.MeterBar_mc.width;
		}
		
		function __setProp_Optional_mc_ActionPointMeter_Optional_mc_0() : *
		{
			try
			{
				this.Optional_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.Optional_mc.BarAlpha = 1;
			this.Optional_mc.bracketCornerLength = 6;
			this.Optional_mc.bracketLineWidth = 1.5;
			this.Optional_mc.bracketPaddingX = 0;
			this.Optional_mc.bracketPaddingY = 0;
			this.Optional_mc.BracketStyle = "horizontal";
			this.Optional_mc.bShowBrackets = false;
			this.Optional_mc.bUseShadedBackground = false;
			this.Optional_mc.Justification = "left";
			this.Optional_mc.Percent = 0;
			this.Optional_mc.ShadedBackgroundMethod = "Shader";
			this.Optional_mc.ShadedBackgroundType = "normal";
			try
			{
				this.Optional_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_MeterBar_mc_ActionPointMeter_MeterBar_mc_0() : *
		{
			try
			{
				this.MeterBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.MeterBar_mc.BarAlpha = 1;
			this.MeterBar_mc.bracketCornerLength = 6;
			this.MeterBar_mc.bracketLineWidth = 1.5;
			this.MeterBar_mc.bracketPaddingX = 0;
			this.MeterBar_mc.bracketPaddingY = 0;
			this.MeterBar_mc.BracketStyle = "horizontal";
			this.MeterBar_mc.bShowBrackets = false;
			this.MeterBar_mc.bUseShadedBackground = false;
			this.MeterBar_mc.Justification = "right";
			this.MeterBar_mc.Percent = 1;
			this.MeterBar_mc.ShadedBackgroundMethod = "Shader";
			this.MeterBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.MeterBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
