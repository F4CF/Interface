package Pipboy_InvPage_fla
{
   import flash.display.MovieClip;
   
   public dynamic class Leg_Right_Anim_13 extends MovieClip
   {
       
      public function Leg_Right_Anim_13()
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
