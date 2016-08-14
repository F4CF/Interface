package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   import Shared.GlobalFunc;
   import scaleform.gfx.Extensions;
   
   public class InputMappingListEntry extends BSScrollingListEntry
   {
      
      private static const NameToTextMap:Object = {
         "Xenon_A":"A",
         "Xenon_B":"B",
         "Xenon_X":"C",
         "Xenon_Y":"D",
         "Xenon_Select":"E",
         "Xenon_LS":"F",
         "Xenon_L1":"G",
         "Xenon_L3":"H",
         "Xenon_L2":"I",
         "Xenon_L2R2":"J",
         "Xenon_RS":"K",
         "Xenon_R1":"L",
         "Xenon_R3":"M",
         "Xenon_R2":"N",
         "Xenon_Start":"O",
         "_Positive":"P",
         "_Negative":"Q",
         "_Question":"R",
         "_Neutral":"S",
         "Left":"T",
         "Right":"U",
         "Down":"V",
         "Up":"W",
         "Xenon_R2_Alt":"X",
         "Xenon_L2_Alt":"Y",
         "PSN_A":"a",
         "PSN_Y":"b",
         "PSN_X":"c",
         "PSN_B":"d",
         "PSN_Select":"z",
         "PSN_L3":"f",
         "PSN_L1":"g",
         "PSN_L1R1":"h",
         "PSN_LS":"i",
         "PSN_L2":"j",
         "PSN_L2R2":"k",
         "PSN_R3":"l",
         "PSN_R1":"m",
         "PSN_RS":"n",
         "PSN_R2":"o",
         "PSN_Start":"p",
         "_DPad_LR":"q",
         "_DPad_UD":"r",
         "DPad_Left":"t",
         "DPad_Right":"u",
         "DPad_Down":"v",
         "DPad_Up":"w",
         "PSN_R2_Alt":"x",
         "PSN_L2_Alt":"y"
      };
       
      public var Icon_tf:TextField;
      
      public var PCKey_tf:TextField;
      
      public function InputMappingListEntry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Icon_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.PCKey_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         TextFieldEx.setTextAutoSize(textField,"shrink");
         GlobalFunc.SetText(textField,"$" + param1.text,false);
         if(param1.buttonName != undefined)
         {
            GlobalFunc.SetText(this.Icon_tf,NameToTextMap[param1.buttonName],false);
            this.Icon_tf.visible = true;
            GlobalFunc.SetText(this.PCKey_tf," ",false);
         }
         else if(param1.PCKeyName != undefined)
         {
            GlobalFunc.SetText(this.PCKey_tf,param1.PCKeyName + ")",false);
            this.Icon_tf.visible = false;
         }
         else if(param1.buttonID != undefined)
         {
            GlobalFunc.SetText(this.PCKey_tf,param1.buttonID.toString(16),false);
            this.Icon_tf.visible = false;
         }
         else
         {
            GlobalFunc.SetText(this.PCKey_tf,"???",false);
            this.Icon_tf.visible = false;
         }
         border.alpha = !!this.selected?Number(GlobalFunc.SELECTED_RECT_ALPHA):Number(0);
         textField.textColor = !!this.selected?uint(0):uint(16777215);
         this.PCKey_tf.textColor = !!this.selected?uint(0):uint(16777215);
         this.Icon_tf.textColor = !!this.selected?uint(0):uint(16777215);
      }
   }
}
