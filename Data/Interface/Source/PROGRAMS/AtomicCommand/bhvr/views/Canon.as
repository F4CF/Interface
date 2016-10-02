package bhvr.views
{
	import flash.geom.Point;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class Canon extends Target
	{
		 
		
		public function Canon(container:MovieClip)
		{
			super(container,Target.TYPE_CANON);
		}
		
		public function get basePosition() : Point
		{
			return new Point(_containerMc.x,_containerMc.y);
		}
		
		public function get headPosition() : Point
		{
			var pt:Point = new Point(_containerMc.canonViewMc.canonHeadMc.fireStartPointMc.x,_containerMc.canonViewMc.canonHeadMc.fireStartPointMc.y);
			pt = _containerMc.canonViewMc.canonHeadMc.localToGlobal(pt);
			return pt;
		}
		
		override public function get position() : Point
		{
			return new Point(_containerMc.x,_containerMc.y + _containerMc.height);
		}
		
		override protected function playDestroyAnimation() : void
		{
			eaze(_containerMc.canonViewMc).to(0.5,{"alphaVisible":0});
			eaze(_containerMc.explosionMc).play("start>end").onComplete(this.onDestroyAnimationFinished);
		}
		
		private function onDestroyAnimationFinished() : void
		{
			SoundManager.instance.stopSound(SoundList.CANON_DESTRUCTION_SOUND_ID);
		}
		
		public function rotate(angle:Number) : void
		{
			_containerMc.canonViewMc.canonHeadMc.rotation = angle;
		}
		
		public function reset() : void
		{
			_destroyed = false;
			_containerMc.canonViewMc.alpha = 1;
			this.rotate(0);
		}
		
		override public function destroy() : void
		{
			if(!_destroyed)
			{
				SoundManager.instance.startSound(SoundList.CANON_DESTRUCTION_SOUND_ID);
			}
			super.destroy();
		}
		
		override public function dispose() : void
		{
			this.onDestroyAnimationFinished();
			super.dispose();
		}
	}
}
