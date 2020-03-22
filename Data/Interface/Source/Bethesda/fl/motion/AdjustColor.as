package fl.motion
{
	public class AdjustColor
	{
		
		private static var s_arrayOfDeltaIndex:Array = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.2,0.21,0.22,0.24,0.25,0.27,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.8,0.83,0.86,0.89,0.92,0.95,0.98,1,1.06,1.12,1.18,1.24,1.3,1.36,1.42,1.48,1.54,1.6,1.66,1.72,1.78,1.84,1.9,1.96,2,2.12,2.25,2.37,2.5,2.62,2.75,2.87,3,3.2,3.4,3.6,3.8,4,4.3,4.7,4.9,5,5.5,6,6.5,6.8,7,7.3,7.5,7.8,8,8.4,8.7,9,9.4,9.6,9.8,10];
		 
		
		private var m_brightnessMatrix:ColorMatrix;
		
		private var m_contrastMatrix:ColorMatrix;
		
		private var m_saturationMatrix:ColorMatrix;
		
		private var m_hueMatrix:ColorMatrix;
		
		private var m_finalMatrix:ColorMatrix;
		
		public function AdjustColor()
		{
			super();
		}
		
		public function set brightness(param1:Number) : void
		{
			if(this.m_brightnessMatrix == null)
			{
				this.m_brightnessMatrix = new ColorMatrix();
			}
			if(param1 != 0)
			{
				this.m_brightnessMatrix.SetBrightnessMatrix(param1);
			}
		}
		
		public function set contrast(param1:Number) : void
		{
			var _loc2_:Number = param1;
			if(param1 == 0)
			{
				_loc2_ = 127;
			}
			else if(param1 > 0)
			{
				_loc2_ = s_arrayOfDeltaIndex[int(param1)] * 127 + 127;
			}
			else
			{
				_loc2_ = param1 / 100 * 127 + 127;
			}
			if(this.m_contrastMatrix == null)
			{
				this.m_contrastMatrix = new ColorMatrix();
			}
			this.m_contrastMatrix.SetContrastMatrix(_loc2_);
		}
		
		public function set saturation(param1:Number) : void
		{
			var _loc2_:Number = param1;
			if(param1 == 0)
			{
				_loc2_ = 1;
			}
			else if(param1 > 0)
			{
				_loc2_ = 1 + 3 * param1 / 100;
			}
			else
			{
				_loc2_ = param1 / 100 + 1;
			}
			if(this.m_saturationMatrix == null)
			{
				this.m_saturationMatrix = new ColorMatrix();
			}
			this.m_saturationMatrix.SetSaturationMatrix(_loc2_);
		}
		
		public function set hue(param1:Number) : void
		{
			if(this.m_hueMatrix == null)
			{
				this.m_hueMatrix = new ColorMatrix();
			}
			if(param1 != 0)
			{
				this.m_hueMatrix.SetHueMatrix(param1 * Math.PI / 180);
			}
		}
		
		public function AllValuesAreSet() : Boolean
		{
			return this.m_brightnessMatrix && this.m_contrastMatrix && this.m_saturationMatrix && this.m_hueMatrix;
		}
		
		public function CalculateFinalFlatArray() : Array
		{
			if(this.CalculateFinalMatrix())
			{
				return this.m_finalMatrix.GetFlatArray();
			}
			return null;
		}
		
		private function CalculateFinalMatrix() : Boolean
		{
			if(!this.AllValuesAreSet())
			{
				return false;
			}
			this.m_finalMatrix = new ColorMatrix();
			this.m_finalMatrix.Multiply(this.m_brightnessMatrix);
			this.m_finalMatrix.Multiply(this.m_contrastMatrix);
			this.m_finalMatrix.Multiply(this.m_saturationMatrix);
			this.m_finalMatrix.Multiply(this.m_hueMatrix);
			return true;
		}
	}
}
