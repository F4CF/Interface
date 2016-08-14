package MainMenu_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class OptionsListPanel_36 extends MovieClip
   {
       
      public var Fader_mc:MovieClip;
      
      public var GuideText_tf:TextField;
      
      public function OptionsListPanel_36()
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
