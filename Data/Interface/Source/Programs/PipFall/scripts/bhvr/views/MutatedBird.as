package bhvr.views
{
	import flash.display.MovieClip;
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import aze.motion.easing.Linear;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.utils.MathUtil;
	
	public class MutatedBird extends InteractiveObject
	{
		 
		
		private const FIRE_BALLS_NUM:uint = 2;
		
		private var _currentFireBall:uint;
		
		private var _fireBallColliders:Vector.<MovieClip>;
		
		public function MutatedBird(container:MovieClip)
		{
			_type = InteractiveObject.MUTATED_BIRD;
			super(container,_type);
			this.init();
		}
		
		public function get fireBallColliders() : Vector.<MovieClip>
		{
			return this._fireBallColliders;
		}
		
		private function init() : void
		{
			var i:uint = 0;
			_collider = _mainObject.birdViewMc;
			this._fireBallColliders = new Vector.<MovieClip>();
			for(i = 0; i < this.FIRE_BALLS_NUM; i++)
			{
				this._fireBallColliders[i] = _mainObject["fireBall" + i];
				this._fireBallColliders[i].isActive = true;
			}
			this._currentFireBall = 0;
			eaze(_mainObject).delay(GameConstants.birdDelayAttackStart).onComplete(this.attack);
		}
		
		private function attack() : void
		{
			this.sendFireBall();
			if(this._currentFireBall < this.FIRE_BALLS_NUM)
			{
				eaze(_mainObject).delay(GameConstants.delayBetweenFireBalls).onComplete(this.attack);
			}
		}
		
		private function sendFireBall() : void
		{
			_collider.gotoAndPlay("attack");
			var fireBall:MovieClip = this._fireBallColliders[this._currentFireBall];
			fireBall.x = _mainObject.fireBallContainerMc.x;
			fireBall.y = _mainObject.fireBallContainerMc.y;
			fireBall.gotoAndPlay("loop");
			eaze(fireBall).to(GameConstants.fireBallDuration,{
				"x":(this._currentFireBall == 0?GameConstants.fireBall1FinalPosX:GameConstants.fireBall2FinalPosX),
				"y":GameConstants.OUTSIDE_FLOOR_POSITION - fireBall.height
			}).easing(Linear.easeNone).onComplete(this.explodeFireBall,this._currentFireBall);
			SoundManager.instance.playSound(SoundList.BIRD_FIRE_SOUND);
			this._currentFireBall++;
		}
		
		public function explodeFireBall(fireBallId:uint) : void
		{
			var i:uint = 0;
			var id:uint = MathUtil.clamp(fireBallId,0,this.FIRE_BALLS_NUM - 1);
			var fireBall:MovieClip = this._fireBallColliders[id];
			fireBall.isActive = false;
			eaze(fireBall).play("explodeStart>explodeEnd");
			if(fireBallId == this.FIRE_BALLS_NUM - 1)
			{
				this._currentFireBall = 0;
				for(i = 0; i < this.FIRE_BALLS_NUM; i++)
				{
					this._fireBallColliders[i].isActive = true;
				}
				eaze(_mainObject).delay(GameConstants.birdDelayAttackSequence).onComplete(this.attack);
			}
		}
		
		override public function pause() : void
		{
			for(var i:uint = 0; i < this._fireBallColliders.length; i++)
			{
				if(this._fireBallColliders[i].isActive)
				{
					this._fireBallColliders[i].stop();
				}
			}
		}
		
		override public function resume() : void
		{
			for(var i:uint = 0; i < this._fireBallColliders.length; i++)
			{
				if(this._fireBallColliders[i].isActive)
				{
					this._fireBallColliders[i].play();
				}
			}
		}
		
		override public function dispose() : void
		{
			var i:uint = 0;
			if(_mainObject != null)
			{
				eaze(_mainObject).killTweens();
			}
			if(this._fireBallColliders != null)
			{
				for(i = 0; i < this.FIRE_BALLS_NUM; i++)
				{
					eaze(this._fireBallColliders[i]).killTweens();
				}
				this._fireBallColliders = null;
			}
			super.dispose();
		}
	}
}
