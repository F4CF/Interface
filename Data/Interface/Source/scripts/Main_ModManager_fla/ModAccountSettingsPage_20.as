package Main_ModManager_fla
{
   import flash.display.MovieClip;
   
   public dynamic class ModAccountSettingsPage_20 extends MovieClip
   {
       
      public var Background_mc:MovieClip;
      
      public var List_mc:ModAccountSettingsList;
      
      public function ModAccountSettingsPage_20()
      {
         super();
         this.__setProp_List_mc_ModAccountSettingsPage_List_0();
      }
      
      function __setProp_List_mc_ModAccountSettingsPage_List_0() : *
      {
         try
         {
            this.List_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.List_mc.disableSelection = false;
         this.List_mc.listEntryClass = "ModAccountSettings_Entry";
         this.List_mc.numListItems = 3;
         this.List_mc.restoreListIndex = true;
         this.List_mc.textOption = "Shrink To Fit";
         this.List_mc.verticalSpacing = 0;
         try
         {
            this.List_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
