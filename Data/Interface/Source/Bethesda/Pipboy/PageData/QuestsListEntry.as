package
{
	import Shared.AS3.BSScrollingListEntry;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class QuestsListEntry extends BSScrollingListEntry
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public var Container_mc:MovieClip;
		
		private const SelectedColorTransform:ColorTransform = new ColorTransform(1,1,1,1,-255,-255,-255,0);
		
		private var FadedColor:Color;
		
		public function QuestsListEntry()
		{
			this.FadedColor = new Color();
			super();
			addFrameScript(0,this.frame1,1,this.frame2);
			this.Container_mc = this;
			this.FadedColor.brightness = -0.4;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			if(param1.isDivider == true)
			{
				this.Container_mc.gotoAndStop("divider");
			}
			else
			{
				this.Container_mc.gotoAndStop("normal");
				super.SetEntryText(param1,param2);
				if(param1.active)
				{
					this.EquipIcon_mc.gotoAndStop("active");
					this.Container_mc.transform.colorTransform = null;
					this.EquipIcon_mc.visible = true;
				}
				else if(!param1.enabled)
				{
					if(param1.completed)
					{
						this.EquipIcon_mc.gotoAndStop("complete");
					}
					this.Container_mc.transform.colorTransform = this.FadedColor;
					this.EquipIcon_mc.visible = param1.completed;
				}
				else
				{
					this.EquipIcon_mc.visible = false;
					this.Container_mc.transform.colorTransform = null;
				}
				this.EquipIcon_mc.transform.colorTransform = !!this.selected?this.SelectedColorTransform:null;
			}
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame2() : *
		{
			stop();
		}
	}
}
