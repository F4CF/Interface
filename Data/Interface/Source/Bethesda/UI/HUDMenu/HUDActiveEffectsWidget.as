package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public dynamic class HUDActiveEffectsWidget extends BSUIComponent
	{
		 
		
		public var MAX_NUM_CLIPS:uint = 8;
		
		public var CLIP_HEIGHT:Number = 23;
		
		public var CLIP_SPACER:Number = 2.66;
		
		public var CLIP_FLASH_CLASS:String = "HUDActiveEffectClip";
		
		private var ClipHolderInternal_mc:MovieClip;
		
		private var _bInPowerArmorMode:Boolean = false;
		
		public function HUDActiveEffectsWidget()
		{
			super();
			this.ClipHolderInternal_mc = new MovieClip();
			addChild(this.ClipHolderInternal_mc);
		}
		
		public function get ClipHolderInternal() : MovieClip
		{
			return this.ClipHolderInternal_mc;
		}
		
		public function get bInPowerArmorMode() : Boolean
		{
			return this._bInPowerArmorMode;
		}
		
		public function set bInPowerArmorMode(param1:Boolean) : void
		{
			if(this._bInPowerArmorMode != param1)
			{
				this._bInPowerArmorMode = param1;
				SetIsDirty();
			}
		}
		
		override public function redrawUIComponent() : void
		{
			if(this.bInPowerArmorMode)
			{
				this.ClipHolderInternal_mc.x = 50;
				this.ClipHolderInternal_mc.y = 15;
			}
			else
			{
				this.ClipHolderInternal_mc.x = 0;
				this.ClipHolderInternal_mc.y = 0;
			}
		}
	}
}
