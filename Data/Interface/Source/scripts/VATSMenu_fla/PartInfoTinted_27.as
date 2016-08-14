package VATSMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class PartInfoTinted_27 extends MovieClip
   {
       
      public var AnimationInstance:MovieClip;
      
      public function PartInfoTinted_27()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame30() : *
      {
         gotoAndPlay("flashing");
      }
   }
}
