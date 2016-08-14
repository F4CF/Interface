package Pipboy_InvPage_fla
{
   import flash.display.MovieClip;
   
   public dynamic class Goggles_Anim_17 extends MovieClip
   {
       
      public function Goggles_Anim_17()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame25() : *
      {
         gotoAndPlay("Animate");
      }
   }
}
