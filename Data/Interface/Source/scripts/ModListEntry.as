package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.display.Loader;
   import Shared.CustomEvent;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.text.TextLineMetrics;
   import flash.geom.ColorTransform;
   import Shared.PlatformChangeEvent;
   import flash.display.BlendMode;
   import Shared.GlobalFunc;
   import flash.events.IOErrorEvent;
   
   public class ModListEntry extends BSUIComponent
   {
      
      public static const ILS_NOT_LOADED:uint = 0;
      
      public static const ILS_DOWNLOADING:uint = 1;
      
      public static const ILS_DOWNLOADED:uint = 2;
      
      public static const MAX_TEXT_LEN:uint = 30;
      
      public static const LOAD_THUMBNAIL:String = "ModListEntry::loadThumbnail";
      
      public static const UNREGISTER_IMAGE:String = "ModListEntry::unregisterImage";
      
      public static const DISPLAY_IMAGE:String = "ModListEntry::displayImage";
       
      public var ScreenshotHolder_mc:MovieClip;
      
      public var RatingHolder_mc:ModDetails_RatingHolder;
      
      public var IconHolder_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var textField:TextField;
      
      private var _DataObj:Object;
      
      private var _ItemIndex:uint;
      
      private var _ThumbnailLoader:Loader;
      
      private var _OrigScreenshotWidth:Number;
      
      private const TEXT_STAR_INTERSTIT:uint = 5;
      
      private const ICON_SPACING:uint = 5;
      
      public function ModListEntry()
      {
         super();
         this._ItemIndex = uint.MAX_VALUE;
         this._OrigScreenshotWidth = this.ScreenshotHolder_mc.width;
         this._ThumbnailLoader = new Loader();
         this._ThumbnailLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onThumbnailLoadComplete,false,0,true);
         this._ThumbnailLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onThumbnailLoadFail);
      }
      
      public function get itemIndex() : uint
      {
         return this._ItemIndex;
      }
      
      public function set itemIndex(param1:uint) : *
      {
         this._ItemIndex = param1;
      }
      
      public function set dataObj(param1:Object) : *
      {
         if(this._DataObj != null && param1 == null)
         {
            this.UnloadThumbnail();
         }
         else if(this._DataObj != null && param1.imageTextureName != this._DataObj.imageTextureName && this._ThumbnailLoader.content != null)
         {
            this.UnloadThumbnail();
         }
         this._DataObj = param1;
         if(this._DataObj != null)
         {
            this.RatingHolder_mc.rating = this._DataObj.rating;
            this.RatingHolder_mc.ratingCount = this._DataObj.ratingCount;
            if(this._DataObj.imageLoadState == ILS_NOT_LOADED)
            {
               this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.visible = true;
               this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.gotoAndPlay(1);
               dispatchEvent(new CustomEvent(LOAD_THUMBNAIL,this._DataObj,true,true));
            }
            if(this._DataObj.imageLoadState == ILS_DOWNLOADED && this._ThumbnailLoader.content == null)
            {
               this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.visible = true;
               this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.gotoAndPlay(1);
               this._ThumbnailLoader.load(new URLRequest("img://" + this._DataObj.imageTextureName));
            }
         }
         else
         {
            this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.visible = true;
            this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.gotoAndStop(1);
         }
         SetIsDirty();
      }
      
      private function onThumbnailLoadComplete(param1:Event) : *
      {
         this._ThumbnailLoader.width = this._OrigScreenshotWidth;
         this._ThumbnailLoader.height = this._OrigScreenshotWidth;
         this.ScreenshotHolder_mc.addChild(this._ThumbnailLoader);
         this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.visible = false;
         dispatchEvent(new CustomEvent(DISPLAY_IMAGE,this._DataObj,true,true));
      }
      
      private function onThumbnailLoadFail(param1:Event) : *
      {
         if(this._DataObj != null)
         {
            this._DataObj.imageLoadState = ILS_NOT_LOADED;
         }
         this.ScreenshotHolder_mc.Screenshot_mc.Spinner_mc.gotoAndStop(1);
      }
      
      public function UnloadThumbnail() : *
      {
         if(this._DataObj != null)
         {
            dispatchEvent(new CustomEvent(UNREGISTER_IMAGE,this._DataObj,true,true));
            this.ScreenshotHolder_mc.removeChild(this._ThumbnailLoader);
            this._ThumbnailLoader.unloadAndStop();
            this._DataObj.imageLoadState = ILS_NOT_LOADED;
         }
      }
      
      public function CheckScreenshotLoaded() : Boolean
      {
         return this._DataObj == null || this._ThumbnailLoader.content != null && this._ThumbnailLoader.parent == this.ScreenshotHolder_mc;
      }
      
      override public function redrawUIComponent() : void
      {
         var _loc1_:* = null;
         var _loc2_:TextLineMetrics = null;
         var _loc3_:Number = NaN;
         var _loc4_:MovieClip = null;
         var _loc5_:ColorTransform = null;
         if(this.iPlatform == PlatformChangeEvent.PLATFORM_PS4)
         {
            this.Background_mc.blendMode = BlendMode.NORMAL;
            this.ScreenshotHolder_mc.border.blendMode = BlendMode.NORMAL;
         }
         if(this._DataObj == null)
         {
            this.visible = false;
         }
         else
         {
            _loc1_ = this._DataObj.text;
            if(_loc1_.length >= MAX_TEXT_LEN)
            {
               _loc1_ = _loc1_.substr(0,MAX_TEXT_LEN) + "...";
            }
            GlobalFunc.SetText(this.textField,_loc1_,false);
            _loc2_ = this.textField.getLineMetrics(0);
            this.RatingHolder_mc.y = this.textField.y + _loc2_.height * this.textField.numLines + this.TEXT_STAR_INTERSTIT + (this.textField.numLines > 1?2:0);
            _loc3_ = 0;
            while(this.IconHolder_mc.numChildren > 0)
            {
               this.IconHolder_mc.removeChildAt(0);
            }
            if(this._DataObj.followed == true)
            {
               _loc4_ = new Icon_Followed();
               _loc4_.x = _loc3_ - _loc4_.width;
               _loc3_ = _loc3_ - (_loc4_.width + this.ICON_SPACING);
               this.IconHolder_mc.addChild(_loc4_);
            }
            if(this._DataObj.downloaded == true)
            {
               _loc4_ = new Icon_Downloaded();
               _loc4_.x = _loc3_ - _loc4_.width;
               _loc3_ = _loc3_ - (_loc4_.width + this.ICON_SPACING);
               this.IconHolder_mc.addChild(_loc4_);
            }
            if(this._DataObj.installed == true || this._DataObj.installQueued == true)
            {
               _loc4_ = new Icon_Installed();
               _loc4_.x = _loc3_ - _loc4_.width;
               _loc5_ = _loc4_.transform.colorTransform;
               _loc5_.redOffset = this._DataObj.installQueued == true?Number(-128):Number(0);
               _loc5_.greenOffset = this._DataObj.installQueued == true?Number(-128):Number(0);
               _loc5_.blueOffset = this._DataObj.installQueued == true?Number(-128):Number(0);
               _loc4_.transform.colorTransform = _loc5_;
               _loc3_ = _loc3_ - (_loc4_.width + this.ICON_SPACING);
               this.IconHolder_mc.addChild(_loc4_);
            }
            this.visible = true;
         }
      }
   }
}
