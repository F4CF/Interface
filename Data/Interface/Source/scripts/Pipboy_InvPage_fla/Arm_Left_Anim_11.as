package Pipboy_InvPage_fla
{
   import flash.display.MovieClip;
   
   public dynamic class Arm_Left_Anim_11 extends MovieClip
   {
       
      public function Arm_Left_Anim_11()
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
