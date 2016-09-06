package bhvr.data
{
	import bhvr.utils.MathUtil;
	import bhvr.constants.GameConstants;
	import bhvr.views.InteractiveObject;
	
	public class ScreenData
	{
		 
		
		private var _id:uint;
		
		private var _background:uint;
		
		public var isGenerated:Boolean;
		
		public var hazardGroupA:int;
		
		public var hazardGroupB:int;
		
		public var hazardGroupC:int;
		
		public var tunnelEntrance:int;
		
		public function ScreenData(screenId:uint)
		{
			super();
			this._id = screenId;
			this.isGenerated = false;
			this._background = MathUtil.random(0,GameConstants.BACKGROUNDS_NUM - 1);
			this.hazardGroupA = InteractiveObject.NONE;
			this.hazardGroupB = InteractiveObject.NONE;
			this.hazardGroupC = InteractiveObject.NONE;
			this.tunnelEntrance = InteractiveObject.NONE;
		}
		
		public function get id() : uint
		{
			return this._id;
		}
		
		public function get background() : uint
		{
			return this._background;
		}
	}
}
