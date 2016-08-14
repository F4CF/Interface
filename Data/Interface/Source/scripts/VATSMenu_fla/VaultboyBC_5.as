package VATSMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class VaultboyBC_5 extends MovieClip
   {
       
      public function VaultboyBC_5()
      {
         super();
         addFrameScript(8,this.frame9,100,this.frame101);
      }
      
      function frame9() : *
      {
         stop();
      }
      
      function frame101() : *
      {
         this.visible = false;
         this["OnCritAnimationComplete"]();
         stop();
      }
   }
}
