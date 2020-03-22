package
{
	import Shared.IMenu;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class SWFLoaderMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		protected var LoadedSWFMap:Object;
		
		public function SWFLoaderMenu()
		{
			super();
			this.BGSCodeObj = new Object();
			this.LoadedSWFMap = new Object();
		}
		
		public function SWFLoad(param1:String) : *
		{
			var _loc2_:URLRequest = null;
			if(this.LoadedSWFMap[param1] == undefined || this.LoadedSWFMap[param1] == null)
			{
				this.LoadedSWFMap[param1] = new Loader();
				_loc2_ = new URLRequest(param1 + ".swf");
				this.LoadedSWFMap[param1].contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMenuLoadComplete);
				this.LoadedSWFMap[param1].load(_loc2_);
			}
			else if(this.LoadedSWFMap[param1] is Loader)
			{
				this.LoadedSWFMap[param1].contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMenuLoadAbandoned);
				this.LoadedSWFMap[param1].contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMenuLoadComplete);
			}
			else
			{
				this.BGSCodeObj.onMenuLoadComplete(param1,this.LoadedSWFMap[param1]);
			}
		}
		
		protected function GetMenuNameFromURL(param1:String) : String
		{
			var _loc2_:Number = param1.lastIndexOf("/");
			var _loc3_:Number = param1.length - 4;
			return param1.slice(_loc2_ + 1,_loc3_);
		}
		
		public function onMenuLoadComplete(param1:Event) : *
		{
			var _loc2_:String = this.GetMenuNameFromURL(param1.currentTarget.url);
			this.LoadedSWFMap[_loc2_].contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMenuLoadComplete);
			addChild(param1.currentTarget.content);
			this.LoadedSWFMap[_loc2_] = param1.currentTarget.content;
			this.BGSCodeObj.onMenuLoadComplete(_loc2_,this.LoadedSWFMap[_loc2_]);
		}
		
		public function SWFUnload(param1:String) : *
		{
			if(this.LoadedSWFMap[param1] != undefined && this.LoadedSWFMap[param1] != null)
			{
				if(this.LoadedSWFMap[param1] is Loader)
				{
					this.LoadedSWFMap[param1].contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMenuLoadComplete);
					this.LoadedSWFMap[param1].contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMenuLoadAbandoned);
				}
				else
				{
					removeChild(this.LoadedSWFMap[param1]);
					this.LoadedSWFMap[param1].loaderInfo.loader.unloadAndStop();
					this.LoadedSWFMap[param1] = null;
				}
			}
		}
		
		public function onMenuLoadAbandoned(param1:Event) : *
		{
			var _loc2_:String = this.GetMenuNameFromURL(param1.currentTarget.url);
			this.LoadedSWFMap[_loc2_].contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMenuLoadAbandoned);
			this.LoadedSWFMap[_loc2_].unloadAndStop();
			this.LoadedSWFMap[_loc2_] = null;
		}
		
		public function GetTimelineObj(param1:String) : Object
		{
			if(this.LoadedSWFMap[param1] != undefined && this.LoadedSWFMap[param1] != null && !(this.LoadedSWFMap[param1] is Loader))
			{
				return this.LoadedSWFMap[param1];
			}
			return null;
		}
	}
}
