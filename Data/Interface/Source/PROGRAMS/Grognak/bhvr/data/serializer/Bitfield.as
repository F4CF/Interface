package bhvr.data.serializer
{
	public class Bitfield
	{
		 
		
		private var _bitfield:int = 0;
		
		public function Bitfield()
		{
			super();
		}
		
		public function get value() : int
		{
			return this._bitfield;
		}
		
		public function set value(val:int) : void
		{
			this._bitfield = val;
		}
		
		public function setBit(bitIndex:int, val:Boolean) : void
		{
			if(val)
			{
				this._bitfield = this._bitfield | 1 << bitIndex;
			}
			else
			{
				this._bitfield = this._bitfield & ~(1 << bitIndex);
			}
		}
		
		public function getBit(bitIndex:int) : Boolean
		{
			return (this._bitfield & 1 << bitIndex) != 0;
		}
		
		public function clear() : void
		{
			this._bitfield = 0;
		}
	}
}
