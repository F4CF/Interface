package MainMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class HelpPanel_mc_30 extends MovieClip
   {
       
      public var HelpList_mc:HelpList;
      
      public var background_mc:MovieClip;
      
      public var HelpListBrackets_mc:MovieClip;
      
      public function HelpPanel_mc_30()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5);
         this.__setProp_HelpList_mc_HelpPanel_mc_List_0();
      }
      
      function __setProp_HelpList_mc_HelpPanel_mc_List_0() : *
      {
         try
         {
            this.HelpList_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.HelpList_mc.disableSelection = false;
         this.HelpList_mc.listEntryClass = "MainMenuHelpListEntry";
         this.HelpList_mc.numListItems = 12;
         this.HelpList_mc.restoreListIndex = true;
         this.HelpList_mc.textOption = "None";
         this.HelpList_mc.verticalSpacing = 0;
         try
         {
            this.HelpList_mc["componentInspectorSetting"] = false;
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
