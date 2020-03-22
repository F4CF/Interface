package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class StealthMeter extends MovieClip
	{
		 
		
		public var BracketLeftInstance:MovieClip;
		
		public var BracketRightInstance:MovieClip;
		
		public var StealthTextInstance:TextField;
		
		var LastPercent:Number;
		
		public function StealthMeter()
		{
			super();
			this.LastPercent = 0;
			this.StealthTextInstance.multiline = false;
			this.StealthTextInstance.autoSize = TextFieldAutoSize.CENTER;
		}
		
		public function SetStealthMeter(param1:String, param2:Number, param3:Boolean) : void
		{
			var _loc4_:* = param2 - this.LastPercent;
			var _loc5_:Number = Math.floor(Math.abs(_loc4_) / 5) + 1;
			_loc5_ = Math.min(_loc5_,4);
			if(Math.abs(_loc4_) < 1 || param3)
			{
				_loc4_ = param2;
			}
			else
			{
				_loc4_ = this.LastPercent + (_loc4_ > 0?_loc5_:-_loc5_);
			}
			GlobalFunc.SetText(this.StealthTextInstance,param1,true);
			this.BracketLeftInstance.x = this.StealthTextInstance.x - _loc4_ - this.BracketLeftInstance.width;
			this.BracketRightInstance.x = this.StealthTextInstance.x + this.StealthTextInstance.width + _loc4_;
			this.LastPercent = _loc4_;
		}
	}
}
