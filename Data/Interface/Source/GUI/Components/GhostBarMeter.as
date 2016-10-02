package Components
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public class GhostBarMeter extends BSUIComponent
	{
		 
		
		public var Fill_mc:MovieClip;
		
		public var GhostFill_mc:MovieClip;
		
		private var _Value:Number;
		
		private var _GhostValue:Number;
		
		private var _MaxValue:Number;
		
		public function GhostBarMeter()
		{
			super();
			this._Value = 0;
			this._GhostValue = 0;
			this._MaxValue = 0;
		}
		
		public function SetMeter(param1:Number, param2:Number, param3:Number) : *
		{
			this._Value = param1;
			this._GhostValue = param2;
			this._MaxValue = param3;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			if(this.Fill_mc != null)
			{
				this.Fill_mc.visible = this._Value > 0 && this._MaxValue > 0;
				if(this.Fill_mc.visible)
				{
					this.Fill_mc.width = this._Value / this._MaxValue * (this.width / this.scaleX);
				}
			}
			if(this.GhostFill_mc != null)
			{
				this.GhostFill_mc.visible = this._GhostValue > 0 && this._MaxValue > 0;
				if(this.GhostFill_mc.visible)
				{
					this.GhostFill_mc.width = this._GhostValue / this._MaxValue * (this.width / this.scaleX);
				}
			}
		}
	}
}
