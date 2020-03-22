package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	
	public class Selection_WorkshopInfo extends BSUIComponent
	{
		 
		
		public var PopulationIcon_mc:MovieClip;
		
		public var HappyIcon_mc:MovieClip;
		
		public var Population_tf:TextField;
		
		public var Happy_tf:TextField;
		
		private var _PopulationAmount:uint;
		
		private var _HappyPct:uint;
		
		public function Selection_WorkshopInfo()
		{
			super();
			this._PopulationAmount = 0;
			this._HappyPct = 0;
		}
		
		public function SetWorkshopInfo(param1:uint, param2:uint) : *
		{
			this._PopulationAmount = param1;
			this._HappyPct = param2;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			GlobalFunc.SetText(this.Population_tf,this._PopulationAmount.toString(),false);
			GlobalFunc.SetText(this.Happy_tf,this._HappyPct.toString() + "%",false);
			var _loc1_:TextLineMetrics = this.Population_tf.getLineMetrics(0);
			this.HappyIcon_mc.x = this.Population_tf.x + _loc1_.width + 10;
			this.Happy_tf.x = this.HappyIcon_mc.x + this.HappyIcon_mc.width + 10;
		}
	}
}
