package
{
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class StreamingInstallMenu extends IMenu
	{
		 
		
		public var ProgressText_tf:TextField;
		
		public var ProgressNumber_tf:TextField;
		
		public var ProgressPercentChar_tf:TextField;
		
		public var VaultTecLoading_mc:MovieClip;
		
		public var Background_mc:MovieClip;
		
		public var BGSCodeObj:Object;
		
		public function StreamingInstallMenu()
		{
			super();
			this.BGSCodeObj = new Object();
			GlobalFunc.SetText(this.ProgressText_tf,"$StreamInstallCaption",false);
			GlobalFunc.SetText(this.ProgressNumber_tf,"0",false);
			GlobalFunc.SetText(this.ProgressPercentChar_tf,"%",false);
			this.ShowBackground();
			this.SetProgressVisible(true);
			var _loc1_:Timer = new Timer(500);
			_loc1_.addEventListener(TimerEvent.TIMER,this.refreshInstallationProgress);
			_loc1_.start();
		}
		
		public function SetProgressVisible(param1:Boolean) : *
		{
			this.ProgressText_tf.visible = param1;
			this.ProgressNumber_tf.visible = param1;
			this.ProgressPercentChar_tf.visible = param1;
			this.VaultTecLoading_mc.visible = param1;
		}
		
		public function SetInstallProgress(param1:Number) : *
		{
			var _loc2_:uint = uint(100 * param1);
			GlobalFunc.SetText(this.ProgressNumber_tf,_loc2_.toString(),false);
		}
		
		public function ShowBackground() : *
		{
			this.Background_mc.visible = true;
		}
		
		public function HideBackground() : *
		{
			this.Background_mc.visible = false;
		}
		
		private function refreshInstallationProgress() : *
		{
			this.BGSCodeObj.RequestRefreshInstallProgress();
		}
	}
}
