package aze.motion.specials
{
	public class EazeSpecial
	{
		 
		
		protected var target:Object;
		
		protected var property:String;
		
		public var next:aze.motion.specials.EazeSpecial;
		
		public function EazeSpecial(target:Object, property:*, value:*, next:aze.motion.specials.EazeSpecial)
		{
			super();
			this.target = target;
			this.property = property;
			this.next = next;
		}
		
		public function init(reverse:Boolean) : void
		{
		}
		
		public function update(ke:Number, isComplete:Boolean) : void
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
