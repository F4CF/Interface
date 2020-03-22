package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HeaderArrow extends MovieClip
	{
		
		public static const MOUSE_UP:String = "HeaderArrow::mouse_up";
		 
		
		public function HeaderArrow()
		{
			super();
			addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
		}
		
		public function onMouseUp(param1:MouseEvent) : void
		{
			dispatchEvent(new Event(MOUSE_UP,true,true));
		}
	}
}
