package
{
	public class PipboyUpdateMask
	{
		
		public static const None:PipboyUpdateMask = new PipboyUpdateMask(0);
		
		public static const Stats:PipboyUpdateMask = new PipboyUpdateMask(1 << 0);
		
		public static const Special:PipboyUpdateMask = new PipboyUpdateMask(1 << 1);
		
		public static const Perks:PipboyUpdateMask = new PipboyUpdateMask(1 << 2);
		
		public static const Inventory:PipboyUpdateMask = new PipboyUpdateMask(1 << 3);
		
		public static const Quest:PipboyUpdateMask = new PipboyUpdateMask(1 << 4);
		
		public static const Workshop:PipboyUpdateMask = new PipboyUpdateMask(1 << 5);
		
		public static const Log:PipboyUpdateMask = new PipboyUpdateMask(1 << 6);
		
		public static const Map:PipboyUpdateMask = new PipboyUpdateMask(1 << 7);
		
		public static const Radio:PipboyUpdateMask = new PipboyUpdateMask(1 << 8);
		
		public static const PlayerInfo:PipboyUpdateMask = new PipboyUpdateMask(1 << 9);
		
		public static const ReadOnly:PipboyUpdateMask = new PipboyUpdateMask(1 << 10);
		
		public static const BottomBar:PipboyUpdateMask = new PipboyUpdateMask(1 << 11);
		
		public static const All:PipboyUpdateMask = new PipboyUpdateMask(4294967295);
		 
		
		private var _Mask:uint;
		
		public function PipboyUpdateMask(param1:uint)
		{
			super();
			this._Mask = param1;
		}
		
		public function Contains(param1:PipboyUpdateMask) : Boolean
		{
			return (this._Mask & param1._Mask) == param1._Mask;
		}
		
		public function Intersects(param1:PipboyUpdateMask) : Boolean
		{
			return (this._Mask & param1._Mask) > 0;
		}
	}
}
