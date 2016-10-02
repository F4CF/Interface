package fl.motion
{
	public class DynamicMatrix
	{
		
		public static const MATRIX_ORDER_PREPEND:int = 0;
		
		public static const MATRIX_ORDER_APPEND:int = 1;
		 
		
		protected var m_width:int;
		
		protected var m_height:int;
		
		protected var m_matrix:Array;
		
		public function DynamicMatrix(param1:int, param2:int)
		{
			super();
			this.Create(param1,param2);
		}
		
		protected function Create(param1:int, param2:int) : void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			if(param1 > 0 && param2 > 0)
			{
				this.m_width = param1;
				this.m_height = param2;
				this.m_matrix = new Array(param2);
				_loc3_ = 0;
				while(_loc3_ < param2)
				{
					this.m_matrix[_loc3_] = new Array(param1);
					_loc4_ = 0;
					while(_loc4_ < param2)
					{
						this.m_matrix[_loc3_][_loc4_] = 0;
						_loc4_++;
					}
					_loc3_++;
				}
			}
		}
		
		protected function Destroy() : void
		{
			this.m_matrix = null;
		}
		
		public function GetWidth() : Number
		{
			return this.m_width;
		}
		
		public function GetHeight() : Number
		{
			return this.m_height;
		}
		
		public function GetValue(param1:int, param2:int) : Number
		{
			var _loc3_:Number = 0;
			if(param1 >= 0 && param1 < this.m_height && param2 >= 0 && param2 <= this.m_width)
			{
				_loc3_ = this.m_matrix[param1][param2];
			}
			return _loc3_;
		}
		
		public function SetValue(param1:int, param2:int, param3:Number) : void
		{
			if(param1 >= 0 && param1 < this.m_height && param2 >= 0 && param2 <= this.m_width)
			{
				this.m_matrix[param1][param2] = param3;
			}
		}
		
		public function LoadIdentity() : void
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			if(this.m_matrix)
			{
				_loc1_ = 0;
				while(_loc1_ < this.m_height)
				{
					_loc2_ = 0;
					while(_loc2_ < this.m_width)
					{
						if(_loc1_ == _loc2_)
						{
							this.m_matrix[_loc1_][_loc2_] = 1;
						}
						else
						{
							this.m_matrix[_loc1_][_loc2_] = 0;
						}
						_loc2_++;
					}
					_loc1_++;
				}
			}
		}
		
		public function LoadZeros() : void
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			if(this.m_matrix)
			{
				_loc1_ = 0;
				while(_loc1_ < this.m_height)
				{
					_loc2_ = 0;
					while(_loc2_ < this.m_width)
					{
						this.m_matrix[_loc1_][_loc2_] = 0;
						_loc2_++;
					}
					_loc1_++;
				}
			}
		}
		
		public function Multiply(param1:DynamicMatrix, param2:int = 0) : Boolean
		{
			var _loc5_:DynamicMatrix = null;
			var _loc6_:int = 0;
			var _loc7_:int = 0;
			var _loc8_:Number = NaN;
			var _loc9_:int = 0;
			var _loc10_:int = 0;
			if(!this.m_matrix || !param1)
			{
				return false;
			}
			var _loc3_:int = param1.GetHeight();
			var _loc4_:int = param1.GetWidth();
			if(param2 == MATRIX_ORDER_APPEND)
			{
				if(this.m_width != _loc3_)
				{
					return false;
				}
				_loc5_ = new DynamicMatrix(_loc4_,this.m_height);
				_loc6_ = 0;
				while(_loc6_ < this.m_height)
				{
					_loc7_ = 0;
					while(_loc7_ < _loc4_)
					{
						_loc8_ = 0;
						_loc9_ = 0;
						_loc10_ = 0;
						while(_loc9_ < Math.max(this.m_height,_loc3_) && _loc10_ < Math.max(this.m_width,_loc4_))
						{
							_loc8_ = _loc8_ + param1.GetValue(_loc9_,_loc7_) * this.m_matrix[_loc6_][_loc10_];
							_loc9_++;
							_loc10_++;
						}
						_loc5_.SetValue(_loc6_,_loc7_,_loc8_);
						_loc7_++;
					}
					_loc6_++;
				}
				this.Destroy();
				this.Create(_loc4_,this.m_height);
				_loc6_ = 0;
				while(_loc6_ < _loc3_)
				{
					_loc7_ = 0;
					while(_loc7_ < this.m_width)
					{
						this.m_matrix[_loc6_][_loc7_] = _loc5_.GetValue(_loc6_,_loc7_);
						_loc7_++;
					}
					_loc6_++;
				}
			}
			else
			{
				if(this.m_height != _loc4_)
				{
					return false;
				}
				_loc5_ = new DynamicMatrix(this.m_width,_loc3_);
				_loc6_ = 0;
				while(_loc6_ < _loc3_)
				{
					_loc7_ = 0;
					while(_loc7_ < this.m_width)
					{
						_loc8_ = 0;
						_loc9_ = 0;
						_loc10_ = 0;
						while(_loc9_ < Math.max(_loc3_,this.m_height) && _loc10_ < Math.max(_loc4_,this.m_width))
						{
							_loc8_ = _loc8_ + this.m_matrix[_loc9_][_loc7_] * param1.GetValue(_loc6_,_loc10_);
							_loc9_++;
							_loc10_++;
						}
						_loc5_.SetValue(_loc6_,_loc7_,_loc8_);
						_loc7_++;
					}
					_loc6_++;
				}
				this.Destroy();
				this.Create(this.m_width,_loc3_);
				_loc6_ = 0;
				while(_loc6_ < _loc3_)
				{
					_loc7_ = 0;
					while(_loc7_ < this.m_width)
					{
						this.m_matrix[_loc6_][_loc7_] = _loc5_.GetValue(_loc6_,_loc7_);
						_loc7_++;
					}
					_loc6_++;
				}
			}
			return true;
		}
		
		public function MultiplyNumber(param1:Number) : Boolean
		{
			var _loc3_:int = 0;
			var _loc4_:Number = NaN;
			if(!this.m_matrix)
			{
				return false;
			}
			var _loc2_:int = 0;
			while(_loc2_ < this.m_height)
			{
				_loc3_ = 0;
				while(_loc3_ < this.m_width)
				{
					_loc4_ = 0;
					_loc4_ = this.m_matrix[_loc2_][_loc3_] * param1;
					this.m_matrix[_loc2_][_loc3_] = _loc4_;
					_loc3_++;
				}
				_loc2_++;
			}
			return true;
		}
		
		public function Add(param1:DynamicMatrix) : Boolean
		{
			var _loc5_:int = 0;
			var _loc6_:Number = NaN;
			if(!this.m_matrix || !param1)
			{
				return false;
			}
			var _loc2_:int = param1.GetHeight();
			var _loc3_:int = param1.GetWidth();
			if(this.m_width != _loc3_ || this.m_height != _loc2_)
			{
				return false;
			}
			var _loc4_:int = 0;
			while(_loc4_ < this.m_height)
			{
				_loc5_ = 0;
				while(_loc5_ < this.m_width)
				{
					_loc6_ = 0;
					_loc6_ = this.m_matrix[_loc4_][_loc5_] + param1.GetValue(_loc4_,_loc5_);
					this.m_matrix[_loc4_][_loc5_] = _loc6_;
					_loc5_++;
				}
				_loc4_++;
			}
			return true;
		}
	}
}
