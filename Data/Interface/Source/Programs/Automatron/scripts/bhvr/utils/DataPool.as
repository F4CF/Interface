package bhvr.utils
{
	import flash.utils.Dictionary;
	
	public class DataPool
	{
		
		public static const INVALID_DATA_ID:int = -1;
		 
		
		private var _data:Dictionary;
		
		private var _totalWeight:Number;
		
		public function DataPool()
		{
			super();
			this.reset();
		}
		
		public function reset() : void
		{
			this._data = new Dictionary(true);
			this._totalWeight = 0;
		}
		
		public function add(param1:int, param2:Number) : void
		{
			if(this._data[param1] == null)
			{
				this._data[param1] = param2;
				this._totalWeight = this._totalWeight + param2;
			}
		}
		
		public function getRandomData() : int
		{
			var _loc4_:Object = null;
			var _loc5_:* = null;
			var _loc6_:Number = NaN;
			if(this._data == null)
			{
				return INVALID_DATA_ID;
			}
			var _loc1_:int = MathUtil.random(0,100);
			var _loc2_:Number = 0;
			var _loc3_:Boolean = true;
			for(_loc5_ in this._data)
			{
				_loc3_ = false;
				_loc4_ = _loc5_;
				_loc6_ = this._data[_loc4_] / this._totalWeight;
				_loc2_ = _loc2_ + _loc6_ * 100;
				if(_loc1_ < _loc2_)
				{
					return int(_loc4_);
				}
			}
			return !!_loc3_?int(INVALID_DATA_ID):int(int(_loc4_));
		}
		
		public function dispose() : void
		{
			this._data = null;
		}
	}
}
