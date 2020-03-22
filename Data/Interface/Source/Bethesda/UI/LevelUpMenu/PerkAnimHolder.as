package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.MouseEventEx;
	
	public class PerkAnimHolder extends MovieClip
	{
		
		public static const MOUSE_OVER:String = "PerkAnimHolder::mouse_over";
		
		public static const MOUSE_OUT:String = "PerkAnimHolder::mouse_out";
		
		public static const CLICK:String = "PerkAnimHolder::mouse_click";
		 
		
		public var border:MovieClip;
		
		protected var _row:uint;
		
		protected var _col:uint;
		
		public function PerkAnimHolder()
		{
			super();
			Extensions.enabled = true;
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			addEventListener(MouseEvent.CLICK,this.onMouseClick);
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
		}
		
		public function get row() : uint
		{
			return this._row;
		}
		
		public function set row(param1:uint) : *
		{
			this._row = param1;
		}
		
		public function get col() : uint
		{
			return this._col;
		}
		
		public function set col(param1:uint) : *
		{
			this._col = param1;
		}
		
		private function onAddedToStageEvent(param1:Event) : *
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
			this.hitArea = this.border;
		}
		
		public function onMouseClick(param1:MouseEvent) : void
		{
			if(param1 is MouseEventEx && (param1 as MouseEventEx).buttonIdx == 0)
			{
				this.onMousePress();
			}
		}
		
		public function onMousePress() : void
		{
			dispatchEvent(new Event(CLICK,true,true));
		}
		
		public function onMouseOver() : void
		{
			dispatchEvent(new Event(MOUSE_OVER,true,true));
		}
		
		public function onMouseOut() : void
		{
			dispatchEvent(new Event(MOUSE_OUT,true,true));
		}
	}
}
