package
{
   import Shared.IMenu;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import Shared.GlobalFunc;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public class LoadingMenu extends IMenu
   {
       
      public var LeftText_mc:MovieClip;
      
      public var VaultTecLogo_mc:MovieClip;
      
      public var BlackRect_mc:MovieClip;
      
      public var BGSCodeObj:Object;
      
      private const SLIDE_TEXT_Y_POSITION:int = 651;
      
      private const SLIDE_NUMBER_SPACER:int = 29;
      
      private const LEVEL_METER_SPACER:int = 44;
      
      private const LEVEL_TEXT_SPACER:int = 27;
      
      private var BORDER_BUFFER:Rectangle;
      
      private var BorderRectangle:MovieClip;
      
      private const RefreshSeconds:Number = 20;
      
      private var InMinimalMode:Boolean;
      
      public function LoadingMenu()
      {
         this.BORDER_BUFFER = new Rectangle(8,3,5,10);
         super();
         this.BGSCodeObj = new Object();
         this.InMinimalMode = true;
         GlobalFunc.SetText(this.LeftText_mc.VDSGText_tf," ",false);
         GlobalFunc.SetText(this.LeftText_mc.LoadScreenText_tf," ",false);
         var _loc1_:Timer = new Timer(this.RefreshSeconds * 1000);
         _loc1_.addEventListener(TimerEvent.TIMER,this.refreshLoadingText);
         _loc1_.start();
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.LeftText_mc,"L",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.VaultTecLogo_mc,"BR",SafeX,SafeY);
      }
      
      public function SetLoadingText(param1:uint, param2:String, param3:String) : *
      {
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         this.InMinimalMode = false;
         this.BlackRect_mc.visible = false;
         this.LeftText_mc.VDSGText_tf.visible = true;
         this.LeftText_mc.LoadScreenText_tf.visible = true;
         var _loc4_:int = this.LeftText_mc.LoadScreenText_tf.numLines;
         GlobalFunc.SetText(this.LeftText_mc.VDSGText_tf,"$VDSGPrepend",false);
         GlobalFunc.SetText(this.LeftText_mc.VDSGText_tf,this.LeftText_mc.VDSGText_tf.text + param1.toString(),false);
         GlobalFunc.SetText(this.LeftText_mc.LoadScreenText_tf,param3,false);
         var _loc5_:int = this.LeftText_mc.LoadScreenText_tf.length - 1;
         if(_loc5_ >= 0)
         {
            _loc6_ = this.LeftText_mc.LoadScreenText_tf.getCharBoundaries(_loc5_);
            _loc7_ = this.LeftText_mc.LoadScreenText_tf.numLines;
            this.LeftText_mc.LoadScreenText_tf.y = this.LeftText_mc.LoadScreenText_tf.y - (_loc7_ - _loc4_) * _loc6_.height;
            this.LeftText_mc.VDSGText_tf.y = this.LeftText_mc.LoadScreenText_tf.y - this.SLIDE_NUMBER_SPACER;
            this.LeftText_mc.LevelMeter_mc.y = this.LeftText_mc.VDSGText_tf.y - this.LEVEL_METER_SPACER;
            this.LeftText_mc.LevelText_tf.y = this.LeftText_mc.LevelMeter_mc.y - this.LEVEL_TEXT_SPACER;
            if(this.BorderRectangle != null)
            {
               this.LeftText_mc.removeChild(this.BorderRectangle);
               this.BorderRectangle = null;
            }
            this.BorderRectangle = new MovieClip();
            this.BorderRectangle.graphics.lineStyle(2,16777215);
            this.BorderRectangle.graphics.beginFill(0,0);
            this.BorderRectangle.graphics.drawRect(0,0,this.LeftText_mc.LoadScreenText_tf.width + this.BORDER_BUFFER.x + this.BORDER_BUFFER.width,_loc6_.y + _loc6_.height + this.BORDER_BUFFER.y + this.BORDER_BUFFER.height);
            this.BorderRectangle.graphics.endFill();
            this.BorderRectangle.x = this.LeftText_mc.LoadScreenText_tf.x - this.BORDER_BUFFER.x;
            this.BorderRectangle.y = this.LeftText_mc.LoadScreenText_tf.y - this.BORDER_BUFFER.y;
            this.LeftText_mc.addChild(this.BorderRectangle);
         }
      }
      
      public function SetLevel(param1:uint, param2:Number) : *
      {
         GlobalFunc.SetText(this.LeftText_mc.LevelText_tf,"$LEVEL",false);
         GlobalFunc.SetText(this.LeftText_mc.LevelText_tf,this.LeftText_mc.LevelText_tf.text + " " + param1.toString(),false);
         this.LeftText_mc.LevelMeter_mc.SetMeter(param2,-1,1);
         this.LeftText_mc.LevelMeter_mc.visible = !this.InMinimalMode && param1 > 0;
         this.LeftText_mc.LevelText_tf.visible = !this.InMinimalMode && param1 > 0;
      }
      
      public function SetMinimalMode() : *
      {
         this.LeftText_mc.VDSGText_tf.visible = false;
         this.LeftText_mc.LoadScreenText_tf.visible = false;
         this.LeftText_mc.LevelMeter_mc.visible = false;
         this.LeftText_mc.LevelText_tf.visible = false;
         if(this.BorderRectangle != null)
         {
            this.BorderRectangle.visible = false;
         }
         this.BlackRect_mc.visible = true;
         this.InMinimalMode = true;
      }
      
      public function SpinnerOnly() : *
      {
         this.SetMinimalMode();
         this.BlackRect_mc.visible = false;
      }
      
      private function refreshLoadingText() : *
      {
         this.BGSCodeObj.requestLoadingText();
      }
   }
}
