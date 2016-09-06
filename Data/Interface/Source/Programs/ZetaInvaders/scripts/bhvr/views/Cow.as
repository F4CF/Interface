package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import aze.motion.eaze;
	import bhvr.constatnts.GameConstants;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class Cow extends Target
	{
		
		public static const ASSET_LINKAGE_ID:String = "CowMc";
		 
		
		private var _heightValue:Number;
		
		private var _cowTimerObject:MovieClip;
		
		public function Cow(flashAssets:MovieClip)
		{
			super(flashAssets,ASSET_LINKAGE_ID);
			_collider = _container.cowViewMc;
			this._heightValue = _collider.height;
			this._cowTimerObject = new MovieClip();
			this.startMooTimer();
		}
		
		public function get heightValue() : Number
		{
			return this._heightValue;
		}
		
		public function get position() : Point
		{
			return FlashUtil.localToGlobalPosition(_container);
		}
		
		private function startMooTimer() : void
		{
			eaze(this._cowTimerObject).delay(GameConstants.cowMooInterval).onComplete(this.onMoo);
		}
		
		private function stopMooTimer() : void
		{
			eaze(this._cowTimerObject).killTweens();
		}
		
		private function onMoo() : void
		{
			SoundManager.instance.playSound(SoundList.COW_MOO_SOUND);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			this.stopMooTimer();
			_container.cowViewMc.visible = false;
			eaze(_container.explosionMc).play("start>end").onComplete(this.onDestroyed);
			SoundManager.instance.playSound(SoundList.COW_FAIL_SOUND);
		}
		
		private function onDestroyed() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.COW_EXPLODED,{"target":this}));
		}
		
		public function abduct() : void
		{
			_collider = null;
			this.stopMooTimer();
			eaze(_container.cowViewMc).play("abductionStart>abductionEnd").onComplete(this.onAbductionEnd);
			dispatchEvent(new EventWithParams(GameEvents.COW_ABDUCT,{"target":this}));
			SoundManager.instance.playSound(SoundList.COW_FAIL_SOUND);
		}
		
		private function onAbductionEnd() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.COW_ABDUCTED));
		}
		
		public function release() : void
		{
			_collider = null;
			this.stopMooTimer();
			_container.cowViewMc.gotoAndStop("air");
			SoundManager.instance.playSound(SoundList.COW_SAVE_SOUND);
		}
		
		public function run() : void
		{
			_container.cowViewMc.gotoAndPlay("floor");
		}
		
		public function fly(moving:Boolean = true) : void
		{
			if(moving)
			{
				_container.cowViewMc.gotoAndPlay("air");
			}
			else
			{
				_container.cowViewMc.gotoAndStop("air");
			}
		}
		
		override public function dispose() : void
		{
			eaze(_container.explosionMc).killTweens();
			eaze(_container.cowViewMc).killTweens();
			this.stopMooTimer();
			super.dispose();
		}
	}
}
