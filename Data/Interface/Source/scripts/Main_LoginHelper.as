package
{
   import flash.display.MovieClip;
   import Shared.AS3.BSButtonHintData;
   import Shared.PlatformChangeEvent;
   import Shared.GlobalFunc;
   import flash.display.BlendMode;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.display.InteractiveObject;
   import flash.ui.Keyboard;
   import flash.events.Event;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class Main_LoginHelper extends ISubmenu
   {
       
      public var LoginPage_mc:MovieClip;
      
      public var Spinner_mc:MovieClip;
      
      public var EULAPage_mc:MovieClip;
      
      public var NewAccountPage_mc:MovieClip;
      
      private var CoppaCheckbox:Login_Checkbox;
      
      private var NewsOptInCheckbox:Login_Checkbox;
      
      public var EULAPagesA:Array;
      
      private var _CurrEULAIndex:uint;
      
      private var Login_ToggleButton:BSButtonHintData;
      
      private var Login_AcceptButton:BSButtonHintData;
      
      private var Login_CancelButton:BSButtonHintData;
      
      private var Login_CreateNewButton:BSButtonHintData;
      
      private var Login_LoadOrderButton:BSButtonHintData;
      
      public function Main_LoginHelper()
      {
         this.Login_ToggleButton = new BSButtonHintData("$TOGGLE","","PSN_Y","Xenon_Y",1,null);
         this.Login_AcceptButton = new BSButtonHintData("$ACCEPT","Enter","PSN_A","Xenon_A",1,this.onLoginAccept);
         this.Login_CancelButton = new BSButtonHintData("$CANCEL","Esc","PSN_B","Xenon_B",1,this.onLoginCancel);
         this.Login_CreateNewButton = new BSButtonHintData("$Login_CreateNew","Insert","PSN_X","Xenon_X",1,this.onLogin_CreateNew);
         this.Login_LoadOrderButton = new BSButtonHintData("$Mod_MyLibrary","Home","PSN_Y","Xenon_Y",1,this.onLogin_LoadOrder);
         super();
         this.CoppaCheckbox = this.NewAccountPage_mc.CoppaCheckbox;
         this.NewsOptInCheckbox = this.NewAccountPage_mc.NewsOptInCheckbox;
         this.CoppaCheckbox.text = "$CoppaText";
         this.NewsOptInCheckbox.text = "$NewsOptInMessage";
         this.NewsOptInCheckbox.y = this.CoppaCheckbox.y + this.CoppaCheckbox.height + 0;
         var _loc1_:Vector.<BSButtonHintData> = this.buttonData;
         _loc1_.push(this.Login_ToggleButton);
         _loc1_.push(this.Login_AcceptButton);
         _loc1_.push(this.Login_CancelButton);
         _loc1_.push(this.Login_LoadOrderButton);
         this.Login_ToggleButton.ButtonVisible = false;
         this.Login_AcceptButton.ButtonVisible = false;
         this.Login_CancelButton.ButtonVisible = false;
         this.Login_CreateNewButton.ButtonVisible = false;
         this.Login_LoadOrderButton.ButtonVisible = false;
         this.EULAPagesA = new Array();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.LoginPage_mc.Error_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.LoginPage_mc.LoginHeader_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.LoginPage_mc.LoginFooter_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.NewAccountPage_mc.Error_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EULAPage_mc.Title_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Spinner_mc.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setVerticalAlign(this.Spinner_mc.textField,TextFieldEx.VALIGN_BOTTOM);
         this.LoginPage_mc.UsernameGrayText_tf.mouseEnabled = false;
         this.LoginPage_mc.UsernameInput_tf.addEventListener(MouseEvent.CLICK,this.onTextFieldShiftFocus);
         this.LoginPage_mc.PasswordGrayText_tf.mouseEnabled = false;
         this.LoginPage_mc.PasswordInput_tf.addEventListener(MouseEvent.CLICK,this.onTextFieldShiftFocus);
         this.EULAPage_mc.addEventListener(MouseEvent.MOUSE_WHEEL,this.onEULAMouseWheel);
         this.EULAPage_mc.EULA_tf.addEventListener(Event.SCROLL,this.UpdateEULAScrollIndicators);
         this.EULAPage_mc.ScrollUp.addEventListener(MouseEvent.CLICK,this.onEULAScrollUpClicked);
         this.EULAPage_mc.ScrollDown.addEventListener(MouseEvent.CLICK,this.onEULAScrollUpClicked);
         this.NewAccountPage_mc.UsernameGrayText_tf.mouseEnabled = false;
         this.NewAccountPage_mc.NewUsernameInput_tf.addEventListener(MouseEvent.CLICK,this.onTextFieldShiftFocus);
         this.NewAccountPage_mc.EmailGrayText_tf.mouseEnabled = false;
         this.NewAccountPage_mc.NewEmailInput_tf.addEventListener(MouseEvent.CLICK,this.onTextFieldShiftFocus);
         this.CoppaCheckbox.addEventListener(Login_Checkbox.ON_CHECK,this.onCoppaCheck);
         this.NewsOptInCheckbox.checked = true;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.buttonHintBar.SetButtonHintData(this.buttonData);
         if(!stage.hasEventListener("showLoginScreen"))
         {
            stage.addEventListener("showLoginScreen",this.onEventShowLogin,false,0,true);
         }
         if(this.iPlatform == PlatformChangeEvent.PLATFORM_PS4)
         {
            GlobalFunc.SetText(this.LoginPage_mc.LoginFooter_tf,"$LoginPage_Footer_PS4",false);
            this.Spinner_mc.Background_mc.blendMode = BlendMode.NORMAL;
            this.LoginPage_mc.Background_mc.blendMode = BlendMode.NORMAL;
            this.EULAPage_mc.Background_mc.blendMode = BlendMode.NORMAL;
         }
      }
      
      private function onEventShowLogin() : *
      {
         this.ShowLoginScreen("");
      }
      
      public function ShowLoginScreen(param1:String) : *
      {
         this.HideSpinner();
         this.LoginPage_mc.visible = true;
         this.LoginPage_mc.UsernameGrayText_tf.visible = this.LoginPage_mc.UsernameInput_tf.text.length <= 0;
         this.LoginPage_mc.PasswordGrayText_tf.visible = this.LoginPage_mc.PasswordInput_tf.text.length <= 0;
         this.LoginPage_mc.addEventListener(KeyboardEvent.KEY_UP,this.onLoginScreenKeyUp);
         if(this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD)
         {
            this.codeObj.startEditText();
         }
         this.LoginPage_mc.UsernameInput_tf.text = param1;
         this.LoginPage_mc.PasswordInput_tf.text = "";
         stage.focus = this.LoginPage_mc.UsernameInput_tf;
         this.LoginPage_mc.UsernameInput_tf.setSelection(0,this.LoginPage_mc.UsernameInput_tf.text.length);
         this.UpdateButtons();
      }
      
      public function ShowLoginScreen_AfterFailure(param1:String) : *
      {
         GlobalFunc.SetText(this.LoginPage_mc.Error_tf,"$LoginError_" + param1,false);
         if(this.LoginPage_mc.Error_tf.text.length > 0 && this.LoginPage_mc.Error_tf.text.charAt(0) == "$")
         {
            GlobalFunc.SetText(this.LoginPage_mc.Error_tf,"$LoginError_BNET_UNKNOWN_ERROR",false);
         }
         this.ShowLoginScreen(this.LoginPage_mc.UsernameInput_tf.text);
      }
      
      public function HideLoginScreen() : *
      {
         this.codeObj.endEditText();
         this.LoginPage_mc.visible = false;
         this.LoginPage_mc.removeEventListener(KeyboardEvent.KEY_UP,this.onLoginScreenKeyUp);
      }
      
      public function ShowSpinner(param1:String) : *
      {
         GlobalFunc.SetText(this.Spinner_mc.textField,param1,false);
         stage.focus = null;
         this.Spinner_mc.visible = true;
         this.UpdateButtons();
      }
      
      public function HideSpinner() : *
      {
         this.Spinner_mc.visible = false;
      }
      
      public function onEULAPopulated() : *
      {
         this.HideSpinner();
         this._CurrEULAIndex = 0;
         stage.focus = this.EULAPage_mc;
         this.EULAPage_mc.addEventListener(KeyboardEvent.KEY_DOWN,this.onEULAKeyDown);
         this.EULAPage_mc.addEventListener(KeyboardEvent.KEY_UP,this.onEULAKeyUp);
         this.LoadEULAPage();
         this.EULAPage_mc.visible = true;
         this.UpdateButtons();
      }
      
      private function LoadEULAPage() : *
      {
         GlobalFunc.SetText(this.EULAPage_mc.Title_tf,this.EULAPagesA[this._CurrEULAIndex].title,true);
         GlobalFunc.SetText(this.EULAPage_mc.EULA_tf,this.EULAPagesA[this._CurrEULAIndex].text,true);
         this.EULAPage_mc.EULA_tf.scrollV = 0;
      }
      
      public function HideEULAScreen() : *
      {
         this.EULAPage_mc.removeEventListener(KeyboardEvent.KEY_DOWN,this.onEULAKeyDown);
         this.EULAPage_mc.removeEventListener(KeyboardEvent.KEY_UP,this.onEULAKeyUp);
         stage.focus = null;
         this.EULAPage_mc.visible = false;
      }
      
      public function ShowNewAccountPage(param1:String = null) : *
      {
         this.NewAccountPage_mc.visible = true;
         this.NewAccountPage_mc.UsernameGrayText_tf.visible = this.NewAccountPage_mc.NewUsernameInput_tf.text.length <= 0;
         this.NewAccountPage_mc.EmailGrayText_tf.visible = this.NewAccountPage_mc.NewEmailInput_tf.text.length <= 0;
         this.NewAccountPage_mc.addEventListener(KeyboardEvent.KEY_UP,this.onNewAccountKeyUp);
         this.codeObj.startEditText();
         stage.focus = this.NewAccountPage_mc.NewUsernameInput_tf;
         if(this.NewAccountPage_mc.NewUsernameInput_tf.text.length > 0)
         {
            this.NewAccountPage_mc.NewUsernameInput_tf.setSelection(0,this.NewAccountPage_mc.NewUsernameInput_tf.text.length);
         }
         if(param1 != null)
         {
            GlobalFunc.SetText(this.NewAccountPage_mc.Error_tf,"$CreateAcct_" + param1,false);
         }
         else
         {
            GlobalFunc.SetText(this.NewAccountPage_mc.Error_tf," ",false);
         }
         this.UpdateButtons();
      }
      
      public function HideNewAccountPage() : *
      {
         this.codeObj.endEditText();
         this.NewAccountPage_mc.visible = false;
         stage.focus = null;
         this.NewAccountPage_mc.removeEventListener(KeyboardEvent.KEY_UP,this.onNewAccountKeyUp);
      }
      
      private function UpdateButtons() : *
      {
         if(this.LoginPage_mc.visible)
         {
            if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_GAMEPAD)
            {
               this.Login_AcceptButton.ButtonText = this.LoginPage_mc.UsernameInput_tf.text.length > 0 && this.LoginPage_mc.PasswordInput_tf.text.length > 0 && stage.focus == this.LoginPage_mc.PasswordInput_tf?"$ACCEPT":"$ENTER TEXT";
            }
            else
            {
               this.Login_AcceptButton.ButtonText = "$ACCEPT";
            }
            this.Login_AcceptButton.ButtonVisible = true;
            this.Login_CancelButton.ButtonVisible = true;
            this.Login_CreateNewButton.ButtonVisible = true;
            this.Login_AcceptButton.ButtonEnabled = true;
            this.Login_LoadOrderButton.ButtonVisible = true;
         }
         else if(this.EULAPage_mc.visible)
         {
            this.Login_AcceptButton.ButtonText = "$NEXT";
            this.Login_AcceptButton.ButtonVisible = true;
            this.Login_CancelButton.ButtonVisible = true;
            this.Login_CreateNewButton.ButtonVisible = false;
            this.Login_AcceptButton.ButtonEnabled = true;
            this.Login_LoadOrderButton.ButtonVisible = false;
         }
         else if(this.NewAccountPage_mc.visible)
         {
            this.Login_AcceptButton.ButtonText = "$ACCEPT";
            this.Login_AcceptButton.ButtonVisible = true;
            this.Login_CancelButton.ButtonVisible = true;
            this.Login_CreateNewButton.ButtonVisible = false;
            this.Login_ToggleButton.ButtonVisible = this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && (stage.focus == this.NewAccountPage_mc.CoppaCheckbox || stage.focus == this.NewAccountPage_mc.NewsOptInCheckbox);
            this.Login_AcceptButton.ButtonEnabled = this.CoppaCheckbox.checked;
            this.Login_LoadOrderButton.ButtonVisible = false;
         }
         else
         {
            this.Login_AcceptButton.ButtonVisible = false;
            this.Login_CancelButton.ButtonVisible = false;
            this.Login_CreateNewButton.ButtonVisible = false;
            this.Login_LoadOrderButton.ButtonVisible = false;
         }
      }
      
      private function onTextFieldShiftFocus(param1:MouseEvent) : *
      {
         stage.focus = param1.currentTarget as InteractiveObject;
      }
      
      private function onEULAKeyUp(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onLoginAccept();
         }
      }
      
      private function onEULAKeyDown(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               this.EULAPage_mc.EULA_tf.scrollV--;
            }
            else
            {
               this.EULAPage_mc.EULA_tf.scrollV++;
            }
         }
      }
      
      public function UpdateEULAScrollIndicators() : *
      {
         this.EULAPage_mc.ScrollUp.visible = this.EULAPage_mc.EULA_tf.scrollV > 1;
         this.EULAPage_mc.ScrollDown.visible = this.EULAPage_mc.EULA_tf.bottomScrollV < this.EULAPage_mc.EULA_tf.numLines;
      }
      
      private function onEULAScrollUpClicked() : *
      {
         this.EULAPage_mc.EULA_tf.scrollV--;
      }
      
      private function onEULAScrollDownClicked() : *
      {
         this.EULAPage_mc.EULA_tf.scrollV++;
      }
      
      private function onEULAMouseWheel(param1:MouseEvent) : *
      {
         if(this.EULAPage_mc.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            if(param1.delta < 0)
            {
               this.EULAPage_mc.EULA_tf.scrollV++;
            }
            else if(param1.delta > 0)
            {
               this.EULAPage_mc.EULA_tf.scrollV--;
            }
         }
      }
      
      private function onLoginScreenKeyUp(param1:KeyboardEvent) : *
      {
         if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            if(param1.keyCode == Keyboard.DOWN)
            {
               if(stage.focus == this.LoginPage_mc.UsernameInput_tf)
               {
                  stage.focus = this.LoginPage_mc.PasswordInput_tf;
               }
            }
            else if(param1.keyCode == Keyboard.UP)
            {
               if(stage.focus == this.LoginPage_mc.PasswordInput_tf)
               {
                  stage.focus = this.LoginPage_mc.UsernameInput_tf;
               }
            }
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onLoginAccept();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.onLoginCancel();
         }
         else if(param1.keyCode == Keyboard.INSERT)
         {
            this.onLogin_CreateNew();
         }
         else if(param1.keyCode == Keyboard.HOME)
         {
            this.onLogin_LoadOrder();
         }
         if(this.LoginPage_mc.UsernameInput_tf.text.length > 0)
         {
            this.LoginPage_mc.UsernameGrayText_tf.visible = false;
         }
         if(this.LoginPage_mc.PasswordInput_tf.text.length > 0)
         {
            this.LoginPage_mc.PasswordGrayText_tf.visible = false;
         }
      }
      
      private function onNewAccountKeyUp(param1:KeyboardEvent) : *
      {
         if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            if(param1.keyCode == Keyboard.DOWN)
            {
               if(stage.focus == this.NewAccountPage_mc.NewUsernameInput_tf)
               {
                  stage.focus = this.NewAccountPage_mc.NewEmailInput_tf;
               }
               else if(stage.focus == this.NewAccountPage_mc.NewEmailInput_tf)
               {
                  stage.focus = this.NewAccountPage_mc.CoppaCheckbox;
               }
               else if(stage.focus == this.NewAccountPage_mc.CoppaCheckbox)
               {
                  stage.focus = this.NewAccountPage_mc.NewsOptInCheckbox;
               }
               this.UpdateButtons();
            }
            else if(param1.keyCode == Keyboard.UP)
            {
               if(stage.focus == this.NewAccountPage_mc.NewsOptInCheckbox)
               {
                  stage.focus = this.NewAccountPage_mc.CoppaCheckbox;
               }
               else if(stage.focus == this.NewAccountPage_mc.CoppaCheckbox)
               {
                  stage.focus = this.NewAccountPage_mc.NewEmailInput_tf;
               }
               else if(stage.focus == this.NewAccountPage_mc.NewEmailInput_tf)
               {
                  stage.focus = this.NewAccountPage_mc.NewUsernameInput_tf;
               }
               this.UpdateButtons();
            }
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onLoginAccept();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.onLoginCancel();
         }
         else if(param1.keyCode == Keyboard.TAB)
         {
            this.UpdateButtons();
         }
         if(this.NewAccountPage_mc.NewUsernameInput_tf.text.length > 0)
         {
            this.NewAccountPage_mc.UsernameGrayText_tf.visible = false;
         }
         if(this.NewAccountPage_mc.NewEmailInput_tf.text.length > 0)
         {
            this.NewAccountPage_mc.EmailGrayText_tf.visible = false;
         }
      }
      
      private function onCoppaCheck() : *
      {
         this.UpdateButtons();
      }
      
      override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.Spinner_mc.visible)
         {
            _loc3_ = true;
         }
         if(!param2 && !_loc3_)
         {
            switch(param1)
            {
               case "DeleteSave":
                  if(Boolean(this.Login_CreateNewButton.ButtonVisible) && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
                  {
                     this.onLogin_CreateNew();
                     _loc3_ = true;
                  }
                  break;
               case "YButton":
               case "ResetToDefault":
                  if(this.Login_ToggleButton.ButtonVisible)
                  {
                     if(stage.focus == this.NewAccountPage_mc.CoppaCheckbox)
                     {
                        this.NewAccountPage_mc.CoppaCheckbox.checked = !this.NewAccountPage_mc.CoppaCheckbox.checked;
                     }
                     else if(stage.focus == this.NewAccountPage_mc.NewsOptInCheckbox)
                     {
                        this.NewAccountPage_mc.NewsOptInCheckbox.checked = !this.NewAccountPage_mc.NewsOptInCheckbox.checked;
                     }
                     this.UpdateButtons();
                     _loc3_ = true;
                  }
                  else if(this.Login_LoadOrderButton.ButtonVisible)
                  {
                     this.onLogin_LoadOrder();
                     _loc3_ = true;
                  }
                  break;
               case "Cancel":
               case "Start":
                  if(this.Login_CancelButton.ButtonVisible)
                  {
                     _loc3_ = this.onLoginCancel();
                  }
            }
         }
         return _loc3_;
      }
      
      private function onLoginAccept() : *
      {
         if(Boolean(this.Login_AcceptButton.ButtonVisible) && Boolean(this.Login_AcceptButton.ButtonEnabled))
         {
            if(this.LoginPage_mc.visible)
            {
               if(this.LoginPage_mc.UsernameInput_tf.text.length > 0 && this.LoginPage_mc.PasswordInput_tf.text.length > 0)
               {
                  this.HideLoginScreen();
                  this.codeObj.attemptLogin(this.LoginPage_mc.UsernameInput_tf.text,this.LoginPage_mc.PasswordInput_tf.text);
               }
               else if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_GAMEPAD)
               {
                  if(stage.focus == this.LoginPage_mc.UsernameInput_tf)
                  {
                     this.LoginPage_mc.UsernameGrayText_tf.visible = false;
                     this.codeObj.startEditText(this.LoginPage_mc.UsernameInput_tf.text.length > 0?this.LoginPage_mc.UsernameInput_tf.text:this.LoginPage_mc.UsernameGrayText_tf.text);
                  }
                  else if(stage.focus == this.LoginPage_mc.PasswordInput_tf)
                  {
                     this.LoginPage_mc.PasswordGrayText_tf.visible = false;
                     this.codeObj.startEditText(this.LoginPage_mc.PasswordInput_tf.text.length > 0?this.LoginPage_mc.PasswordInput_tf.text:this.LoginPage_mc.PasswordGrayText_tf.text,true);
                  }
               }
            }
            else if(this.EULAPage_mc.visible)
            {
               this.codeObj.AcceptLegalDoc(this.EULAPagesA[this._CurrEULAIndex].id);
               if(this._CurrEULAIndex < this.EULAPagesA.length - 1)
               {
                  this._CurrEULAIndex++;
                  this.LoadEULAPage();
               }
               else
               {
                  this.HideEULAScreen();
                  dispatchEvent(new Event("onEULAAccepted",true,true));
               }
            }
            else if(this.NewAccountPage_mc.visible)
            {
               if(this.NewAccountPage_mc.NewUsernameInput_tf.text.length > 0 && this.NewAccountPage_mc.NewEmailInput_tf.text.length > 0)
               {
                  this.HideNewAccountPage();
                  this.codeObj.createQuickAccount(this.NewAccountPage_mc.NewUsernameInput_tf.text,this.NewAccountPage_mc.NewEmailInput_tf.text,this.CoppaCheckbox.checked,this.NewsOptInCheckbox.checked);
               }
            }
         }
      }
      
      private function onLoginCancel() : Boolean
      {
         var executeDelayedShowLogin:* = undefined;
         var bhandled:Boolean = false;
         var cancelToLogin:Boolean = false;
         if(this.EULAPage_mc.visible)
         {
            dispatchEvent(new Event("onEULACancelled",true,true));
            bhandled = true;
         }
         else if(this.NewAccountPage_mc.visible)
         {
            this.HideNewAccountPage();
            cancelToLogin = true;
            bhandled = true;
         }
         else if(this.Spinner_mc.visible)
         {
            bhandled = true;
         }
         else if(this.LoginPage_mc.visible)
         {
            this.HideLoginScreen();
            dispatchEvent(new Event("CANCEL_LOGIN",true,true));
            bhandled = true;
         }
         if(cancelToLogin)
         {
            executeDelayedShowLogin = function delayedFunc(param1:Event):void
            {
               ShowLoginScreen(LoginPage_mc.UsernameInput_tf.text);
               removeEventListener(Event.ENTER_FRAME,executeDelayedShowLogin);
            };
            addEventListener(Event.ENTER_FRAME,executeDelayedShowLogin);
         }
         return bhandled;
      }
      
      private function onLogin_CreateNew() : *
      {
      }
      
      private function onLogin_LoadOrder() : *
      {
         this.HideLoginScreen();
         dispatchEvent(new Event("openLoadOrder",true,true));
      }
      
      public function onVKBTextEntered(param1:String) : *
      {
         var _loc2_:Timer = null;
         if(param1.length > 0)
         {
            if(stage.focus == this.LoginPage_mc.UsernameInput_tf)
            {
               if(this.iPlatform != PlatformChangeEvent.PLATFORM_PS4)
               {
                  GlobalFunc.SetText(this.LoginPage_mc.UsernameInput_tf,param1,false);
               }
               stage.focus = this.LoginPage_mc.PasswordInput_tf;
               this.LoginPage_mc.PasswordGrayText_tf.visible = false;
               _loc2_ = new Timer(1000,0);
               _loc2_.addEventListener(TimerEvent.TIMER,this.onNextEditTimerDone);
               _loc2_.start();
            }
            else if(stage.focus == this.LoginPage_mc.PasswordInput_tf && this.iPlatform != PlatformChangeEvent.PLATFORM_PS4)
            {
               GlobalFunc.SetText(this.LoginPage_mc.PasswordInput_tf,param1,false);
            }
         }
         if(this.LoginPage_mc.UsernameInput_tf.text.length > 0)
         {
            this.LoginPage_mc.UsernameGrayText_tf.visible = false;
         }
         if(this.LoginPage_mc.PasswordInput_tf.text.length > 0)
         {
            this.LoginPage_mc.PasswordGrayText_tf.visible = false;
         }
         this.UpdateButtons();
      }
      
      private function onNextEditTimerDone(param1:TimerEvent) : *
      {
         this.codeObj.startEditText(this.LoginPage_mc.PasswordInput_tf.text.length > 0?this.LoginPage_mc.PasswordInput_tf.text:this.LoginPage_mc.PasswordGrayText_tf.text,true);
         param1.target.removeEventListener(TimerEvent.TIMER,this.onNextEditTimerDone);
         (param1.target as Timer).stop();
      }
   }
}
