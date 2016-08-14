package MainMenu_fla
{
   import flash.display.MovieClip;
   
   public dynamic class MainListPanel_44 extends MovieClip
   {
       
      public var MainPanelBackground_mc:MovieClip;
      
      public var List_mc:MainMenuList;
      
      public function MainListPanel_44()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5);
         this.__setProp_List_mc_MainListPanel_List_0();
      }
      
      function __setProp_List_mc_MainListPanel_List_0() : *
      {
         try
         {
            this.List_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.List_mc.disableSelection = false;
         this.List_mc.listEntryClass = "MainMenuListEntry";
         this.List_mc.numListItems = 8;
         this.List_mc.restoreListIndex = true;
         this.List_mc.textOption = "None";
         this.List_mc.verticalSpacing = 1.2;
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
      
      function frame1() : *
      {
         gotoAndPlay("start");
      }
      
      function frame3() : *
      {
         stop();
      }
      
      function frame5() : *
      {
         stop();
      }
   }
}
