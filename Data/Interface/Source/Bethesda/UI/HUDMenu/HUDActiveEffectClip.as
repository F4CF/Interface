package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public dynamic class HUDActiveEffectClip extends BSUIComponent
	{
		 
		
		public var Icon_mc:MovieClip;
		
		private var _IconFrame:uint = 1;
		
		public function HUDActiveEffectClip()
		{
			super();
			bUseShadedBackground = true;
			this.Icon_mc.scaleX = 1.25;
			this.Icon_mc.scaleY = 1.25;
		}
		
		public function get IconFrame() : uint
		{
			return this._IconFrame;
		}
		
		public function set IconFrame(param1:uint) : void
		{
			this._IconFrame = param1;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			this.Icon_mc.gotoAndStop(this._IconFrame);
			visible = this._IconFrame > 1;
		}
	}
}
