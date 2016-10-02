package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.constatnts.GameConstants;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	
	public class Landmark extends Target
	{
		
		public static const GOLDEN_GATE_BRIDGE:int = 0;
		
		public static const SEATTLE_SPACE_NEEDLE:int = 1;
		
		public static const LAS_VEGAS_COWBOY:int = 2;
		
		public static const MOUNT_RUSHMORE:int = 3;
		
		public static const SEARS_TOWER:int = 4;
		
		public static const ST_LOUIS_ARCH:int = 5;
		
		public static const WASHINTON_MONUMENT:int = 6;
		
		public static const STATUE_OF_LYBERTY:int = 7;
		 
		
		protected var _id:int;
		
		public function Landmark(container:MovieClip)
		{
			super(container,Target.TYPE_LANDMARK);
		}
		
		public function get id() : int
		{
			return this._id;
		}
		
		public function setVisual(id:int) : void
		{
			var landmarkView:MovieClip = null;
			this._id = id;
			for(var i:int = 0; i < GameConstants.NUMBER_OF_LANDMARKS; i++)
			{
				landmarkView = _containerMc.landmarkViewAnimMc["landmarkView" + i];
				landmarkView.alpha = 1;
				landmarkView.visible = i == this._id && !destroyed;
			}
		}
		
		public function playBonusAnimation() : void
		{
			eaze(_containerMc).play("bonusStart>bonusEnd");
		}
		
		override protected function playDestroyAnimation() : void
		{
			eaze(_containerMc.landmarkViewAnimMc["landmarkView" + this._id]).to(0.5,{"alphaVisible":0});
			eaze(_containerMc.explosionMc).play("start>end").onComplete(this.onDestroyAnimationFinished);
		}
		
		private function onDestroyAnimationFinished() : void
		{
			SoundManager.instance.stopSound(SoundList["LANDMARK_DESTRUCTION_SOUND_" + (this._id + 1) + "_ID"]);
		}
		
		public function pause() : void
		{
			if(_containerMc.explosionMc.lightMc)
			{
				_containerMc.explosionMc.lightMc.stop();
			}
		}
		
		public function resume() : void
		{
			if(_containerMc.explosionMc.lightMc)
			{
				_containerMc.explosionMc.lightMc.play();
			}
		}
		
		override public function destroy() : void
		{
			if(!_destroyed)
			{
				SoundManager.instance.startSound(SoundList["LANDMARK_DESTRUCTION_SOUND_" + (this._id + 1) + "_ID"]);
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
