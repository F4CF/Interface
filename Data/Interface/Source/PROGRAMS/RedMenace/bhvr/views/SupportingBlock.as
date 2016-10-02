package bhvr.views
{
	import flash.display.MovieClip;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class SupportingBlock extends InteractiveObject
	{
		 
		
		private var _enemyCollider:MovieClip;
		
		private var _isAnimating:Boolean;
		
		public function SupportingBlock(assets:MovieClip)
		{
			super(assets);
			this._enemyCollider = _assets.enemyColliderMc;
			this.reset();
		}
		
		public function get enemyCollider() : MovieClip
		{
			return this._enemyCollider;
		}
		
		public function reset() : void
		{
			_collider = _assets.colliderMc;
			_assets.gotoAndPlay("idle");
			this._isAnimating = false;
		}
		
		public function unlock() : void
		{
			eaze(_assets).play("unlockStart>unlockEnd").onComplete(this.onBlockUnlocked);
			this._isAnimating = true;
			_collider = null;
		}
		
		private function onBlockUnlocked() : void
		{
			this._isAnimating = false;
			dispatchEvent(new EventWithParams(GameEvents.SUPPORTING_BLOCK_REMOVED,{"target":this}));
		}
		
		override public function destroy() : void
		{
			super.destroy();
			this._enemyCollider = null;
		}
		
		override public function pause() : void
		{
			super.pause();
			if(this._isAnimating)
			{
				_assets.stop();
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			if(this._isAnimating)
			{
				_assets.play();
			}
		}
	}
}
