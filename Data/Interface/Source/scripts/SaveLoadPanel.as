package
{
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import Shared.AS3.BSScrollingList;
   import flash.text.TextField;
   import flash.display.Loader;
   import flash.utils.Timer;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import Shared.PlatformChangeEvent;
   import flash.display.Bitmap;
   import flash.events.TimerEvent;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class SaveLoadPanel extends MovieClip
   {
      
      public static const SAVE_LIST_POPULATED:String = "SaveLoadPanel::SAVE_LIST_POPULATED";
      
      public static const SAVE_HIGHLIGHTED:String = "SaveLoadPanel::SAVE_HIGHLIGHTED";
      
      public static const SAVE_SELECTED:String = "SaveLoadPanel::SAVE_SELECTED";
      
      public static const LOAD_GAME_SELECTED:String = "SaveLoadPanel::LOAD_GAME_SELECTED";
      
      private static const SCREENSHOT_URL:URLRequest = new URLRequest("img://BGSSaveLoadHeader_Screenshot");
       
      public var List_mc:BSScrollingList;
      
      public var PlayerInfo_tf:TextField;
      
      public var ScreenshotSizer_mc:MovieClip;
      
      public var TRBracket_mc:MovieClip;
      
      public var SaveTime_tf:TextField;
      
      public var LocationText_tf:TextField;
      
      public var LevelText_tf:TextField;
      
      public var LevelMeter_mc:Pipboy_Meter;
      
      public var ModsLoaded_tf:TextField;
      
      private var ScreenShotLoader:Loader;
      
      private var ScreenshotDelayTimer:Timer;
      
      private var bSaving:Boolean;
      
      private var uiPlatform:uint;
      
      private var uiBatchSize:uint;
      
      private var Confirming:Boolean = false;
      
      private var bShowScreenshot;
      
      private var ScreenshotDelayTimerSlow:uint;
      
      private var ScreenshotDelayTimerFast:uint;
      
      var BGSCodeObj:Object;
      
      public function SaveLoadPanel()
      {
         super();
         this.bSaving = false;
         this.bShowScreenshot = false;
         this.ScreenshotDelayTimerSlow = 450;
         this.ScreenshotDelayTimerFast = 200;
         this.ScreenshotDelayTimer = new Timer(this.ScreenshotDelayTimerFast,1);
         this.ScreenshotDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.PrepScreenshot);
         addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
         this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onListItemPress);
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         this.List_mc.addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onListCreate);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.PlayerInfo_tf,"shrink");
         this.ScreenShotLoader = new Loader();
         this.ScreenShotLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onScreenshotLoadComplete);
         addChild(this.ScreenShotLoader);
         this.screenShotVisible = true;
         this.__setProp_List_mc_SaveLoadPanel_List_0();
      }
      
      public function get isSaving() : Boolean
      {
         return this.bSaving;
      }
      
      public function set isSaving(param1:Boolean) : *
      {
         this.bSaving = param1;
         this.ScreenshotSizer_mc.visible = !this.bSaving || this.List_mc.selectedIndex > 0;
      }
      
      public function get selectedIndex() : int
      {
         return this.List_mc.selectedIndex;
      }
      
      public function get platform() : uint
      {
         return this.uiPlatform;
      }
      
      public function set platform(param1:uint) : *
      {
         this.uiPlatform = param1;
      }
      
      public function get batchSize() : uint
      {
         return this.uiBatchSize;
      }
      
      public function get numSaves() : uint
      {
         return this.List_mc.entryList.length;
      }
      
      public function get codeObj() : Object
      {
         return this.BGSCodeObj;
      }
      
      public function set codeObj(param1:Object) : *
      {
         this.BGSCodeObj = param1;
      }
      
      public function set confirming(param1:Boolean) : *
      {
         this.Confirming = param1;
      }
      
      public function SetScreenshotDelayTimer(param1:uint) : *
      {
         this.ScreenshotDelayTimer.delay = param1;
      }
      
      public function ConfigureScreenshotDelayTimer(param1:uint, param2:uint) : *
      {
         this.ScreenshotDelayTimerSlow = param1;
         this.ScreenshotDelayTimerFast = param2;
      }
      
      public function set screenShotVisible(param1:*) : *
      {
         this.bShowScreenshot = param1;
         this.ScreenshotSizer_mc.visible = param1;
         this.SaveTime_tf.visible = param1;
         this.LocationText_tf.visible = param1;
      }
      
      public function set continueMode(param1:Boolean) : *
      {
         this.LevelText_tf.visible = param1;
         this.LevelMeter_mc.visible = param1;
         if(Boolean(param1) && this.List_mc.selectedEntry != null)
         {
            GlobalFunc.SetText(this.LevelText_tf,"$$LEVEL " + this.List_mc.selectedEntry.level,false);
            this.LevelMeter_mc.SetMeter(this.List_mc.selectedEntry.progress,-1,1);
         }
         this.List_mc.visible = !param1;
         this.SaveTime_tf.visible = param1;
         this.LocationText_tf.visible = param1;
      }
      
      protected function onStageInit(param1:Event) : *
      {
         stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
      }
      
      protected function onStageDestruct(param1:Event) : *
      {
         stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
      }
      
      protected function onSetPlatform(param1:Event) : *
      {
         this.platform = (param1 as PlatformChangeEvent).uiPlatform;
      }
      
      public function onListCreate(param1:Event) : *
      {
         this.uiBatchSize = this.List_mc.numListItems;
      }
      
      public function onListItemPress(param1:Event) : *
      {
         if(!this.bSaving)
         {
            if(this.ScreenshotDelayTimer.running)
            {
               this.ScreenshotDelayTimer.reset();
               this.HideScreenshot();
               this.PrepScreenshot();
            }
            this.codeObj.requestLoadGame(this,this.List_mc.selectedIndex);
         }
         else
         {
            dispatchEvent(new Event(SAVE_SELECTED,true,true));
         }
      }
      
      public function onOKToLoadConfirm() : *
      {
         dispatchEvent(new Event(LOAD_GAME_SELECTED,true,true));
      }
      
      public function onListSelectionChange(param1:Event) : *
      {
         this.ScreenshotSizer_mc.visible = !this.bSaving || this.List_mc.selectedIndex > 0;
         this.DoListSelectionChange();
      }
      
      public function DoListSelectionChange() : *
      {
         var _loc1_:* = undefined;
         this.HideScreenshot();
         this.ScreenshotDelayTimer.reset();
         GlobalFunc.SetText(this.PlayerInfo_tf," ",false);
         GlobalFunc.SetText(this.LevelText_tf," ",false);
         this.LevelMeter_mc.visible = false;
         if(this.List_mc.selectedIndex != -1)
         {
            _loc1_ = !!this.List_mc.selectedEntry.loaded?this.ScreenshotDelayTimerFast:this.ScreenshotDelayTimerSlow;
            this.SetScreenshotDelayTimer(_loc1_);
            this.ScreenshotDelayTimer.start();
         }
         dispatchEvent(new Event(SAVE_HIGHLIGHTED,true,true));
      }
      
      private function HideScreenshot() : *
      {
         this.ScreenShotLoader.close();
         this.ScreenShotLoader.visible = false;
         this.ScreenShotLoader.mask = null;
         var _loc1_:* = this.ScreenShotLoader.content as Bitmap;
         if(_loc1_)
         {
            _loc1_.bitmapData.dispose();
         }
         this.ScreenShotLoader.unloadAndStop();
      }
      
      private function PrepScreenshot() : *
      {
         this.ScreenshotDelayTimer.reset();
         if(this.bSaving)
         {
            this.codeObj.PrepSaveGameScreenshot(int(this.List_mc.selectedIndex - 1),this.List_mc.selectedEntry);
         }
         else
         {
            this.codeObj.PrepSaveGameScreenshot(int(this.List_mc.selectedIndex),this.List_mc.selectedEntry);
         }
      }
      
      public function ShowScreenshot() : *
      {
         var _loc1_:* = null;
         var _loc2_:Number = NaN;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.ScreenShotLoader.load(SCREENSHOT_URL);
         if(this.List_mc.selectedEntry.corrupt == true)
         {
            GlobalFunc.SetText(this.PlayerInfo_tf,"$SAVE CORRUPT",false);
         }
         else if(this.List_mc.selectedEntry.obsolete == true)
         {
            GlobalFunc.SetText(this.PlayerInfo_tf,"$SAVE OBSOLETE",false);
         }
         else if(this.List_mc.selectedEntry.name != undefined)
         {
            _loc1_ = this.List_mc.selectedEntry.name;
            _loc2_ = 20;
            if(_loc1_.length > _loc2_)
            {
               _loc1_ = _loc1_.substr(0,_loc2_ - 3) + "...";
            }
            GlobalFunc.SetText(this.PlayerInfo_tf,_loc1_,false);
            GlobalFunc.SetText(this.LocationText_tf,this.List_mc.selectedEntry.text,false);
            _loc3_ = this.List_mc.selectedEntry.playTime.split(".");
            if(_loc3_.length == 6)
            {
               _loc4_ = _loc3_[3];
               _loc5_ = "";
               if(_loc4_.charAt(0) != "0")
               {
                  _loc5_ = _loc5_ + (_loc3_[3] + " ");
               }
               _loc5_ = _loc5_ + (_loc3_[4] + " " + _loc3_[5]);
               GlobalFunc.SetText(this.SaveTime_tf,_loc5_,false);
            }
            else
            {
               GlobalFunc.SetText(this.SaveTime_tf,"-d -h -m",false);
            }
         }
         else
         {
            GlobalFunc.SetText(this.PlayerInfo_tf," ",false);
         }
         this.List_mc.UpdateSelectedEntry();
      }
      
      private function onScreenshotLoadComplete(param1:Event) : *
      {
         var _loc2_:Number = this.ScreenShotLoader.width;
         var _loc3_:Number = this.ScreenShotLoader.height;
         this.ScreenShotLoader.x = this.ScreenshotSizer_mc.x;
         this.ScreenShotLoader.width = this.ScreenshotSizer_mc.width;
         this.ScreenShotLoader.height = this.ScreenShotLoader.width * _loc3_ / _loc2_;
         this.ScreenShotLoader.y = this.ScreenshotSizer_mc.y - (this.ScreenShotLoader.height - this.ScreenshotSizer_mc.height) / 2;
         this.ScreenShotLoader.mask = this.ScreenshotSizer_mc;
         this.ScreenShotLoader.visible = this.bShowScreenshot;
      }
      
      public function onSaveLoadBatchComplete(param1:Boolean) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         for(_loc2_ in this.List_mc.entryList)
         {
            if(this.List_mc.entryList[_loc2_].text != undefined && this.List_mc.entryList[_loc2_].text.length > SaveLoadListEntry.MaxLocationNameLength)
            {
               this.List_mc.entryList[_loc2_].text = this.List_mc.entryList[_loc2_].text.substr(0,SaveLoadListEntry.MaxLocationNameLength - 3) + "...";
            }
         }
         if(param1)
         {
            _loc3_ = "$[NEW SAVE]";
            if(Boolean(this.bSaving) && (this.List_mc.entryList.length == 0 || this.List_mc.entryList[0].text != _loc3_))
            {
               _loc4_ = {
                  "name":" ",
                  "text":_loc3_
               };
               this.List_mc.entryList.unshift(_loc4_);
            }
            else if(!this.bSaving && this.List_mc.entryList.length > 0 && this.List_mc.entryList[0].text == _loc3_)
            {
               this.List_mc.entryList.shift();
            }
         }
         this.List_mc.InvalidateData();
         if(!this.Confirming)
         {
            this.List_mc.disableSelection = false;
         }
         if(Boolean(param1) || this.List_mc.selectedIndex == -1)
         {
            if(this.List_mc.selectedIndex == 0)
            {
               this.DoListSelectionChange();
            }
            else
            {
               this.List_mc.selectedIndex = 0;
            }
            dispatchEvent(new Event(SAVE_LIST_POPULATED,true,true));
         }
      }
      
      public function DeleteSelectedSave() : *
      {
         var _loc1_:Boolean = false;
         if(!this.bSaving || this.List_mc.selectedIndex != 0)
         {
            if(this.bSaving)
            {
               this.codeObj.DeleteSave(int(this.List_mc.selectedIndex - 1));
            }
            else
            {
               this.codeObj.DeleteSave(this.List_mc.selectedIndex);
            }
            _loc1_ = this.List_mc.disableSelection;
            this.List_mc.disableSelection = false;
            this.List_mc.entryList.splice(this.List_mc.selectedIndex,1);
            this.List_mc.InvalidateData();
            this.List_mc.disableSelection = _loc1_;
            this.DoListSelectionChange();
         }
      }
      
      function __setProp_List_mc_SaveLoadPanel_List_0() : *
      {
         try
         {
            this.List_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.List_mc.disableSelection = false;
         this.List_mc.listEntryClass = "SaveLoadListEntry";
         this.List_mc.numListItems = 3;
         this.List_mc.restoreListIndex = true;
         this.List_mc.textOption = "Shrink To Fit";
         this.List_mc.verticalSpacing = 0;
         try
         {
            this.List_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
