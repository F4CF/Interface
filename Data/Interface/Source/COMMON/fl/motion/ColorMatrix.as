package fl.motion
{
	public class ColorMatrix extends DynamicMatrix
	{
		
		protected static const LUMINANCER:Number = 0.3086;
		
		protected static const LUMINANCEG:Number = 0.6094;
		
		protected static const LUMINANCEB:Number = 0.082;
		 
		
		public function ColorMatrix()
		{
			super(5,5);
			LoadIdentity();
		}
		
		public function SetBrightnessMatrix(param1:Number) : void
		{
			if(!m_matrix)
			{
				return;
			}
			m_matrix[0][4] = param1;
			m_matrix[1][4] = param1;
			m_matrix[2][4] = param1;
		}
		
		public function SetContrastMatrix(param1:Number) : void
		{
			if(!m_matrix)
			{
				return;
			}
			var _loc2_:Number = 0.5 * (127 - param1);
			param1 = param1 / 127;
			m_matrix[0][0] = param1;
			m_matrix[1][1] = param1;
			m_matrix[2][2] = param1;
			m_matrix[0][4] = _loc2_;
			m_matrix[1][4] = _loc2_;
			m_matrix[2][4] = _loc2_;
		}
		
		public function SetSaturationMatrix(param1:Number) : void
		{
			if(!m_matrix)
			{
				return;
			}
			var _loc2_:Number = 1 - param1;
			var _loc3_:Number = _loc2_ * LUMINANCER;
			m_matrix[0][0] = _loc3_ + param1;
			m_matrix[1][0] = _loc3_;
			m_matrix[2][0] = _loc3_;
			_loc3_ = _loc2_ * LUMINANCEG;
			m_matrix[0][1] = _loc3_;
			m_matrix[1][1] = _loc3_ + param1;
			m_matrix[2][1] = _loc3_;
			_loc3_ = _loc2_ * LUMINANCEB;
			m_matrix[0][2] = _loc3_;
			m_matrix[1][2] = _loc3_;
			m_matrix[2][2] = _loc3_ + param1;
		}
		
		public function SetHueMatrix(param1:Number) : void
		{
			var _loc11_:int = 0;
			if(!m_matrix)
			{
				return;
			}
			LoadIdentity();
			var _loc2_:DynamicMatrix = new DynamicMatrix(3,3);
			var _loc3_:DynamicMatrix = new DynamicMatrix(3,3);
			var _loc4_:DynamicMatrix = new DynamicMatrix(3,3);
			var _loc5_:Number = Math.cos(param1);
			var _loc6_:Number = Math.sin(param1);
			var _loc7_:Number = 0.213;
			var _loc8_:Number = 0.715;
			var _loc9_:Number = 0.072;
			_loc2_.SetValue(0,0,_loc7_);
			_loc2_.SetValue(1,0,_loc7_);
			_loc2_.SetValue(2,0,_loc7_);
			_loc2_.SetValue(0,1,_loc8_);
			_loc2_.SetValue(1,1,_loc8_);
			_loc2_.SetValue(2,1,_loc8_);
			_loc2_.SetValue(0,2,_loc9_);
			_loc2_.SetValue(1,2,_loc9_);
			_loc2_.SetValue(2,2,_loc9_);
			_loc3_.SetValue(0,0,1 - _loc7_);
			_loc3_.SetValue(1,0,-_loc7_);
			_loc3_.SetValue(2,0,-_loc7_);
			_loc3_.SetValue(0,1,-_loc8_);
			_loc3_.SetValue(1,1,1 - _loc8_);
			_loc3_.SetValue(2,1,-_loc8_);
			_loc3_.SetValue(0,2,-_loc9_);
			_loc3_.SetValue(1,2,-_loc9_);
			_loc3_.SetValue(2,2,1 - _loc9_);
			_loc3_.MultiplyNumber(_loc5_);
			_loc4_.SetValue(0,0,-_loc7_);
			_loc4_.SetValue(1,0,0.143);
			_loc4_.SetValue(2,0,-(1 - _loc7_));
			_loc4_.SetValue(0,1,-_loc8_);
			_loc4_.SetValue(1,1,0.14);
			_loc4_.SetValue(2,1,_loc8_);
			_loc4_.SetValue(0,2,1 - _loc9_);
			_loc4_.SetValue(1,2,-0.283);
			_loc4_.SetValue(2,2,_loc9_);
			_loc4_.MultiplyNumber(_loc6_);
			_loc2_.Add(_loc3_);
			_loc2_.Add(_loc4_);
			var _loc10_:int = 0;
			while(_loc10_ < 3)
			{
				_loc11_ = 0;
				while(_loc11_ < 3)
				{
					m_matrix[_loc10_][_loc11_] = _loc2_.GetValue(_loc10_,_loc11_);
					_loc11_++;
				}
				_loc10_++;
			}
		}
		
		public function GetFlatArray() : Array
		{
			var _loc4_:int = 0;
			if(!m_matrix)
			{
				return null;
			}
			var _loc1_:Array = new Array();
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			while(_loc3_ < 4)
			{
				_loc4_ = 0;
				while(_loc4_ < 5)
				{
					_loc1_[_loc2_] = m_matrix[_loc3_][_loc4_];
					_loc2_++;
					_loc4_++;
				}
				_loc3_++;
			}
			return _loc1_;
		}
	}
}

class XFormData
{
	 
	
	public var ox:Number;
	
	public var oy:Number;
	
	public var oz:Number;
	
	function XFormData()
	{
		super();
	}
}
