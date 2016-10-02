package
{
	import Shared.AS3.BSUIComponent;
	
	public class SPECIALStarHolder extends BSUIComponent
	{
		 
		
		private var _Value:uint;
		
		private var _OrigX:Number;
		
		public function SPECIALStarHolder()
		{
			super();
			this._Value = 0;
			this._OrigX = this.x;
		}
		
		public function set value(param1:uint) : *
		{
			this._Value = Math.min(param1,10);
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc2_:SPECIALStar = null;
			super.redrawUIComponent();
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			var _loc1_:uint = 0;
			while(_loc1_ < this._Value)
			{
				_loc2_ = new SPECIALStar();
				this.addChild(_loc2_);
				_loc2_.x = 17.5 * _loc1_;
				_loc1_++;
			}
			this.x = this._OrigX - this.width / 2 + 0;
		}
	}
}
