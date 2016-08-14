package
{
   import Shared.IMenu;
   import Shared.AS3.BSButtonHintBar;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import Shared.AS3.BSButtonHintData;
   import Shared.GlobalFunc;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class LockpickingMenu extends IMenu
   {
       
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var LockLevelText:TextField;
      
      public var NumLockpicksText:TextField;
      
      public var DebugDisplay_mc:MovieClip;
      
      private var ExitButton:BSButtonHintData;
      
      private var iDebugRectBaseWidth:Number;
      
      private var fPickMinAngle:Number;
      
      private var fPickMaxAngle:Number;
      
      public function LockpickingMenu()
      {
         this.ExitButton = new BSButtonHintData("$Exit","Esc","PSN_B","Xenon_B",1,this.onExitPressed);
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.LockLevelText,"shrink");
         this.PopulateButtonBar();
         this.iDebugRectBaseWidth = 1000;
         this.fPickMinAngle = 0;
         this.fPickMaxAngle = 0;
      }
      
      private function PopulateButtonBar() : void
      {
         var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
         _loc1_.push(this.ExitButton);
         this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
      }
      
      private function onExitPressed() : void
      {
      }
      
      public function InitLockpickingMenu() : *
      {
         this.DebugDisplay_mc.visible = false;
         this.ExitButton.ButtonVisible = false;
      }
      
      public function ToggleDebugMode() : void
      {
         this.DebugDisplay_mc.visible = !this.DebugDisplay_mc.visible;
      }
      
      public function UpdatePickAngle(param1:Number) : void
      {
         GlobalFunc.SetText(this.DebugDisplay_mc.PickAngleText,"PICK ANGLE: " + Math.floor(param1) + "°",false);
         this.DebugDisplay_mc.PickIndicator_mc.x = this.PickAngleToX(param1);
      }
      
      private function PickAngleToX(param1:Number) : Number
      {
         var _loc2_:Number = (param1 - this.fPickMinAngle) / (this.fPickMaxAngle - this.fPickMinAngle);
         return this.DebugDisplay_mc.SweetSpotRects_mc.x + this.iDebugRectBaseWidth * _loc2_;
      }
      
      public function UpdateLockAngle(param1:Number) : void
      {
         GlobalFunc.SetText(this.DebugDisplay_mc.LockAngleText,"LOCK ANGLE: " + Math.floor(param1) + "°",false);
      }
      
      public function UpdatePickHealth(param1:Number) : void
      {
         GlobalFunc.SetText(this.DebugDisplay_mc.PickHealthText,"PICK HEALTH: " + Math.floor(param1) + "%",false);
      }
      
      public function UpdateSweetSpot(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:MovieClip = this.DebugDisplay_mc.SweetSpotRects_mc;
         _loc4_.SweetSpotRect.x = this.PickAngleToX(param1 - param2 / 2);
         _loc4_.SweetSpotRect.width = this.PickAngleToX(param1 + param2 / 2) - _loc4_.SweetSpotRect.x;
         _loc4_.PartialPickRect.x = this.PickAngleToX(param1 - param2 / 2 - param3);
         _loc4_.PartialPickRect.width = this.PickAngleToX(param1 + param2 / 2 + param3) - _loc4_.PartialPickRect.x;
         GlobalFunc.SetText(this.DebugDisplay_mc.SweetSpotText,"SWEET SPOT WIDTH: " + param2.toFixed(1) + "°",false);
         GlobalFunc.SetText(this.DebugDisplay_mc.PartialPickText,"PARTIAL PICK WIDTH: " + param3.toFixed(1) + "°",false);
      }
      
      public function SetPickMinMax(param1:Number, param2:Number) : void
      {
         this.fPickMinAngle = param1;
         this.fPickMaxAngle = param2;
      }
      
      public function SetLockInfo() : void
      {
         GlobalFunc.SetText(this.LockLevelText,"$Lock",false);
         GlobalFunc.SetText(this.LockLevelText,(arguments[0] + " " + this.LockLevelText.text).toUpperCase(),false);
         trace(this.LockLevelText.text);
         GlobalFunc.SetText(this.NumLockpicksText,"$Lockpicks Left",false);
         if(arguments[1] < 100)
         {
            GlobalFunc.SetText(this.NumLockpicksText,arguments[1] + " " + this.NumLockpicksText.text,false);
         }
         else
         {
            GlobalFunc.SetText(this.NumLockpicksText,"99+ " + this.NumLockpicksText.text,false);
         }
         this.ExitButton.ButtonVisible = true;
      }
   }
}
