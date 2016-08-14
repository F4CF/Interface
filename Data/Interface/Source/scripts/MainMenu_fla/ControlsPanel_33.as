package MainMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class ControlsPanel_33 extends MovieClip
   {
       
      public var Fader_mc:MovieClip;
      
      public function ControlsPanel_33()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5);
      }
      
      function frame1() : *
      {
         visible = false;
         stop();
      }
      
      function frame3() : *
      {
         visible = true;
         stop();
      }
      
      function frame5() : *
      {
         visible = false;
         stop();
      }
   }
}
