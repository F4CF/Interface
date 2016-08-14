package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import Shared.GlobalFunc;
   import flash.events.KeyboardEvent;
   import flash.events.Event;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class SettingsOptionItem extends BSScrollingListEntry
   {
      
      public static const VALUE_CHANGE:String = "SettingsOptionItem::value_change";
       
      private var OptionItem:MovieClip;
      
      private var uiMovieType:uint;
      
      private var uiID:uint;
      
      private var bHUDColorUpdate:Boolean;
      
      private var bPipboyColorUpdate:Boolean;
      
      private var bDifficultyUpdate:Boolean;
      
      public function SettingsOptionItem()
      {
         super();
         this.uiID = uint.MAX_VALUE;
         this.bHUDColorUpdate = false;
         this.bPipboyColorUpdate = false;
         addEventListener(Option_Checkbox.VALUE_CHANGE,this.onValueChange);
         addEventListener(Option_OptionStepper.VALUE_CHANGE,this.onValueChange);
         addEventListener(Option_Scrollbar.VALUE_CHANGE,this.onValueChange);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(textField,"shrink");
      }
      
      public function get movieType() : uint
      {
         return this.uiMovieType;
      }
      
      public function set movieType(param1:uint) : *
      {
         this.uiMovieType = param1;
         if(this.OptionItem != null)
         {
            removeChild(this.OptionItem);
            this.OptionItem = null;
         }
         switch(this.uiMovieType)
         {
            case 0:
               this.OptionItem = new Option_Scrollbar();
               break;
            case 1:
               this.OptionItem = new Option_OptionStepper();
               break;
            case 2:
               this.OptionItem = new Option_Checkbox();
         }
         addChild(this.OptionItem);
         this.OptionItem.x = 210;
         this.OptionItem.y = -1;
      }
      
      public function get ID() : uint
      {
         return this.uiID;
      }
      
      public function set ID(param1:uint) : *
      {
         this.uiID = param1;
      }
      
      public function get hudColorUpdate() : Boolean
      {
         return this.bHUDColorUpdate;
      }
      
      public function set hudColorUpdate(param1:Boolean) : *
      {
         this.bHUDColorUpdate = param1;
      }
      
      public function get pipboyColorUpdate() : Boolean
      {
         return this.bPipboyColorUpdate;
      }
      
      public function set pipboyColorUpdate(param1:Boolean) : *
      {
         this.bPipboyColorUpdate = param1;
      }
      
      public function get difficultyUpdate() : Boolean
      {
         return this.bDifficultyUpdate;
      }
      
      public function set difficultyUpdate(param1:Boolean) : void
      {
         this.bDifficultyUpdate = param1;
      }
      
      public function get value() : Number
      {
         var _loc1_:Number = NaN;
         switch(this.uiMovieType)
         {
            case 0:
               _loc1_ = (this.OptionItem as Option_Scrollbar).value;
               break;
            case 1:
               _loc1_ = (this.OptionItem as Option_OptionStepper).index;
               break;
            case 2:
               _loc1_ = !!(this.OptionItem as Option_Checkbox).checked?Number(1):Number(0);
         }
         return _loc1_;
      }
      
      public function set value(param1:Number) : *
      {
         switch(this.uiMovieType)
         {
            case 0:
               (this.OptionItem as Option_Scrollbar).value = param1;
               break;
            case 1:
               (this.OptionItem as Option_OptionStepper).index = param1;
               break;
            case 2:
               (this.OptionItem as Option_Checkbox).checked = param1 == 1?true:false;
         }
      }
      
      public function SetOptionStepperOptions(param1:Array) : *
      {
         if(this.uiMovieType == 1)
         {
            (this.OptionItem as Option_OptionStepper).options = param1;
         }
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc3_:ColorTransform = null;
         super.SetEntryText(param1,param2);
         if(this.border != null)
         {
            this.border.alpha = !!this.selected?Number(GlobalFunc.SELECTED_RECT_ALPHA):Number(0);
         }
         if(this.textField != null)
         {
            this.textField.textColor = !!this.selected?uint(0):uint(16777215);
         }
         if(this.OptionItem != null)
         {
            _loc3_ = this.OptionItem.transform.colorTransform;
            _loc3_.redOffset = !!this.selected?Number(-255):Number(0);
            _loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
            _loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
            this.OptionItem.transform.colorTransform = _loc3_;
         }
      }
      
      public function onItemPressed() : *
      {
         if(this.OptionItem != null)
         {
            switch(this.uiMovieType)
            {
               case 1:
                  (this.OptionItem as Option_OptionStepper).onItemPressed();
                  break;
               case 2:
                  (this.OptionItem as Option_Checkbox).onItemPressed();
            }
         }
      }
      
      public function HandleKeyboardInput(param1:KeyboardEvent) : *
      {
         if(this.OptionItem != null)
         {
            switch(this.uiMovieType)
            {
               case 0:
                  (this.OptionItem as Option_Scrollbar).HandleKeyboardInput(param1);
                  break;
               case 1:
                  (this.OptionItem as Option_OptionStepper).HandleKeyboardInput(param1);
                  break;
               case 2:
                  (this.OptionItem as Option_Checkbox).HandleKeyboardInput(param1);
            }
         }
      }
      
      private function onValueChange(param1:Event) : *
      {
         dispatchEvent(new Event(VALUE_CHANGE,true,true));
      }
   }
}
