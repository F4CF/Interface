package Pipboy_InvPage_fla
{
   import flash.display.MovieClip;
   
   public dynamic class Helmet_Anim_19 extends MovieClip
   {
       
      public function Helmet_Anim_19()
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
