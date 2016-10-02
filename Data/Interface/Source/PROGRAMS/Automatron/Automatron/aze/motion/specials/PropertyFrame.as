package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	
	public class PropertyFrame extends EazeSpecial
	{
		 
		
		private var start:int;
		
		private var delta:int;
		
		private var frameStart;
		
		private var frameEnd;
		
		public function PropertyFrame(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			var _loc6_:Array = null;
			var _loc7_:String = null;
			var _loc8_:int = 0;
			super(param1,param2,param3,param4);
			var _loc5_:MovieClip = MovieClip(param1);
			if(param3 is String)
			{
				_loc7_ = param3;
				if(_loc7_.indexOf("+") > 0)
				{
					_loc6_ = _loc7_.split("+");
					this.frameStart = _loc6_[0];
					this.frameEnd = _loc7_;
				}
				else if(_loc7_.indexOf(">") > 0)
				{
					_loc6_ = _loc7_.split(">");
					this.frameStart = _loc6_[0];
					this.frameEnd = _loc6_[1];
				}
				else
				{
					this.frameEnd = _loc7_;
				}
			}
			else
			{
				_loc8_ = int(param3);
				if(_loc8_ <= 0)
				{
					_loc8_ = _loc8_ + _loc5_.totalFrames;
				}
				this.frameEnd = Math.max(1,Math.min(_loc5_.totalFrames,_loc8_));
			}
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties.frame = PropertyFrame;
		}
		
		override public function init(param1:Boolean) : void
		{
			var _loc2_:MovieClip = MovieClip(target);
			if(this.frameStart is String)
			{
				this.frameStart = this.findLabel(_loc2_,this.frameStart);
			}
			else
			{
				this.frameStart = _loc2_.currentFrame;
			}
			if(this.frameEnd is String)
			{
				this.frameEnd = this.findLabel(_loc2_,this.frameEnd);
			}
			if(param1)
			{
				this.start = this.frameEnd;
				this.delta = this.frameStart - this.start;
			}
			else
			{
				this.start = this.frameStart;
				this.delta = this.frameEnd - this.start;
			}
			_loc2_.gotoAndStop(this.start);
		}
		
		private function findLabel(param1:MovieClip, param2:String) : int
		{
			var _loc3_:FrameLabel = null;
			for each(_loc3_ in param1.currentLabels)
			{
				if(_loc3_.name == param2)
				{
					return _loc3_.frame;
				}
			}
			return 1;
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			var _loc3_:MovieClip = MovieClip(target);
			_loc3_.gotoAndStop(Math.round(this.start + this.delta * param1));
		}
		
		public function getPreferredDuration() : Number
		{
			var _loc1_:MovieClip = MovieClip(target);
			var _loc2_:Number = !!_loc1_.stage?Number(_loc1_.stage.frameRate):Number(30);
			return Math.abs(Number(this.delta) / _loc2_);
		}
	}
}
