package Components
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class SWFLoaderClip extends MovieClip
	{
		 
		
		var SWF:DisplayObject;
		
		var menuLoader:Loader;
		
		var ClipAlpha:Number = 0.65;
		
		var ClipScale:Number = 0.5;
		
		var AltMenuName:String;
		
		public function SWFLoaderClip()
		{
			this.AltMenuName = new String();
			super();
			this.SWF = null;
			this.menuLoader = new Loader();
		}
		
		public function set clipAlpha(param1:Number) : *
		{
			this.ClipAlpha = param1;
		}
		
		public function set clipScale(param1:Number) : *
		{
			this.ClipScale = param1;
		}
		
		public function SWFLoad(param1:String) : void
		{
			this.menuLoader.close();
			if(this.SWF)
			{
				this.SWFUnload(this.SWF);
			}
			var _loc2_:URLRequest = new URLRequest(param1 + ".swf");
			this.menuLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMenuLoadComplete);
			this.menuLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this._ioErrorEventHandler,false,0,true);
			this.menuLoader.load(_loc2_);
		}
		
		public function SWFLoadAlt(param1:String, param2:String) : *
		{
			this.AltMenuName = param2;
			this.SWFLoad(param1);
		}
		
		private function _ioErrorEventHandler(param1:IOErrorEvent) : *
		{
			if(this.AltMenuName.length > 0)
			{
				this.SWFLoad(this.AltMenuName);
			}
			else
			{
				trace("Failed to load .swf. " + new Error().getStackTrace());
			}
		}
		
		public function onMenuLoadComplete(param1:Event) : void
		{
			this.SWF = param1.currentTarget.content;
			this.SWF.scaleX = this.ClipScale;
			this.SWF.scaleY = this.ClipScale;
			this.SWF.alpha = this.ClipAlpha;
			addChild(this.SWF);
		}
		
		public function SWFUnload(param1:DisplayObject) : void
		{
			removeChild(param1);
			param1.loaderInfo.loader.unload();
		}
	}
}
