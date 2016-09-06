package bhvr.data.database
{
	public class ShopItem extends Item
	{
		 
		
		public var canOnlyBeBoughtOnce:Boolean;
		
		private var _shopName:String;
		
		private var _uid:uint;
		
		public function ShopItem(uid:uint)
		{
			super();
			this._uid = uid;
			this.canOnlyBeBoughtOnce = true;
		}
		
		public function get shopName() : String
		{
			return Boolean(this._shopName)?this._shopName:name;
		}
		
		public function set shopName(value:String) : void
		{
			this._shopName = value;
		}
		
		public function get uid() : uint
		{
			return this._uid;
		}
	}
}
