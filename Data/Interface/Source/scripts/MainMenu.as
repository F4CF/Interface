package
{
   import Shared.IMenu;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import Shared.AS3.BSButtonHintBar;
   import flash.display.Loader;
   import Shared.AS3.BSButtonHintData;
   import flash.display.Bitmap;
   import flash.utils.Timer;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.net.URLRequest;
   import Shared.PlatformChangeEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.TimerEvent;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import flash.events.MouseEvent;
   import Shared.AS3.BSScrollingList;
   import flash.display.Shape;
   import flash.display.LineScaleMode;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class MainMenu extends IMenu
   {
       
      public var SaveLoadHolder_mc:MovieClip;
      
      public var CharacterSelectList_mc:SaveLoadList;
      
      public var MainPanel_mc:MovieClip;
      
      public var ConfirmPanel_mc:MovieClip;
      
      public var VersionText_tf:TextField;
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var Spinner_mc:MovieClip;
      
      public var SettingsPanel_mc:MovieClip;
      
      public var BackgroundAndBrackets_mc:MovieClip;
      
      public var BackgroundAndBracketsHelpTopic_mc:MovieClip;
      
      public var OptionsPanel_mc:MovieClip;
      
      public var ControlsPanel_mc:MovieClip;
      
      public var ColorReference_mc:MovieClip;
      
      public var SplashScreenHolder_mc:MovieClip;
      
      public var HelpPanel_mc:MovieClip;
      
      public var DLCPanel_mc:MovieClip;
      
      public var ModManager_mc:MovieClip;
      
      public var GamerTag_mc:MovieClip;
      
      public var GamerIcon_mc:MovieClip;
      
      public var BethesdaLogo_mc:MovieClip;
      
      public var RemapPrompt_mc:MovieClip;
      
      public var BlackLoading_mc:MovieClip;
      
      public var HelpText:TextField;
      
      public var HelpTitleText:TextField;
      
      public var HelpScrollUp:MovieClip;
      
      public var HelpScrollDown:MovieClip;
      
      public var DLCImageLoader:Loader;
      
      public var DLCImageSizer_mc:MovieClip;
      
      private var standardButtonHintDataV:Vector.<BSButtonHintData>;
      
      private var ConfirmButton:BSButtonHintData;
      
      private var QuitToDesktopButton:BSButtonHintData;
      
      private var XButton:BSButtonHintData;
      
      private var CancelButton:BSButtonHintData;
      
      private var YButton:BSButtonHintData;
      
      public var BGSCodeObj:Object;
      
      public const MAIN_STATE:String = "MAIN_STATE";
      
      public const CONTINUE_CONFIRM_STATE:String = "CONTINUE_CONFIRM_STATE";
      
      public const NEW_CONFIRM_STATE:String = "NEW_CONFIRM_STATE";
      
      public const SAVE_LOAD_STATE:String = "SAVE_LOAD_STATE";
      
      public const SAVE_LOAD_CONFIRM_STATE:String = "SAVE_LOAD_CONFIRM_STATE";
      
      public const QUIT_CONFIRM_STATE:String = "QUIT_CONFIRM_STATE";
      
      public const DELETE_SAVE_CONFIRM_STATE:String = "DELETE_SAVE_CONFIRM_STATE";
      
      public const SETTINGS_CATEGORY_STATE:String = "SETTINGS_CATEGORY_STATE";
      
      public const HELP_STATE:String = "HELP_STATE";
      
      public const OPTIONS_LISTS_STATE:String = "OPTIONS_LISTS_STATE";
      
      public const DEFAULT_SETTINGS_CONFIRM_STATE:String = "DEFAULT_SETTINGS_CONFIRM_STATE";
      
      public const INPUT_MAPPING_STATE:String = "INPUT_MAPPING_STATE";
      
      public const CREDIT_STATE:String = "CREDIT_STATE";
      
      public const CHARACTER_SELECT_STATE:String = "CHARACTER_SELECT_STATE";
      
      public const DLC_STATE:String = "DLC_STATE";
      
      public const BETHESDANET_STATE:String = "BETHESDANET_STATE";
      
      private const RIGHT_INPUT_SCROLL_THRESHOLD:Number = 3;
      
      private var strCurrentState:String = "MAIN_STATE";
      
      private var PauseMode:Boolean = false;
      
      private var ShowPlatformHelp:Boolean = false;
      
      private const CONTINUE_INDEX:Number = 0;
      
      private const NEW_INDEX:Number = 1;
      
      private const QUICKSAVE_INDEX:Number = 2;
      
      private const SAVE_INDEX:Number = 3;
      
      private const LOAD_INDEX:Number = 4;
      
      private const DLC_INDEX:Number = 5;
      
      private const BETHESDANET_INDEX:Number = 6;
      
      private const HELP_INDEX = 7;
      
      private const SETTINGS_INDEX = 8;
      
      private const CREDITS_INDEX:Number = 9;
      
      private const QUIT_INDEX:Number = 10;
      
      private const PLATFORM_HELP = 11;
      
      private const MAIN_PANEL_BACKGROUND:uint = 0;
      
      private const SECOND_PANEL_BACKGROUND:uint = 1;
      
      private const HELP_TOPIC_BACKGROUND:uint = 2;
      
      private const HELP_LIST_BACKGROUND:uint = 3;
      
      private var TopmostPanel:MovieClip;
      
      private var GamerIconRect:Bitmap;
      
      private var ModManager_Loader:Loader;
      
      private var SaveLoadObj:SaveLoadPanel;
      
      private var SavingSettingsTimer:Timer;
      
      private var SaveDelayTimer:Timer;
      
      private var HideMessageTextTimer:Timer;
      
      private var DebounceRemapModeTimer:Timer;
      
      private var DebounceResetSettingsTimer:Timer;
      
      private var QuicksavingMessageTimer:Timer;
      
      private var bRemapMode:Boolean;
      
      private var bSavingSettings:Boolean;
      
      private var bSettingsChanged:Boolean;
      
      private var bMenuClosing:Boolean;
      
      private var bShowQuitOption:Boolean;
      
      private var bShowDLCOption:Boolean;
      
      private var bSplashScreen:Boolean = false;
      
      private var AllowQuitToDesktop:Boolean = false;
      
      private var HasRecentSave:Boolean = false;
      
      private var bShowChangeUserOption:Boolean = false;
      
      private var iHelpTopicIndex:uint = 0;
      
      private var AllowSkip = false;
      
      private var _IsSurvivalAvailable = true;
      
      private var bAudioSettingsDisabled:Boolean = true;
      
      private var StoredSaveList:Array;
      
      private var HelpScrollDeltaAccum:Number = 0.0;
      
      private var ShouldShowGamerTagAndIcon:Boolean = false;
      
      public function MainMenu()
      {
         this.ConfirmButton = new BSButtonHintData("$CONFIRM","Enter","PSN_A","Xenon_A",1,this.onAcceptPress);
         this.QuitToDesktopButton = new BSButtonHintData("$DESKTOP","T","PSN_Y","Xenon_Y",1,this.onQuitToDesktopPress);
         this.XButton = new BSButtonHintData("$DELETE","X","PSN_X","Xenon_X",1,this.onXButtonPressed);
         this.CancelButton = new BSButtonHintData("$CANCEL","Esc","PSN_B","Xenon_B",1,this.onCancelPress);
         this.YButton = new BSButtonHintData("$CHANGEUSER","T","PSN_Y","Xenon_Y",1,this.onYButtonPressed);
         this.StoredSaveList = new Array();
         super();
         this.visible = false;
         this.BGSCodeObj = new Object();
         this.bSettingsChanged = false;
         this.bMenuClosing = false;
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(BSScrollingList.ITEM_PRESS,this.onListItemPress);
         addEventListener(BSScrollingList.PLAY_FOCUS_SOUND,this.onListPlayFocus);
         addEventListener(GlobalFunc.PLAY_FOCUS_SOUND,this.onListPlayFocus);
         addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onListsCreated);
         addEventListener(SaveLoadPanel.SAVE_LIST_POPULATED,this.OnSaveListOpenSuccess);
         addEventListener(SaveLoadPanel.SAVE_SELECTED,this.ConfirmSaveGame);
         addEventListener(SaveLoadPanel.LOAD_GAME_SELECTED,this.ConfirmLoadGame);
         this.SettingsPanel_mc.SettingsList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onSettingsListItemPress);
         this.HelpPanel_mc.HelpList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onHelpListItemSelect);
         this.BackgroundAndBracketsHelpTopic_mc.addEventListener(MouseEvent.ROLL_OVER,this.onHelpContentRollOver);
         this.BackgroundAndBracketsHelpTopic_mc.addEventListener(MouseEvent.ROLL_OUT,this.onHelpContentRollOut);
         addEventListener(SettingsOptionItem.VALUE_CHANGE,this.onSettingsValueChange);
         this.SaveLoadObj = this.SaveLoadHolder_mc.Panel_mc;
         this.SaveLoadObj.mouseEnabled = false;
         this.SavingSettingsTimer = new Timer(1000,1);
         this.SaveDelayTimer = new Timer(200,1);
         this.SaveDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.DoSaveGame);
         this.HideMessageTextTimer = new Timer(1000,1);
         this.HideMessageTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.HideMessageText);
         this.DebounceRemapModeTimer = new Timer(200,1);
         this.DebounceRemapModeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.ClearRemapMode);
         this.DebounceResetSettingsTimer = new Timer(200,1);
         this.DebounceResetSettingsTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onResetSettings);
         this.QuicksavingMessageTimer = new Timer(100,1);
         this.PopulateButtonBar();
         this.ConfirmButton.ButtonVisible = false;
         this.QuitToDesktopButton.ButtonVisible = false;
         this.XButton.ButtonVisible = false;
         this.CancelButton.ButtonVisible = false;
         this.YButton.ButtonVisible = false;
         this.HelpText = this.BackgroundAndBracketsHelpTopic_mc.HelpText;
         this.HelpTitleText = this.BackgroundAndBracketsHelpTopic_mc.HelpTitleText;
         this.HelpScrollUp = this.BackgroundAndBracketsHelpTopic_mc.ScrollUp;
         this.HelpScrollDown = this.BackgroundAndBracketsHelpTopic_mc.ScrollDown;
         this.HelpScrollUp.addEventListener(MouseEvent.CLICK,this.onHelpContentScrollUpClicked);
         this.HelpScrollDown.addEventListener(MouseEvent.CLICK,this.onHelpContentScrollDownClicked);
         this.HelpText.selectable = false;
         this.HelpTitleText.selectable = false;
         this.GamerIcon_mc.visible = false;
         this.GamerTag_mc.visible = false;
         this.BethesdaLogo_mc.visible = false;
         this.ModManager_Loader = new Loader();
         this.DLCImageLoader = new Loader();
         addChild(this.DLCImageLoader);
         this.DLCImageSizer_mc.alpha = 0;
         this.ModManager_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModManagerLoadComplete,false,0,true);
         this.DLCImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onDLCImageLoadComplete,false,0,true);
         var _loc1_:Shape = new Shape();
         _loc1_.name = "lines";
         _loc1_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
         _loc1_.graphics.moveTo(0,4.5);
         _loc1_.graphics.lineTo(0,0);
         _loc1_.graphics.lineTo(430,0);
         _loc1_.graphics.lineTo(430,4.5);
         _loc1_.graphics.moveTo(0,302.5);
         _loc1_.graphics.lineTo(0,307.5);
         _loc1_.graphics.lineTo(430,307.5);
         _loc1_.graphics.lineTo(430,302.5);
         this.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.addChild(_loc1_);
         this.DLCImageSizer_mc.x = 700;
         this.DLCPanel_mc.DLCInstalledText_tf.x = 231;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.__setProp_CharacterSelectList_mc_MenuObj_CharacterSelectList_0();
      }
      
      public function set pauseMode(param1:Boolean) : *
      {
         this.PauseMode = param1;
      }
      
      public function set showPlatformHelp(param1:Boolean) : *
      {
         this.ShowPlatformHelp = param1;
      }
      
      public function set allowQuitToDesktop(param1:Boolean) : *
      {
         this.AllowQuitToDesktop = param1;
      }
      
      public function set isSurvivalAvailable(param1:Boolean) : *
      {
         this._IsSurvivalAvailable = param1;
      }
      
      public function get dataVersion() : uint
      {
         return 7;
      }
      
      public function SetSavingText() : *
      {
         GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"",false);
         GlobalFunc.SetText(this.RemapPrompt_mc.textField,"$Saving...",false);
      }
      
      public function SetAllowSkip(param1:Boolean, param2:Boolean) : *
      {
         this.AllowSkip = param1;
         this.SplashScreenText_tf.visible = param2;
      }
      
      private function onListsCreated(param1:Event) : *
      {
         if(this.SettingsPanel_mc.SettingsList_mc.initialized)
         {
            this.SettingsPanel_mc.SettingsList_mc.entryList = [{"text":"$GAMEPLAY"},{"text":"$CONTROLS"},{"text":"$DISPLAY"},{
               "text":"$AUDIO",
               "disabled":true,
               "waitingForLoad":true
            }];
            this.SettingsPanel_mc.SettingsList_mc.InvalidateData();
            this.SettingsPanel_mc.SettingsList_mc.disableInput = false;
            this.SettingsPanel_mc.SettingsList_mc.selectedIndex = 0;
         }
      }
      
      private function PopulateButtonBar() : void
      {
         this.standardButtonHintDataV = new Vector.<BSButtonHintData>();
         this.standardButtonHintDataV.push(this.ConfirmButton);
         this.standardButtonHintDataV.push(this.QuitToDesktopButton);
         this.standardButtonHintDataV.push(this.XButton);
         this.standardButtonHintDataV.push(this.YButton);
         this.standardButtonHintDataV.push(this.CancelButton);
         this.ButtonHintBar_mc.SetButtonHintData(this.standardButtonHintDataV);
      }
      
      public function InitMenu() : *
      {
         this.CharacterSelectList_mc.visible = false;
         this.ShowSecondPanelBackground(false);
         this.ShowHelpBackgrounds(false);
         this.SaveLoadHolder_mc.gotoAndPlay("end");
         this.ShowSecondPanelBackground(false);
         this.BGSCodeObj.RegisterSaveLoadPanel(this.SaveLoadObj);
         this.BGSCodeObj.InitialPopulateLoadList(this.SaveLoadObj.List_mc.entryList,this.SaveLoadObj.batchSize);
         visible = true;
      }
      
      public function onCodeObjCreate() : *
      {
         this.SaveLoadHolder_mc.codeObj = this.BGSCodeObj;
         this.SaveLoadObj.codeObj = this.BGSCodeObj;
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.BethesdaLogo_mc,"BL",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.Spinner_mc,"BR",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.SplashScreenHolder_mc,"BC",SafeX,SafeY);
      }
      
      public function SetAudioAvailable() : *
      {
         this.SettingsPanel_mc.SettingsList_mc.entryList[3].disabled = false;
         this.SettingsPanel_mc.SettingsList_mc.entryList[3].waitingForLoad = false;
         this.SettingsPanel_mc.SettingsList_mc.InvalidateData();
         this.SettingsPanel_mc.SettingsList_mc.disableInput = false;
         this.SettingsPanel_mc.SettingsList_mc.selectedIndex = 0;
         this.bAudioSettingsDisabled = false;
      }
      
      public function onCodeObjDestruction() : *
      {
         this.SaveLoadHolder_mc.codeObj = null;
         this.SaveLoadObj.codeObj = null;
         this.BGSCodeObj = null;
      }
      
      public function InitList(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean = true, param6:Boolean = true, param7:* = false) : *
      {
         var _loc9_:Number = NaN;
         this.HasRecentSave = this.BGSCodeObj.GetHasSavedGames();
         var _loc8_:Number = !!this.PauseMode?Number(this.SAVE_INDEX):Number(this.NEW_INDEX);
         if(this.MainPanel_mc.List_mc.entryList.length > 0 && this.MainPanel_mc.List_mc.selectedEntry != null)
         {
            _loc8_ = this.MainPanel_mc.List_mc.selectedEntry.index;
         }
         this.MainPanel_mc.List_mc.ClearList();
         if(!this.PauseMode && Boolean(this.HasRecentSave))
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$CONTINUE",
               "disabled":!this.HasRecentSave,
               "index":this.CONTINUE_INDEX
            });
         }
         if(this.PauseMode)
         {
            if(param7)
            {
               this.MainPanel_mc.List_mc.entryList.push({
                  "text":"$QUICKSAVE",
                  "disabled":!param5,
                  "index":this.QUICKSAVE_INDEX
               });
            }
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$SAVE",
               "disabled":!param5,
               "index":this.SAVE_INDEX
            });
         }
         else
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$NEW",
               "index":this.NEW_INDEX
            });
         }
         this.MainPanel_mc.List_mc.entryList.push({
            "text":"$LOAD",
            "disabled":!this.HasRecentSave || !param6,
            "index":this.LOAD_INDEX
         });
         this.bShowDLCOption = param2;
         if(!this.PauseMode && Boolean(param2))
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$ADD-ONS",
               "index":this.DLC_INDEX
            });
         }
         if(this.BGSCodeObj.GetShowBethesdaNetOption())
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$BETHESDA.NET",
               "index":this.BETHESDANET_INDEX
            });
         }
         if(this.PauseMode)
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$HELP",
               "index":this.HELP_INDEX
            });
         }
         if(this.ShowPlatformHelp)
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$HELP",
               "index":this.PLATFORM_HELP
            });
         }
         this.MainPanel_mc.List_mc.entryList.push({
            "text":"$SETTINGS",
            "index":this.SETTINGS_INDEX
         });
         if(!this.PauseMode)
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$CREW",
               "index":this.CREDITS_INDEX
            });
         }
         this.bShowQuitOption = param1;
         if(param1)
         {
            this.MainPanel_mc.List_mc.entryList.push({
               "text":"$QUIT",
               "index":this.QUIT_INDEX
            });
         }
         if(param3)
         {
            this.MainPanel_mc.List_mc.selectedIndex = -1;
         }
         else
         {
            _loc9_ = 0;
            while(_loc9_ < this.MainPanel_mc.List_mc.entryList.length)
            {
               if(this.MainPanel_mc.List_mc.entryList[_loc9_].index == _loc8_)
               {
                  this.MainPanel_mc.List_mc.selectedIndex = _loc9_;
               }
               _loc9_++;
            }
         }
         this.bShowChangeUserOption = param4;
         this.MainPanel_mc.List_mc.InvalidateData();
         this.currentState = this.MAIN_STATE;
      }
      
      public function get currentState() : String
      {
         return this.strCurrentState;
      }
      
      public function set currentState(param1:String) : *
      {
         this.strCurrentState = param1;
         this.UpdateButtons(param1);
         this.UpdateStateFocus(param1);
      }
      
      public function get shouldIgnoreInput() : Boolean
      {
         return Boolean(this.bRemapMode) || Boolean(this.bMenuClosing);
      }
      
      public function get SplashScreenText_tf() : TextField
      {
         return this.SplashScreenHolder_mc.SplashScreenText_tf;
      }
      
      public function SetVersionText(param1:String, param2:uint) : *
      {
         if(param1.length > 0)
         {
            GlobalFunc.SetText(this.VersionText_tf,"v " + param1 + "." + param2,false);
         }
         else
         {
            GlobalFunc.SetText(this.VersionText_tf," ",false);
         }
      }
      
      public function ShowGamerTagAndIcon(param1:String) : *
      {
         var _loc2_:Loader = null;
         var _loc3_:URLRequest = null;
         if(param1.length > 0)
         {
            GlobalFunc.SetText(this.GamerTag_mc.GamerTagText_tf,param1,false);
            this.GamerTag_mc.visible = true;
            _loc2_ = new Loader();
            _loc3_ = new URLRequest("img://BGSUserIcon");
            _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadGamerIconComplete);
            _loc2_.load(_loc3_);
         }
         else
         {
            this.GamerTag_mc.visible = false;
            this.GamerIcon_mc.visible = false;
         }
      }
      
      private function onLoadGamerIconComplete(param1:Event) : *
      {
         if(this.GamerIconRect != null)
         {
            this.GamerIcon_mc.removeChild(this.GamerIconRect);
            this.GamerIconRect = null;
         }
         this.GamerIconRect = param1.target.content;
         this.GamerIconRect.width = this.GamerIcon_mc.width;
         this.GamerIconRect.height = this.GamerIcon_mc.height;
         this.GamerIcon_mc.addChild(this.GamerIconRect);
         this.GamerIcon_mc.visible = true;
      }
      
      private function onListItemPress(param1:Event) : *
      {
         if(!this.bSavingSettings && Boolean(this.BGSCodeObj.IsMainMenuReady()))
         {
            if(param1.target == this.MainPanel_mc.List_mc)
            {
               this.onMainListItemPress();
            }
            else if(param1.target == this.OptionsPanel_mc.Fader_mc.List_mc)
            {
               (this.OptionsPanel_mc.Fader_mc.List_mc as OptionsList).onListItemPressed();
            }
            else if(param1.target == this.ControlsPanel_mc.Fader_mc.List_mc)
            {
               this.onInputMappingPress();
            }
            else if(param1.target == this.CharacterSelectList_mc)
            {
               this.onAcceptPress();
            }
         }
      }
      
      private function onMainListItemPress() : *
      {
         if(Boolean(this.MainPanel_mc.List_mc.selectedEntry.disabled) || Boolean(this.Spinner_mc.visible == true) || Boolean(this.bSettingsChanged))
         {
            this.BGSCodeObj.PlayCancelSound();
         }
         else
         {
            while(this.strCurrentState != this.MAIN_STATE)
            {
               this.onCancelPress(true,false);
            }
            if(this.MainPanel_mc.List_mc.selectedEntry.index == this.CONTINUE_INDEX && Boolean(this.PauseMode))
            {
               this.SaveLoadHolder_mc.visible = false;
            }
            this.SaveLoadHolder_mc.gotoAndPlay("end");
            this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
            this.ShowSecondPanelBackground(false);
            this.HideDeleteConfirmCancelButtons();
            this.SaveLoadHolder_mc.Panel_mc.ModsLoaded_tf.visible = this.BGSCodeObj.AreModsLoaded();
            switch(this.MainPanel_mc.List_mc.selectedEntry.index)
            {
               case this.CONTINUE_INDEX:
                  this.BGSCodeObj.PlayOKSound();
                  this.BGSCodeObj.onContinuePress();
                  break;
               case this.NEW_INDEX:
                  this.BGSCodeObj.PlayOKSound();
                  this.BGSCodeObj.onNewPress();
                  break;
               case this.QUICKSAVE_INDEX:
                  if(this.MainPanel_mc.List_mc.selectedEntry.disabled != true)
                  {
                     this.BGSCodeObj.DoQuicksave();
                  }
                  break;
               case this.SAVE_INDEX:
                  if(this.MainPanel_mc.List_mc.selectedEntry.disabled != true)
                  {
                     this.SaveLoadObj.isSaving = true;
                     this.BGSCodeObj.PopulateSaveList(this.SaveLoadObj.List_mc.entryList,this.SaveLoadObj.batchSize);
                  }
                  break;
               case this.LOAD_INDEX:
                  if(this.MainPanel_mc.List_mc.selectedEntry.disabled != true)
                  {
                     if(uiPlatform == PlatformChangeEvent.PLATFORM_PS4)
                     {
                        this.ShowSecondPanelBackground(true);
                        this.ShowCharacterList();
                     }
                     else
                     {
                        this.SaveLoadObj.isSaving = false;
                        this.BGSCodeObj.PopulateLoadList(this.SaveLoadObj.List_mc.entryList,this.SaveLoadObj.batchSize);
                        this.SaveLoadObj.visible = true;
                     }
                  }
                  else
                  {
                     this.BGSCodeObj.onDisabledLoadPress();
                  }
                  break;
               case this.HELP_INDEX:
                  this.StartState(this.HELP_STATE);
                  this.BGSCodeObj.PlayOKSound();
                  break;
               case this.DLC_INDEX:
                  if(this.BGSCodeObj.IsDLCReady())
                  {
                     this.StartState(this.DLC_STATE);
                     this.BGSCodeObj.PlayOKSound();
                  }
                  break;
               case this.BETHESDANET_INDEX:
                  this.StartState(this.BETHESDANET_STATE);
                  this.BGSCodeObj.PlayOKSound();
                  break;
               case this.PLATFORM_HELP:
                  this.BGSCodeObj.ShowPlatformHelp();
                  break;
               case this.SETTINGS_INDEX:
                  this.StartState(this.SETTINGS_CATEGORY_STATE);
                  this.BGSCodeObj.PlayOKSound();
                  break;
               case this.CREDITS_INDEX:
                  this.StartState(this.CREDIT_STATE);
                  this.BGSCodeObj.PlayOKSound();
                  break;
               case this.QUIT_INDEX:
                  this.BGSCodeObj.PlayOKSound();
                  GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,!!this.PauseMode?"$Quit to main menu?  Any unsaved progress will be lost.":"$Quit to desktop?",false);
                  this.StartState(this.QUIT_CONFIRM_STATE);
            }
            this.UpdateButtons(this.strCurrentState);
         }
      }
      
      public function ConfirmContinue() : *
      {
         GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"$ConfirmContinue",false);
         this.StartState(this.CONTINUE_CONFIRM_STATE);
      }
      
      public function ConfirmNewGame(param1:String = "$ConfirmNew") : *
      {
         GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,param1,false);
         this.StartState(this.NEW_CONFIRM_STATE);
      }
      
      private function onKeyUp(param1:KeyboardEvent) : *
      {
         if(!this.shouldIgnoreInput)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               this.onAcceptPress();
            }
         }
      }
      
      public function onAcceptPress() : Boolean
      {
         var _loc1_:Boolean = true;
         switch(this.strCurrentState)
         {
            case this.CONTINUE_CONFIRM_STATE:
               this.BGSCodeObj.PlayOKSound();
               this.bMenuClosing = true;
               this.ShowSecondPanelBackground(false);
               this.BGSCodeObj.ContinueGame();
               this.HideDeleteConfirmCancelButtons();
               break;
            case this.SAVE_LOAD_CONFIRM_STATE:
               if(this.SaveLoadObj.List_mc.disableInput)
               {
                  this.BGSCodeObj.PlayOKSound();
                  this.bMenuClosing = true;
                  if(this.SaveLoadObj.isSaving)
                  {
                     this.ConfirmPanel_mc.visible = false;
                     GlobalFunc.SetText(this.RemapPrompt_mc.textField,"$Saving...",false);
                     this.SaveDelayTimer.start();
                  }
                  else
                  {
                     this.BGSCodeObj.FinishLoadGame(this.SaveLoadObj.selectedIndex);
                     this.ShowSecondPanelBackground(false);
                  }
                  this.HideDeleteConfirmCancelButtons();
               }
               break;
            case this.CHARACTER_SELECT_STATE:
               if(uiPlatform == PlatformChangeEvent.PLATFORM_PS4)
               {
                  this.BGSCodeObj.SetCurrentCharacter(this.CharacterSelectList_mc.entryList[this.CharacterSelectList_mc.selectedIndex].id);
                  this.CharacterSelectList_mc.visible = false;
                  this.ShowSecondPanelBackground(false);
                  this.HideDeleteConfirmCancelButtons();
                  this.BGSCodeObj.PopulateLoadList(this.SaveLoadObj.List_mc.entryList,this.SaveLoadObj.batchSize);
               }
               else
               {
                  this.BGSCodeObj.SetCurrentCharacter(this.CharacterSelectList_mc.entryList[this.CharacterSelectList_mc.selectedIndex].id);
                  this.SaveLoadObj.isSaving = false;
                  this.SaveLoadObj.List_mc.entryList.splice(0,this.SaveLoadObj.List_mc.entryList.length);
                  this.SaveLoadObj.List_mc.InvalidateData();
                  this.BGSCodeObj.PopulateLoadList(this.SaveLoadObj.List_mc.entryList,this.SaveLoadObj.batchSize);
                  this.CharacterSelectList_mc.visible = false;
                  this.SaveLoadObj.visible = true;
                  this.currentState = this.SAVE_LOAD_STATE;
               }
               break;
            case this.SAVE_LOAD_STATE:
               if(this.SaveLoadObj.isSaving)
               {
                  this.ConfirmSaveGame(null);
               }
               else
               {
                  this.ConfirmLoadGame(null);
               }
               break;
            case this.NEW_CONFIRM_STATE:
               this.bMenuClosing = true;
               this.BGSCodeObj.StartNewGame();
               this.HideDeleteConfirmCancelButtons();
               break;
            case this.QUIT_CONFIRM_STATE:
               this.BGSCodeObj.PlayOKSound();
               this.bMenuClosing = true;
               this.BGSCodeObj.onQuitPress();
               break;
            case this.DEFAULT_SETTINGS_CONFIRM_STATE:
               this.BGSCodeObj.PlayOKSound();
               if(this.ConfirmPanel_mc.returnType == this.OPTIONS_LISTS_STATE)
               {
                  this.ResetSettingsToDefaults();
                  this.OptionsPanel_mc.Fader_mc.List_mc.disableInput = true;
               }
               else if(this.ConfirmPanel_mc.returnType == this.INPUT_MAPPING_STATE)
               {
                  this.ResetControlsToDefaults();
                  this.ControlsPanel_mc.Fader_mc.List_mc.disableInput = true;
               }
               this.DebounceResetSettingsTimer.start();
               this.EndState();
               break;
            case this.DELETE_SAVE_CONFIRM_STATE:
               this.BGSCodeObj.PlayOKSound();
               this.SaveLoadObj.DeleteSelectedSave();
               if(this.SaveLoadObj.numSaves == 0)
               {
                  this.BGSCodeObj.SetCurrentCharacter(0);
                  GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"",false);
                  this.GetPanelForState(this.SAVE_LOAD_STATE).gotoAndStop(1);
                  this.XButton.ButtonVisible = false;
                  if(this.BGSCodeObj.GetHasSavedGames())
                  {
                     this.ShowCharacterList();
                  }
                  else
                  {
                     this.InitList(this.bShowQuitOption,this.bShowDLCOption,false,this.bShowChangeUserOption);
                     this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
                     this.ShowSecondPanelBackground(false);
                  }
               }
               else
               {
                  this.EndState();
                  this.currentState = this.SAVE_LOAD_STATE;
                  this.UpdateButtons(this.ConfirmPanel_mc.returnType);
               }
               break;
            case this.DLC_STATE:
               if(this.ConfirmButton.ButtonVisible)
               {
                  this.BGSCodeObj.PurchaseDLC(this.DLCPanel_mc.List_mc.selectedIndex);
               }
               break;
            default:
               _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function onQuitToDesktopPress() : Boolean
      {
         if(this.strCurrentState == this.QUIT_CONFIRM_STATE && Boolean(this.PauseMode) && Boolean(this.AllowQuitToDesktop))
         {
            this.BGSCodeObj.onQuitToDesktopPress();
         }
         return true;
      }
      
      public function onCancelPress(param1:Boolean = false, param2:Boolean = true) : Boolean
      {
         var _loc3_:Boolean = true;
         switch(this.strCurrentState)
         {
            case this.MAIN_STATE:
               if(this.PauseMode)
               {
                  this.BGSCodeObj.PlayCancelSound();
                  this.BGSCodeObj.onContinuePress();
                  _loc3_ = true;
               }
               _loc3_ = false;
               break;
            case this.SAVE_LOAD_STATE:
            case this.SETTINGS_CATEGORY_STATE:
               if(param2)
               {
                  this.BGSCodeObj.PlayCancelSound();
               }
               if(this.bSettingsChanged)
               {
                  GlobalFunc.SetText(this.RemapPrompt_mc.textField,"$Saving...",false);
                  this.bSavingSettings = true;
                  if(this.strCurrentState == this.SETTINGS_CATEGORY_STATE)
                  {
                     this.SavingSettingsTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.SaveSettings);
                     this.SavingSettingsTimer.start();
                  }
                  if(param1)
                  {
                     this.EndState();
                     this.StartState(this.MAIN_STATE);
                  }
               }
               else
               {
                  this.onSettingsSaved();
               }
               break;
            case this.HELP_STATE:
               this.EndState();
               this.StartState(this.MAIN_STATE);
               this.ShowHelpBackgrounds(false);
               if(param2)
               {
                  this.BGSCodeObj.PlayCancelSound();
               }
               break;
            case this.DLC_STATE:
               this.ShowDLCImage(-1);
               this.BGSCodeObj.ReturnFromDLC();
            case this.BETHESDANET_STATE:
               this.EndState();
               this.StartState(this.MAIN_STATE);
               if(param2)
               {
                  this.BGSCodeObj.PlayCancelSound();
               }
               break;
            case this.OPTIONS_LISTS_STATE:
            case this.INPUT_MAPPING_STATE:
               this.ColorReference_mc.visible = false;
               if(param2)
               {
                  this.BGSCodeObj.PlayCancelSound();
               }
               this.EndState();
               this.StartState(this.SETTINGS_CATEGORY_STATE);
               break;
            case this.CONTINUE_CONFIRM_STATE:
            case this.NEW_CONFIRM_STATE:
            case this.SAVE_LOAD_CONFIRM_STATE:
            case this.QUIT_CONFIRM_STATE:
            case this.DELETE_SAVE_CONFIRM_STATE:
            case this.DEFAULT_SETTINGS_CONFIRM_STATE:
               if(param2)
               {
                  this.BGSCodeObj.PlayCancelSound();
               }
               this.EndState();
               this.UpdateButtons(this.ConfirmPanel_mc.returnType);
               break;
            case this.CHARACTER_SELECT_STATE:
               if(uiPlatform == PlatformChangeEvent.PLATFORM_PS4)
               {
                  this.CharacterSelectList_mc.visible = false;
                  if(param2)
                  {
                     this.BGSCodeObj.PlayCancelSound();
                  }
                  this.ShowSecondPanelBackground(false);
                  this.HideDeleteConfirmCancelButtons();
                  this.currentState = this.MAIN_STATE;
                  this.UpdateButtons(this.ConfirmPanel_mc.returnType);
               }
               else
               {
                  this.CharacterSelectList_mc.visible = false;
                  if(this.SaveLoadObj.numSaves > 0)
                  {
                     this.SaveLoadObj.visible = true;
                     this.currentState = this.SAVE_LOAD_STATE;
                  }
                  else
                  {
                     this.InitList(this.bShowQuitOption,this.bShowDLCOption,false,this.bShowChangeUserOption);
                     this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
                     this.ShowSecondPanelBackground(false);
                  }
               }
         }
         return _loc3_;
      }
      
      private function onXButtonPressed() : void
      {
         if(uiPlatform == PlatformChangeEvent.PLATFORM_PS4)
         {
            this.BGSCodeObj.SetCurrentCharacter(this.CharacterSelectList_mc.entryList[this.CharacterSelectList_mc.selectedIndex].id);
            this.BGSCodeObj.PlayOKSound();
            this.BGSCodeObj.DeleteSave(0);
            this.ShowCharacterList();
         }
         else if(!this.SaveLoadObj.isSaving || this.SaveLoadObj.selectedIndex != 0)
         {
            this.BGSCodeObj.PlayOKSound();
            this.SaveLoadObj.List_mc.disableInput = true;
            if(this.strCurrentState == this.SAVE_LOAD_STATE)
            {
               GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"$Delete this save?",false);
               this.StartState(this.DELETE_SAVE_CONFIRM_STATE);
            }
         }
      }
      
      private function isConfirming() : Boolean
      {
         return this.strCurrentState == this.DELETE_SAVE_CONFIRM_STATE || this.strCurrentState == this.CONTINUE_CONFIRM_STATE || this.strCurrentState == this.NEW_CONFIRM_STATE || this.strCurrentState == this.SAVE_LOAD_CONFIRM_STATE || this.strCurrentState == this.QUIT_CONFIRM_STATE;
      }
      
      private function onAcceptMousePress() : *
      {
         if(this.isConfirming())
         {
            this.onAcceptPress();
         }
      }
      
      private function onCancelMousePress() : *
      {
         if(this.isConfirming())
         {
            this.onCancelPress();
         }
      }
      
      private function onListPlayFocus() : *
      {
         this.BGSCodeObj.PlayFocusSound();
      }
      
      public function onListSelectionChange(param1:Event) : *
      {
         if(param1.target.selectedIndex != null && param1.target.selectedIndex != -1)
         {
            if(param1.target.entryList[param1.target.selectedIndex].pipboyColorUpdate == true)
            {
               this.ColorReference_mc.visible = true;
               this.ColorReference_mc.ColorText_tf.text = "$PIPBOY";
               this.BGSCodeObj.onPipboyColorUpdate();
            }
            else
            {
               this.ColorReference_mc.visible = false;
            }
            if(this.strCurrentState == this.OPTIONS_LISTS_STATE && Boolean(param1.target.entryList[param1.target.selectedIndex].guideText))
            {
               GlobalFunc.SetText(this.OptionsPanel_mc.GuideText_tf,param1.target.entryList[param1.target.selectedIndex].guideText,false);
            }
            else
            {
               GlobalFunc.SetText(this.OptionsPanel_mc.GuideText_tf,"",false);
            }
            if(this.strCurrentState == this.DLC_STATE && param1.target == this.DLCPanel_mc.List_mc && param1.target.selectedIndex > -1)
            {
               this.ShowDLCImage(param1.target.selectedIndex);
            }
         }
      }
      
      public function InvalidateSaveList() : *
      {
         this.SaveLoadObj.List_mc.ClearList();
         this.SaveLoadObj.List_mc.InvalidateData();
      }
      
      private function UpdateButtons(param1:String) : *
      {
         switch(param1)
         {
            case this.MAIN_STATE:
               this.XButton.ButtonVisible = false;
               this.ConfirmButton.ButtonVisible = false;
               this.QuitToDesktopButton.ButtonVisible = false;
               this.CancelButton.ButtonVisible = false;
               this.YButton.ButtonText = "$CHANGEUSER";
               this.YButton.ButtonEnabled = true;
               this.YButton.ButtonVisible = !this.bSplashScreen && Boolean(this.bShowChangeUserOption);
               this.VersionText_tf.visible = false;
               break;
            case this.SAVE_LOAD_STATE:
               this.XButton.ButtonVisible = true;
               this.ConfirmButton.ButtonVisible = uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
               this.ConfirmButton.ButtonText = "$CONFIRM";
               this.QuitToDesktopButton.ButtonVisible = false;
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$CANCEL";
               this.VersionText_tf.visible = false;
               if(this.SaveLoadObj.isSaving)
               {
                  this.YButton.ButtonVisible = false;
               }
               else
               {
                  this.YButton.ButtonVisible = true;
                  this.YButton.ButtonText = "$SELECT CHARACTER";
                  this.YButton.ButtonEnabled = true;
               }
               break;
            case this.QUIT_CONFIRM_STATE:
               this.VersionText_tf.visible = false;
               if(Boolean(this.PauseMode) && Boolean(this.AllowQuitToDesktop))
               {
                  this.QuitToDesktopButton.ButtonVisible = true;
                  this.ConfirmButton.ButtonText = "$MAIN MENU";
               }
            case this.CONTINUE_CONFIRM_STATE:
            case this.NEW_CONFIRM_STATE:
            case this.SAVE_LOAD_CONFIRM_STATE:
            case this.DELETE_SAVE_CONFIRM_STATE:
            case this.DEFAULT_SETTINGS_CONFIRM_STATE:
               this.XButton.ButtonVisible = false;
               this.ConfirmButton.ButtonVisible = true;
               this.ConfirmButton.ButtonText = "$CONFIRM";
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$CANCEL";
               this.YButton.ButtonVisible = false;
               this.VersionText_tf.visible = param1 == this.DEFAULT_SETTINGS_CONFIRM_STATE;
               break;
            case this.HELP_STATE:
               this.XButton.ButtonVisible = false;
               this.ConfirmButton.ButtonVisible = false;
               this.QuitToDesktopButton.ButtonVisible = false;
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$BACK";
               this.YButton.ButtonVisible = false;
               this.VersionText_tf.visible = false;
               break;
            case this.DLC_STATE:
               this.XButton.ButtonVisible = false;
               this.QuitToDesktopButton.ButtonVisible = false;
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$BACK";
               this.VersionText_tf.visible = false;
               break;
            case this.OPTIONS_LISTS_STATE:
            case this.INPUT_MAPPING_STATE:
               this.YButton.ButtonText = "$DEFAULTS";
               this.YButton.ButtonEnabled = true;
               this.YButton.ButtonVisible = true;
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$BACK";
               this.XButton.ButtonVisible = false;
               this.ConfirmButton.ButtonVisible = false;
               this.VersionText_tf.visible = true;
               break;
            case this.SETTINGS_CATEGORY_STATE:
               this.YButton.ButtonVisible = false;
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$BACK";
               this.XButton.ButtonVisible = false;
               this.ConfirmButton.ButtonVisible = false;
               this.VersionText_tf.visible = true;
               break;
            case this.CHARACTER_SELECT_STATE:
               this.YButton.ButtonVisible = false;
               this.XButton.ButtonVisible = uiPlatform == PlatformChangeEvent.PLATFORM_PS4;
               this.CancelButton.ButtonVisible = true;
               this.CancelButton.ButtonText = "$BACK";
               this.ConfirmButton.ButtonVisible = true;
               this.ConfirmButton.ButtonText = "$SELECT";
               this.VersionText_tf.visible = false;
         }
      }
      
      private function OnSaveListOpenSuccess(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.MainPanel_mc.List_mc.selectedIndex > -1)
         {
            _loc2_ = this.MainPanel_mc.List_mc.entryList[this.MainPanel_mc.List_mc.selectedIndex];
            if(_loc2_.index == this.SAVE_INDEX || _loc2_.index == this.LOAD_INDEX)
            {
               if(this.SaveLoadObj.numSaves > 0)
               {
                  this.BGSCodeObj.PlayOKSound();
                  this.EndState();
                  this.StartState(this.SAVE_LOAD_STATE);
               }
               else
               {
                  this.BGSCodeObj.PlayCancelSound();
               }
            }
         }
         else
         {
            this.MainPanel_mc.List_mc.selectedIndex = 0;
         }
      }
      
      private function DoSaveGame() : *
      {
         this.SaveDelayTimer.reset();
         this.BGSCodeObj.FinishSaveGame(this.SaveLoadObj.selectedIndex);
         this.bMenuClosing = false;
         this.onCancelPress();
         this.onCancelPress();
         this.SetToMenu();
      }
      
      private function ConfirmSaveGame(param1:Event) : *
      {
         this.SaveLoadObj.List_mc.disableInput = true;
         this.SaveLoadObj.confirming = true;
         if(this.strCurrentState == this.SAVE_LOAD_STATE)
         {
            if(this.SaveLoadObj.List_mc.selectedIndex == 0)
            {
               this.strCurrentState = this.SAVE_LOAD_CONFIRM_STATE;
               this.onAcceptPress();
            }
            else
            {
               GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"$Overwrite?",false);
               this.StartState(this.SAVE_LOAD_CONFIRM_STATE);
               this.BGSCodeObj.PlayOKSound();
            }
         }
      }
      
      private function ConfirmLoadGame(param1:Event) : *
      {
         this.SaveLoadObj.List_mc.disableInput = true;
         this.SaveLoadObj.confirming = true;
         if(this.strCurrentState == this.SAVE_LOAD_STATE)
         {
            GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"$ConfirmLoad",false);
            this.StartState(this.SAVE_LOAD_CONFIRM_STATE);
            this.BGSCodeObj.PlayOKSound();
         }
      }
      
      public function ShowMenu() : *
      {
         this.visible = true;
      }
      
      public function HideMenu() : *
      {
         this.visible = false;
      }
      
      private function StartState(param1:String) : *
      {
         var _loc3_:Object = null;
         this.ShowHelpBackgrounds(false);
         this.SettingsPanel_mc.SettingsList_mc.disableSelection = true;
         this.HelpPanel_mc.HelpList_mc.visible = false;
         this.HelpPanel_mc.HelpList_mc.disableSelection = true;
         var _loc2_:* = true;
         switch(param1)
         {
            case this.CONTINUE_CONFIRM_STATE:
               this.SaveLoadObj.List_mc.selectedIndex = 0;
               this.SaveLoadHolder_mc.Panel_mc.continueMode = true;
               this.ConfirmPanel_mc.confirmState = param1;
               this.ConfirmPanel_mc.returnType = this.strCurrentState;
               if(this.BGSCodeObj.ShowContinueSecondPanel())
               {
                  this.SaveLoadHolder_mc.gotoAndPlay("start");
                  this.ShowSecondPanelBackground(true);
               }
               else
               {
                  _loc2_ = false;
               }
               break;
            case this.DELETE_SAVE_CONFIRM_STATE:
            case this.SAVE_LOAD_CONFIRM_STATE:
               this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
               this.ShowSecondPanelBackground(true);
               this.ConfirmPanel_mc.confirmState = param1;
               this.ConfirmPanel_mc.returnType = this.strCurrentState;
               this.ConfirmPanel_mc.gotoAndPlay(1);
               break;
            case this.NEW_CONFIRM_STATE:
            case this.QUIT_CONFIRM_STATE:
            case this.DEFAULT_SETTINGS_CONFIRM_STATE:
               this.ConfirmPanel_mc.confirmState = param1;
               this.ConfirmPanel_mc.returnType = this.strCurrentState;
               break;
            case this.SETTINGS_CATEGORY_STATE:
               setChildIndex(this.SettingsPanel_mc,numChildren - 1);
               this.SettingsPanel_mc.SettingsList_mc.disableSelection = false;
               this.ShowSecondPanelBackground(true);
               this.SettingsPanel_mc.SettingsList_mc.InvalidateData();
               break;
            case this.OPTIONS_LISTS_STATE:
               if(this.OptionsPanel_mc.Fader_mc.List_mc.entryList[0].guideText)
               {
                  GlobalFunc.SetText(this.OptionsPanel_mc.GuideText_tf,this.OptionsPanel_mc.Fader_mc.List_mc.entryList[0].guideText,false);
               }
               else
               {
                  GlobalFunc.SetText(this.OptionsPanel_mc.GuideText_tf,"",false);
               }
               this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
               break;
            case this.SAVE_LOAD_STATE:
            case this.INPUT_MAPPING_STATE:
               this.ShowSecondPanelBackground(true);
               break;
            case this.HELP_STATE:
               setChildIndex(this.HelpPanel_mc,numChildren - 1);
               this.HelpPanel_mc.HelpList_mc.visible = true;
               this.HelpPanel_mc.HelpList_mc.disableSelection = false;
               this.HelpPanel_mc.HelpList_mc.entryList.splice(0);
               this.BGSCodeObj.PopulateHelpTopics(this.HelpPanel_mc.HelpList_mc.entryList);
               this.HelpPanel_mc.HelpList_mc.InvalidateData();
               this.HelpPanel_mc.HelpList_mc.disableInput = false;
               this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
               this.HelpPanel_mc.HelpList_mc.selectedIndex = this.iHelpTopicIndex;
               this.HelpUpdateScrollIndicators(null);
               setChildIndex(this.BackgroundAndBracketsHelpTopic_mc,numChildren - 1);
               this.ShowSecondPanelBackground(false);
               this.ShowHelpBackgrounds(true);
               this.MainPanel_mc.visible = false;
               break;
            case this.DLC_STATE:
               setChildIndex(this.DLCPanel_mc,numChildren - 1);
               this.ShowSecondPanelBackground(true,true);
               this.BGSCodeObj.PopulateDLCList(this.DLCPanel_mc.List_mc.entryList,-1);
               for each(_loc3_ in this.DLCPanel_mc.List_mc.entryList)
               {
                  _loc3_.text = "$" + _loc3_.text;
               }
               this.DLCPanel_mc.List_mc.InvalidateData();
               this.DLCPanel_mc.EmptyWarning_mc.visible = this.DLCPanel_mc.List_mc.entryList.length <= 0;
               this.DLCPanel_mc.List_mc.disableSelection = false;
               this.DLCPanel_mc.List_mc.disableInput = false;
               this.DLCPanel_mc.List_mc.selectedIndex = 0;
               this.ShowDLCImage(0);
               break;
            case this.BETHESDANET_STATE:
               if(this.GamerTag_mc.visible == true)
               {
                  this.ShouldShowGamerTagAndIcon = true;
                  this.GamerTag_mc.visible = false;
                  this.GamerIcon_mc.visible = false;
               }
               setChildIndex(this.ModManager_mc,numChildren - 1);
               this.SetToCredits();
               this.ModManager_Loader.load(new URLRequest("Main_ModManager.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
               break;
            case this.CREDIT_STATE:
               this.BGSCodeObj.ShowCreditMenu();
               param1 = this.MAIN_STATE;
               break;
            default:
               this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
         }
         this.CancelButton.ButtonText = param1 == this.SETTINGS_CATEGORY_STATE?"$BACK":"$CANCEL";
         this.currentState = param1;
         if(this.GetPanelForState(param1) != null && Boolean(_loc2_))
         {
            this.GetPanelForState(param1).gotoAndPlay("start");
         }
      }
      
      private function HideDeleteConfirmCancelButtons() : *
      {
         GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"",false);
         this.XButton.ButtonVisible = false;
         this.ConfirmButton.ButtonVisible = false;
         this.CancelButton.ButtonVisible = false;
      }
      
      private function EndState() : *
      {
         if(this.GetPanelForState(this.strCurrentState) != null)
         {
            this.GetPanelForState(this.strCurrentState).gotoAndPlay("end");
         }
         switch(this.strCurrentState)
         {
            case this.CONTINUE_CONFIRM_STATE:
               this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
               this.ShowSecondPanelBackground(false);
               this.HideDeleteConfirmCancelButtons();
               this.currentState = this.MAIN_STATE;
               break;
            case this.SAVE_LOAD_CONFIRM_STATE:
            case this.DELETE_SAVE_CONFIRM_STATE:
               this.SaveLoadHolder_mc.Panel_mc.continueMode = false;
               this.HideDeleteConfirmCancelButtons();
               this.currentState = this.SAVE_LOAD_STATE;
               this.SaveLoadObj.confirming = false;
               break;
            case this.SAVE_LOAD_STATE:
               this.ShowSecondPanelBackground(false);
               this.HideDeleteConfirmCancelButtons();
               this.currentState = this.MAIN_STATE;
               break;
            case this.NEW_CONFIRM_STATE:
            case this.QUIT_CONFIRM_STATE:
               this.HideDeleteConfirmCancelButtons();
               this.currentState = this.MAIN_STATE;
               break;
            case this.DEFAULT_SETTINGS_CONFIRM_STATE:
               this.currentState = this.ConfirmPanel_mc.returnType;
               break;
            case this.SETTINGS_CATEGORY_STATE:
               this.SettingsPanel_mc.SettingsList_mc.disableSelection = true;
               this.ShowSecondPanelBackground(false);
               this.currentState = this.MAIN_STATE;
               break;
            case this.HELP_STATE:
               this.HelpPanel_mc.HelpList_mc.visible = false;
               this.HelpPanel_mc.HelpList_mc.disableSelection = true;
               this.ShowSecondPanelBackground(false);
               this.currentState = this.MAIN_STATE;
               this.ShowHelpBackgrounds(false);
               this.MainPanel_mc.visible = true;
               break;
            case this.DLC_STATE:
               this.ShowSecondPanelBackground(false);
               this.currentState = this.MAIN_STATE;
               break;
            case this.BETHESDANET_STATE:
               if(this.ShouldShowGamerTagAndIcon)
               {
                  this.GamerTag_mc.visible = true;
                  this.GamerIcon_mc.visible = true;
                  this.ShouldShowGamerTagAndIcon = false;
               }
               this.ModManager_mc.removeChild(this.ModManager_Loader);
               this.ModManager_Loader.unloadAndStop();
               this.ButtonHintBar_mc.SetButtonHintData(this.standardButtonHintDataV);
               this.SetToMenu();
               this.currentState = this.MAIN_STATE;
               break;
            case this.OPTIONS_LISTS_STATE:
            case this.INPUT_MAPPING_STATE:
               this.currentState = this.SETTINGS_CATEGORY_STATE;
               break;
            default:
               this.currentState = this.MAIN_STATE;
         }
      }
      
      private function GetPanelForState(param1:String) : MovieClip
      {
         switch(param1)
         {
            case this.MAIN_STATE:
               return this.MainPanel_mc;
            case this.SAVE_LOAD_STATE:
               return this.SaveLoadHolder_mc;
            case this.CONTINUE_CONFIRM_STATE:
               return this.SaveLoadHolder_mc;
            case this.SETTINGS_CATEGORY_STATE:
               return this.SettingsPanel_mc;
            case this.OPTIONS_LISTS_STATE:
               return this.OptionsPanel_mc;
            case this.INPUT_MAPPING_STATE:
               return this.ControlsPanel_mc;
            case this.HELP_STATE:
               return this.HelpPanel_mc;
            case this.DLC_STATE:
               return this.DLCPanel_mc;
            case this.BETHESDANET_STATE:
               return null;
            case this.NEW_CONFIRM_STATE:
            case this.QUIT_CONFIRM_STATE:
            case this.DEFAULT_SETTINGS_CONFIRM_STATE:
            case this.DELETE_SAVE_CONFIRM_STATE:
            case this.SAVE_LOAD_CONFIRM_STATE:
               return this.ConfirmPanel_mc;
            default:
               return null;
         }
      }
      
      private function UpdateStateFocus(param1:String) : *
      {
         switch(param1)
         {
            case this.MAIN_STATE:
               stage.focus = this.MainPanel_mc.List_mc;
               break;
            case this.SAVE_LOAD_STATE:
               stage.focus = this.SaveLoadObj.List_mc;
               this.SaveLoadObj.List_mc.disableInput = false;
               break;
            case this.SETTINGS_CATEGORY_STATE:
               stage.focus = this.SettingsPanel_mc.SettingsList_mc;
               this.SettingsPanel_mc.SettingsList_mc.InvalidateData();
               break;
            case this.HELP_STATE:
               this.HelpPanel_mc.HelpList_mc.disableSelection = false;
               stage.focus = this.HelpPanel_mc.HelpList_mc;
               break;
            case this.OPTIONS_LISTS_STATE:
               stage.focus = this.OptionsPanel_mc.Fader_mc.List_mc;
               break;
            case this.INPUT_MAPPING_STATE:
               stage.focus = this.ControlsPanel_mc.Fader_mc.List_mc;
               this.ControlsPanel_mc.Fader_mc.List_mc.selectedIndex = 0;
               break;
            case this.CHARACTER_SELECT_STATE:
               stage.focus = this.CharacterSelectList_mc;
               this.CharacterSelectList_mc.InvalidateData();
               break;
            case this.DLC_STATE:
               stage.focus = this.DLCPanel_mc.List_mc;
               break;
            case this.CONTINUE_CONFIRM_STATE:
            case this.NEW_CONFIRM_STATE:
            case this.SAVE_LOAD_CONFIRM_STATE:
            case this.DELETE_SAVE_CONFIRM_STATE:
            case this.QUIT_CONFIRM_STATE:
               stage.focus = this;
         }
         this.MainPanel_mc.List_mc.InvalidateData();
      }
      
      public function BackOutFromLoadGame() : *
      {
         this.bMenuClosing = false;
         this.onCancelPress();
         this.SetToMenu();
         this.SaveLoadHolder_mc.visible = false;
      }
      
      public function ReturnToMainState() : *
      {
         this.bMenuClosing = false;
         while(this.strCurrentState != this.MAIN_STATE && this.strCurrentState != null)
         {
            this.onCancelPress(true,false);
         }
         this.SetToMenu();
      }
      
      public function onYButtonPressed() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.strCurrentState == this.OPTIONS_LISTS_STATE || this.strCurrentState == this.INPUT_MAPPING_STATE)
         {
            GlobalFunc.SetText(this.ConfirmPanel_mc.Text_mc.TextPulse_mc.textField,"$Reset settings to default values?",false);
            this.StartState(this.DEFAULT_SETTINGS_CONFIRM_STATE);
            _loc1_ = true;
         }
         else if(this.strCurrentState == this.SAVE_LOAD_STATE && !this.SaveLoadObj.isSaving)
         {
            this.ShowCharacterList();
            _loc1_ = true;
         }
         else if(this.strCurrentState == this.QUIT_CONFIRM_STATE && Boolean(this.PauseMode) && Boolean(this.AllowQuitToDesktop))
         {
            this.onQuitToDesktopPress();
            _loc1_ = true;
         }
         else if(this.strCurrentState == this.MAIN_STATE && !this.bSplashScreen && Boolean(this.bShowChangeUserOption) && Boolean(this.YButton.ButtonVisible))
         {
            this.BGSCodeObj.ShowChangeUser();
            _loc1_ = true;
         }
         else if(this.strCurrentState == this.DLC_STATE && Boolean(this.YButton.ButtonVisible))
         {
            this.BGSCodeObj.DeleteDLC(this.DLCPanel_mc.List_mc.selectedIndex);
         }
         return _loc1_;
      }
      
      public function ShowCharacterList() : *
      {
         this.BGSCodeObj.PopulateCharacterList(this.CharacterSelectList_mc.entryList);
         this.CharacterSelectList_mc.visible = true;
         this.CharacterSelectList_mc.selectedIndex = 0;
         this.CharacterSelectList_mc.InvalidateData();
         this.SaveLoadObj.visible = false;
         this.currentState = this.CHARACTER_SELECT_STATE;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_ && this.strCurrentState == this.BETHESDANET_STATE && this.ModManager_Loader.content is ISubmenu)
         {
            _loc3_ = (this.ModManager_Loader.content as ISubmenu).ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !param2 && !this.shouldIgnoreInput)
         {
            if((param1 == "DeleteSave" || param1 == "XButton") && (this.strCurrentState == this.SAVE_LOAD_STATE || uiPlatform == PlatformChangeEvent.PLATFORM_PS4 && this.strCurrentState == this.CHARACTER_SELECT_STATE))
            {
               this.onXButtonPressed();
               _loc3_ = true;
            }
            else if(param1 == "ResetToDefault" || param1 == "YButton")
            {
               _loc3_ = this.onYButtonPressed();
            }
            else if(param1 == "Cancel" || !this.bSplashScreen && param1 == "Start")
            {
               _loc3_ = this.onCancelPress();
            }
            else if(param1 == "Accept" && (this.strCurrentState == this.DEFAULT_SETTINGS_CONFIRM_STATE || this.strCurrentState == this.DLC_STATE))
            {
               _loc3_ = this.onAcceptPress();
            }
         }
         if(!_loc3_ && this.strCurrentState == this.HELP_STATE && Boolean(param2) && stage.focus == this.HelpText)
         {
            switch(param1)
            {
               case "Up":
               case "Forward":
                  this.HelpText.scrollV--;
                  break;
               case "Down":
               case "Back":
                  this.HelpText.scrollV++;
            }
         }
         return _loc3_;
      }
      
      public function SetToLoading(param1:Boolean = false) : *
      {
         this.BGSCodeObj.SetBackgroundVisible(this.MAIN_PANEL_BACKGROUND,false);
         this.ShowSecondPanelBackground(false);
         this.CharacterSelectList_mc.visible = false;
         this.SaveLoadHolder_mc.visible = false;
         this.MainPanel_mc.visible = false;
         this.ConfirmPanel_mc.visible = false;
         this.VersionText_tf.visible = false;
         this.Spinner_mc.visible = true;
         this.SplashScreenText_tf.visible = false;
         this.BethesdaLogo_mc.visible = false;
         this.bSplashScreen = false;
         this.YButton.ButtonVisible = false;
         this.BlackLoading_mc.visible = param1;
      }
      
      public function SetToMenu() : *
      {
         this.BGSCodeObj.SetBackgroundVisible(this.MAIN_PANEL_BACKGROUND,true);
         this.SaveLoadHolder_mc.visible = true;
         this.MainPanel_mc.visible = true;
         this.ConfirmPanel_mc.visible = true;
         this.VersionText_tf.visible = false;
         this.Spinner_mc.visible = false;
         this.SplashScreenText_tf.visible = false;
         this.BethesdaLogo_mc.visible = !this.PauseMode;
         this.bSplashScreen = false;
         this.YButton.ButtonVisible = this.bShowChangeUserOption;
         this.MainPanel_mc.List_mc.InvalidateData();
         this.BlackLoading_mc.visible = false;
      }
      
      public function SetToSplashScreen() : *
      {
         this.BGSCodeObj.SetBackgroundVisible(this.MAIN_PANEL_BACKGROUND,false);
         this.SaveLoadHolder_mc.visible = false;
         this.MainPanel_mc.visible = false;
         this.ConfirmPanel_mc.visible = false;
         this.VersionText_tf.visible = false;
         this.Spinner_mc.visible = false;
         this.SplashScreenText_tf.visible = false;
         this.bSplashScreen = true;
         this.YButton.ButtonVisible = false;
         this.BethesdaLogo_mc.visible = false;
         this.BlackLoading_mc.visible = false;
      }
      
      public function SetToCredits() : *
      {
         this.BGSCodeObj.SetBackgroundVisible(this.MAIN_PANEL_BACKGROUND,false);
         this.SaveLoadHolder_mc.visible = false;
         this.MainPanel_mc.visible = false;
         this.ConfirmPanel_mc.visible = false;
         this.VersionText_tf.visible = false;
         this.Spinner_mc.visible = false;
         this.SplashScreenText_tf.visible = false;
         this.bSplashScreen = false;
         this.BlackLoading_mc.visible = false;
         this.BethesdaLogo_mc.visible = false;
      }
      
      public function ShowSecondPanelBackground(param1:Boolean, param2:Boolean = false) : *
      {
         this.BGSCodeObj.SetBackgroundVisible(this.SECOND_PANEL_BACKGROUND,param1);
         if(param1)
         {
            this.BackgroundAndBrackets_mc.LoadPanelBackground_mc.width = !!param2?this.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.width:this.BackgroundAndBrackets_mc.LoadPanelBrackets_mc.width;
         }
         this.BackgroundAndBrackets_mc.LoadPanelBrackets_mc.visible = param1 && !param2;
         this.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.visible = param1 && param2;
      }
      
      public function ShowHelpBackgrounds(param1:Boolean) : *
      {
         this.BGSCodeObj.SetBackgroundVisible(this.HELP_TOPIC_BACKGROUND,param1);
         this.BGSCodeObj.SetBackgroundVisible(this.HELP_LIST_BACKGROUND,param1);
         if(param1)
         {
            this.HelpText.addEventListener(Event.SCROLL,this.HelpUpdateScrollIndicators);
         }
         else
         {
            this.HelpText.removeEventListener(Event.SCROLL,this.HelpUpdateScrollIndicators);
         }
         this.HelpText.visible = param1;
         this.HelpTitleText.visible = param1;
         this.HelpScrollUp.visible = param1;
         this.HelpScrollDown.visible = param1;
         this.HelpUpdateScrollIndicators(null);
         this.BackgroundAndBracketsHelpTopic_mc.visible = param1;
      }
      
      public function onSettingsValueChange(param1:Event) : *
      {
         this.BGSCodeObj.onSettingsValueChange(param1.target.ID,param1.target.value);
         if(param1.target.hudColorUpdate == true)
         {
            this.BGSCodeObj.onHUDColorUpdate();
         }
         else if(param1.target.pipboyColorUpdate == true)
         {
            this.BGSCodeObj.onPipboyColorUpdate();
         }
         else if(param1.target.difficultyUpdate == true)
         {
            this.RequestOptions(0);
         }
         this.bSettingsChanged = true;
      }
      
      private function onHelpListItemSelect() : *
      {
         var _loc1_:* = undefined;
         if(this.HelpPanel_mc.HelpList_mc.selectedIndex > -1)
         {
            this.iHelpTopicIndex = this.HelpPanel_mc.HelpList_mc.selectedIndex;
            _loc1_ = this.HelpPanel_mc.HelpList_mc.entryList[this.iHelpTopicIndex];
            if(_loc1_ != null)
            {
               GlobalFunc.SetText(this.HelpText,this.BGSCodeObj.RequestHelpText(this.iHelpTopicIndex),true);
               this.HelpTitleText.text = this.BGSCodeObj.RequestHelpTitle(this.iHelpTopicIndex);
               this.HelpText.scrollV = 1;
               this.HelpUpdateScrollIndicators(null);
            }
         }
      }
      
      private function RequestOptions(param1:uint) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:uint = 0;
         var _loc2_:Array = null;
         switch(param1)
         {
            case 0:
               _loc2_ = [{
                  "text":(!!this.PauseMode?"$Difficulty":"$New Game Difficulty"),
                  "movieType":1,
                  "options":["$Very Easy","$Easy","$Normal","$Hard","$Very Hard","$Survival"]
               },{
                  "text":"$Invert Y",
                  "movieType":2
               },{
                  "text":"$Look Sensitivity",
                  "movieType":0
               },{
                  "text":"$Vibration",
                  "movieType":2
               },{
                  "text":"$Controller",
                  "movieType":2
               },{
                  "text":"$Save on Rest",
                  "movieType":2
               },{
                  "text":"$Save on Wait",
                  "movieType":2
               },{
                  "text":"$Save on Travel",
                  "movieType":2
               },{
                  "text":"$Save in Pipboy",
                  "movieType":1,
                  "options":["$5 Mins","$10 Mins","$15 Mins","$30 Mins","$45 Mins","$60 Mins","$Disabled"]
               },{
                  "text":"$Companion Enabled",
                  "movieType":2
               }];
               if(!this._IsSurvivalAvailable)
               {
                  _loc2_[0].options.pop();
               }
               this.BGSCodeObj.RequestGameplayOptions(_loc2_);
               break;
            case 1:
               this.ControlsPanel_mc.Fader_mc.List_mc.entryList.length = 0;
               this.BGSCodeObj.RequestInputMappings(this.ControlsPanel_mc.Fader_mc.List_mc.entryList);
               this.ControlsPanel_mc.Fader_mc.List_mc.entryList.sortOn("sortIndex",Array.NUMERIC);
               this.ControlsPanel_mc.Fader_mc.List_mc.InvalidateData();
               this.ControlsPanel_mc.Fader_mc.List_mc.selectedIndex = 0;
               this.EndState();
               this.StartState(this.INPUT_MAPPING_STATE);
               this.BGSCodeObj.PlayOKSound();
               break;
            case 2:
               _loc2_ = [{
                  "text":"$Actor Fade",
                  "movieType":0
               },{
                  "text":"$Item Fade",
                  "movieType":0
               },{
                  "text":"$Object Fade",
                  "movieType":0
               },{
                  "text":"$Grass Fade",
                  "movieType":0
               },{
                  "text":"$Crosshair",
                  "movieType":2
               },{
                  "text":"$Dialogue Camera",
                  "movieType":2
               },{
                  "text":"$Dialogue Subtitles",
                  "movieType":2
               },{
                  "text":"$General Subtitles",
                  "movieType":2
               },{
                  "text":"$Show Floating Markers",
                  "movieType":2
               },{
                  "text":"$Show Active Effects On HUD",
                  "movieType":1,
                  "options":["$Disabled","$Detrimental","$All"]
               },{
                  "text":"$HUD Opacity",
                  "movieType":0
               },{
                  "text":"$HUDColorR",
                  "movieType":0
               },{
                  "text":"$HUDColorG",
                  "movieType":0
               },{
                  "text":"$HUDColorB",
                  "movieType":0
               },{
                  "text":"$PipboyColorR",
                  "movieType":0
               },{
                  "text":"$PipboyColorG",
                  "movieType":0
               },{
                  "text":"$PipboyColorB",
                  "movieType":0
               }];
               this.BGSCodeObj.RequestDisplayOptions(_loc2_);
               break;
            case 3:
               if(!this.bAudioSettingsDisabled)
               {
                  _loc2_ = [{
                     "text":"$Master",
                     "movieType":0
                  }];
                  this.BGSCodeObj.RequestAudioOptions(_loc2_);
                  for(_loc4_ in _loc2_)
                  {
                     _loc2_[_loc4_].movieType = 0;
                  }
               }
         }
         var _loc3_:* = _loc2_ != null;
         if(_loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(_loc2_[_loc5_].ID == undefined)
               {
                  _loc2_.splice(_loc5_,1);
               }
               else
               {
                  _loc5_++;
               }
            }
            this.OptionsPanel_mc.Fader_mc.List_mc.entryList = _loc2_;
            this.OptionsPanel_mc.Fader_mc.List_mc.allowValueOverwrite = true;
            this.OptionsPanel_mc.Fader_mc.List_mc.InvalidateData();
            this.OptionsPanel_mc.Fader_mc.List_mc.allowValueOverwrite = false;
         }
         return _loc3_;
      }
      
      private function onSettingsListItemPress() : *
      {
         if(this.RequestOptions(this.SettingsPanel_mc.SettingsList_mc.selectedIndex))
         {
            this.OptionsPanel_mc.Fader_mc.List_mc.selectedIndex = 0;
            if(this.GetPanelForState(this.SETTINGS_CATEGORY_STATE) != null)
            {
               this.GetPanelForState(this.SETTINGS_CATEGORY_STATE).gotoAndPlay("end");
            }
            this.StartState(this.OPTIONS_LISTS_STATE);
            this.BGSCodeObj.PlayOKSound();
         }
      }
      
      private function ResetSettingsToDefaults() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = this.OptionsPanel_mc.Fader_mc.List_mc.entryList;
         for(_loc2_ in _loc1_)
         {
            if(_loc1_[_loc2_].defaultVal != undefined)
            {
               _loc1_[_loc2_].value = _loc1_[_loc2_].defaultVal;
               this.BGSCodeObj.onSettingsValueChange(_loc1_[_loc2_].ID,_loc1_[_loc2_].value);
            }
         }
         this.OptionsPanel_mc.Fader_mc.List_mc.allowValueOverwrite = true;
         this.OptionsPanel_mc.Fader_mc.List_mc.UpdateList();
         this.OptionsPanel_mc.Fader_mc.List_mc.allowValueOverwrite = false;
         this.BGSCodeObj.onHUDColorUpdate();
         this.BGSCodeObj.onPipboyColorUpdate();
         this.bSettingsChanged = true;
      }
      
      private function onInputMappingPress() : *
      {
         if(this.bRemapMode == false && this.strCurrentState == this.INPUT_MAPPING_STATE)
         {
            this.ControlsPanel_mc.Fader_mc.List_mc.disableSelection = true;
            this.bRemapMode = true;
            GlobalFunc.SetText(this.RemapPrompt_mc.textField,"$Press a button to map to this action.",false);
            this.BGSCodeObj.PlayOKSound();
            this.BGSCodeObj.StartRemapMode(this.ControlsPanel_mc.Fader_mc.List_mc.selectedEntry.text,this.ControlsPanel_mc.Fader_mc.List_mc.entryList);
         }
      }
      
      public function onFinishRemapMode(param1:Boolean) : *
      {
         if(param1)
         {
            this.HideMessageText();
            this.ControlsPanel_mc.Fader_mc.List_mc.entryList.sortOn("sortIndex",Array.NUMERIC);
            this.ControlsPanel_mc.Fader_mc.List_mc.UpdateList();
            this.bSettingsChanged = true;
            this.BGSCodeObj.PlayOKSound();
         }
         else
         {
            GlobalFunc.SetText(this.RemapPrompt_mc.textField,"$That button is reserved.",false);
            this.BGSCodeObj.PlayCancelSound();
            this.HideMessageTextTimer.start();
         }
         this.ControlsPanel_mc.Fader_mc.List_mc.disableSelection = false;
         this.DebounceRemapModeTimer.start();
      }
      
      private function ClearRemapMode() : *
      {
         this.DebounceRemapModeTimer.reset();
         this.bRemapMode = false;
      }
      
      private function ResetControlsToDefaults() : *
      {
         this.BGSCodeObj.ResetControlsToDefaults();
         this.ControlsPanel_mc.Fader_mc.List_mc.entryList.splice(0,this.ControlsPanel_mc.Fader_mc.List_mc.entryList.length);
         this.BGSCodeObj.RequestInputMappings(this.ControlsPanel_mc.Fader_mc.List_mc.entryList);
         this.ControlsPanel_mc.Fader_mc.List_mc.entryList.sortOn("sortIndex",Array.NUMERIC);
         this.ControlsPanel_mc.Fader_mc.List_mc.UpdateList();
         this.bSettingsChanged = true;
      }
      
      private function HideMessageText() : *
      {
         this.HideMessageTextTimer.reset();
         GlobalFunc.SetText(this.RemapPrompt_mc.textField," ",false);
      }
      
      private function SaveSettings() : *
      {
         this.SavingSettingsTimer.reset();
         this.SavingSettingsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.SaveSettings);
         this.BGSCodeObj.SaveSettings();
      }
      
      public function onSettingsSaved() : *
      {
         this.bSavingSettings = false;
         this.bSettingsChanged = false;
         GlobalFunc.SetText(this.RemapPrompt_mc.textField," ",false);
         this.EndState();
         this.StartState(this.MAIN_STATE);
      }
      
      public function onResetSettings() : *
      {
         this.OptionsPanel_mc.Fader_mc.List_mc.disableInput = this.ControlsPanel_mc.Fader_mc.List_mc.disableInput = false;
         this.DebounceResetSettingsTimer.reset();
      }
      
      public function afterSaveLoadCheck(param1:Boolean, param2:Boolean) : *
      {
         var _loc4_:* = undefined;
         var _loc3_:uint = 0;
         while(_loc3_ < this.MainPanel_mc.List_mc.entryList.length)
         {
            _loc4_ = this.MainPanel_mc.List_mc.entryList[_loc3_];
            if(_loc4_.index == this.SAVE_INDEX)
            {
               _loc4_.disabled = param1;
            }
            else if(_loc4_.index == this.QUICKSAVE_INDEX)
            {
               _loc4_.disabled = param1;
            }
            else if(_loc4_.index == this.LOAD_INDEX)
            {
               _loc4_.disabled = param2;
            }
            _loc3_++;
         }
         this.MainPanel_mc.List_mc.UpdateList();
      }
      
      public function HelpUpdateScrollIndicators(param1:Event) : *
      {
         this.HelpScrollUp.visible = this.HelpText.scrollV > 1;
         if(this.HelpText.numLines >= this.HelpText.bottomScrollV)
         {
            this.HelpScrollDown.visible = this.HelpText.bottomScrollV < this.HelpText.numLines;
         }
         else
         {
            this.HelpScrollDown.visible = false;
         }
      }
      
      public function OnRightStickInput(param1:Number, param2:Number) : *
      {
         if(this.strCurrentState == this.HELP_STATE)
         {
            this.HelpScrollDeltaAccum = this.HelpScrollDeltaAccum + Math.abs(param2);
            if(this.HelpScrollDeltaAccum >= this.RIGHT_INPUT_SCROLL_THRESHOLD)
            {
               this.HelpScrollDeltaAccum = 0;
               if(param2 > 0.1)
               {
                  this.HelpText.scrollV--;
               }
               if(param2 < -0.1)
               {
                  this.HelpText.scrollV++;
               }
            }
         }
         else if(this.strCurrentState == this.BETHESDANET_STATE)
         {
            (this.ModManager_Loader.content as ISubmenu).OnRightStickInput(param1,param2);
         }
      }
      
      private function onHelpContentRollOver(param1:MouseEvent) : void
      {
         stage.focus = this.HelpText;
      }
      
      private function onHelpContentRollOut(param1:MouseEvent) : void
      {
         stage.focus = this.HelpPanel_mc.HelpList_mc;
      }
      
      private function onHelpContentScrollUpClicked(param1:MouseEvent) : void
      {
         this.HelpText.scrollV--;
      }
      
      private function onHelpContentScrollDownClicked(param1:MouseEvent) : void
      {
         this.HelpText.scrollV++;
      }
      
      private function onModManagerLoadComplete(param1:Event) : *
      {
         if(this.ModManager_Loader.content != null && this.ModManager_Loader.content is ISubmenu)
         {
            (this.ModManager_Loader.content as ISubmenu).codeObj = this.BGSCodeObj;
            (this.ModManager_Loader.content as ISubmenu).buttonHintBar = this.ButtonHintBar_mc;
            this.ModManager_mc.addChild(this.ModManager_Loader);
         }
      }
      
      private function onDLCImageLoadComplete(param1:Event) : *
      {
         var _loc2_:Number = this.DLCImageLoader.width;
         var _loc3_:Number = this.DLCImageLoader.height;
         this.DLCImageLoader.x = this.DLCImageSizer_mc.x;
         this.DLCImageLoader.y = this.DLCImageSizer_mc.y;
         this.DLCImageLoader.width = this.DLCImageSizer_mc.width;
         this.DLCImageLoader.height = this.DLCImageSizer_mc.height;
         this.DLCImageLoader.visible = true;
      }
      
      private function ShowDLCImage(param1:int) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this.DLCImageLoader.unloadAndStop();
         if(param1 > -1)
         {
            _loc2_ = this.DLCPanel_mc.List_mc.entryList[param1].owned;
            _loc3_ = this.DLCPanel_mc.List_mc.entryList[param1].installed;
            _loc4_ = this.DLCPanel_mc.List_mc.entryList[param1].available;
            _loc5_ = this.DLCPanel_mc.List_mc.entryList[param1].downloaded;
            this.ConfirmButton.ButtonVisible = uiPlatform != PlatformChangeEvent.PLATFORM_PS4 && uiPlatform != PlatformChangeEvent.PLATFORM_XB1 && !_loc2_ && Boolean(_loc4_);
            this.ConfirmButton.ButtonText = uiPlatform == PlatformChangeEvent.PLATFORM_PS4 || uiPlatform == PlatformChangeEvent.PLATFORM_XB1?"$STORE":"$BUY";
            _loc6_ = !_loc3_ && !_loc5_;
            _loc7_ = param1 == 5?3:param1 > 2?param1 + 1:param1;
            this.DLCImageLoader.load(new URLRequest("img://Textures\\Interface\\DLCBannerDLC0" + (_loc7_ + 1).toString() + (!!_loc6_?"Grey":"") + ".dds"));
            if(Boolean(_loc3_) || Boolean(_loc5_))
            {
               GlobalFunc.SetText(this.DLCPanel_mc.DLCInstalledText_tf,"$INSTALLED",false);
               this.DLCPanel_mc.DLCInstalledText_tf.alpha = 1;
            }
            else if(uiPlatform == PlatformChangeEvent.PLATFORM_PS4 || uiPlatform == PlatformChangeEvent.PLATFORM_XB1)
            {
               GlobalFunc.SetText(this.DLCPanel_mc.DLCInstalledText_tf,"$NOT INSTALLED",false);
               this.DLCPanel_mc.DLCInstalledText_tf.alpha = GlobalFunc.DIMMED_ALPHA;
            }
            else
            {
               this.DLCPanel_mc.DLCInstalledText_tf.alpha = 1;
               if(_loc4_)
               {
                  GlobalFunc.SetText(this.DLCPanel_mc.DLCInstalledText_tf,"$AVAILABLE",false);
                  this.DLCPanel_mc.DLCInstalledText_tf.alpha = GlobalFunc.DIMMED_ALPHA;
               }
               else
               {
                  GlobalFunc.SetText(this.DLCPanel_mc.DLCInstalledText_tf,"$COMING SOON",false);
                  this.DLCPanel_mc.DLCInstalledText_tf.alpha = GlobalFunc.DIMMED_ALPHA;
               }
            }
            if(uiPlatform == PlatformChangeEvent.PLATFORM_PS4)
            {
               this.YButton.ButtonVisible = false;
               this.YButton.ButtonText = "$DELETE";
            }
            else
            {
               this.YButton.ButtonVisible = false;
            }
         }
         else
         {
            this.ConfirmButton.ButtonVisible = false;
            this.YButton.ButtonVisible = false;
         }
         this.DLCPanel_mc.DLCInstalledText_tf.visible = param1 > -1;
      }
      
      public function updateDLCList(param1:Boolean) : void
      {
         var _loc2_:int = this.DLCPanel_mc.List_mc.selectedIndex;
         if(param1)
         {
            this.BGSCodeObj.PopulateDLCList(this.DLCPanel_mc.List_mc.entryList,_loc2_);
            this.DLCPanel_mc.List_mc.selectedIndex = _loc2_;
         }
         else
         {
            this.BGSCodeObj.PopulateDLCList(this.DLCPanel_mc.List_mc.entryList,-1);
         }
         this.ShowDLCImage(_loc2_);
      }
      
      public function get dlcList() : Object
      {
         return this.DLCPanel_mc.List_mc.entryList;
      }
      
      function __setProp_CharacterSelectList_mc_MenuObj_CharacterSelectList_0() : *
      {
         try
         {
            this.CharacterSelectList_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.CharacterSelectList_mc.disableSelection = false;
         this.CharacterSelectList_mc.listEntryClass = "SaveLoadListEntry";
         this.CharacterSelectList_mc.numListItems = 3;
         this.CharacterSelectList_mc.restoreListIndex = true;
         this.CharacterSelectList_mc.textOption = "None";
         this.CharacterSelectList_mc.verticalSpacing = 0;
         try
         {
            this.CharacterSelectList_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
