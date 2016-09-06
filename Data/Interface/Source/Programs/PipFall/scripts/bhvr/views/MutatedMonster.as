package bhvr.views
{
	import flash.display.MovieClip;
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.utils.FlashUtil;
	import aze.motion.easing.Linear;
	import bhvr.utils.MathUtil;
	import bhvr.debug.Log;
	
	public class MutatedMonster extends InteractiveObject
	{
		 
		
		private const BARRELS_MIN_NUM:uint = 1;
		
		private const BARRELS_MAX_NUM:uint = 3;
		
		private var _barrelsNum:uint;
		
		private var _currentBarrel:uint;
		
		private var _barrelColliders:Vector.<MovieClip>;
		
		public function MutatedMonster(container:MovieClip)
		{
			_type = InteractiveObject.MUTATED_MONSTER;
			super(container,_type);
			this._barrelsNum = MathUtil.random(this.BARRELS_MIN_NUM,this.BARRELS_MAX_NUM);
			this.init();
			Log.info("Mutated Monster created with " + this._barrelsNum + " barrels.");
		}
		
		public function get barrelColliders() : Vector.<MovieClip>
		{
			return this._barrelColliders;
		}
		
		private function init() : void
		{
			var barrel:MovieClip = null;
			var i:uint = 0;
			_collider = _mainObject.mutatedMonsterViewMc;
			this._barrelColliders = new Vector.<MovieClip>();
			for(i = 0; i < this.BARRELS_MAX_NUM; i++)
			{
				barrel = _mainObject["barrel" + i];
				barrel.visible = false;
				if(i < this._barrelsNum)
				{
					this._barrelColliders[i] = barrel;
					barrel.gotoAndPlay("roll");
				}
			}
			this._currentBarrel = 0;
			eaze(_mainObject).delay(GameConstants.monsterDelayEnterStart).onComplete(this.enterMonster);
		}
		
		private function enterMonster() : void
		{
			_collider.gotoAndPlay("idle");
			_collider.x = this._barrelsNum > 1?Number(GameConstants.monsterFinalPosX):Number(GameConstants.STAGE_WIDTH);
			_collider.y = this._barrelsNum > 1?Number(-_collider.height):Number(GameConstants.monsterInitialPosY);
			eaze(_collider).to(GameConstants.monsterEnterDuration,{
				"x":GameConstants.monsterFinalPosX,
				"y":GameConstants.monsterInitialPosY
			}).onComplete(this.onMonsterEntered);
			SoundManager.instance.startLongSound(SoundList.MONSTER_ENTRANCE_SOUND_ID);
		}
		
		private function onMonsterEntered() : void
		{
			this.sendBarrel();
			if(this._currentBarrel < this._barrelsNum)
			{
				eaze(_mainObject).delay(GameConstants.delayBetweenMonsterBarrels).onComplete(this.onMonsterEntered);
			}
			else
			{
				this.leaveMonster();
			}
		}
		
		private function sendBarrel() : void
		{
			_collider.gotoAndPlay("throwBarrel");
			SoundManager.instance.playSound(SoundList.BARREL_THROWN_SOUND);
			this._barrelColliders[this._currentBarrel].x = FlashUtil.localToGlobalPosition(_collider.barrelContainerMc).x;
			this._barrelColliders[this._currentBarrel].y = FlashUtil.localToGlobalPosition(_collider.barrelContainerMc).y;
			this._barrelColliders[this._currentBarrel].visible = true;
			eaze(this._barrelColliders[this._currentBarrel]).to(GameConstants.monsterBarrelFallingDuration,{
				"x":this._barrelColliders[this._currentBarrel].x - GameConstants.monsterBarrelFallingDeltaX,
				"y":GameConstants.monsterBarrelFinalPosY
			}).easing(Linear.easeNone).onComplete(this.onRollingBarrel,this._currentBarrel);
			this._currentBarrel++;
		}
		
		private function onRollingBarrel(barrelId:uint) : void
		{
			var duration:Number = (GameConstants.STAGE_WIDTH + this._barrelColliders[barrelId].width) / GameConstants.monsterBarrelSpeed;
			this._barrelColliders[barrelId].gotoAndPlay("roll");
			eaze(this._barrelColliders[barrelId]).to(duration,{"x":-this._barrelColliders[barrelId].width}).easing(Linear.easeNone).onComplete(this.onBarrelOutside,barrelId);
		}
		
		private function onBarrelOutside(barrelId:uint) : void
		{
			this._barrelColliders[barrelId].gotoAndPlay("static");
			this._barrelColliders[barrelId].visible = false;
			if(barrelId == this._barrelsNum - 1)
			{
				this._currentBarrel = 0;
				eaze(_mainObject).delay(GameConstants.monsterDelayEnterSequence).onComplete(this.enterMonster);
			}
		}
		
		private function leaveMonster() : void
		{
			eaze(_collider).to(GameConstants.monsterLeaveDuration,{"y":-_collider.height}).easing(Linear.easeNone);
		}
		
		override public function pause() : void
		{
			if(_collider)
			{
				_collider.tailMc.stop();
			}
			for(var i:uint = 0; i < this._barrelColliders.length; i++)
			{
				this._barrelColliders[i].stop();
			}
		}
		
		override public function resume() : void
		{
			if(_collider)
			{
				_collider.tailMc.play();
			}
			for(var i:uint = 0; i < this._barrelColliders.length; i++)
			{
				this._barrelColliders[i].play();
			}
		}
		
		override public function dispose() : void
		{
			var i:uint = 0;
			if(_collider != null)
			{
				eaze(_collider).killTweens();
			}
			if(_mainObject != null)
			{
				eaze(_mainObject).killTweens();
			}
			if(this._barrelColliders != null)
			{
				for(i = 0; i < this._barrelsNum; i++)
				{
					eaze(this._barrelColliders[i]).killTweens();
				}
				this._barrelColliders = null;
			}
			super.dispose();
		}
	}
}
