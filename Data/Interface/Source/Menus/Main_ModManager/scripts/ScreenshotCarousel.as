package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import Shared.PlatformChangeEvent;
	import flash.display.BlendMode;
	import flash.net.URLRequest;
	import flash.events.Event;
	import Shared.CustomEvent;
	import flash.events.MouseEvent;
	
	public class ScreenshotCarousel extends BSUIComponent
	{
		 
		
		public var PrevScreenshot_mc:MovieClip;
		
		public var CurrScreenshot_mc:MovieClip;
		
		public var NextScreenshot_mc:MovieClip;
		
		private var _DataArray:Array;
		
		private var _PrevScreenshotLoader:Loader;
		
		private var _CurrScreenshotLoader:Loader;
		
		private var _NextScreenshotLoader:Loader;
		
		private var _SelectedIndex:uint;
		
		public function ScreenshotCarousel()
		{
			super();
			addFrameScript(0,this.frame1,3,this.frame4);
			this._PrevScreenshotLoader = new Loader();
			this._CurrScreenshotLoader = new Loader();
			this._NextScreenshotLoader = new Loader();
			this._PrevScreenshotLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageLoadComplete);
			this._CurrScreenshotLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageLoadComplete);
			this._NextScreenshotLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageLoadComplete);
			this.PrevScreenshot_mc.addEventListener(MouseEvent.CLICK,this.onPrevClick);
			this.NextScreenshot_mc.addEventListener(MouseEvent.CLICK,this.onNextClick);
			this.PrevScreenshot_mc.visible = false;
			this.NextScreenshot_mc.visible = false;
			this._SelectedIndex = 0;
		}
		
		public function get dataArray() : Array
		{
			return this._DataArray;
		}
		
		public function set dataArray(param1:Array) : *
		{
			if(this.iPlatform == PlatformChangeEvent.PLATFORM_PS4)
			{
				this.PrevScreenshot_mc.border.blendMode = BlendMode.NORMAL;
				this.CurrScreenshot_mc.border.blendMode = BlendMode.NORMAL;
				this.NextScreenshot_mc.border.blendMode = BlendMode.NORMAL;
			}
			var _loc2_:* = this._DataArray == null;
			if(param1 == null)
			{
				this.ReleaseTextures();
			}
			this._DataArray = param1;
			this.CurrScreenshot_mc.Spinner_mc.visible = true;
			if(this._DataArray is Array)
			{
				this.CurrScreenshot_mc.Spinner_mc.gotoAndPlay(1);
				if(_loc2_)
				{
					this._SelectedIndex = 0;
				}
				this.RefreshTextures();
			}
			else
			{
				this.CurrScreenshot_mc.Spinner_mc.gotoAndStop(1);
			}
		}
		
		private function RefreshTextures() : *
		{
			if(this._SelectedIndex == 0)
			{
				this.PrevScreenshot_mc.visible = false;
			}
			else
			{
				this.PrevScreenshot_mc.visible = true;
				if(this._PrevScreenshotLoader.content == null && this._DataArray[this._SelectedIndex - 1].imageLoadState == ModListEntry.ILS_DOWNLOADED)
				{
					this._PrevScreenshotLoader.load(new URLRequest("img://" + this._DataArray[this._SelectedIndex - 1].imageTextureName));
				}
			}
			if(this._CurrScreenshotLoader.content == null && this._DataArray[this._SelectedIndex].imageLoadState == ModListEntry.ILS_DOWNLOADED)
			{
				this._CurrScreenshotLoader.load(new URLRequest("img://" + this._DataArray[this._SelectedIndex].imageTextureName));
			}
			if(this._SelectedIndex == this._DataArray.length - 1)
			{
				this.NextScreenshot_mc.visible = false;
			}
			else
			{
				this.NextScreenshot_mc.visible = true;
				if(this._NextScreenshotLoader.content == null && this._DataArray[this._SelectedIndex + 1].imageLoadState == ModListEntry.ILS_DOWNLOADED)
				{
					this._NextScreenshotLoader.load(new URLRequest("img://" + this._DataArray[this._SelectedIndex + 1].imageTextureName));
				}
			}
		}
		
		private function onImageLoadComplete(param1:Event) : *
		{
			var _loc2_:Loader = null;
			var _loc3_:MovieClip = null;
			var _loc4_:uint = 0;
			if(param1.currentTarget.loader == this._PrevScreenshotLoader)
			{
				_loc2_ = this._PrevScreenshotLoader;
				_loc3_ = this.PrevScreenshot_mc;
				_loc4_ = this._SelectedIndex - 1;
			}
			else if(param1.currentTarget.loader == this._CurrScreenshotLoader)
			{
				_loc2_ = this._CurrScreenshotLoader;
				_loc3_ = this.CurrScreenshot_mc;
				_loc4_ = this._SelectedIndex;
			}
			else
			{
				_loc2_ = this._NextScreenshotLoader;
				_loc3_ = this.NextScreenshot_mc;
				_loc4_ = this._SelectedIndex + 1;
			}
			_loc2_.width = _loc3_.width;
			_loc2_.height = _loc3_.height;
			_loc3_.addChild(_loc2_);
			this.CurrScreenshot_mc.Spinner_mc.visible = false;
			dispatchEvent(new CustomEvent(ModListEntry.DISPLAY_IMAGE,this._DataArray[_loc4_],true,true));
		}
		
		private function ReleaseTextures() : *
		{
			var _loc1_:Object = null;
			if(this._DataArray != null)
			{
				for each(_loc1_ in this._DataArray)
				{
					dispatchEvent(new CustomEvent(ModListEntry.UNREGISTER_IMAGE,_loc1_,true,true));
				}
				this.PrevScreenshot_mc.removeChild(this._PrevScreenshotLoader);
				this.CurrScreenshot_mc.removeChild(this._CurrScreenshotLoader);
				this.NextScreenshot_mc.removeChild(this._NextScreenshotLoader);
				this._PrevScreenshotLoader.unloadAndStop();
				this._CurrScreenshotLoader.unloadAndStop();
				this._NextScreenshotLoader.unloadAndStop();
			}
		}
		
		public function ScrollLeft() : *
		{
			var _loc1_:Loader = null;
			if(this._SelectedIndex > 0)
			{
				if(this._NextScreenshotLoader.content != null)
				{
					this.NextScreenshot_mc.removeChild(this._NextScreenshotLoader);
					this._NextScreenshotLoader.unloadAndStop();
				}
				this._SelectedIndex--;
				_loc1_ = this._NextScreenshotLoader;
				this.NextScreenshot_mc.addChild(this.CurrScreenshot_mc.removeChild(this._CurrScreenshotLoader));
				this.NextScreenshot_mc.visible = true;
				this._NextScreenshotLoader = this._CurrScreenshotLoader;
				this.CurrScreenshot_mc.addChild(this.PrevScreenshot_mc.removeChild(this._PrevScreenshotLoader));
				this._CurrScreenshotLoader = this._PrevScreenshotLoader;
				this._PrevScreenshotLoader = _loc1_;
				if(this._SelectedIndex == 0)
				{
					this.PrevScreenshot_mc.visible = false;
				}
				else
				{
					this.PrevScreenshot_mc.visible = true;
					if(this._PrevScreenshotLoader.content == null && this._DataArray[this._SelectedIndex - 1].imageLoadState == ModListEntry.ILS_DOWNLOADED)
					{
						this._PrevScreenshotLoader.load(new URLRequest("img://" + this._DataArray[this._SelectedIndex - 1].imageTextureName));
					}
				}
				gotoAndPlay("scrollLeft");
			}
		}
		
		public function ScrollRight() : *
		{
			var _loc1_:Loader = null;
			if(this._SelectedIndex < this._DataArray.length - 1)
			{
				if(this._PrevScreenshotLoader.content != null)
				{
					this.PrevScreenshot_mc.removeChild(this._PrevScreenshotLoader);
					this._PrevScreenshotLoader.unloadAndStop();
				}
				this._SelectedIndex++;
				_loc1_ = this._PrevScreenshotLoader;
				this.PrevScreenshot_mc.addChild(this.CurrScreenshot_mc.removeChild(this._CurrScreenshotLoader));
				this.PrevScreenshot_mc.visible = true;
				this._PrevScreenshotLoader = this._CurrScreenshotLoader;
				this.CurrScreenshot_mc.addChild(this.NextScreenshot_mc.removeChild(this._NextScreenshotLoader));
				this._CurrScreenshotLoader = this._NextScreenshotLoader;
				this._NextScreenshotLoader = _loc1_;
				if(this._SelectedIndex == this._DataArray.length - 1)
				{
					this.NextScreenshot_mc.visible = false;
				}
				else
				{
					this.NextScreenshot_mc.visible = true;
					if(this._NextScreenshotLoader.content == null && this._DataArray[this._SelectedIndex + 1].imageLoadState == ModListEntry.ILS_DOWNLOADED)
					{
						this._NextScreenshotLoader.load(new URLRequest("img://" + this._DataArray[this._SelectedIndex + 1].imageTextureName));
					}
				}
				gotoAndPlay("scrollRight");
			}
		}
		
		private function onPrevClick() : *
		{
			this.ScrollLeft();
		}
		
		private function onNextClick() : *
		{
			this.ScrollRight();
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame4() : *
		{
			gotoAndStop(1);
		}
	}
}
