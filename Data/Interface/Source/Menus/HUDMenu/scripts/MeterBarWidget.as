package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public dynamic class MeterBarWidget extends BSUIComponent
	{
		 
		
		public var MeterBarInternal_mc:MovieClip;
		
		private var _startingX:Number;
		
		private var _startingWidth:Number;
		
		private var _justification:String;
		
		private var _percent:Number;
		
		private var _barAlpha:Number;
		
		public function MeterBarWidget()
		{
			super();
		}
		
		public function get Justification() : String
		{
			return this._justification;
		}
		
		public function set Justification(param1:String) : *
		{
			if(this._justification != param1)
			{
				this._justification = param1;
				SetIsDirty();
			}
		}
		
		public function get Percent() : Number
		{
			return this._percent;
		}
		
		public function set Percent(param1:Number) : *
		{
			if(this._percent != param1)
			{
				this._percent = param1;
				SetIsDirty();
			}
		}
		
		public function get BarAlpha() : Number
		{
			return this._barAlpha;
		}
		
		public function set BarAlpha(param1:Number) : *
		{
			if(this._barAlpha != param1)
			{
				this._barAlpha = param1;
				SetIsDirty();
			}
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			this._startingX = x;
			this._startingWidth = width;
			this.MeterBarInternal_mc.alpha = this.BarAlpha;
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			this.MeterBarInternal_mc.alpha = this.BarAlpha;
			scaleX = this.Percent;
			if(this.Justification == "right")
			{
				x = this._startingX + this._startingWidth - width;
			}
		}
	}
}
