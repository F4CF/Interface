package bhvr.views
{
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	
	public class MotherShip extends Target
	{
		
		public static const ASSET_LINKAGE_ID:String = "MotherShipMc";
		 
		
		public function MotherShip(flashAssets:MovieClip)
		{
			super(flashAssets,ASSET_LINKAGE_ID);
			_collider = _container.motherShipViewMc;
			_container.motherShipViewMc.gotoAndPlay("start");
		}
		
		public function get position() : Point
		{
			return FlashUtil.localToGlobalPosition(_container);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			_container.motherShipViewMc.visible = false;
			eaze(_container.explosionMc).play("start>end").onComplete(this.onMotherShipDestroyed);
			SoundManager.instance.playSound(SoundList.MOTHERSHIP_EXPLOSION_SOUND);
		}
		
		private function onMotherShipDestroyed() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.MOTHERSHIP_EXPLODED));
		}
		
		public function pauseAnimation() : void
		{
			_container.motherShipViewMc.stop();
		}
		
		public function resumeAnimation() : void
		{
			_container.motherShipViewMc.play();
		}
	}
}
