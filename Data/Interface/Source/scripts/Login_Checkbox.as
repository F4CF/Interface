package
{
   import Shared.AS3.BSUIComponent;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class Login_Checkbox extends BSUIComponent
   {
      
      public static const ON_CHECK:String = "Login_Checkbox::checked";
       
      public var textField:TextField;
      
      public var FocusRect_mc:MovieClip;
      
      private var _Checked:Boolean;
      
      public function Login_Checkbox()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         this._Checked = false;
         this.FocusRect_mc.visible = false;
         addEventListener(MouseEvent.CLICK,this.onCheckboxClick);
         this.textField.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(FocusEvent.FOCUS_IN,this.onFocusChanged);
         stage.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusChanged);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         stage.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusChanged);
         stage.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusChanged);
      }
      
      public function set text(param1:String) : *
      {
         GlobalFunc.SetText(this.textField,param1,false);
      }
      
      public function get checked() : Boolean
      {
         return this._Checked;
      }
      
      public function set checked(param1:Boolean) : *
      {
         this._Checked = param1;
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         gotoAndStop(!!this._Checked?"checked":"unchecked");
         this.FocusRect_mc.visible = stage.focus == this;
      }
      
      private function onCheckboxClick() : *
      {
         this._Checked = !this._Checked;
         dispatchEvent(new Event(ON_CHECK,true,true));
         SetIsDirty();
      }
      
      private function onFocusChanged() : *
      {
         SetIsDirty();
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
