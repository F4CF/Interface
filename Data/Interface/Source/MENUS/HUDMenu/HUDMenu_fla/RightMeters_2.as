package HUDMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class RightMeters_2 extends MovieClip
	{
		 
		
		public var ActionPointMeter_mc:ActionPointMeter;
		
		public var AmmoCount_mc:MovieClip;
		
		public var ExplosiveAmmoCount_mc:ExplosiveAmmoCount;
		
		public var FatigueWarning_mc:MovieClip;
		
		public var FlashLightWidget_mc:FlashLightWidget;
		
		public var HUDActiveEffectsWidget_mc:HUDActiveEffectsWidget;
		
		public var PowerArmorLowBatteryWarning_mc:MovieClip;
		
		public function RightMeters_2()
		{
			super();
			this.__setProp_FlashLightWidget_mc_RightMeters_FlashLightWidget_mc_0();
			this.__setProp_ExplosiveAmmoCount_mc_RightMeters_ExplosiveAmmoCount_0();
		}
		
		function __setProp_FlashLightWidget_mc_RightMeters_FlashLightWidget_mc_0() : *
		{
			try
			{
				this.FlashLightWidget_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.FlashLightWidget_mc.bracketCornerLength = 6;
			this.FlashLightWidget_mc.bracketLineWidth = 1.5;
			this.FlashLightWidget_mc.bracketPaddingX = 0;
			this.FlashLightWidget_mc.bracketPaddingY = 0;
			this.FlashLightWidget_mc.BracketStyle = "horizontal";
			this.FlashLightWidget_mc.bShowBrackets = false;
			this.FlashLightWidget_mc.bUseShadedBackground = true;
			this.FlashLightWidget_mc.ShadedBackgroundMethod = "Shader";
			this.FlashLightWidget_mc.ShadedBackgroundType = "normal";
			try
			{
				this.FlashLightWidget_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_ExplosiveAmmoCount_mc_RightMeters_ExplosiveAmmoCount_0() : *
		{
			try
			{
				this.ExplosiveAmmoCount_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ExplosiveAmmoCount_mc.bracketCornerLength = 6;
			this.ExplosiveAmmoCount_mc.bracketLineWidth = 1.5;
			this.ExplosiveAmmoCount_mc.bracketPaddingX = 0;
			this.ExplosiveAmmoCount_mc.bracketPaddingY = 0;
			this.ExplosiveAmmoCount_mc.BracketStyle = "horizontal";
			this.ExplosiveAmmoCount_mc.bShowBrackets = false;
			this.ExplosiveAmmoCount_mc.bUseShadedBackground = true;
			this.ExplosiveAmmoCount_mc.ShadedBackgroundMethod = "Shader";
			this.ExplosiveAmmoCount_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ExplosiveAmmoCount_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
