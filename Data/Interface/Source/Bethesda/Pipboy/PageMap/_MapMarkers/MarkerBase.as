package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MarkerBase extends MovieClip
	{
		 
		
		public function MarkerBase()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			addEventListener(MouseEvent.CLICK,this.onMousePress);
		}
		
		public function onMousePress(param1:MouseEvent) : *
		{
		}
		
		public function onMouseOver(param1:MouseEvent) : *
		{
		}
		
		public function onMouseOut(param1:MouseEvent) : *
		{
		}
	}
}
