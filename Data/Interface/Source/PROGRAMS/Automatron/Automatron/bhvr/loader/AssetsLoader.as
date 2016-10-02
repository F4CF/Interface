package bhvr.loader
{
	import flash.events.EventDispatcher;
	import scaleform.clik.controls.UILoader;
	import bhvr.utils.XMLLoader;
	import bhvr.debug.Log;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.MovieClip;
	import bhvr.constants.GameConfig;
	import bhvr.events.EventWithParams;
	import bhvr.constants.GameConstants;
	
	public class AssetsLoader extends EventDispatcher
	{
		
		public static const SWF_LOADED:String = "SwfLoaded";
		
		public static const ALL_ASSETS_LOADED:String = "AllAssetsLoaded";
		 
		
		private var _xmls:Vector.<String>;
		
		private var _swfs:Vector.<String>;
		
		private var _assetLoaders:Vector.<UILoader>;
		
		private var _xmlLoaders:Vector.<XMLLoader>;
		
		private var _assetsLoadedNum:uint;
		
		private var _maxAssetsNum:uint;
		
		public function AssetsLoader()
		{
			super();
			this._xmls = new Vector.<String>();
			this._swfs = new Vector.<String>();
			this._assetsLoadedNum = 0;
		}
		
		public function load(param1:Vector.<String>) : void
		{
			var _loc2_:uint = 0;
			var _loc3_:String = null;
			var _loc4_:Array = null;
			var _loc5_:String = null;
			this._maxAssetsNum = param1.length;
			_loc2_ = 0;
			while(_loc2_ < this._maxAssetsNum)
			{
				_loc3_ = param1[_loc2_];
				_loc4_ = _loc3_.split(".");
				_loc5_ = _loc4_[_loc4_.length - 1];
				if(_loc5_ == "xml")
				{
					this._xmls.push(_loc3_);
				}
				else if(_loc5_ == "swf")
				{
					this._swfs.push(_loc3_);
				}
				else
				{
					Log.error("File type: " + _loc5_ + " is not supported.");
				}
				_loc2_++;
			}
			if(this._swfs.length > 0)
			{
				this.loadSwfs();
			}
			if(this._xmls.length > 0)
			{
				this.loadXmls();
			}
		}
		
		private function loadSwfs() : void
		{
			this._assetLoaders = new Vector.<UILoader>(this._swfs.length);
			var _loc1_:uint = 0;
			while(_loc1_ < this._swfs.length)
			{
				this._assetLoaders[_loc1_] = new UILoader();
				this._assetLoaders[_loc1_].addEventListener(Event.COMPLETE,this.onSwfLoaded,false,0,true);
				this._assetLoaders[_loc1_].addEventListener(IOErrorEvent.IO_ERROR,this.onSwfLoadingError,false,0,true);
				this._assetLoaders[_loc1_].source = this._swfs[_loc1_];
				_loc1_++;
			}
		}
		
		private function loadXmls() : void
		{
			this._xmlLoaders = new Vector.<XMLLoader>(this._xmls.length);
			var _loc1_:uint = 0;
			while(_loc1_ < this._xmls.length)
			{
				this._xmlLoaders[_loc1_] = new XMLLoader();
				this._xmlLoaders[_loc1_].addEventListener(XMLLoader.XML_LOADED,this.onXmlLoaded,false,0,true);
				this._xmlLoaders[_loc1_].load(this._xmls[_loc1_]);
				_loc1_++;
			}
		}
		
		private function onSwfLoaded(param1:Event) : void
		{
			var _loc2_:MovieClip = param1.target.content as MovieClip;
			var _loc3_:String = param1.target.source;
			this._assetsLoadedNum++;
			var _loc4_:uint = GameConfig.getAssetIdFromUrl(_loc3_);
			if(_loc4_ == GameConfig.INVALID_ASSET_ID)
			{
				throw new Error("Assets loaded \'" + _loc3_ + "\' is not expected!");
			}
			Log.info("[AssetLoader]: " + _loc3_ + "(id=" + _loc4_ + ") has been successfully loaded!");
			dispatchEvent(new EventWithParams(SWF_LOADED,{
				"content":_loc2_,
				"assetId":_loc4_,
				"asset":_loc2_.getChildByName("mainMc") as MovieClip
			}));
			this.checkEndOfLoading();
		}
		
		private function onXmlLoaded(param1:Event) : void
		{
			var _loc5_:String = null;
			this._assetsLoadedNum++;
			var _loc2_:XML = param1.target.xml as XML;
			var _loc3_:XMLList = _loc2_.children();
			var _loc4_:int = _loc3_.length();
			var _loc6_:int = 0;
			while(_loc6_ < _loc4_)
			{
				_loc5_ = _loc3_[_loc6_].@name;
				if(_loc5_ != "")
				{
					if(GameConstants[_loc5_] != null)
					{
						GameConstants[_loc5_] = _loc3_[_loc6_];
					}
					else
					{
						Log.error("XML config parsing: ignored variable \'" + _loc5_ + "\' : doesn\'t exist.");
					}
				}
				else
				{
					Log.error("XML config parsing: ignored variable #" + _loc6_ + " : name empty.");
				}
				_loc6_++;
			}
			param1.target.dispose();
			this.checkEndOfLoading();
		}
		
		private function checkEndOfLoading() : void
		{
			if(this._assetsLoadedNum == this._maxAssetsNum)
			{
				dispatchEvent(new EventWithParams(ALL_ASSETS_LOADED));
			}
		}
		
		private function onSwfLoadingError(param1:IOErrorEvent) : void
		{
			Log.error("Can\'t load Game assets because " + param1.target.source + " doesn\'t exist!");
		}
		
		public function dispose() : void
		{
			this._xmls = null;
			this._swfs = null;
			this._assetLoaders = null;
			this._xmlLoaders = null;
		}
	}
}
