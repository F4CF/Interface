package
{
	import Shared.AS3.BSScrollingListEntry;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class RadioListEntry extends BSScrollingListEntry
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		private const SelectedColorTransform:ColorTransform = new ColorTransform(1,1,1,1,-255,-255,-255,0);
		
		private var FadedColor:Color;
		
		public function RadioListEntry()
		{
			this.FadedColor = new Color();
			super();
			this.FadedColor.brightness = -0.5;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.transform.colorTransform = !!param1.enabled?null:this.FadedColor;
			this.EquipIcon_mc.visible = param1.active;
			this.EquipIcon_mc.transform.colorTransform = !!this.selected?this.SelectedColorTransform:null;
		}
	}
}
