package Components
{
	import flash.display.MovieClip;
	
	public class ItemCard_TimedEntry extends ItemCard_Entry
	{
		 
		
		public var TimerIcon_mc:MovieClip;
		
		private var TIMER_ORIG_X:Number;
		
		public function ItemCard_TimedEntry()
		{
			super();
			this.TIMER_ORIG_X = this.TimerIcon_mc.x;
		}
		
		override public function PopulateEntry(param1:Object) : *
		{
			super.PopulateEntry(param1);
			var _loc2_:Number = Value_tf.x + Value_tf.getLineMetrics(0).x - this.TimerIcon_mc.width / 2 - 10;
			if(_loc2_ < this.TIMER_ORIG_X)
			{
				this.TimerIcon_mc.x = _loc2_;
			}
		}
	}
}
