package
{
	import Shared.IMenu;
	import Shared.AS3.BSButtonHintData;
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import scaleform.gfx.Extensions;
	import Shared.AS3.BSScrollingList;
	
	public class LooksMenu extends IMenu
	{
		 
		
		protected var _buttonHintDataV:Vector.<BSButtonHintData>;
		
		protected var buttonHint_StartMode_Face:BSButtonHintData;
		
		protected var buttonHint_StartMode_Extras:BSButtonHintData;
		
		protected var buttonHint_StartMode_Sex:BSButtonHintData;
		
		protected var buttonHint_StartMode_Body:BSButtonHintData;
		
		protected var buttonHint_StartMode_Preset:BSButtonHintData;
		
		protected var buttonHint_FaceMode_Sculpt:BSButtonHintData;
		
		protected var buttonHint_HairMode_Style:BSButtonHintData;
		
		protected var buttonHint_FaceMode_Type:BSButtonHintData;
		
		protected var buttonHint_FaceMode_Color:BSButtonHintData;
		
		protected var buttonHint_FaceMode_Back:BSButtonHintData;
		
		protected var buttonHint_SculptMode_Move:BSButtonHintData;
		
		protected var buttonHint_SculptMode_Slide:BSButtonHintData;
		
		protected var buttonHint_SculptMode_Rotate:BSButtonHintData;
		
		protected var buttonHint_SculptMode_Scale:BSButtonHintData;
		
		protected var buttonHint_FeatureMode_Modifier:BSButtonHintData;
		
		protected var buttonHint_EditAccept:BSButtonHintData;
		
		protected var buttonHint_FeatureMode_Apply:BSButtonHintData;
		
		protected var buttonHint_EditCancel:BSButtonHintData;
		
		protected var buttonHint_FeatureCategoryMode_RemoveAll:BSButtonHintData;
		
		protected var buttonHint_FeatureCategoryMode_Select:BSButtonHintData;
		
		protected var buttonHint_FeatureCategoryMode_Back:BSButtonHintData;
		
		protected var buttonHint_StartMode_Done:BSButtonHintData;
		
		public var WeightTriangle_mc:MovieClip;
		
		public var ButtonHintBar_mc:MovieClip;
		
		public var Cursor_mc:MovieClip;
		
		public var LoadingSpinner_mc:MovieClip;
		
		public var FacePartLabel_tf;
		
		public var LeftStickHelp_tf;
		
		public var uiCharacterPresetCount = 0;
		
		public var FeaturePanel_mc:MovieClip;
		
		private var PreviousStageFocus:InteractiveObject;
		
		private var AppliedMorphIntensity:Number = 0.0;
		
		private var AppliedMorphIndex:uint = 0;
		
		private var CurrentFeatureIntensity:Number = 0.0;
		
		private const FeatureIntensityStep:Number = 0.01;
		
		private var CurrentExtraNumColors:uint = 0;
		
		private const FeatureIntensityRampDurationCeiling = 3.0;
		
		private const FeatureIntensityRampEffect = 0.09;
		
		private const ColorChangeRateSlow = 0.5;
		
		private const ColorChangeRateFast = 0.2;
		
		private const ColorChangeRateIncreaseAt = 1.0;
		
		private var _BumperDurationHeld:Number = 0.0;
		
		private var _BumperJustPressed:Boolean = false;
		
		private var LastColorChangeAt:Number = 0.0;
		
		private var FeatureListChangeLock:int = 0;
		
		public var FacialBoneRegions:Array;
		
		public var CurrentBoneID:uint = 4.294967295E9;
		
		private var CurrentExtraGroup:uint = 4.294967295E9;
		
		private var CurrentExtraColor:uint = 0;
		
		private var LastSelectedExtraGroup:uint = 0;
		
		private var CurrentSelectedExtra:uint = 0;
		
		private var LetFeatureListHandleClick = true;
		
		private var BlockNextAccept = false;
		
		public var BGSCodeObj:Object;
		
		private var bInitialized:Boolean = false;
		
		private const SLIDER_STEP_SIZE:Number = 0.1;
		
		private const SLIDER_MIN:Number = -1.0;
		
		private const SLIDER_MAX:Number = 1.0;
		
		private const X_AXIS:uint = 0;
		
		private const Y_AXIS:uint = 1;
		
		private const Z_AXIS:uint = 2;
		
		private const X_ROT_AXIS:uint = 3;
		
		private const Y_ROT_AXIS:uint = 4;
		
		private const Z_ROT_AXIS:uint = 5;
		
		private const X_SCALE_AXIS:uint = 6;
		
		private const Y_SCALE_AXIS:uint = 7;
		
		private const Z_SCALE_AXIS:uint = 8;
		
		private const LEFT_RIGHT:uint = 0;
		
		private const UP_DOWN:uint = 1;
		
		private const BUMPERS:uint = 2;
		
		private const DPADX:uint = 3;
		
		private const DPADY:uint = 4;
		
		private const HeadPartEyes = 2;
		
		private const HeadPartHair = 3;
		
		private const HeadPartFacialHair = 4;
		
		private const HeadPartTeeth = 8;
		
		private const HeadPartNone = 4.294967295E9;
		
		private const DISABLED_ALPHA:Number = 0.0;
		
		private var ControlAxes:Array;
		
		private var CurrentActor:uint = 0;
		
		private var _bisFemale:Boolean = false;
		
		private var UndoDataSculptingTransform:Array;
		
		private var _bconfirmClose:Boolean = false;
		
		private var _dirty:Boolean = false;
		
		private var _loading:Boolean = false;
		
		private var _controlsEnabled:Boolean = true;
		
		private const START_MODE:uint = 0;
		
		private const FACE_MODE:uint = 1;
		
		private const BODY_MODE:uint = 2;
		
		private const SCULPT_MODE:uint = 3;
		
		private const HAIR_MODE:uint = 4;
		
		private const FEATURE_MODE:uint = 5;
		
		private const FEATURE_CATEGORY_MODE:uint = 6;
		
		private var eMode:uint = 0;
		
		private const AST_HAIR:uint = 0;
		
		private const AST_HAIR_COLOR:uint = 1;
		
		private const AST_BEARD:uint = 2;
		
		private const AST_EYES:uint = 3;
		
		private const AST_EXTRAS:uint = 4;
		
		private const AST_COLOR:uint = 5;
		
		private const AST_MORPHS:uint = 6;
		
		private const AST_COUNT:uint = 7;
		
		private var eFeature:uint = 7;
		
		private const UNDO_WEIGHT:uint = 0;
		
		private const UNDO_SCULPT:uint = 1;
		
		private const UNDO_HAIRCOLOR:uint = 2;
		
		private const UNDO_HAIRSTYLE:uint = 3;
		
		private const UNDO_BEARD:uint = 4;
		
		private const UNDO_EXTRAS:uint = 5;
		
		private const UNDO_COLOR:uint = 6;
		
		private const UNDO_MORPHS:uint = 7;
		
		private const BANTER_GENERAL:uint = 0;
		
		private const BANTER_EYES:uint = 1;
		
		private const BANTER_NOSE:uint = 2;
		
		private const BANTER_MOUTH:uint = 3;
		
		private const BANTER_HAIR:uint = 4;
		
		private const BANTER_BEARD:uint = 5;
		
		private const EDIT_CHARGEN:uint = 0;
		
		private const EDIT_REMAKE_UNUSED = 1;
		
		private const EDIT_HAIRCUT:uint = 2;
		
		private const EDIT_BODYMOD:uint = 3;
		
		private var EditMode:uint = 0;
		
		private var AllowChangeSex:Boolean = false;
		
		private const AllModeInputMap:Object = {
			"Done":0,
			"Accept":1,
			"Cancel":2,
			"XButton":3,
			"YButton":4,
			"LTrigger":5,
			"RTrigger":6,
			"LShoulder":7,
			"RShoulder":8,
			"Left":9,
			"Right":10,
			"Up":11,
			"Down":12
		};
		
		private const StartModeInputMapKBM:Object = {
			"Done":0,
			"F":1,
			"B":2,
			"Accept":3,
			"X":4,
			"KeyLeft":5,
			"KeyRight":6
		};
		
		private const StartModeInputMapController:Object = {
			"Done":0,
			"Accept":1,
			"B":2,
			"XButton":3,
			"YButton":4,
			"KeyLeft":5,
			"KeyRight":6
		};
		
		private const FaceHairModeInputMap:Object = {
			"Done":0,
			"KeyDown":1,
			"Cancel":2,
			"T":3,
			"C":4
		};
		
		private const BodyModeInputMap:Object = {
			"Done":1,
			"Accept":1,
			"Cancel":2
		};
		
		private const SculptModeInputMap:Object = {
			"Done":1,
			"Accept":1,
			"Cancel":2,
			"KeyDown":9,
			"KeyUp":10,
			"KeyLeft":7,
			"KeyRight":8
		};
		
		private const FeatureModeInputMap:Object = {
			"Done":1,
			"Accept":1,
			"Cancel":2,
			"Space":3,
			"R":4,
			"KeyLeft":7,
			"KeyRight":8
		};
		
		private const FeatureCategoryModeInputMap:Object = {
			"Accept":1,
			"Cancel":2,
			"R":4
		};
		
		private const InputMapA:Array = [this.StartModeInputMapController,this.FaceHairModeInputMap,this.BodyModeInputMap,this.SculptModeInputMap,this.FaceHairModeInputMap,this.FeatureModeInputMap,this.FeatureCategoryModeInputMap];
		
		private const StartModeFunctionsReleased:Array = [this.ConfirmCloseMenu,this.FaceMode,this.BodyMode,this.ExtrasMode,this.ChangeSex,this.CharacterPresetLeft,this.CharacterPresetRight,undefined,undefined,undefined,undefined,undefined,undefined];
		
		private const FaceModeFunctionsReleased:Array = [this.ConfirmCloseMenu,this.SculptMode,this.StartMode,this.TypeMode,this.ColorMode,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined];
		
		private const BodyModeFunctionsReleased:Array = [undefined,this.AcceptChanges,this.CancelChanges,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined];
		
		private const SculptModeFunctionsReleased:Array = [undefined,this.AcceptChanges,this.CancelChanges,undefined,undefined,undefined,undefined,this.SculptModeRotateLeft,this.SculptModeRotateRight,this.SculptModeShrink,this.SculptModeEnlarge,this.SculptModeOut,this.SculptModeIn];
		
		private const HairModeFunctionsReleased:Array = [this.ConfirmCloseMenu,this.StyleMode,this.StartMode,this.TypeMode,this.ColorMode,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined];
		
		private const FeatureModeFunctionsReleased:Array = [undefined,undefined,this.CancelChanges,this.FeaturesApply,undefined,undefined,undefined,this.FeatureModeLBumper,this.FeatureModeRBumper,undefined,undefined,undefined,undefined];
		
		private const FeatureCategoryModeFunctionsReleased:Array = [undefined,undefined,this.StartMode,undefined,this.FeaturesClear,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined];
		
		private const InputFunctionsA:Array = [this.StartModeFunctionsReleased,this.FaceModeFunctionsReleased,this.BodyModeFunctionsReleased,this.SculptModeFunctionsReleased,this.HairModeFunctionsReleased,this.FeatureModeFunctionsReleased,this.FeatureCategoryModeFunctionsReleased];
		
		private var TriangleSize:Number = 200.0;
		
		public function LooksMenu()
		{
			this.buttonHint_StartMode_Face = new BSButtonHintData("$FACE","F","PSN_A","Xenon_A",1,this.FaceMode);
			this.buttonHint_StartMode_Extras = new BSButtonHintData("$EXTRAS","E","PSN_X","Xenon_X",1,this.ExtrasMode);
			this.buttonHint_StartMode_Sex = new BSButtonHintData("$SEX","X","PSN_Y","Xenon_Y",1,this.ChangeSex);
			this.buttonHint_StartMode_Body = new BSButtonHintData("$BODY","B","PSN_B","Xenon_B",1,this.BodyMode);
			this.buttonHint_StartMode_Preset = new BSButtonHintData("$$FACE 01","A","PSN_L2","Xenon_L2",1,this.CharacterPresetRight);
			this.buttonHint_FaceMode_Sculpt = new BSButtonHintData("$SCULPT","S","PSN_A","Xenon_A",1,this.SculptMode);
			this.buttonHint_HairMode_Style = new BSButtonHintData("$STYLE","S","PSN_A","Xenon_A",1,this.StyleMode);
			this.buttonHint_FaceMode_Type = new BSButtonHintData("$TYPE","T","PSN_X","Xenon_X",1,this.TypeMode);
			this.buttonHint_FaceMode_Color = new BSButtonHintData("$COLOR","C","PSN_Y","Xenon_Y",1,this.ColorMode);
			this.buttonHint_FaceMode_Back = new BSButtonHintData("$BACK","Esc","PSN_B","Xenon_B",1,this.StartMode);
			this.buttonHint_SculptMode_Move = new BSButtonHintData("$MOVE","LMOUSE","PSN_LS","Xenon_LS",1,null);
			this.buttonHint_SculptMode_Slide = new BSButtonHintData("$SLIDE","MOUSEWHEEL","_DPad_UD","_DPad_UD",1,null);
			this.buttonHint_SculptMode_Rotate = new BSButtonHintData("$ROTATE","A","PSN_L1","Xenon_L1",1,this.SculptModeRotateLeft);
			this.buttonHint_SculptMode_Scale = new BSButtonHintData("$SCALE","S","_DPad_LR","_DPad_LR",1,this.SculptModeShrink);
			this.buttonHint_FeatureMode_Modifier = new BSButtonHintData("100%","A","PSN_L1","Xenon_L1",1,this.FeatureModeLBumper);
			this.buttonHint_EditAccept = new BSButtonHintData("$ACCEPT","E","PSN_A","Xenon_A",1,this.AcceptChanges);
			this.buttonHint_FeatureMode_Apply = new BSButtonHintData("$APPLY","SPACE","PSN_X","Xenon_X",1,this.FeaturesApply);
			this.buttonHint_EditCancel = new BSButtonHintData("$CANCEL","Esc","PSN_B","Xenon_B",1,this.CancelChanges);
			this.buttonHint_FeatureCategoryMode_RemoveAll = new BSButtonHintData("$REMOVE ALL","R","PSN_Y","Xenon_Y",1,this.FeaturesClear);
			this.buttonHint_FeatureCategoryMode_Select = new BSButtonHintData("$SELECT","E","PSN_A","Xenon_A",1,this.SelectCategory);
			this.buttonHint_FeatureCategoryMode_Back = new BSButtonHintData("$BACK","Esc","PSN_B","Xenon_B",1,this.PreviousMode);
			this.buttonHint_StartMode_Done = new BSButtonHintData("$DONE","Enter","PSN_Start","Xenon_Start",1,this.ConfirmCloseMenu);
			this.FacialBoneRegions = new Array();
			this.ControlAxes = [this.X_AXIS,this.Y_AXIS,this.X_ROT_AXIS,this.X_SCALE_AXIS,this.Z_AXIS];
			super();
			this.BGSCodeObj = new Object();
			this.eMode = this.START_MODE;
			Extensions.enabled = true;
			stage.focus = this;
			stage.stageFocusRect = false;
			this.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(BSScrollingList.SELECTION_CHANGE,this.onFeatureSelectionChange);
			addEventListener(BSScrollingList.ITEM_PRESS,this.onFeatureSelected);
			this.WeightTriangle_mc.WeightTriangleHitArea_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onWeightTriangleChange);
			this.WeightTriangle_mc.WeightTriangleHitArea_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.onWeightTriangleChange);
			this.buttonHint_StartMode_Preset.SetSecondaryButtons("D","PSN_R2","Xenon_R2");
			this.buttonHint_StartMode_Preset.secondaryButtonCallback = this.CharacterPresetRight;
			this.buttonHint_SculptMode_Slide.DynamicMovieClipName = "SlideIcon";
			this.buttonHint_SculptMode_Rotate.SetSecondaryButtons("D","PSN_R1","Xenon_R1");
			this.buttonHint_SculptMode_Rotate.secondaryButtonCallback = this.SculptModeRotateRight;
			this.buttonHint_SculptMode_Rotate.DynamicMovieClipName = "RotationIcon";
			this.buttonHint_SculptMode_Scale.SetSecondaryButtons("W","","");
			this.buttonHint_SculptMode_Scale.secondaryButtonCallback = this.SculptModeEnlarge;
			this.buttonHint_FeatureMode_Modifier.SetSecondaryButtons("D","PSN_R1","Xenon_R1");
			this.buttonHint_FeatureMode_Modifier.secondaryButtonCallback = this.FeatureModeLBumper;
			this._buttonHintDataV = new Vector.<BSButtonHintData>();
			this._buttonHintDataV.push(this.buttonHint_StartMode_Preset);
			this._buttonHintDataV.push(this.buttonHint_StartMode_Face);
			this._buttonHintDataV.push(this.buttonHint_StartMode_Extras);
			this._buttonHintDataV.push(this.buttonHint_StartMode_Sex);
			this._buttonHintDataV.push(this.buttonHint_StartMode_Body);
			this._buttonHintDataV.push(this.buttonHint_FaceMode_Sculpt);
			this._buttonHintDataV.push(this.buttonHint_HairMode_Style);
			this._buttonHintDataV.push(this.buttonHint_FaceMode_Type);
			this._buttonHintDataV.push(this.buttonHint_FaceMode_Color);
			this._buttonHintDataV.push(this.buttonHint_FaceMode_Back);
			this._buttonHintDataV.push(this.buttonHint_SculptMode_Move);
			this._buttonHintDataV.push(this.buttonHint_SculptMode_Slide);
			this._buttonHintDataV.push(this.buttonHint_SculptMode_Rotate);
			this._buttonHintDataV.push(this.buttonHint_SculptMode_Scale);
			this._buttonHintDataV.push(this.buttonHint_FeatureMode_Modifier);
			this._buttonHintDataV.push(this.buttonHint_EditAccept);
			this._buttonHintDataV.push(this.buttonHint_FeatureMode_Apply);
			this._buttonHintDataV.push(this.buttonHint_EditCancel);
			this._buttonHintDataV.push(this.buttonHint_StartMode_Done);
			this._buttonHintDataV.push(this.buttonHint_FeatureCategoryMode_Select);
			this._buttonHintDataV.push(this.buttonHint_FeatureCategoryMode_RemoveAll);
			this._buttonHintDataV.push(this.buttonHint_FeatureCategoryMode_Back);
			this.ButtonHintBar_mc.SetButtonHintData(this._buttonHintDataV);
			this.UpdateButtons();
			this.bInitialized = true;
			this.__setProp_ButtonHintBar_mc_LooksMenuBase_Shared_0();
		}
		
		public function set characterPresetCount(param1:uint) : *
		{
			this.uiCharacterPresetCount = param1;
		}
		
		public function ShouldMoveCursor() : Boolean
		{
			return (this.eMode == this.FACE_MODE || this.eMode == this.HAIR_MODE) && this.EditMode != this.EDIT_HAIRCUT;
		}
		
		public function set confirmClose(param1:Boolean) : *
		{
			this._bconfirmClose = param1;
		}
		
		public function get confirmClose() : *
		{
			return this._bconfirmClose;
		}
		
		public function get sculpting() : *
		{
			return this.eMode == this.SCULPT_MODE;
		}
		
		public function get dirty() : *
		{
			return this._dirty;
		}
		
		public function set dirty(param1:Boolean) : *
		{
			this._dirty = param1;
		}
		
		public function get cursorRadius() : *
		{
			return this.Cursor_mc.width * 0.5;
		}
		
		public function set currentActor(param1:uint) : *
		{
			this.CurrentActor = param1;
			this.UpdateButtons();
		}
		
		public function set isFemale(param1:*) : *
		{
			this._bisFemale = param1;
		}
		
		public function set enableControls(param1:Boolean) : *
		{
			this._controlsEnabled = param1;
		}
		
		public function set loading(param1:Boolean) : *
		{
			if(this._loading != param1)
			{
				this._loading = param1;
				this.UpdateButtons();
			}
		}
		
		public function CharacterPresetStepperGetDispInfo(param1:Object, param2:uint) : *
		{
			param1.DisplayLabel = "$FACE";
			param1.DisplayIndex = param2 + 1;
		}
		
		public function DetailColorStepperGetDispInfo(param1:Object, param2:uint) : *
		{
			param1.DisplayLabel = "$COLOR";
			param1.DisplayIndex = param2 + 1;
		}
		
		public function GetBoneRegionIndexFromCurrentID() : uint
		{
			var _loc2_:uint = 0;
			var _loc1_:uint = uint.MAX_VALUE;
			if(this.FacialBoneRegions.length > 0)
			{
				_loc2_ = 0;
				while(_loc2_ < this.FacialBoneRegions[this.CurrentActor].length)
				{
					if(this.FacialBoneRegions[this.CurrentActor][_loc2_].regionID == this.CurrentBoneID)
					{
						_loc1_ = _loc2_;
						break;
					}
					_loc2_++;
				}
			}
			return _loc1_;
		}
		
		public function GetMorphSliderFromCurrentID() : uint
		{
			var _loc1_:uint = uint.MAX_VALUE;
			var _loc2_:uint = this.GetBoneRegionIndexFromCurrentID();
			if(_loc2_ != uint.MAX_VALUE && this.FacialBoneRegions[this.CurrentActor][_loc2_].isSlider == true)
			{
				_loc1_ = _loc2_;
			}
			return _loc1_;
		}
		
		public function FindAndSetAxisValue(param1:uint, param2:Boolean, param3:Number = 1.0) : *
		{
			var _loc6_:uint = 0;
			var _loc4_:Number = param3 * this.SLIDER_STEP_SIZE;
			var _loc5_:uint = this.GetBoneRegionIndexFromCurrentID();
			if(this.CurrentBoneID != uint.MAX_VALUE && _loc5_ != uint.MAX_VALUE)
			{
				_loc6_ = 0;
				while(_loc6_ < this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray.length)
				{
					if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].buttonMapping == param1)
					{
						if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].isScalingAxis == true)
						{
							if(param2)
							{
								this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue = this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue + _loc4_;
								if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue > this.SLIDER_MAX)
								{
									this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue = this.SLIDER_MAX;
								}
							}
							else
							{
								this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue = this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue - _loc4_;
								if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue < this.SLIDER_MIN)
								{
									this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue = this.SLIDER_MIN;
								}
							}
							this.BGSCodeObj.ChangeBoneRegionAxis(this.CurrentBoneID,this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisIndex,this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisScalingValue as Number);
						}
						else if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].isSlider == true)
						{
							if(param2)
							{
								this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue = this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue + _loc4_;
								if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue > this.SLIDER_MAX)
								{
									this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue = this.SLIDER_MAX;
								}
							}
							else
							{
								this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue = this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue - _loc4_;
								if(this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue < this.SLIDER_MIN)
								{
									this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue = this.SLIDER_MIN;
								}
							}
							this.BGSCodeObj.ChangeBoneRegionMorphSlider(this.CurrentBoneID,this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisIndex,this.FacialBoneRegions[this.CurrentActor][_loc5_].axisArray[_loc6_].axisSliderValue as Number);
						}
						break;
					}
					_loc6_++;
				}
			}
		}
		
		public function GetValidAxis(param1:uint) : Boolean
		{
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			if(this.CurrentBoneID != uint.MAX_VALUE)
			{
				_loc2_ = 0;
				while(_loc2_ < this.FacialBoneRegions[this.CurrentActor].length)
				{
					if(this.CurrentBoneID == this.FacialBoneRegions[this.CurrentActor][_loc2_].regionID)
					{
						_loc3_ = 0;
						while(_loc3_ < this.FacialBoneRegions[this.CurrentActor][_loc2_].axisArray.length)
						{
							if(this.FacialBoneRegions[this.CurrentActor][_loc2_].axisArray[_loc3_].buttonMapping == param1)
							{
								return true;
							}
							_loc3_++;
						}
					}
					_loc2_++;
				}
			}
			return false;
		}
		
		public function ShouldEnableButton() : *
		{
			return this.GetValidAxis(this.X_AXIS) || this.GetValidAxis(this.Y_AXIS) || this.GetValidAxis(this.Z_AXIS) || this.GetValidAxis(this.X_ROT_AXIS) || this.GetValidAxis(this.X_SCALE_AXIS);
		}
		
		private function ShowHairHighlight(param1:Boolean) : *
		{
			this.BGSCodeObj.SetHairHighlight(param1);
		}
		
		public function set editMode(param1:uint) : *
		{
			this.AllowChangeSex = param1 == this.EDIT_CHARGEN;
			if(param1 == this.EDIT_REMAKE_UNUSED)
			{
				param1 = this.EDIT_CHARGEN;
			}
			this.EditMode = param1;
			if(param1 == this.EDIT_HAIRCUT)
			{
				this.eMode = this.HAIR_MODE;
			}
			this.UpdateButtons();
		}
		
		private function GetBanterFlavor(param1:uint) : *
		{
			var _loc2_:uint = this.GetBoneRegionIndexFromCurrentID();
			var _loc3_:* = _loc2_ < uint.MAX_VALUE?this.FacialBoneRegions[this.CurrentActor][_loc2_].headPart:this.HeadPartNone;
			var _loc4_:uint = this.BANTER_GENERAL;
			switch(param1)
			{
				case this.AST_HAIR:
				case this.AST_HAIR_COLOR:
					_loc4_ = this.BANTER_HAIR;
					break;
				case this.AST_EYES:
					_loc4_ = this.BANTER_EYES;
					break;
				case this.AST_COLOR:
					if(_loc3_ == this.HeadPartEyes)
					{
						_loc4_ = this.BANTER_EYES;
					}
					break;
				case this.AST_BEARD:
					_loc4_ = this.BANTER_BEARD;
					break;
				case this.AST_COUNT:
					switch(_loc3_)
					{
						case this.HeadPartEyes:
							_loc4_ = this.BANTER_EYES;
							break;
						case this.HeadPartHair:
							_loc4_ = this.BANTER_HAIR;
							break;
						case this.HeadPartFacialHair:
							_loc4_ = this.BANTER_GENERAL;
							break;
						case this.HeadPartTeeth:
							_loc4_ = this.BANTER_MOUTH;
							break;
						default:
							if(_loc2_ < uint.MAX_VALUE)
							{
								_loc4_ = this.FacialBoneRegions[this.CurrentActor][_loc2_].banterFlavor;
							}
					}
			}
			return _loc4_;
		}
		
		private function FeatureModeBack() : *
		{
			this.BGSCodeObj.ClearTemporaryDetail(this.CurrentExtraGroup);
			this.CurrentExtraGroup = uint.MAX_VALUE;
			this.FeatureMode(this.AST_EXTRAS);
		}
		
		private function PreviousMode(param1:Boolean) : *
		{
			switch(this.eMode)
			{
				case this.SCULPT_MODE:
					if(param1)
					{
						this.BGSCodeObj.NotifyForWittyBanter(this.GetBanterFlavor(this.AST_COUNT));
					}
					this.BGSCodeObj.HighlightBoneRegion(this.CurrentBoneID);
					this.menuMode = this.FACE_MODE;
					break;
				case this.FEATURE_MODE:
					if(param1)
					{
						this.BGSCodeObj.NotifyForWittyBanter(this.GetBanterFlavor(this.eFeature));
					}
					switch(this.eFeature)
					{
						case this.AST_HAIR_COLOR:
						case this.AST_HAIR:
							this.menuMode = this.HAIR_MODE;
							if(this.EditMode != this.EDIT_HAIRCUT)
							{
								this.ShowHairHighlight(true);
							}
							this.BlockNextAccept = false;
							break;
						case this.AST_EXTRAS:
							this.BGSCodeObj.ClearTemporaryDetail(this.CurrentExtraGroup);
							this.FeatureCategoryMode();
							break;
						case this.AST_BEARD:
							this.menuMode = this.EditMode == this.EDIT_HAIRCUT?uint(this.HAIR_MODE):uint(this.FACE_MODE);
							this.BlockNextAccept = false;
							break;
						default:
							this.menuMode = this.FACE_MODE;
							this.BlockNextAccept = false;
					}
					if(this.eFeature != this.AST_EXTRAS)
					{
						this.BGSCodeObj.HighlightBoneRegion(this.CurrentBoneID);
						this.eFeature = this.AST_COUNT;
						stage.focus = this.PreviousStageFocus;
					}
					break;
				case this.FEATURE_CATEGORY_MODE:
					this.menuMode = this.START_MODE;
					this.eFeature = this.AST_COUNT;
					stage.focus = this.PreviousStageFocus;
					break;
				case this.FACE_MODE:
				case this.HAIR_MODE:
					this.ShowHairHighlight(false);
					this.BGSCodeObj.ClearBoneRegionTint();
				case this.BODY_MODE:
					if(this.BGSCodeObj.EndBodyEdit())
					{
						this.BGSCodeObj.NotifyForWittyBanter(this.BANTER_GENERAL);
						this.menuMode = this.START_MODE;
					}
			}
		}
		
		private function AcceptChanges() : *
		{
			this.dirty = true;
			this.PreviousMode(true);
		}
		
		private function CancelChanges() : *
		{
			var _loc1_:uint = 0;
			var _loc2_:uint = 0;
			switch(this.eMode)
			{
				case this.SCULPT_MODE:
					_loc1_ = this.GetBoneRegionIndexFromCurrentID();
					_loc2_ = 0;
					while(_loc2_ < this.FacialBoneRegions[this.CurrentActor][_loc1_].axisArray.length)
					{
						if(this.FacialBoneRegions[this.CurrentActor][_loc1_].axisArray[_loc2_].isScalingAxis)
						{
							this.FacialBoneRegions[this.CurrentActor][_loc1_].axisArray[_loc2_].axisScalingValue = this.UndoDataSculptingTransform[_loc2_];
						}
						else if(this.FacialBoneRegions[this.CurrentActor][_loc1_].axisArray[_loc2_].isSlider)
						{
							this.FacialBoneRegions[this.CurrentActor][_loc1_].axisArray[_loc2_].axisSliderValue = this.UndoDataSculptingTransform[_loc2_];
						}
						_loc2_++;
					}
			}
			this.BGSCodeObj.UndoLastAction();
			this.PreviousMode(false);
		}
		
		private function ConfirmCloseMenu() : *
		{
			if(this.eMode == this.START_MODE || this.eMode == this.HAIR_MODE && this.EditMode == this.EDIT_HAIRCUT)
			{
				if(this.BGSCodeObj.ConfirmAndCloseMenu())
				{
					this.confirmClose = true;
				}
			}
		}
		
		private function ChangeSex() : *
		{
			if(!this.confirmClose)
			{
				this.BGSCodeObj.ChangeSex();
				this.UpdateButtons();
			}
		}
		
		private function CharacterPresetLeft() : *
		{
			if(!this.confirmClose)
			{
				this.BGSCodeObj.ChangeCharacterPreset(true);
				this.UpdateButtons();
			}
		}
		
		private function CharacterPresetRight() : *
		{
			if(!this.confirmClose)
			{
				this.BGSCodeObj.ChangeCharacterPreset(false);
				this.UpdateButtons();
			}
		}
		
		public function onCommitCharacterPresetChange(param1:uint) : *
		{
			this.dirty = false;
		}
		
		private function FaceMode() : *
		{
			if(this.eMode == this.START_MODE)
			{
				this.eMode = this.FACE_MODE;
				this.UpdateButtons();
				this.BGSCodeObj.ClearPickData();
			}
		}
		
		private function BodyMode() : *
		{
			if(this.eMode == this.START_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD) && this.BGSCodeObj.StartBodyEdit())
			{
				this.BGSCodeObj.CreateUndoPoint(this.UNDO_WEIGHT);
				this.eMode = this.BODY_MODE;
				this.UpdateButtons();
			}
		}
		
		private function ExtrasMode() : *
		{
			var _loc1_:uint = this.GetBoneRegionIndexFromCurrentID();
			if(this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD)
			{
				this.CurrentExtraGroup = uint.MAX_VALUE;
				this.FeatureCategoryMode();
			}
		}
		
		private function StartMode() : *
		{
			if(this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD)
			{
				this.eMode = this.START_MODE;
				this.BGSCodeObj.ClearBoneRegionTint();
				this.ShowHairHighlight(false);
				this.UpdateButtons();
			}
		}
		
		public function SculptMode() : *
		{
			var _loc1_:uint = 0;
			var _loc2_:Array = null;
			var _loc3_:uint = 0;
			if(this.buttonHint_FaceMode_Sculpt.ButtonEnabled && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD))
			{
				this.eMode = this.SCULPT_MODE;
				this.UpdateButtons();
				this.BGSCodeObj.ClearBoneRegionTint();
				_loc1_ = this.GetBoneRegionIndexFromCurrentID();
				_loc2_ = this.FacialBoneRegions[this.CurrentActor][_loc1_].axisArray;
				this.UndoDataSculptingTransform = new Array(_loc2_.length);
				_loc3_ = 0;
				while(_loc3_ < _loc2_.length)
				{
					if(_loc2_[_loc3_].isScalingAxis)
					{
						this.UndoDataSculptingTransform[_loc3_] = _loc2_[_loc3_].axisScalingValue;
					}
					else if(_loc2_[_loc3_].isSlider)
					{
						this.UndoDataSculptingTransform[_loc3_] = _loc2_[_loc3_].axisSliderValue;
					}
					_loc3_++;
				}
				this.BGSCodeObj.CreateUndoPoint(this.UNDO_SCULPT,this.CurrentBoneID);
			}
		}
		
		private function ColorMode() : *
		{
			var _loc1_:uint = 0;
			var _loc2_:* = undefined;
			if(this.buttonHint_FaceMode_Color.ButtonEnabled)
			{
				if(this.eMode == this.FACE_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD))
				{
					_loc1_ = this.GetBoneRegionIndexFromCurrentID();
					_loc2_ = this.FacialBoneRegions[this.CurrentActor][_loc1_].headPart;
					this.FeatureMode(_loc2_ == this.HeadPartEyes?uint(this.AST_EYES):uint(this.AST_COLOR));
				}
				else if(this.eMode == this.HAIR_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_HAIRCUT))
				{
					this.FeatureMode(this.AST_HAIR_COLOR);
				}
			}
		}
		
		private function TypeMode() : *
		{
			var _loc1_:uint = 0;
			if(this.buttonHint_FaceMode_Type.ButtonEnabled)
			{
				if(this.eMode == this.HAIR_MODE)
				{
					if(this.EditMode == this.EDIT_HAIRCUT && !this._bisFemale)
					{
						this.FeatureMode(this.AST_BEARD);
					}
				}
				else
				{
					_loc1_ = this.GetBoneRegionIndexFromCurrentID();
					if(this.FacialBoneRegions[this.CurrentActor][_loc1_].headPart == this.HeadPartFacialHair)
					{
						this.FeatureMode(this.AST_BEARD);
					}
					else if(this.eMode == this.FACE_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD))
					{
						if(this.CurrentBoneID < uint.MAX_VALUE)
						{
							this.FeatureMode(this.AST_MORPHS);
						}
					}
					else if(this.eMode == this.HAIR_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_HAIRCUT))
					{
						this.FeatureMode(this.AST_HAIR);
					}
				}
			}
		}
		
		private function StyleMode() : *
		{
			if(this.buttonHint_HairMode_Style.ButtonEnabled && this.eMode == this.HAIR_MODE)
			{
				this.FeatureMode(this.AST_HAIR);
			}
		}
		
		public function SculptModeLStickMouse(param1:Number, param2:Number) : *
		{
			if(param1 != 0)
			{
				this.FindAndSetAxisValue(this.ControlAxes[this.LEFT_RIGHT],param1 < 0,Math.abs(param1));
			}
			if(param2 != 0)
			{
				this.FindAndSetAxisValue(this.ControlAxes[this.UP_DOWN],param2 < 0,Math.abs(param2));
			}
		}
		
		public function SculptModeMouseWheel(param1:Number) : *
		{
			if(param1 > 0)
			{
				this.SculptModeIn();
			}
			else if(param1 < 0)
			{
				this.SculptModeOut();
			}
		}
		
		private function SculptModeShrink() : *
		{
			this.FindAndSetAxisValue(this.X_SCALE_AXIS,false);
		}
		
		private function SculptModeEnlarge() : *
		{
			this.FindAndSetAxisValue(this.X_SCALE_AXIS,true);
		}
		
		private function SculptModeRotateLeft() : *
		{
			this.FindAndSetAxisValue(this.X_ROT_AXIS,true);
		}
		
		private function SculptModeRotateRight() : *
		{
			this.FindAndSetAxisValue(this.X_ROT_AXIS,false);
		}
		
		private function SculptModeOut() : *
		{
			this.FindAndSetAxisValue(this.Z_AXIS,true);
		}
		
		private function SculptModeIn() : *
		{
			this.FindAndSetAxisValue(this.Z_AXIS,false);
		}
		
		private function FeatureModeLBumper() : *
		{
			this.FeatureModeBumper(true);
		}
		
		private function FeatureModeRBumper() : *
		{
			this.FeatureModeBumper(false);
		}
		
		public function set BumperDurationHeld(param1:Number) : *
		{
			this._BumperDurationHeld = param1;
		}
		
		public function set BumperJustPressed(param1:Boolean) : *
		{
			this._BumperJustPressed = param1;
		}
		
		private function FeatureModeBumper(param1:Boolean) : *
		{
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			var _loc5_:* = undefined;
			var _loc6_:uint = 0;
			var _loc7_:* = undefined;
			var _loc8_:* = undefined;
			var _loc9_:* = undefined;
			var _loc2_:Number = this.CurrentFeatureIntensity;
			if(this.CurrentFeatureIntensity > -1)
			{
				_loc3_ = this.FeatureIntensityStep;
				_loc4_ = Math.min(this.FeatureIntensityRampDurationCeiling,this._BumperDurationHeld);
				_loc5_ = _loc4_ / this.FeatureIntensityRampDurationCeiling;
				_loc3_ = _loc3_ + _loc5_ * _loc5_ * _loc5_ * this.FeatureIntensityRampEffect;
				if(param1)
				{
					_loc2_ = _loc2_ - _loc3_;
				}
				else
				{
					_loc2_ = _loc2_ + _loc3_;
				}
				if(_loc2_ < 0.01)
				{
					_loc2_ = 0.01;
				}
				if(_loc2_ > 1)
				{
					_loc2_ = 1;
				}
			}
			switch(this.eFeature)
			{
				case this.AST_MORPHS:
					if(_loc2_ > -1)
					{
						_loc6_ = this.GetBoneRegionIndexFromCurrentID();
						this.FacialBoneRegions[this.CurrentActor][_loc6_].presetIntensity = _loc2_;
						this.BGSCodeObj.ChangePresetIntensity(_loc2_);
						this.CurrentFeatureIntensity = _loc2_;
						this.UpdateFeatureModifierButtonHint();
					}
					break;
				case this.AST_EXTRAS:
					if(this.CurrentExtraNumColors > 1)
					{
						_loc7_ = false;
						_loc8_ = this._BumperDurationHeld > this.ColorChangeRateIncreaseAt?this.ColorChangeRateFast:this.ColorChangeRateSlow;
						if(this._BumperJustPressed || this._BumperDurationHeld - this.LastColorChangeAt > _loc8_)
						{
							if(param1 && this.CurrentExtraColor > 0 || !param1 && this.CurrentExtraColor < this.CurrentExtraNumColors - 1)
							{
								if(param1)
								{
									this.CurrentExtraColor--;
								}
								else
								{
									this.CurrentExtraColor++;
								}
								this.BGSCodeObj.SetDetailColor(this.CurrentExtraGroup,this.CurrentSelectedExtra,this.CurrentExtraColor);
								this.UpdateFeatureModifierButtonHint();
							}
							this.LastColorChangeAt = this._BumperDurationHeld;
							this._BumperJustPressed = false;
						}
					}
					else if(this.CurrentExtraNumColors == 0 && _loc2_ > -1)
					{
						_loc9_ = this.BGSCodeObj.GetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra) == 0;
						this.BGSCodeObj.SetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra,_loc2_,_loc9_);
						this.CurrentFeatureIntensity = _loc2_;
						this.UpdateFeatureModifierButtonHint();
					}
			}
		}
		
		private function onFeatureSelected() : *
		{
			var _loc1_:* = undefined;
			if(this.BlockNextAccept)
			{
				this.BlockNextAccept = false;
				return;
			}
			if(this.eMode == this.FEATURE_CATEGORY_MODE)
			{
				this.SelectCategory();
			}
			else if(this.eMode == this.FEATURE_MODE && this.eFeature == this.AST_EXTRAS)
			{
				this.AcceptChanges();
			}
			else if(this.eMode == this.FEATURE_MODE)
			{
				_loc1_ = 0;
				while(_loc1_ < this.FeaturePanel_mc.List_mc.entryList.length)
				{
					this.FeaturePanel_mc.List_mc.entryList[_loc1_].applied = false;
					this.FeaturePanel_mc.List_mc.UpdateEntry(this.FeaturePanel_mc.List_mc.entryList[_loc1_]);
					_loc1_++;
				}
				this.FeaturePanel_mc.List_mc.selectedEntry.applied = true;
				this.FeaturePanel_mc.List_mc.UpdateSelectedEntry();
				switch(this.eFeature)
				{
					case this.AST_HAIR:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_HAIRSTYLE);
						break;
					case this.AST_HAIR_COLOR:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_HAIRCOLOR);
						break;
					case this.AST_BEARD:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_BEARD);
						break;
					case this.AST_COLOR:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_COLOR,this.CurrentBoneID);
						break;
					case this.AST_EYES:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_COLOR,this.CurrentBoneID);
						break;
					case this.AST_EXTRAS:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_EXTRAS);
						break;
					case this.AST_MORPHS:
						this.BGSCodeObj.CreateSavePoint(this.UNDO_MORPHS);
				}
				this.AcceptChanges();
			}
		}
		
		private function onFeatureSelectionChange() : *
		{
			var _loc1_:uint = 0;
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			var _loc5_:Number = NaN;
			var _loc6_:* = undefined;
			if(this.FeatureListChangeLock == 0)
			{
				_loc1_ = this.FeaturePanel_mc.List_mc.selectedIndex;
				if(this.eMode == this.FEATURE_CATEGORY_MODE)
				{
					this.LastSelectedExtraGroup = _loc1_;
				}
				else if(this.eMode == this.FEATURE_MODE)
				{
					this.CurrentFeatureIntensity = 0;
					this.CurrentExtraNumColors = 0;
					switch(this.eFeature)
					{
						case this.AST_HAIR:
							this.BGSCodeObj.ChangeHairStyle(_loc1_);
							break;
						case this.AST_HAIR_COLOR:
							this.BGSCodeObj.ChangeHairColor(_loc1_);
							break;
						case this.AST_BEARD:
							this.BGSCodeObj.ChangeBeard(_loc1_);
							break;
						case this.AST_EYES:
						case this.AST_COLOR:
							this.BGSCodeObj.ChangeColor(_loc1_);
							break;
						case this.AST_EXTRAS:
							this.CurrentSelectedExtra = _loc1_;
							this.CurrentFeatureIntensity = this.BGSCodeObj.GetDetailIntensity(this.CurrentExtraGroup,_loc1_);
							this.buttonHint_FeatureMode_Apply.ButtonText = this.CurrentFeatureIntensity > 0?"$REMOVE":"$APPLY";
							if(this.CurrentFeatureIntensity == 0)
							{
								this.BGSCodeObj.SetDetailIntensity(this.CurrentExtraGroup,_loc1_,Number(1),true);
								this.CurrentFeatureIntensity = 1;
							}
							else
							{
								this.BGSCodeObj.ClearTemporaryDetail(this.CurrentExtraGroup);
							}
							this.CurrentExtraNumColors = this.BGSCodeObj.GetDetailColorCount(this.CurrentExtraGroup,this.CurrentSelectedExtra);
							this.CurrentExtraColor = this.BGSCodeObj.GetDetailColor(this.CurrentExtraGroup,this.CurrentSelectedExtra);
							this.UpdateFeatureModifierButtonHint();
							break;
						case this.AST_MORPHS:
							_loc2_ = this.GetBoneRegionIndexFromCurrentID();
							_loc3_ = this.FacialBoneRegions[this.CurrentActor][_loc2_].presetCount;
							_loc4_ = this.FacialBoneRegions[this.CurrentActor][_loc2_].presetIndex;
							if(_loc4_ != _loc1_)
							{
								this.BGSCodeObj.ChangePreset(this.CurrentBoneID,uint(_loc1_));
								this.FacialBoneRegions[this.CurrentActor][_loc2_].presetIndex = _loc1_;
								_loc5_ = _loc1_ == this.AppliedMorphIndex?Number(this.AppliedMorphIntensity):!!this.FacialBoneRegions[this.CurrentActor][_loc2_].presetsSupportIntensity?!!_loc1_?Number(1):Number(-1):Number(-1);
								this.FacialBoneRegions[this.CurrentActor][_loc2_].presetIntensity = _loc5_;
								this.BGSCodeObj.NotifyForWittyBanter(this.GetBanterFlavor(this.AST_COUNT));
								this.dirty = true;
								_loc6_ = 0;
								while(_loc6_ < this.FacialBoneRegions[this.CurrentActor].length)
								{
									if(_loc6_ != _loc2_ && this.FacialBoneRegions[this.CurrentActor][_loc6_].associatedPresetGroup == this.FacialBoneRegions[this.CurrentActor][_loc2_].associatedPresetGroup)
									{
										this.FacialBoneRegions[this.CurrentActor][_loc6_].presetIndex = _loc1_;
										this.FacialBoneRegions[this.CurrentActor][_loc6_].presetIntensity = _loc5_;
									}
									_loc6_++;
								}
								this.CurrentFeatureIntensity = _loc5_;
								this.UpdateFeatureModifierButtonHint();
							}
					}
				}
			}
		}
		
		private function FeaturesApply() : *
		{
			var _loc1_:* = undefined;
			var _loc2_:Number = NaN;
			if(this.eFeature == this.AST_EXTRAS && this.CurrentSelectedExtra < uint.MAX_VALUE)
			{
				_loc1_ = this.BGSCodeObj.GetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra) > 0;
				_loc2_ = !!_loc1_?Number(0):Number(this.CurrentFeatureIntensity);
				this.BGSCodeObj.SetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra,_loc2_);
				if(!_loc1_ && this.CurrentExtraNumColors > 1)
				{
					this.BGSCodeObj.SetDetailColor(this.CurrentExtraGroup,this.CurrentSelectedExtra,this.CurrentExtraColor);
				}
				this.FeaturePanel_mc.List_mc.selectedEntry.applied = !_loc1_;
				this.FeaturePanel_mc.List_mc.UpdateSelectedEntry();
				this.UpdateButtons();
				this.buttonHint_FeatureMode_Apply.ButtonText = !!_loc1_?"$APPLY":"$REMOVE";
			}
		}
		
		private function FeaturesClear() : *
		{
			this.BGSCodeObj.ClearDetails();
			this.UpdateButtons();
		}
		
		private function FeatureCategoryMode() : *
		{
			this.eMode = this.FEATURE_CATEGORY_MODE;
			this.UpdateButtons();
			this.BGSCodeObj.GetFeatureData(this.FeaturePanel_mc.List_mc.entryList,this.AST_EXTRAS,uint.MAX_VALUE);
			this.FeatureListChangeLock++;
			this.FeaturePanel_mc.List_mc.InvalidateData();
			var _loc1_:* = this.LastSelectedExtraGroup;
			this.CurrentSelectedExtra = uint.MAX_VALUE;
			this.FeaturePanel_mc.List_mc.InvalidateData();
			this.FeatureListChangeLock--;
			this.FeaturePanel_mc.List_mc.selectedIndex = _loc1_;
			GlobalFunc.SetText(this.FeaturePanel_mc.Brackets_mc.Label_tf,"$EXTRAS",false,true);
			this.FeaturePanel_mc.Brackets_mc.UpperHorizontalLine_mc.x = this.FeaturePanel_mc.Brackets_mc.Label_tf.x + this.FeaturePanel_mc.Brackets_mc.Label_tf.textWidth + 5;
			this.FeaturePanel_mc.Brackets_mc.UpperHorizontalLine_mc.width = this.FeaturePanel_mc.Brackets_mc.UpperRightCorner_mc.x - this.FeaturePanel_mc.Brackets_mc.UpperHorizontalLine_mc.x;
			this.PreviousStageFocus = stage.focus;
			stage.focus = this.FeaturePanel_mc.List_mc;
		}
		
		private function SelectCategory() : *
		{
			this.CurrentExtraGroup = this.LastSelectedExtraGroup;
			this.FeatureMode(this.AST_EXTRAS);
		}
		
		private function FeatureMode(param1:uint) : *
		{
			var _loc5_:uint = 0;
			var _loc6_:* = undefined;
			this.eMode = this.FEATURE_MODE;
			this.eFeature = param1;
			this.UpdateButtons();
			this.BGSCodeObj.ClearBoneRegionTint();
			var _loc2_:String = "$TYPE";
			var _loc3_:uint = this.eFeature == this.AST_EXTRAS?uint(this.CurrentExtraGroup):uint(this.CurrentBoneID);
			var _loc4_:* = this.BGSCodeObj.GetFeatureData(this.FeaturePanel_mc.List_mc.entryList,this.eFeature,_loc3_);
			this.FeatureListChangeLock++;
			this.FeaturePanel_mc.List_mc.InvalidateData();
			_loc5_ = this.GetBoneRegionIndexFromCurrentID();
			switch(this.eFeature)
			{
				case this.AST_HAIR:
					this.ShowHairHighlight(false);
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_HAIRSTYLE);
					_loc2_ = "$STYLE";
					this.UpdateFeatureModifierButtonHint();
					break;
				case this.AST_HAIR_COLOR:
					this.ShowHairHighlight(false);
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_HAIRCOLOR);
					_loc2_ = "$COLOR";
					this.UpdateFeatureModifierButtonHint();
					break;
				case this.AST_BEARD:
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_BEARD);
					this.UpdateFeatureModifierButtonHint();
					break;
				case this.AST_COLOR:
					_loc6_ = this.FacialBoneRegions[this.CurrentActor][_loc5_].headPart;
					GlobalFunc.SetText(this.FacePartLabel_tf,_loc6_ == this.HeadPartEyes?"$EYE COLOR":"$SKIN TONE",false);
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_COLOR,this.CurrentBoneID);
					_loc2_ = "$COLOR";
					this.UpdateFeatureModifierButtonHint();
					break;
				case this.AST_EYES:
					GlobalFunc.SetText(this.FacePartLabel_tf,"$EYE COLOR",false);
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_COLOR,this.CurrentBoneID);
					_loc2_ = "$COLOR";
					this.UpdateFeatureModifierButtonHint();
					break;
				case this.AST_EXTRAS:
					_loc2_ = this.BGSCodeObj.GetExtraGroupName(this.CurrentExtraGroup);
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_EXTRAS);
					if(this.CurrentExtraGroup < uint.MAX_VALUE)
					{
						if(_loc4_ == uint.MAX_VALUE)
						{
							_loc4_ = 0;
						}
						this.CurrentSelectedExtra = _loc4_;
						if(!this.BGSCodeObj.GetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra))
						{
							this.BGSCodeObj.SetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra,Number(1),true);
							this.CurrentFeatureIntensity = 1;
						}
						this.CurrentExtraNumColors = this.BGSCodeObj.GetDetailColorCount(this.CurrentExtraGroup,this.CurrentSelectedExtra);
						this.CurrentExtraColor = this.BGSCodeObj.GetDetailColor(this.CurrentExtraGroup,this.CurrentSelectedExtra);
						this.UpdateFeatureModifierButtonHint();
					}
					break;
				case this.AST_MORPHS:
					this.BGSCodeObj.CreateUndoPoint(this.UNDO_MORPHS);
					this.CurrentFeatureIntensity = this.FacialBoneRegions[this.CurrentActor][_loc5_].presetIntensity;
					this.AppliedMorphIndex = _loc4_;
					this.AppliedMorphIntensity = this.CurrentFeatureIntensity;
					this.UpdateFeatureModifierButtonHint();
			}
			this.FeaturePanel_mc.List_mc.InvalidateData();
			this.FeatureListChangeLock--;
			this.FeaturePanel_mc.List_mc.selectedIndex = _loc4_;
			GlobalFunc.SetText(this.FeaturePanel_mc.Brackets_mc.Label_tf,_loc2_,false,true);
			this.FeaturePanel_mc.Brackets_mc.UpperHorizontalLine_mc.x = this.FeaturePanel_mc.Brackets_mc.Label_tf.x + this.FeaturePanel_mc.Brackets_mc.Label_tf.textWidth + 5;
			this.FeaturePanel_mc.Brackets_mc.UpperHorizontalLine_mc.width = this.FeaturePanel_mc.Brackets_mc.UpperRightCorner_mc.x - this.FeaturePanel_mc.Brackets_mc.UpperHorizontalLine_mc.x;
			this.PreviousStageFocus = stage.focus;
			stage.focus = this.FeaturePanel_mc.List_mc;
		}
		
		private function UpdateFeatureModifierButtonHint() : *
		{
			var _loc1_:Number = NaN;
			if(this.CurrentExtraGroup < uint.MAX_VALUE && this.CurrentSelectedExtra < uint.MAX_VALUE)
			{
				switch(this.CurrentExtraNumColors)
				{
					case 0:
						this.buttonHint_FeatureMode_Modifier.ButtonVisible = this.CurrentFeatureIntensity > 0;
						if(this.CurrentFeatureIntensity > 0)
						{
							this.buttonHint_FeatureMode_Modifier.ButtonText = uint(this.CurrentFeatureIntensity * 100).toString() + "%";
						}
						this.buttonHint_FeatureMode_Modifier.ButtonEnabled = this.CurrentFeatureIntensity > 0;
						this.buttonHint_FeatureMode_Modifier.SecondaryButtonEnabled = this.CurrentFeatureIntensity < 1;
						break;
					case 1:
						this.buttonHint_FeatureMode_Modifier.ButtonVisible = false;
						break;
					default:
						this.buttonHint_FeatureMode_Modifier.ButtonVisible = true;
						this.buttonHint_FeatureMode_Modifier.ButtonEnabled = this.CurrentExtraColor > 0;
						this.buttonHint_FeatureMode_Modifier.SecondaryButtonEnabled = this.CurrentExtraColor < this.CurrentExtraNumColors - 1;
						this.buttonHint_FeatureMode_Modifier.ButtonText = "$$COLOR " + (this.CurrentExtraColor < 9?"0":"") + (this.CurrentExtraColor + 1).toString();
				}
				_loc1_ = this.BGSCodeObj.GetDetailIntensity(this.CurrentExtraGroup,this.CurrentSelectedExtra);
				this.buttonHint_FeatureMode_Apply.ButtonText = _loc1_ > 0?"$REMOVE":"$APPLY";
			}
			else if(this.eFeature == this.AST_MORPHS)
			{
				this.buttonHint_FeatureMode_Modifier.ButtonVisible = this.CurrentFeatureIntensity > 0;
				if(this.CurrentFeatureIntensity > 0)
				{
					this.buttonHint_FeatureMode_Modifier.ButtonText = uint(this.CurrentFeatureIntensity * 100).toString() + "%";
				}
			}
			else
			{
				this.buttonHint_FeatureMode_Modifier.ButtonVisible = false;
			}
		}
		
		private function getInput(param1:*) : *
		{
			var _loc2_:* = undefined;
			if(this._controlsEnabled)
			{
				if(this.eMode == this.START_MODE && uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					_loc2_ = this.StartModeInputMapKBM[param1];
				}
				else
				{
					_loc2_ = this.InputMapA[this.eMode][param1];
				}
				if(!_loc2_)
				{
					_loc2_ = this.AllModeInputMap[param1];
				}
			}
			else
			{
				_loc2_ = null;
			}
			return _loc2_;
		}
		
		public function onKeyDown(param1:KeyboardEvent) : *
		{
			if(visible && !this.confirmClose && this.InputFunctionsA[this.eMode][this.getInput(param1.keyCode)] != null)
			{
				this.InputFunctionsA[this.eMode][this.getInput(param1.keyCode)]();
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(this.eMode != this.START_MODE || param1 != "Cancel" || uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
			{
				if(!param2 && !this.confirmClose && this.InputFunctionsA[this.eMode][this.getInput(param1)] != null)
				{
					this.InputFunctionsA[this.eMode][this.getInput(param1)]();
					if(param1 != "Up" && param1 != "Down" && param1 != "Left" && param1 != "Right")
					{
						_loc3_ = true;
					}
					if(param1 == "Accept")
					{
						if(this.eMode == this.FEATURE_MODE || this.eMode == this.FEATURE_CATEGORY_MODE)
						{
							this.BlockNextAccept = true;
						}
					}
				}
			}
			return _loc3_;
		}
		
		public function SetWeightPoint(param1:Number, param2:Number) : *
		{
			this.WeightTriangle_mc.CurrentWeightTick_mc.x = GlobalFunc.Lerp(0,this.TriangleSize,0,1,param1,true);
			this.WeightTriangle_mc.CurrentWeightTick_mc.y = GlobalFunc.Lerp(0,this.TriangleSize,0,1,param2,true);
		}
		
		private function onWeightTriangleChange(param1:MouseEvent) : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			if(param1.buttonDown && this.eMode == this.BODY_MODE)
			{
				_loc2_ = GlobalFunc.Lerp(0,1,0,this.TriangleSize,param1.localX,true);
				_loc3_ = GlobalFunc.Lerp(0,1,0,this.TriangleSize,param1.localY,true);
				this.BGSCodeObj.WeightPointChange(_loc2_,_loc3_);
			}
		}
		
		public function SetCursorPosition(param1:Number, param2:Number) : *
		{
			this.Cursor_mc.x = param1 * 1280;
			this.Cursor_mc.y = param2 * 720;
			this.LoadingSpinner_mc.x = this.Cursor_mc.x;
			this.LoadingSpinner_mc.y = this.Cursor_mc.y;
		}
		
		public function set menuMode(param1:uint) : *
		{
			this.eMode = param1 < uint.MAX_VALUE?uint(param1):uint(this.START_MODE);
			if(this.EditMode != this.EDIT_HAIRCUT)
			{
				if(param1 == this.HAIR_MODE)
				{
					this.ShowHairHighlight(true);
				}
				else if(param1 == this.FACE_MODE)
				{
					this.ShowHairHighlight(false);
				}
			}
			this.UpdateButtons();
		}
		
		public function get menuMode() : uint
		{
			return this.eMode;
		}
		
		public function set currentBoneRegionID(param1:uint) : *
		{
			this.CurrentBoneID = param1;
			this.UpdateButtons();
		}
		
		public function UpdateButtons() : *
		{
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			var _loc1_:uint = this.GetBoneRegionIndexFromCurrentID();
			var _loc2_:Boolean = this.eMode == this.SCULPT_MODE || this.eMode == this.FEATURE_MODE;
			this.buttonHint_StartMode_Preset.ButtonVisible = this.bInitialized && (this.eMode == this.START_MODE && this.EditMode == this.EDIT_CHARGEN);
			this.buttonHint_StartMode_Preset.ButtonVisible = this.bInitialized && (this.eMode == this.START_MODE && this.EditMode == this.EDIT_CHARGEN);
			this.buttonHint_StartMode_Face.ButtonVisible = this.bInitialized && this.eMode == this.START_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD);
			this.buttonHint_StartMode_Extras.ButtonVisible = this.bInitialized && this.eMode == this.START_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD);
			this.buttonHint_StartMode_Sex.ButtonVisible = this.bInitialized && (this.eMode == this.START_MODE && this.EditMode == this.EDIT_CHARGEN && this.AllowChangeSex);
			this.buttonHint_StartMode_Body.ButtonVisible = this.bInitialized && this.eMode == this.START_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD);
			this.buttonHint_StartMode_Done.ButtonVisible = this.bInitialized && (this.eMode == this.START_MODE || this.eMode == this.HAIR_MODE && this.EditMode == this.EDIT_HAIRCUT);
			this.buttonHint_FaceMode_Sculpt.ButtonVisible = this.eMode == this.FACE_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD);
			this.buttonHint_HairMode_Style.ButtonVisible = this.eMode == this.HAIR_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_HAIRCUT);
			this.buttonHint_FaceMode_Type.ButtonVisible = this.eMode == this.FACE_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD) || this.eMode == this.HAIR_MODE && this.EditMode == this.EDIT_HAIRCUT && !this._bisFemale;
			this.buttonHint_FaceMode_Color.ButtonVisible = this.eMode == this.FACE_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD) || this.eMode == this.HAIR_MODE && (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_HAIRCUT);
			this.buttonHint_FaceMode_Back.ButtonVisible = (this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD) && (this.eMode == this.FACE_MODE || this.eMode == this.HAIR_MODE);
			this.buttonHint_EditAccept.ButtonVisible = this.eMode == this.SCULPT_MODE || this.eMode == this.FEATURE_MODE || this.eMode == this.BODY_MODE;
			this.buttonHint_EditCancel.ButtonVisible = this.eMode == this.SCULPT_MODE || this.eMode == this.FEATURE_MODE || this.eMode == this.BODY_MODE;
			this.buttonHint_SculptMode_Move.ButtonVisible = this.eMode == this.SCULPT_MODE && (this.GetValidAxis(this.X_AXIS) || this.GetValidAxis(this.Y_AXIS));
			this.buttonHint_SculptMode_Slide.ButtonVisible = this.eMode == this.SCULPT_MODE && this.GetValidAxis(this.Z_AXIS);
			this.buttonHint_SculptMode_Rotate.ButtonVisible = this.eMode == this.SCULPT_MODE && this.GetValidAxis(this.X_ROT_AXIS);
			this.buttonHint_SculptMode_Scale.ButtonVisible = this.eMode == this.SCULPT_MODE && this.GetValidAxis(this.X_SCALE_AXIS);
			this.buttonHint_FeatureMode_Modifier.ButtonVisible = this.eMode == this.FEATURE_MODE && this.CurrentFeatureIntensity > 0 && this.CurrentExtraNumColors != 1;
			this.buttonHint_FeatureMode_Apply.ButtonVisible = this.eMode == this.FEATURE_MODE && this.eFeature == this.AST_EXTRAS;
			this.buttonHint_FeatureCategoryMode_RemoveAll.ButtonVisible = this.eMode == this.FEATURE_CATEGORY_MODE;
			this.buttonHint_FeatureCategoryMode_Select.ButtonVisible = this.eMode == this.FEATURE_CATEGORY_MODE;
			this.buttonHint_FeatureCategoryMode_Back.ButtonVisible = this.eMode == this.FEATURE_CATEGORY_MODE;
			this.Cursor_mc.visible = !this._loading && this.EditMode != this.EDIT_HAIRCUT && (this.eMode == this.FACE_MODE || this.eMode == this.HAIR_MODE);
			this.LoadingSpinner_mc.alpha = !!this._loading?Number(1):Number(0);
			this.FacePartLabel_tf.alpha = this.EditMode != this.EDIT_HAIRCUT && (this.eMode != this.START_MODE && this.eMode != this.BODY_MODE && this.eMode != this.FEATURE_CATEGORY_MODE && (this.eMode != this.FEATURE_MODE || this.eFeature != this.AST_EXTRAS));
			this.WeightTriangle_mc.alpha = this.eMode == this.BODY_MODE?Number(1):Number(0);
			this.FeaturePanel_mc.visible = this.eMode == this.FEATURE_MODE || this.eMode == this.FEATURE_CATEGORY_MODE;
			this.FeaturePanel_mc.Brackets_mc.BracketExtents_mc.visible = this.eMode == this.FEATURE_MODE || this.eMode == this.FEATURE_CATEGORY_MODE;
			switch(this.eMode)
			{
				case this.START_MODE:
					_loc3_ = !!this.bInitialized?this.BGSCodeObj.GetLastCharacterPreset():0;
					this.buttonHint_StartMode_Preset.ButtonText = "$$FACE " + (_loc3_ < 9?"0":"") + (_loc3_ + 1).toString();
					break;
				case this.FACE_MODE:
					this.eFeature = this.AST_COUNT;
					_loc4_ = this.CurrentBoneID < uint.MAX_VALUE;
					if(_loc4_)
					{
						if(this.FacialBoneRegions[this.CurrentActor][_loc1_].headPart == this.HeadPartFacialHair)
						{
							if(this.EditMode == this.EDIT_CHARGEN)
							{
								this.buttonHint_FaceMode_Type.ButtonText = "$FACIAL HAIR";
								this.buttonHint_FaceMode_Type.ButtonEnabled = true;
								this.buttonHint_FaceMode_Type.ButtonVisible = true;
							}
							else
							{
								this.buttonHint_FaceMode_Type.ButtonVisible = false;
							}
						}
						else if(this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD)
						{
							if(this.FacialBoneRegions[this.CurrentActor][_loc1_].associatedPresetGroup != null)
							{
								this.buttonHint_FaceMode_Type.ButtonText = "$TYPE";
								this.buttonHint_FaceMode_Type.ButtonEnabled = true;
							}
							else
							{
								this.buttonHint_FaceMode_Type.ButtonEnabled = false;
							}
							this.buttonHint_FaceMode_Type.ButtonVisible = true;
						}
						else
						{
							this.buttonHint_FaceMode_Type.ButtonVisible = false;
						}
					}
					else if(this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD)
					{
						this.buttonHint_FaceMode_Type.ButtonText = "$TYPE";
						this.buttonHint_FaceMode_Type.ButtonEnabled = false;
						this.buttonHint_FaceMode_Type.ButtonVisible = true;
					}
					else
					{
						this.buttonHint_FaceMode_Type.ButtonVisible = false;
					}
					if(this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_BODYMOD)
					{
						this.buttonHint_FaceMode_Sculpt.ButtonEnabled = this.buttonHint_FaceMode_Color.ButtonEnabled = _loc4_;
					}
					else
					{
						this.buttonHint_FaceMode_Sculpt.ButtonVisible = false;
					}
					this.FacePartLabel_tf.visible = this.buttonHint_FaceMode_Type.ButtonEnabled && this.buttonHint_FaceMode_Type.ButtonVisible || this.buttonHint_FaceMode_Sculpt.ButtonEnabled && this.buttonHint_FaceMode_Sculpt.ButtonVisible || this.buttonHint_FaceMode_Color.ButtonEnabled && this.buttonHint_FaceMode_Color.ButtonVisible;
					this.FacePartLabel_tf.alpha = this.CurrentBoneID < uint.MAX_VALUE?1:0;
					if(this.CurrentBoneID < uint.MAX_VALUE)
					{
						GlobalFunc.SetText(this.FacePartLabel_tf,this.FacialBoneRegions[this.CurrentActor][_loc1_].name,false,true);
					}
					break;
				case this.HAIR_MODE:
					this.eFeature = this.AST_HAIR;
					if(this.EditMode == this.EDIT_HAIRCUT)
					{
						this.buttonHint_FaceMode_Type.ButtonText = "$FACIAL HAIR";
						this.buttonHint_FaceMode_Type.ButtonEnabled = true;
					}
					this.buttonHint_HairMode_Style.ButtonEnabled = true;
					this.buttonHint_FaceMode_Color.ButtonEnabled = true;
					this.FacePartLabel_tf.visible = true;
					this.FacePartLabel_tf.alpha = this.EditMode == this.EDIT_CHARGEN || this.EditMode == this.EDIT_HAIRCUT?1:0;
					GlobalFunc.SetText(this.FacePartLabel_tf,"$HAIR",false,true);
					break;
				case this.BODY_MODE:
					break;
				case this.SCULPT_MODE:
					GlobalFunc.SetText(this.FacePartLabel_tf,this.FacialBoneRegions[this.CurrentActor][_loc1_].name,false,true);
					break;
				case this.FEATURE_CATEGORY_MODE:
					this.buttonHint_FeatureCategoryMode_RemoveAll.ButtonEnabled = this.BGSCodeObj.GetHasDetailsApplied();
					break;
				case this.FEATURE_MODE:
					if(this.eFeature == this.AST_BEARD)
					{
						GlobalFunc.SetText(this.FacePartLabel_tf,"$FACIAL HAIR",false,true);
					}
			}
			if(this.bInitialized)
			{
				this.BGSCodeObj.SetSculptMode(this.eMode == this.SCULPT_MODE);
				this.BGSCodeObj.SetFeatureMode(this.eMode == this.FEATURE_MODE);
				this.BGSCodeObj.SetBumpersRepeat(_loc2_);
			}
		}
		
		function __setProp_ButtonHintBar_mc_LooksMenuBase_Shared_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 1;
			this.ButtonHintBar_mc.BackgroundColor = 0;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			this.ButtonHintBar_mc.bShowBrackets = true;
			this.ButtonHintBar_mc.bUseShadedBackground = true;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Shader";
			this.ButtonHintBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
