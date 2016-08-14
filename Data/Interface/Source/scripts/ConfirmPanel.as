package
{
   import flash.display.MovieClip;
   
   public class ConfirmPanel extends MovieClip
   {
       
      public var Text_mc:MovieClip;
      
      private var strReturnType:String;
      
      private var strCurrentState:String;
      
      public function ConfirmPanel()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5);
      }
      
      public function get returnType() : String
      {
         return this.strReturnType;
      }
      
      public function set returnType(param1:String) : *
      {
         this.strReturnType = param1;
      }
      
      public function get confirmState() : String
      {
         return this.strCurrentState;
      }
      
      public function set confirmState(param1:String) : *
      {
         this.strCurrentState = param1;
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
