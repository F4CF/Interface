package ContainerMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class FilterHolder_1 extends MovieClip
   {
       
      public var Menu_mc:ContainerMenu;
      
      public function FilterHolder_1()
      {
         super();
         addFrameScript(9,this.frame10);
      }
      
      function frame10() : *
      {
         this.Menu_mc.onIntroAnimComplete();
         stop();
      }
   }
}
