package
{
	import Shared.AS3.VaultBoyImageLoader;
	
	public dynamic class PerkVaultBoy extends VaultBoyImageLoader
	{
		 
		
		public function PerkVaultBoy()
		{
			super();
			this.__setProp_VaultBoyImageInternal_mc_PerkVaultBoy_VaultBoyImageInternal_mc_0();
		}
		
		function __setProp_VaultBoyImageInternal_mc_PerkVaultBoy_VaultBoyImageInternal_mc_0() : *
		{
			try
			{
				VaultBoyImageInternal_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			VaultBoyImageInternal_mc.bracketCornerLength = 6;
			VaultBoyImageInternal_mc.bracketLineWidth = 1.5;
			VaultBoyImageInternal_mc.bracketPaddingX = 3;
			VaultBoyImageInternal_mc.bracketPaddingY = 3;
			VaultBoyImageInternal_mc.BracketStyle = "horizontal";
			VaultBoyImageInternal_mc.bShowBrackets = false;
			VaultBoyImageInternal_mc.bUseShadedBackground = false;
			VaultBoyImageInternal_mc.ShadedBackgroundMethod = "Shader";
			VaultBoyImageInternal_mc.ShadedBackgroundType = "normal";
			try
			{
				VaultBoyImageInternal_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
