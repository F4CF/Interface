package bhvr.views
{
	import flash.display.MovieClip;
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import aze.motion.easing.Linear;
	
	public class Barrels extends InteractiveObject
	{
		 
		
		private const BARRELS_MAX_NUM:uint = 3;
		
		private var _barrelsNum:uint;
		
		private var _currentBarrel:uint;
		
		private var _barrelColliders:Vector.<MovieClip>;
		
		public function Barrels(container:MovieClip, type:int)
		{
			super(container,type);
			this._barrelsNum = type == InteractiveObject.ONE_ROLLING_BARREL?uint(1):type == InteractiveObject.TWO_ROLLING_BARREL?uint(2):uint(this.BARRELS_MAX_NUM);
			this.init();
		}
		
		public function get barrelColliders() : Vector.<MovieClip>
		{
			return this._barrelColliders;
		}
		
		private function init() : void
		{
			var barrel:MovieClip = null;
			var i:uint = 0;
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
			eaze(_mainObject).delay(GameConstants.delayRollingBarrelStart).onComplete(this.onRollingBarrel);
		}
		
		private function sendBarrel() : void
		{
			var barrel:MovieClip = this._barrelColliders[this._currentBarrel];
			barrel.x = GameConstants.STAGE_WIDTH;
			var duration:Number = (GameConstants.STAGE_WIDTH + barrel.width) / GameConstants.barrelSpeed;
			this._barrelColliders[this._currentBarrel].gotoAndPlay("roll");
			this._barrelColliders[this._currentBarrel].visible = true;
			eaze(this._barrelColliders[this._currentBarrel]).to(duration,{"x":-barrel.width}).easing(Linear.easeNone).onComplete(this.onBarrelOutside,this._currentBarrel);
			this._currentBarrel++;
		}
		
		private function onRollingBarrel() : void
		{
			this.sendBarrel();
			if(this._currentBarrel < this._barrelsNum)
			{
				eaze(_mainObject).delay(GameConstants.delayBetweenRollingBarrels).onComplete(this.onRollingBarrel);
			}
		}
		
		private function onBarrelOutside(barrelId:uint) : void
		{
			this._barrelColliders[barrelId].gotoAndPlay("static");
			this._barrelColliders[barrelId].visible = false;
			if(barrelId == this._barrelsNum - 1)
			{
				this._currentBarrel = 0;
				eaze(_mainObject).delay(GameConstants.delayRollingBarrelSequence).onComplete(this.onRollingBarrel);
			}
		}
		
		override public function pause() : void
		{
			for(var i:uint = 0; i < this._barrelColliders.length; i++)
			{
				this._barrelColliders[i].stop();
			}
		}
		
		override public function resume() : void
		{
			for(var i:uint = 0; i < this._barrelColliders.length; i++)
			{
				this._barrelColliders[i].play();
			}
		}
		
		override public function dispose() : void
		{
			var i:uint = 0;
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
