package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.utils.MathUtil;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	
	public class LandMines extends InteractiveObject
	{
		 
		
		private const LANDMINES_MIN_NUM:uint = 1;
		
		private const LANDMINES_MAX_NUM:uint = 2;
		
		private var _minesNum:uint;
		
		private var _mineColliders:Vector.<MovieClip>;
		
		public function LandMines(container:MovieClip, type:int)
		{
			super(container,type);
			this._minesNum = type == InteractiveObject.ONE_LANDMINE?uint(this.LANDMINES_MIN_NUM):uint(this.LANDMINES_MAX_NUM);
			this.init();
		}
		
		public function get mineColliders() : Vector.<MovieClip>
		{
			return this._mineColliders;
		}
		
		private function init() : void
		{
			var i:uint = 0;
			this._mineColliders = new Vector.<MovieClip>();
			for(i = 0; i < this.LANDMINES_MAX_NUM; i++)
			{
				if(i < this._minesNum)
				{
					this._mineColliders[i] = _mainObject["landMine" + i];
					this._mineColliders[i].id = i;
					this._mineColliders[i].isActive = true;
				}
				else
				{
					_mainObject["landMine" + i].visible = false;
				}
			}
		}
		
		public function explode(mineId:uint) : void
		{
			var id:uint = MathUtil.clamp(mineId,0,this._minesNum - 1);
			var mine:MovieClip = _mainObject["landMine" + id];
			mine.isActive = false;
			eaze(mine).play("explodeStart>explodeEnd");
			SoundManager.instance.playSound(SoundList.LANDMINE_EXPLOSION_SOUND);
		}
		
		override public function pause() : void
		{
			for(var i:uint = 0; i < this._mineColliders.length; i++)
			{
				if(this._mineColliders[i].isActive)
				{
					this._mineColliders[i].stop();
				}
			}
		}
		
		override public function resume() : void
		{
			for(var i:uint = 0; i < this._mineColliders.length; i++)
			{
				if(this._mineColliders[i].isActive)
				{
					this._mineColliders[i].play();
				}
			}
		}
		
		override public function dispose() : void
		{
			this._mineColliders = null;
			super.dispose();
		}
	}
}
