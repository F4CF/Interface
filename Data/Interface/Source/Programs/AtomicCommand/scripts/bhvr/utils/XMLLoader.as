package bhvr.utils
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import bhvr.debug.Log;
	import flash.events.Event;
	
	public class XMLLoader extends EventDispatcher
	{
		
		public static const XML_LOADED:String = "XMLLoaded";
		 
		
		private var _loader:URLLoader;
		
		private var _xml:XML;
		
		public function XMLLoader()
		{
			super();
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,this.onXMLLoaded,false,0,true);
		}
		
		public function load(path:String) : void
		{
			try
			{
				this._loader.load(new URLRequest(path));
			}
			catch(e:Error)
			{
				Log.error("error in loading the XML file");
			}
		}
		
		private function onXMLLoaded(event:Event) : void
		{
			var target:URLLoader = event.target as URLLoader;
			this._xml = XML(target.data);
			dispatchEvent(new Event(XMLLoader.XML_LOADED));
		}
		
		public function get xml() : XML
		{
			return this._xml;
		}
		
		public function dispose() : void
		{
			this._loader.removeEventListener(Event.COMPLETE,this.onXMLLoaded);
			this._loader = null;
			this._xml = null;
		}
	}
}
