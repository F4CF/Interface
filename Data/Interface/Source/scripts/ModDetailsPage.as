package
{
   import Shared.AS3.BSUIComponent;
   import flash.text.TextField;
   import Shared.AS3.BSScrollingList;
   import flash.display.MovieClip;
   import flash.display.Loader;
   import Shared.CustomEvent;
   import Shared.PlatformChangeEvent;
   import flash.display.BlendMode;
   import Shared.GlobalFunc;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.MouseEvent;
   import flash.events.IOErrorEvent;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ModDetailsPage extends BSUIComponent
   {
      
      public static const FOLLOW_ID:uint = 0;
      
      public static const UNFOLLOW_ID:uint = 1;
      
      public static const DOWNLOAD_ID:uint = 2;
      
      public static const UPDATE_ID:uint = 3;
      
      public static const INSTALL_ID:uint = 4;
      
      public static const UNINSTALL_ID:uint = 5;
      
      public static const DELETE_ID:uint = 6;
      
      public static const RATE_ID:uint = 7;
      
      public static const REPORT_ID:uint = 8;
       
      public var Title_tf:TextField;
      
      public var AuthorName_tf:TextField;
      
      public var Filesize_tf:TextField;
      
      public var Description_tf:TextField;
      
      public var RatingHolder_mc:ModDetails_RatingHolder;
      
      public var Error_tf:TextField;
      
      public var OptionsList_mc:BSScrollingList;
      
      public var Screenshot_mc:MovieClip;
      
      public var DescBackground_mc:MovieClip;
      
      public var ListBackground_mc:MovieClip;
      
      public var TextScrollUp:MovieClip;
      
      public var TextScrollDown:MovieClip;
      
      public var ScreenshotScrollLeft:MovieClip;
      
      public var ScreenshotScrollRight:MovieClip;
      
      private var _DataObj:Object;
      
      private var _TempRating:Number;
      
      private var _RatingChanged:Boolean;
      
      private var _ScreenshotLoader:Loader;
      
      private var _ScreenshotIndex:uint;
      
      private var _MaxScreenshotIndex:uint;
      
      private var _ScreenshotURL:String;
      
      private var _ScreenshotLoadState:uint;
      
      private var _ScreenshotStateChange:Boolean;
      
      private var _OrigScreenshotWidth:Number;
      
      private var _OrigScreenshotHeight:Number;
      
      private var TextScrollDeltaAccum:Number;
      
      private const RIGHT_INPUT_SCROLL_THRESHOLD:Number = 3;
      
      public function ModDetailsPage()
      {
         super();
         this._TempRating = 0;
         this._RatingChanged = false;
         this.TextScrollDeltaAccum = 0;
         this._ScreenshotURL = "";
         this._ScreenshotIndex = 0;
         this._MaxScreenshotIndex = 0;
         this._ScreenshotStateChange = false;
         this._OrigScreenshotWidth = this.Screenshot_mc.width;
         this._OrigScreenshotHeight = this.Screenshot_mc.height;
         this._ScreenshotLoader = new Loader();
         this._ScreenshotLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onScreenshotLoadComplete);
         this._ScreenshotLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onScreenshotLoadFail);
         this.Screenshot_mc.addChild(this._ScreenshotLoader);
         this.OptionsList_mc.entryList = [{
            "text":"$Follow",
            "id":FOLLOW_ID
         },{
            "text":"$Unfollow",
            "id":UNFOLLOW_ID,
            "filterFlag":0
         },{
            "text":"$Download",
            "id":DOWNLOAD_ID,
            "filterFlag":0
         },{
            "text":"$Update",
            "id":UPDATE_ID,
            "filterFlag":0
         },{
            "text":"$EnableMod",
            "id":INSTALL_ID,
            "filterFlag":0
         },{
            "text":"$DisableMod",
            "id":UNINSTALL_ID,
            "filterFlag":0
         },{
            "text":"$Delete",
            "id":DELETE_ID,
            "filterFlag":0
         },{
            "text":"$Rate",
            "id":RATE_ID,
            "showStars":true
         },{
            "text":"$Report",
            "id":REPORT_ID
         }];
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.Description_tf.addEventListener(Event.SCROLL,this.UpdateTextScrollIndicators);
         this.TextScrollUp.addEventListener(MouseEvent.CLICK,this.onTextScrollUpClicked);
         this.TextScrollDown.addEventListener(MouseEvent.CLICK,this.onTextScrollDownClicked);
         this.ScreenshotScrollLeft.addEventListener(MouseEvent.CLICK,this.onScreenshotLeftClick);
         this.ScreenshotScrollRight.addEventListener(MouseEvent.CLICK,this.onScreenshotRightClick);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Title_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Filesize_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AuthorName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Error_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.__setProp_OptionsList_mc_ModDetailsPage_OptionList_0();
      }
      
      public function get dataObj() : Object
      {
         return this._DataObj;
      }
      
      public function set dataObj(param1:Object) : *
      {
         if(param1 == null || !(param1.detailedImages is Array) || param1.detailedImages.length == 0)
         {
            this._ScreenshotStateChange = this._ScreenshotURL.length > 0;
            this._ScreenshotURL = "";
         }
         else if(this._ScreenshotURL != param1.detailedImages[this._ScreenshotIndex].imageTextureName || this._ScreenshotLoadState != param1.detailedImages[this._ScreenshotIndex].imageLoadState)
         {
            this._ScreenshotURL = param1.detailedImages[this._ScreenshotIndex].imageTextureName;
            this._ScreenshotLoadState = param1.detailedImages[this._ScreenshotIndex].imageLoadState;
            this._ScreenshotStateChange = true;
         }
         if(this._DataObj == null && param1 != null)
         {
            this._TempRating = param1.rating;
            this.OptionsList_mc.entryList[RATE_ID].rating = this._TempRating;
            this.OptionsList_mc.selectedIndex = 0;
            this._RatingChanged = false;
            this.Description_tf.scrollV = 1;
         }
         if(this._DataObj != null && param1 == null)
         {
            if(this._ScreenshotLoader.content != null)
            {
               this._ScreenshotLoader.unloadAndStop();
               dispatchEvent(new CustomEvent(ModListEntry.UNREGISTER_IMAGE,this._DataObj.detailedImages[this._ScreenshotIndex],true,true));
            }
            this._ScreenshotIndex = 0;
         }
         this._DataObj = param1;
         if(this._DataObj != null)
         {
            this.OptionsList_mc.entryList[FOLLOW_ID].filterFlag = this._DataObj.followed != true?1:0;
            this.OptionsList_mc.entryList[FOLLOW_ID].text = this._DataObj.followSyncing == true?"$Following":"$Follow";
            this.OptionsList_mc.entryList[FOLLOW_ID].disabled = this._DataObj.authored == true;
            this.OptionsList_mc.entryList[UNFOLLOW_ID].filterFlag = this._DataObj.followed == true?1:0;
            this.OptionsList_mc.entryList[UNFOLLOW_ID].text = this._DataObj.followSyncing == true?"$Unfollowing":"$Unfollow";
            this.OptionsList_mc.entryList[UNFOLLOW_ID].disabled = this._DataObj.authored == true;
            this.OptionsList_mc.entryList[DOWNLOAD_ID].filterFlag = this._DataObj.downloaded != true?1:0;
            if(this._DataObj.subscribeSyncing == true || this._DataObj.downloadProgress is uint && this._DataObj.downloadProgress == 0)
            {
               this.OptionsList_mc.entryList[DOWNLOAD_ID].text = "$Queued...";
            }
            else if(this._DataObj.downloadProgress is uint)
            {
               this.OptionsList_mc.entryList[DOWNLOAD_ID].text = "$$Downloading... " + this._DataObj.downloadProgress + "%";
            }
            else
            {
               this.OptionsList_mc.entryList[DOWNLOAD_ID].text = "$Download";
            }
            this.OptionsList_mc.entryList[UPDATE_ID].filterFlag = this._DataObj.downloaded == true && this._DataObj.needsUpdate == true?1:0;
            if(this._DataObj.downloadProgress is uint)
            {
               this.OptionsList_mc.entryList[UPDATE_ID].text = "$$Downloading... " + this._DataObj.downloadProgress + "%";
            }
            else
            {
               this.OptionsList_mc.entryList[UPDATE_ID].text = "$Update";
            }
            this.OptionsList_mc.entryList[DELETE_ID].filterFlag = this._DataObj.downloaded == true?1:0;
            this.OptionsList_mc.entryList[DELETE_ID].text = this._DataObj.deleteSyncing == true?"$Deleting":"$Delete";
            this.OptionsList_mc.entryList[RATE_ID].disabled = this._DataObj.authored == true;
            this.OptionsList_mc.entryList[INSTALL_ID].filterFlag = this._DataObj.downloaded == true && (this._DataObj.installed != true || this._DataObj.uninstallQueued == true) && this._DataObj.installQueued != true?1:0;
            this.OptionsList_mc.entryList[INSTALL_ID].text = "$EnableMod";
            this.OptionsList_mc.entryList[UNINSTALL_ID].filterFlag = this._DataObj.downloaded == true && (this._DataObj.installed == true || this._DataObj.installQueued == true) && this._DataObj.uninstallQueued != true?1:0;
            this.OptionsList_mc.entryList[UNINSTALL_ID].text = "$DisableMod";
            if(this._DataObj.reportSyncing == true)
            {
               this.OptionsList_mc.entryList[REPORT_ID].text = "$Reporting...";
            }
            else
            {
               this.OptionsList_mc.entryList[REPORT_ID].text = this._DataObj.reported == true?"$Reported":"$Report";
            }
            this.OptionsList_mc.entryList[REPORT_ID].disabled = this._DataObj.reported == true || this._DataObj.authored == true;
            this._MaxScreenshotIndex = this._DataObj.detailedImages is Array?uint(this._DataObj.detailedImages.length - 1):uint(0);
            this.RatingHolder_mc.rating = this._DataObj.rating;
            this.RatingHolder_mc.ratingCount = this._DataObj.ratingCount;
         }
         SetIsDirty();
      }
      
      public function get selectedEntry() : Object
      {
         return this.OptionsList_mc.selectedEntry;
      }
      
      public function get tempRating() : Number
      {
         return this._TempRating;
      }
      
      public function get hasRatingChanged() : Boolean
      {
         return this._RatingChanged;
      }
      
      override public function redrawUIComponent() : void
      {
         if(this.iPlatform == PlatformChangeEvent.PLATFORM_PS4)
         {
            this.DescBackground_mc.blendMode = BlendMode.NORMAL;
            this.ListBackground_mc.blendMode = BlendMode.NORMAL;
         }
         if(this._DataObj != null)
         {
            GlobalFunc.SetText(this.Title_tf,this._DataObj.text,false);
            GlobalFunc.SetText(this.AuthorName_tf,"$$Author: " + this._DataObj.author,false);
            GlobalFunc.SetText(this.Description_tf,this._DataObj.description,false);
            this.UpdateTextScrollIndicators();
            GlobalFunc.SetText(this.Filesize_tf,"$$DownloadSize: " + Main_ModManager.GetFileSizeString(this._DataObj.fileSizeDisplay),false);
            this.OptionsList_mc.InvalidateData();
            this.ScreenshotScrollLeft.visible = this._ScreenshotIndex > 0;
            this.ScreenshotScrollRight.visible = this._ScreenshotIndex < this._MaxScreenshotIndex;
         }
         if(this._ScreenshotStateChange)
         {
            if(this._ScreenshotURL == "")
            {
               if(this._ScreenshotLoader.content != null)
               {
                  this._ScreenshotLoader.unloadAndStop();
               }
               this.Screenshot_mc.Spinner_mc.visible = true;
               this.Screenshot_mc.Spinner_mc.gotoAndStop(1);
            }
            else if(this._ScreenshotLoadState == ModListEntry.ILS_DOWNLOADING)
            {
               this.Screenshot_mc.Spinner_mc.visible = true;
               this.Screenshot_mc.Spinner_mc.gotoAndPlay(1);
            }
            else if(this._ScreenshotLoadState == ModListEntry.ILS_DOWNLOADED)
            {
               this.Screenshot_mc.Spinner_mc.visible = true;
               this.Screenshot_mc.Spinner_mc.gotoAndPlay(1);
               this._ScreenshotLoader.load(new URLRequest("img://" + this._ScreenshotURL));
            }
            this._ScreenshotStateChange = false;
         }
      }
      
      private function onScreenshotLoadComplete(param1:Event) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._ScreenshotLoader.numChildren)
         {
            this._ScreenshotLoader.getChildAt(_loc2_).width = this._OrigScreenshotWidth;
            this._ScreenshotLoader.getChildAt(_loc2_).height = this._OrigScreenshotHeight;
            _loc2_++;
         }
         this.Screenshot_mc.Spinner_mc.visible = false;
         dispatchEvent(new CustomEvent(ModListEntry.DISPLAY_IMAGE,this._DataObj.detailedImages[this._ScreenshotIndex],true,true));
      }
      
      private function onScreenshotLoadFail(param1:Event) : *
      {
         this.Screenshot_mc.Spinner_mc.visible = true;
         this.Screenshot_mc.Spinner_mc.gotoAndStop(1);
      }
      
      public function ShowError(param1:String) : *
      {
         GlobalFunc.SetText(this.Error_tf,param1,false);
         var _loc2_:Timer = new Timer(2000,0);
         _loc2_.addEventListener(TimerEvent.TIMER,this.onShowErrorTimerDone);
         _loc2_.start();
      }
      
      private function onShowErrorTimerDone(param1:TimerEvent) : *
      {
         GlobalFunc.SetText(this.Error_tf," ",false);
         param1.target.removeEventListener(TimerEvent.TIMER,this.onShowErrorTimerDone);
         (param1.target as Timer).stop();
      }
      
      private function onKeyDown(param1:KeyboardEvent) : *
      {
         if(this.OptionsList_mc.selectedEntry.showStars == true && this.OptionsList_mc.selectedEntry.disabled != true)
         {
            if(param1.keyCode == Keyboard.LEFT && this._TempRating > 0.5)
            {
               this._TempRating = Math.min(Math.max(this._TempRating - 0.5,0.5),ModDetails_RatingHolder.MAX_RATING);
               this._RatingChanged = true;
               this.OptionsList_mc.selectedEntry.rating = this._TempRating;
               this.OptionsList_mc.UpdateSelectedEntry();
               param1.stopPropagation();
            }
            else if(param1.keyCode == Keyboard.RIGHT && this._TempRating < ModDetails_RatingHolder.MAX_RATING)
            {
               this._TempRating = Math.min(Math.max(this._TempRating + 0.5,0.5),ModDetails_RatingHolder.MAX_RATING);
               this._RatingChanged = true;
               this.OptionsList_mc.selectedEntry.rating = this._TempRating;
               this.OptionsList_mc.UpdateSelectedEntry();
               param1.stopPropagation();
            }
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            this.onScreenshotLeftClick();
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            this.onScreenshotRightClick();
            param1.stopPropagation();
         }
      }
      
      private function onScreenshotLeftClick() : *
      {
         if(this._ScreenshotIndex > 0)
         {
            if(this._ScreenshotLoader.content != null)
            {
               this._ScreenshotLoader.unloadAndStop();
               dispatchEvent(new CustomEvent(ModListEntry.UNREGISTER_IMAGE,this._DataObj.detailedImages[this._ScreenshotIndex],true,true));
            }
            this._ScreenshotIndex--;
            this._ScreenshotURL = this._DataObj.detailedImages[this._ScreenshotIndex].imageTextureName;
            this._ScreenshotLoadState = this._DataObj.detailedImages[this._ScreenshotIndex].imageLoadState;
            this._ScreenshotStateChange = true;
            SetIsDirty();
         }
      }
      
      private function onScreenshotRightClick() : *
      {
         if(this._ScreenshotIndex < this._MaxScreenshotIndex)
         {
            if(this._ScreenshotLoader.content != null)
            {
               this._ScreenshotLoader.unloadAndStop();
               dispatchEvent(new CustomEvent(ModListEntry.UNREGISTER_IMAGE,this._DataObj.detailedImages[this._ScreenshotIndex],true,true));
            }
            this._ScreenshotIndex++;
            this._ScreenshotURL = this._DataObj.detailedImages[this._ScreenshotIndex].imageTextureName;
            this._ScreenshotLoadState = this._DataObj.detailedImages[this._ScreenshotIndex].imageLoadState;
            this._ScreenshotStateChange = true;
            SetIsDirty();
         }
      }
      
      public function UpdateTextScrollIndicators() : *
      {
         this.TextScrollUp.visible = this.Description_tf.scrollV > 1;
         this.TextScrollDown.visible = this.Description_tf.bottomScrollV < this.Description_tf.numLines;
      }
      
      public function OnRightStickInput(param1:Number, param2:Number) : *
      {
         this.TextScrollDeltaAccum = this.TextScrollDeltaAccum + Math.abs(param2);
         if(this.TextScrollDeltaAccum >= this.RIGHT_INPUT_SCROLL_THRESHOLD)
         {
            this.TextScrollDeltaAccum = 0;
            if(param2 > 0.1)
            {
               this.Description_tf.scrollV--;
            }
            if(param2 < -0.1)
            {
               this.Description_tf.scrollV++;
            }
         }
      }
      
      private function onTextScrollUpClicked() : *
      {
         this.Description_tf.scrollV--;
      }
      
      private function onTextScrollDownClicked() : *
      {
         this.Description_tf.scrollV++;
      }
      
      private function onMouseWheel(param1:MouseEvent) : *
      {
         if(hitTestPoint(stage.mouseX,stage.mouseY))
         {
            if(param1.delta < 0)
            {
               this.Description_tf.scrollV++;
            }
            else if(param1.delta > 0)
            {
               this.Description_tf.scrollV--;
            }
         }
      }
      
      function __setProp_OptionsList_mc_ModDetailsPage_OptionList_0() : *
      {
         try
         {
            this.OptionsList_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.OptionsList_mc.disableSelection = false;
         this.OptionsList_mc.listEntryClass = "ModDetails_OptionsEntry";
         this.OptionsList_mc.numListItems = 6;
         this.OptionsList_mc.restoreListIndex = true;
         this.OptionsList_mc.textOption = "Shrink To Fit";
         this.OptionsList_mc.verticalSpacing = 0;
         try
         {
            this.OptionsList_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
