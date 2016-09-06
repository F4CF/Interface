package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Loader;
	import Shared.GlobalFunc;
	import Shared.CustomEvent;
	import flash.net.URLRequest;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	
	public class ModLibrary_ListEntry extends BSScrollingListEntry
	{
		
		public static const MAX_TEXT_LEN:uint = 30;
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public var fileSize_tf:TextField;
		
		public var Order_tf:TextField;
		
		public var ScreenshotHolder_mc:MovieClip;
		
		private var _ThumbnailLoader:Loader;
		
		private var _DataObj:Object;
		
		private var _OrigScreenshotWidth:Number;
		
		public function ModLibrary_ListEntry()
		{
			super();
			_HasDynamicHeight = false;
			this._ThumbnailLoader = new Loader();
			this._ThumbnailLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onThumbnailLoadComplete);
			this._OrigScreenshotWidth = this.ScreenshotHolder_mc.width / this.ScreenshotHolder_mc.scaleX;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			GlobalFunc.SetText(this.fileSize_tf,Main_ModManager.GetFileSizeString(param1.fileSizeDisplay),false);
			if(param1.text.length >= MAX_TEXT_LEN)
			{
				GlobalFunc.SetText(textField,param1.text.substr(0,MAX_TEXT_LEN) + "...",false);
			}
			if(this._DataObj != null && param1.dataObj is Object && param1.dataObj.imageTextureName != this._DataObj.imageTextureName)
			{
				this.UnloadThumbnail();
			}
			else if(!(param1.dataObj is Object))
			{
				this.UnloadThumbnail();
			}
			this._DataObj = param1.dataObj is Object?param1.dataObj:null;
			this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.visible = true;
			if(this._DataObj != null)
			{
				this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.gotoAndPlay(1);
				if(this._DataObj.imageLoadState == ModListEntry.ILS_NOT_LOADED)
				{
					dispatchEvent(new CustomEvent(ModListEntry.LOAD_THUMBNAIL,this._DataObj,true,true));
				}
				if(this._DataObj.imageLoadState == ModListEntry.ILS_DOWNLOADED && this._ThumbnailLoader.content == null)
				{
					this._ThumbnailLoader.load(new URLRequest("img://" + this._DataObj.imageTextureName));
				}
			}
			else
			{
				this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.gotoAndStop(1);
			}
			this.EquipIcon_mc.visible = param1.checked == true;
			var _loc3_:ColorTransform = this.transform.colorTransform;
			_loc3_.redOffset = param1.disabled || this._DataObj != null && this._DataObj.blacklisted?Number(-128):Number(0);
			_loc3_.greenOffset = param1.disabled || this._DataObj != null && this._DataObj.blacklisted?Number(-128):Number(0);
			_loc3_.blueOffset = param1.disabled || this._DataObj != null && this._DataObj.blacklisted?Number(-128):Number(0);
			this.transform.colorTransform = _loc3_;
			_loc3_ = this.EquipIcon_mc.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.EquipIcon_mc.transform.colorTransform = _loc3_;
			this.Order_tf.textColor = !!this.selected?uint(0):uint(16777215);
			this.fileSize_tf.textColor = !!this.selected?uint(0):uint(16777215);
		}
		
		private function onThumbnailLoadComplete(param1:Event) : *
		{
			if(this._DataObj != null)
			{
				this._ThumbnailLoader.width = this._OrigScreenshotWidth;
				this._ThumbnailLoader.height = this._OrigScreenshotWidth;
				this.ScreenshotHolder_mc.addChild(this._ThumbnailLoader);
				this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.visible = false;
				dispatchEvent(new CustomEvent(ModListEntry.DISPLAY_IMAGE,this._DataObj,true,true));
			}
		}
		
		public function UnloadThumbnail() : *
		{
			if(this._DataObj != null)
			{
				if(this._DataObj.imageLoadState == ModListEntry.ILS_DOWNLOADING || this._DataObj.imageLoadState == ModListEntry.ILS_DOWNLOADED)
				{
					dispatchEvent(new CustomEvent(ModListEntry.UNREGISTER_IMAGE,this._DataObj,true,true));
				}
				this.ScreenshotHolder_mc.removeChild(this._ThumbnailLoader);
				this._ThumbnailLoader.close();
				this._ThumbnailLoader.unload();
			}
		}
		
		public function CheckThumbnailLoaded() : Boolean
		{
			return this._DataObj == null || this._ThumbnailLoader.content != null && this._ThumbnailLoader.parent == this.ScreenshotHolder_mc;
		}
	}
}
