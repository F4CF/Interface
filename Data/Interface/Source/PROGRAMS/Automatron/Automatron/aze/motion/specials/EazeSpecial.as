package aze.motion.specials
{
	public class EazeSpecial
	{
		 
		
		protected var target:Object;
		
		protected var property:String;
		
		public var next:aze.motion.specials.EazeSpecial;
		
		public function EazeSpecial(param1:Object, param2:*, param3:*, param4:aze.motion.specials.EazeSpecial)
		{
			super();
			this.target = param1;
			this.property = param2;
			this.next = param4;
		}
		
		public function init(param1:Boolean) : void
		{
		}
		
		public function update(param1:Number, param2:Boolean) : void
		{
		}
		
		public function dispose() : void
		{
			this.target = null;
			if(this.next)
			{
				this.next.dispose();
			}
			this.next = null;
		}
	}
}
