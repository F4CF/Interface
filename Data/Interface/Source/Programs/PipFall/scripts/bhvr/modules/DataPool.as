package bhvr.modules
{
	import flash.utils.Dictionary;
	import bhvr.utils.MathUtil;
	import bhvr.views.InteractiveObject;
	
	public class DataPool
	{
		 
		
		private var _data:Dictionary;
		
		private var _totalWeight:Number;
		
		public function DataPool()
		{
			super();
			this._data = new Dictionary(true);
			this._totalWeight = 0;
		}
		
		public function add(objId:int, weight:Number) : void
		{
			if(this._data[objId] == null)
			{
				this._data[objId] = weight;
				this._totalWeight = this._totalWeight + weight;
			}
		}
		
		public function getRandomData() : int
		{
			var obj:* = null;
			var objProb:Number = NaN;
			var randomPercent:int = MathUtil.random(0,100);
			var cumulPercent:Number = 0;
			for(obj in this._data)
			{
				objProb = this._data[obj] / this._totalWeight;
				cumulPercent = cumulPercent + objProb * 100;
				if(randomPercent <= cumulPercent)
				{
					return int(obj);
				}
			}
			return InteractiveObject.NONE;
		}
	}
}
