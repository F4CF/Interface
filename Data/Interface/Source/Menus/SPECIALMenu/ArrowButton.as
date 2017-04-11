package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ArrowButton extends MovieClip
	{
		
		public static const MOUSE_UP:String = "ArrowButton::mouse_up";
		 
		
		public function ArrowButton()
		{
			super();
			addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
		}
		
		public function onMouseUp(param1:MouseEvent) : *
		{
			dispatchEvent(new Event(MOUSE_UP,true,true));
		}
	}
}
