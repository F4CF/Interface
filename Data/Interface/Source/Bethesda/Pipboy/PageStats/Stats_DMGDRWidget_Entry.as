package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Stats_DMGDRWidget_Entry extends MovieClip
	{
		 
		
		public var Icon_mc:MovieClip;
		
		public var Value_tf:TextField;
		
		public function Stats_DMGDRWidget_Entry()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
		
		public function redraw(param1:Boolean, param2:uint, param3:Number) : *
		{
			this.Icon_mc.gotoAndStop(!!param1?param2 + GlobalFunc.NUM_DAMAGE_TYPES:param2);
			GlobalFunc.SetText(this.Value_tf,Math.floor(param3).toString(),false);
		}
	}
}
