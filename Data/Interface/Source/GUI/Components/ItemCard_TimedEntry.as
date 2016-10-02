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
		
		override public function PopulateEntry(aInfoObj:Object) : *
		{
			super.PopulateEntry(aInfoObj);
			var newX:Number = Value_tf.x + Value_tf.getLineMetrics(0).x - this.TimerIcon_mc.width / 2 - 10;
			if(newX < this.TIMER_ORIG_X)
			{
				this.TimerIcon_mc.x = newX;
			}
		}
	}
}
