package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class HeaderArrow extends MovieClip
	{
		
		public static const MOUSE_UP:String = "HeaderArrow::mouse_up";
		 
		
		public function HeaderArrow()
		{
			super();
			addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
		}
		
		public function onMouseUp(event:MouseEvent) : void
		{
			dispatchEvent(new Event(MOUSE_UP,true,true));
		}
	}
}
