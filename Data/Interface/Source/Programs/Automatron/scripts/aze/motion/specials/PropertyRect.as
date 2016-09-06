package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.geom.Rectangle;
	
	public class PropertyRect extends EazeSpecial
	{
		 
		
		private var original:Rectangle;
		
		private var targetRect:Rectangle;
		
		private var tmpRect:Rectangle;
		
		public function PropertyRect(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			super(param1,param2,param3,param4);
			this.targetRect = param3 && param3 is Rectangle?param3.clone():new Rectangle();
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties["__rect"] = PropertyRect;
		}
		
		override public function init(param1:Boolean) : void
		{
			this.original = target[property] is Rectangle?target[property].clone() as Rectangle:new Rectangle(0,0,target.width,target.height);
			if(param1)
			{
				this.tmpRect = this.original;
				this.original = this.targetRect;
				this.targetRect = this.tmpRect;
			}
			this.tmpRect = new Rectangle();
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			if(param2)
			{
				target.scrollRect = this.targetRect;
			}
			else
			{
				this.tmpRect.x = this.original.x + (this.targetRect.x - this.original.x) * param1;
				this.tmpRect.y = this.original.y + (this.targetRect.y - this.original.y) * param1;
				this.tmpRect.width = this.original.width + (this.targetRect.width - this.original.width) * param1;
				this.tmpRect.height = this.original.height + (this.targetRect.height - this.original.height) * param1;
				target[property] = this.tmpRect;
			}
		}
		
		override public function dispose() : void
		{
			this.original = this.targetRect = this.tmpRect = null;
			super.dispose();
		}
	}
}
