package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.events.GameEvents;
	import bhvr.events.EventWithParams;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	
	public class Target extends EventDispatcher
	{
		
		public static const TYPE_LANDMARK:int = 0;
		
		public static const TYPE_CANON:int = 1;
		 
		
		protected var _containerMc:MovieClip;
		
		protected var _type:int;
		
		protected var _destroyed:Boolean;
		
		public function Target(container:MovieClip, type:int)
		{
			super();
			this._containerMc = container;
			this._type = type;
			this._destroyed = false;
		}
		
		public function get type() : int
		{
			return this._type;
		}
		
		public function get destroyed() : Boolean
		{
			return this._destroyed;
		}
		
		public function set destroyed(value:Boolean) : void
		{
			this._destroyed = value;
		}
		
		public function get position() : Point
		{
			return new Point(this._containerMc.x,this._containerMc.y);
		}
		
		public function destroy() : void
		{
			var event:String = null;
			if(!this._destroyed)
			{
				this._destroyed = true;
				this.playDestroyAnimation();
				event = this._type == Target.TYPE_LANDMARK?GameEvents.LANDMARK_DESTROYED:GameEvents.CANON_DESTROYED;
				dispatchEvent(new EventWithParams(event,{"target":this}));
			}
			else
			{
				SoundManager.instance.playSound(SoundList.NUKE_EXPLOSION_SOUND);
			}
		}
		
		protected function playDestroyAnimation() : void
		{
			this._containerMc.visible = false;
		}
		
		public function dispose() : void
		{
			this._containerMc = null;
		}
	}
}
