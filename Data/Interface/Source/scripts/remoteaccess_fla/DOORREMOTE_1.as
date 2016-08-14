package remoteaccess_fla
{
   import flash.display.MovieClip;
   import Shared.BGSExternalInterface;
   
   public dynamic class DOORREMOTE_1 extends MovieClip
   {
       
      public function DOORREMOTE_1()
      {
         super();
         addFrameScript(164,this.frame165);
      }
      
      function frame165() : *
      {
         BGSExternalInterface.call(MovieClip(root).BGSCodeObj,"HideMenu");
      }
   }
}
