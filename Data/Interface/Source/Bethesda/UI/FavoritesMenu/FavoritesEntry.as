package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class FavoritesEntry extends BSUIComponent
	{
		
		public static const MOUSE_OVER:String = "FavoritesEntry::mouse_over";
		
		public static const MOUSE_LEAVE:String = "FavoritesEntry::mouse_leave";
		
		public static const CLICK:String = "FavoritesEntry::mouse_click";
		 
		
		public var Icon_mc:MovieClip;
		
		public var Quickkey_tf:TextField;
		
		protected var _EntryIndex:uint;
		
		public function FavoritesEntry()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onMouseLeave);
			addEventListener(MouseEvent.CLICK,this.onMousePress);
			this._EntryIndex = uint(this.name.substr(this.name.lastIndexOf("_") + 1));
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			if(this._EntryIndex == 9)
			{
				GlobalFunc.SetText(this.Quickkey_tf,"0",false);
			}
			else if(this._EntryIndex == 10)
			{
				GlobalFunc.SetText(this.Quickkey_tf,"-",false);
			}
			else if(this._EntryIndex == 11)
			{
				GlobalFunc.SetText(this.Quickkey_tf,"=",false);
			}
			else
			{
				GlobalFunc.SetText(this.Quickkey_tf,(this._EntryIndex + 1).toString(),false);
			}
			this.Quickkey_tf.visible = this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
		}
		
		public function get entryIndex() : uint
		{
			return this._EntryIndex;
		}
		
		public function onMousePress(param1:MouseEvent) : void
		{
			dispatchEvent(new Event(CLICK,true,true));
		}
		
		public function onMouseOver(param1:MouseEvent) : void
		{
			dispatchEvent(new Event(MOUSE_OVER,true,true));
		}
		
		public function onMouseLeave(param1:MouseEvent) : void
		{
			dispatchEvent(new Event(MOUSE_LEAVE,true,true));
		}
	}
}
