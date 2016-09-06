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
		
		private var _url:String;
		
		private var _xml:XML;
		
		public function XMLLoader()
		{
			super();
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,this.onXMLLoaded,false,0,true);
		}
		
		public function load(param1:String) : void
		{
			var path:String = param1;
			try
			{
				this._url = path;
				this._loader.load(new URLRequest(path));
				return;
			}
			catch(e:Error)
			{
				Log.error("error in loading the XML file");
				return;
			}
		}
		
		private function onXMLLoaded(param1:Event) : void
		{
			var _loc2_:URLLoader = param1.target as URLLoader;
			this._xml = XML(_loc2_.data);
			dispatchEvent(new Event(XMLLoader.XML_LOADED));
		}
		
		public function get xml() : XML
		{
			return this._xml;
		}
		
		public function get url() : String
		{
			return this._url;
		}
		
		public function dispose() : void
		{
			this._loader.removeEventListener(Event.COMPLETE,this.onXMLLoaded);
			this._loader = null;
			this._xml = null;
		}
	}
}
