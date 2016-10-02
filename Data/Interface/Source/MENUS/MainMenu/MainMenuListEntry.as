package
{
	import Shared.AS3.BSScrollingListFadeEntry;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class MainMenuListEntry extends BSScrollingListFadeEntry
	{
		 
		
		public var LoadingSpinner_mc:MovieClip;
		
		private const LOADING_SPINNER_BUFFER_X = 10.0;
		
		public function MainMenuListEntry()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(textField,"shrink");
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			var _loc3_:* = border.alpha;
			if(param1.disabled)
			{
				border.alpha = !!this.selected?Number(0.35):Number(0);
				textField.textColor = !!this.selected?uint(2236962):uint(4473924);
			}
			else
			{
				border.alpha = !!this.selected?Number(_loc3_):Number(0);
				textField.textColor = !!this.selected?uint(0):uint(16777215);
			}
			if(this.LoadingSpinner_mc)
			{
				this.LoadingSpinner_mc.x = super.textField.x + super.textField.textWidth + 10 + this.LOADING_SPINNER_BUFFER_X;
				this.LoadingSpinner_mc.alpha = !!param1.waitingForLoad?Number(1):Number(0);
			}
		}
	}
}
