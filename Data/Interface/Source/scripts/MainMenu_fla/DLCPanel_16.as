package MainMenu_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class DLCPanel_16 extends MovieClip
   {
       
      public var EmptyWarning_mc:MovieClip;
      
      public var DLCInstalledText_tf:TextField;
      
      public var List_mc:DLCList;
      
      public function DLCPanel_16()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,5,this.frame6);
         this.__setProp_List_mc_DLCPanel_List_0();
      }
      
      function __setProp_List_mc_DLCPanel_List_0() : *
      {
         try
         {
            this.List_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.List_mc.disableSelection = true;
         this.List_mc.listEntryClass = "DLCListEntry";
         this.List_mc.numListItems = 8;
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
      
      function frame1() : *
      {
         visible = false;
         stop();
      }
      
      function frame4() : *
      {
         visible = true;
         stop();
      }
      
      function frame6() : *
      {
         visible = false;
         stop();
      }
   }
}
