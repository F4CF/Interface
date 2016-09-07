// 1152: A conflict exists with inherited definition scaleform.clik.controls:Button.textField in namespace public.
package
{
	import scaleform.clik.controls.Button;
	
	public class OverlayButton extends Button
	{
		 
		public function OverlayButton()
		{
			addFrameScript(9, this.frame10, 19, this.frame20, 29, this.frame30, 39, this.frame40);
			super();
			focusable = false;
		}
		
		function frame10() : *
		{
			stop();
		}
		
		function frame20() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			stop();
		}
		
		function frame40() : *
		{
			stop();
		}
		
		
	}
}
