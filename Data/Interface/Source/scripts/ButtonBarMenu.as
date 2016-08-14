package
{
   import Shared.IMenu;
   import flash.display.MovieClip;
   import Shared.GlobalFunc;
   
   public dynamic class ButtonBarMenu extends IMenu
   {
       
      public var PromptMenuPanel_mc:MovieClip;
      
      public var ButtonBarHolder_mc:MovieClip;
      
      public function ButtonBarMenu()
      {
         super();
         this.ButtonBarHolder_mc.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.ButtonBarHolder_mc,"BC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.PromptMenuPanel_mc,"TL",SafeX,SafeY);
      }
   }
}
