package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import Shared.GlobalFunc;
   import flash.text.TextLineMetrics;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.MouseEvent;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class Option_OptionStepper extends MovieClip
   {
      
      public static const VALUE_CHANGE:String = "Option_OptionStepper::VALUE_CHANGE";
       
      public var textField:TextField;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      public var LeftCatcher_mc:MovieClip;
      
      public var RightCatcher_mc:MovieClip;
      
      private var OptionArray:Array;
      
      private var uiSelectedIndex:uint;
      
      public function Option_OptionStepper()
      {
         super();
         this.uiSelectedIndex = 0;
         addEventListener(MouseEvent.CLICK,this.onClick);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.textField,"shrink");
      }
      
      public function get options() : Array
      {
         return this.OptionArray;
      }
      
      public function set options(param1:Array) : *
      {
         this.OptionArray = param1;
         this.RefreshText();
      }
      
      public function get index() : uint
      {
         return this.uiSelectedIndex;
      }
      
      public function set index(param1:uint) : *
      {
         if(this.OptionArray != null)
         {
            this.uiSelectedIndex = Math.min(param1,this.OptionArray.length - 1);
         }
         else
         {
            this.uiSelectedIndex = 0;
         }
         this.RefreshText();
      }
      
      private function RefreshText() : *
      {
         GlobalFunc.SetText(this.textField,this.OptionArray[this.uiSelectedIndex],false);
         var _loc1_:TextLineMetrics = this.textField.getLineMetrics(0);
         this.LeftArrow_mc.x = this.textField.x + _loc1_.x;
         this.RightArrow_mc.x = this.textField.x + _loc1_.x + _loc1_.width + 6;
      }
      
      private function Decrement() : *
      {
         this.index = this.index - 1;
         dispatchEvent(new Event(VALUE_CHANGE,true,true));
      }
      
      private function Increment() : *
      {
         this.index = this.index + 1;
         dispatchEvent(new Event(VALUE_CHANGE,true,true));
      }
      
      public function onItemPressed() : *
      {
         this.index = (this.index + 1) % this.OptionArray.length;
         dispatchEvent(new Event(VALUE_CHANGE,true,true));
      }
      
      public function HandleKeyboardInput(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.LEFT && this.index > 0)
         {
            this.Decrement();
         }
         else if(param1.keyCode == Keyboard.RIGHT && this.index < this.OptionArray.length - 1)
         {
            this.Increment();
         }
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         if(param1.target == this.LeftCatcher_mc && this.index > 0)
         {
            this.Decrement();
            param1.stopPropagation();
         }
         else if(param1.target == this.RightCatcher_mc && this.index < this.OptionArray.length - 1)
         {
            this.Increment();
            param1.stopPropagation();
         }
      }
   }
}
