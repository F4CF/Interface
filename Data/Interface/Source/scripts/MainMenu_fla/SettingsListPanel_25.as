package MainMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class SettingsListPanel_25 extends MovieClip
   {
       
      public var SettingsList_mc:SettingsList;
      
      public function SettingsListPanel_25()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5);
         this.__setProp_SettingsList_mc_SettingsListPanel_List_0();
      }
      
      function __setProp_SettingsList_mc_SettingsListPanel_List_0() : *
      {
         try
         {
            this.SettingsList_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.SettingsList_mc.disableSelection = false;
         this.SettingsList_mc.listEntryClass = "SettingsCategoryListEntry";
         this.SettingsList_mc.numListItems = 4;
         this.SettingsList_mc.restoreListIndex = true;
         this.SettingsList_mc.textOption = "None";
         this.SettingsList_mc.verticalSpacing = 0;
         try
         {
            this.SettingsList_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
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
