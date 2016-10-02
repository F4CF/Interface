package Components
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	
	public class TextEntry extends MovieClip
	{
		 
		
		public var TextEntryAnim_mc:MovieClip;
		
		public var TextEntryBackground_mc:MovieClip;
		
		private var bUseBackground:Boolean = true;
		
		public function TextEntry()
		{
			super();
			addFrameScript(11,this.frame12,23,this.frame24);
			gotoAndStop("FadedOut");
		}
		
		public function set useBackground(param1:Boolean) : *
		{
			var _loc2_:MovieClip = this["TextEntryAnim_mc"] as MovieClip;
			if(param1)
			{
				this.TextEntryBackground_mc.visible = true;
			}
			else
			{
				this.TextEntryBackground_mc.visible = false;
			}
			this.bUseBackground = param1;
		}
		
		public function GetEnteringText() : Boolean
		{
			return stage.focus == (this["TextEntryAnim_mc"] as MovieClip).TextEntry_tf;
		}
		
		public function GetText() : String
		{
			return (this["TextEntryAnim_mc"] as MovieClip).TextEntry_tf.text;
		}
		
		public function FadeIn() : *
		{
			gotoAndPlay("FadeIn");
			var _loc1_:TextField = (this["TextEntryAnim_mc"] as MovieClip).TextEntry_tf;
			_loc1_.selectable = true;
			_loc1_.maxChars = 26;
			GlobalFunc.SetText(_loc1_,"",false);
			stage.focus = _loc1_;
		}
		
		public function FadeOut() : *
		{
			gotoAndPlay("FadeOut");
		}
		
		public function SetPlatform(param1:uint, param2:Boolean) : *
		{
			var _loc3_:MovieClip = this["TextEntryAnim_mc"] as MovieClip;
			_loc3_.AcceptButton_mc.SetPlatform(param1,param2);
			_loc3_.CancelButton_mc.SetPlatform(param1,param2);
		}
		
		public function SetTitleText(param1:String) : *
		{
			var _loc2_:MovieClip = this["TextEntryAnim_mc"] as MovieClip;
			GlobalFunc.SetText(_loc2_.TitleText_tf,param1,true);
		}
		
		function frame12() : *
		{
			stop();
		}
		
		function frame24() : *
		{
			stop();
		}
	}
}
