package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import Shared.GlobalFunc;
   import Shared.PlatformChangeEvent;
   
   public class LooksMenuOptionStepper extends MovieClip
   {
      
      public static const TRIGGERS = 0;
      
      public static const BUMPERS = 1;
       
      public var Label_tf:TextField;
      
      public var Index_tf:TextField;
      
      public var Brackets_mc:MovieClip;
      
      public var LeftIcon_tf:TextField;
      
      public var RightIcon_tf:TextField;
      
      private var CurrentIndex:uint;
      
      private var CurrentLabel:String = "";
      
      private var GetDispInfoFunc:Function = null;
      
      private var MaxIndex:uint;
      
      private var Platform:uint;
      
      private var Buttons:uint = 0;
      
      public function LooksMenuOptionStepper()
      {
         super();
      }
      
      private function UpdateButtonHelp() : *
      {
         GlobalFunc.SetText(this.LeftIcon_tf,this.Buttons == TRIGGERS?this.Platform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD || Boolean(PlatformChangeEvent.PLATFORM_XB1)?"Y":"y":this.Platform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD || Boolean(PlatformChangeEvent.PLATFORM_XB1)?"G":"g",false);
         GlobalFunc.SetText(this.RightIcon_tf,this.Buttons == TRIGGERS?this.Platform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD || Boolean(PlatformChangeEvent.PLATFORM_XB1)?"X":"x":this.Platform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD || Boolean(PlatformChangeEvent.PLATFORM_XB1)?"L":"m",false);
      }
      
      public function set buttons(param1:uint) : *
      {
         this.Buttons = param1;
         this.UpdateButtonHelp();
      }
      
      public function set getDispInfoFunc(param1:Function) : *
      {
         this.GetDispInfoFunc = param1;
      }
      
      public function set max(param1:uint) : *
      {
         this.MaxIndex = param1;
      }
      
      public function set platform(param1:uint) : *
      {
         this.Platform = param1;
         this.UpdateButtonHelp();
      }
      
      public function set value(param1:uint) : *
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this.CurrentIndex = param1;
         var _loc2_:Object = new Object();
         if(this.GetDispInfoFunc == null)
         {
            _loc2_.DisplayIndex = param1;
            _loc2_.DisplayLabel = "";
         }
         else
         {
            this.GetDispInfoFunc(_loc2_,param1);
         }
         this.LeftIcon_tf.alpha = this.CurrentIndex > 0?Number(1):Number(GlobalFunc.DIMMED_ALPHA);
         this.RightIcon_tf.alpha = this.CurrentIndex < this.MaxIndex - 1?Number(1):Number(GlobalFunc.DIMMED_ALPHA);
         if(_loc2_.DisplayIndex < uint.MAX_VALUE)
         {
            _loc3_ = _loc2_.DisplayIndex < 10?"0":"";
            _loc3_ = _loc3_ + _loc2_.DisplayIndex.toString();
            GlobalFunc.SetText(this.Index_tf,_loc3_,false);
            this.Index_tf.alpha = 1;
         }
         else
         {
            this.Index_tf.alpha = 0;
         }
         if(_loc2_.DisplayLabel != this.CurrentLabel)
         {
            this.CurrentLabel = _loc2_.DisplayLabel;
            GlobalFunc.SetText(this.Label_tf,_loc2_.DisplayLabel,false);
            _loc4_ = this.Index_tf.textWidth;
            _loc5_ = this.Label_tf.textWidth + (this.Index_tf.alpha == 0?0:_loc4_ * 1.5);
            this.Label_tf.x = (this.Index_tf.alpha == 0?-this.Label_tf.textWidth:-_loc5_) / 2;
            this.Index_tf.x = _loc5_ / 2 - _loc4_;
            this.LeftIcon_tf.x = this.Label_tf.x - _loc4_ / 2 - this.LeftIcon_tf.textWidth;
            this.RightIcon_tf.x = _loc5_ / 2;
            _loc6_ = _loc5_ + _loc4_;
            this.Brackets_mc.Top_mc.width = this.Brackets_mc.Bottom_mc.width = _loc6_;
            this.Brackets_mc.x = -_loc6_ / 2;
            this.Brackets_mc.Right_mc.x = _loc6_;
            this.CurrentLabel = _loc2_.DisplayLabel;
         }
      }
   }
}
