package
{
   import Shared.AS3.BSScrollingList;
   import flash.display.MovieClip;
   import flash.events.Event;
   import Shared.AS3.BSScrollingListEntry;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class OptionsList extends BSScrollingList
   {
       
      private var bAllowValueOverwrite:Boolean;
      
      public function OptionsList()
      {
         super();
         this.bAllowValueOverwrite = false;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(SettingsOptionItem.VALUE_CHANGE,this.onValueChange);
      }
      
      public function get allowValueOverwrite() : Boolean
      {
         return this.bAllowValueOverwrite;
      }
      
      public function set allowValueOverwrite(param1:Boolean) : *
      {
         this.bAllowValueOverwrite = param1;
      }
      
      override protected function GetEntryHeight(param1:Number) : Number
      {
         var _loc2_:MovieClip = GetClipByIndex(0);
         return _loc2_.height;
      }
      
      public function onValueChange(param1:Event) : *
      {
         EntriesA[param1.target.itemIndex].value = param1.target.value;
      }
      
      override protected function SetEntry(param1:BSScrollingListEntry, param2:Object) : *
      {
         var _loc3_:SettingsOptionItem = null;
         if(param1 != null)
         {
            _loc3_ = param1 as SettingsOptionItem;
            if(Boolean(this.allowValueOverwrite) || _loc3_.ID != param2.ID)
            {
               _loc3_.movieType = param2.movieType;
               if(param2.options != undefined)
               {
                  _loc3_.SetOptionStepperOptions(param2.options);
               }
               _loc3_.ID = param2.ID;
               _loc3_.value = param2.value;
               _loc3_.hudColorUpdate = param2.hudColorUpdate;
               _loc3_.pipboyColorUpdate = param2.pipboyColorUpdate;
               _loc3_.difficultyUpdate = param2.difficultyUpdate;
            }
            super.SetEntry(param1,param2);
         }
      }
      
      public function onListItemPressed() : *
      {
         var _loc1_:BSScrollingListEntry = null;
         if(!bDisableInput)
         {
            if(this.selectedEntry != null)
            {
               _loc1_ = GetClipByIndex(this.selectedEntry.clipIndex);
               if(_loc1_ != null)
               {
                  (_loc1_ as SettingsOptionItem).onItemPressed();
               }
            }
         }
      }
      
      override public function onKeyDown(param1:KeyboardEvent) : *
      {
         var _loc2_:BSScrollingListEntry = null;
         if(!bDisableInput)
         {
            super.onKeyDown(param1);
            if(this.selectedEntry != null && (param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT))
            {
               _loc2_ = GetClipByIndex(this.selectedEntry.clipIndex);
               if(_loc2_ != null)
               {
                  (_loc2_ as SettingsOptionItem).HandleKeyboardInput(param1);
                  param1.stopPropagation();
               }
            }
         }
      }
   }
}
