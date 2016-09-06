package
{
	import flash.display.MovieClip;
	
	public class Workshop_ItemCard extends MovieClip
	{
		 
		
		public var PeopleEntry_mc:Workshop_IC_Entry;
		
		public var FoodEntry_mc:Workshop_IC_Entry;
		
		public var WaterEntry_mc:Workshop_IC_Entry;
		
		public var PowerEntry_mc:Workshop_IC_Entry;
		
		public var SafetyEntry_mc:Workshop_IC_Entry;
		
		public var BedsEntry_mc:Workshop_IC_Entry;
		
		public var HappyEntry_mc:Workshop_IC_Entry;
		
		private var EntrySorting:Vector.<Workshop_IC_Entry>;
		
		public function Workshop_ItemCard()
		{
			super();
			this.PeopleEntry_mc.label = "$WS_People";
			this.FoodEntry_mc.label = "$WS_Food";
			this.WaterEntry_mc.label = "$WS_Water";
			this.PowerEntry_mc.label = "$WS_Power";
			this.SafetyEntry_mc.label = "$WS_Safety";
			this.BedsEntry_mc.label = "$WS_Beds";
			this.HappyEntry_mc.label = "$WS_Happy";
			this.EntrySorting = new <Workshop_IC_Entry>[this.PeopleEntry_mc,this.FoodEntry_mc,this.WaterEntry_mc,this.PowerEntry_mc,this.SafetyEntry_mc,this.BedsEntry_mc,this.HappyEntry_mc];
			this.EntrySorting.fixed = true;
		}
		
		public function SetData(param1:Array) : *
		{
			var _loc2_:uint = 0;
			while(_loc2_ < param1.length && _loc2_ < this.EntrySorting.length)
			{
				this.EntrySorting[_loc2_].SetData(param1[_loc2_]);
				_loc2_++;
			}
		}
	}
}
