package
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	
	public dynamic class LeftToRightTextAnim extends MovieClip
	{
		 
		
		var DisplayText:String;
		
		public function LeftToRightTextAnim()
		{
			super();
		}
		
		public function AnimateText(param1:String) : *
		{
			this.DisplayText = param1;
			this["textField"].SetText("",true);
			var _loc2_:Timer = new Timer(60,this.DisplayText.length - 1);
			_loc2_.addEventListener(TimerEvent.TIMER,this.AddLetter);
			_loc2_.start();
			this["BlinkCursor_mc"].gotoAndPlay("Blink");
		}
		
		public function AddLetter() : *
		{
			var _loc2_:Timer = null;
			this["textField"].SetText(this.DisplayText.substr(0,this["textField"].text.length + 1),true);
			var _loc1_:TextLineMetrics = this["textField"].getLineMetrics(0);
			this["BlinkCursor_mc"].x = this["textField"].x + _loc1_.width + 5;
			if(this["textField"].text.length == this.DisplayText.length)
			{
				_loc2_ = new Timer(4000,1);
				_loc2_.addEventListener(TimerEvent.TIMER,this.StartAnimOut);
				_loc2_.start();
			}
		}
		
		public function StartAnimOut() : *
		{
			var _loc1_:Timer = new Timer(60,this.DisplayText.length);
			_loc1_.addEventListener(TimerEvent.TIMER,this.RemoveLetter);
			_loc1_.start();
		}
		
		public function RemoveLetter() : *
		{
			var _loc1_:* = this["textField"].text.length - 1 == 0;
			this["textField"].SetText(this.DisplayText.substr(0,this["textField"].text.length - 1),true);
			var _loc2_:TextLineMetrics = this["textField"].getLineMetrics(0);
			this["BlinkCursor_mc"].x = this["textField"].x + _loc2_.width + 5;
			if(_loc1_)
			{
				this["BlinkCursor_mc"].gotoAndStop("Hidden");
			}
		}
	}
}
