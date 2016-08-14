package LooksMenu_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class FeatureListBrackets_5 extends MovieClip
   {
       
      public var UpperHorizontalLine_mc:MovieClip;
      
      public var BracketExtents_mc:MovieClip;
      
      public var LowerBracket_mc:MovieClip;
      
      public var Label_tf:TextField;
      
      public var UpperRightCorner_mc:MovieClip;
      
      public var UpperLeftCorner_mc:MovieClip;
      
      public function FeatureListBrackets_5()
      {
         super();
         this.__setProp_BracketExtents_mc_FeatureListBrackets_Layer1_0();
      }
      
      function __setProp_BracketExtents_mc_FeatureListBrackets_Layer1_0() : *
      {
         try
         {
            this.BracketExtents_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.BracketExtents_mc.bracketCornerLength = 6;
         this.BracketExtents_mc.bracketLineWidth = 1.5;
         this.BracketExtents_mc.bracketPaddingX = 0;
         this.BracketExtents_mc.bracketPaddingY = 0;
         this.BracketExtents_mc.BracketStyle = "horizontal";
         this.BracketExtents_mc.bShowBrackets = false;
         this.BracketExtents_mc.bUseShadedBackground = true;
         this.BracketExtents_mc.ShadedBackgroundMethod = "Shader";
         this.BracketExtents_mc.ShadedBackgroundType = "normal";
         try
         {
            this.BracketExtents_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
