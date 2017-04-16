package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextFieldAutoSize;
	
	public class VATSMenu extends IMenu
	{
		 
		
		private const MAX_NEAREST_PARTS:uint = 4;
		
		private const RESISTANCE_ENTRY_SPACING:Number = 14;
		
		public var PartSelectDistanceWeight:Number = 0.3;
		
		public var BGSCodeObj:Object;
		
		public var ButtonHintInstance:BSButtonHintBar;
		
		public var ApplyCriticalInstance:MovieClip;
		
		public var FourLeafInstance:MovieClip;
		
		public var ResistancesInstance:MovieClip;
		
		public var ResistanceBracketsInstance:MovieClip;
		
		public var PartInfos:Array;
		
		public var SelectedPart:uint;
		
		public var ResistanceData:Array;
		
		private var ButtonDataA:Vector.<BSButtonHintData>;
		
		private var SelectButton:BSButtonHintData;
		
		private var AcceptButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		
		private var BodyPartButton:BSButtonHintData;
		
		private var CycleTargetsButton:BSButtonHintData;
		
		private var ExecuteCriticalButton:BSButtonHintData;
		
		private var CancelPlaybackButton:BSButtonHintData;
		
		private var bShowPlaybackButtons:Boolean = false;
		
		private var bShowButtonHelp:Boolean = true;
		
		public function VATSMenu()
		{
			this.ResistanceData = new Array();
			this.SelectButton = new BSButtonHintData("$Select","Q","PSN_R2","Xenon_R2",1,this.onSelectButtonClick);
			this.AcceptButton = new BSButtonHintData("$ACCEPT","E","PSN_A","Xenon_A",1,this.onAcceptButtonClick);
			this.CancelButton = new BSButtonHintData("$RETURN","Tab","PSN_B","Xenon_B",1,this.onCancelButtonClick);
			this.BodyPartButton = new BSButtonHintData("$BODY PART","W,S","PSN_LS","Xenon_LS",1,this.onBodyPartButtonClick);
			this.CycleTargetsButton = new BSButtonHintData("$Cycle Targets","A,D","PSN_RS","Xenon_RS",1,this.onCycleTargetButtonClick);
			this.ExecuteCriticalButton = new BSButtonHintData("$Execute Critical","Space","PSN_X","Xenon_X",1,this.onExecuteCriticalButtonClick);
			this.CancelPlaybackButton = new BSButtonHintData("$ABORT","Tab","PSN_B","Xenon_B",1,this.onCancelPlaybackButtonClick);
			super();
			stage.align = StageAlign.TOP_LEFT;
			this.BGSCodeObj = new Object();
			this.PartInfos = new Array();
			this.SelectedPart = uint.MAX_VALUE;
			this.SetResistancesVisible(false);
			this.ApplyCriticalInstance.stop();
			this.ApplyCriticalInstance.visible = false;
			this.x = 0;
			this.y = 0;
			this.UpdateButtonVisibility();
			this.ButtonDataA = new Vector.<BSButtonHintData>();
			this.ButtonDataA.push(this.SelectButton);
			this.ButtonDataA.push(this.AcceptButton);
			this.ButtonDataA.push(this.CancelButton);
			this.ButtonDataA.push(this.BodyPartButton);
			this.ButtonDataA.push(this.CycleTargetsButton);
			this.ButtonDataA.push(this.ExecuteCriticalButton);
			this.ButtonDataA.push(this.CancelPlaybackButton);
			this.ButtonHintInstance.SetButtonHintData(this.ButtonDataA);
		}
		
		private function onSelectButtonClick() : *
		{
			this.BGSCodeObj.QueueAction();
		}
		
		private function onAcceptButtonClick() : *
		{
			this.BGSCodeObj.StartPlayback();
		}
		
		private function onCancelButtonClick() : *
		{
			this.BGSCodeObj.onCancel();
		}
		
		private function onBodyPartButtonClick() : *
		{
			this.BGSCodeObj.CycleBodyPart();
		}
		
		private function onCycleTargetButtonClick() : *
		{
			this.BGSCodeObj.CycleTarget();
		}
		
		private function onExecuteCriticalButtonClick() : *
		{
			this.BGSCodeObj.ExecuteCritical();
		}
		
		private function onCancelPlaybackButtonClick() : *
		{
			this.BGSCodeObj.CancelPlayback();
		}
		
		public function SetSelectedPart(auiPartIndex:uint) : *
		{
			this.SelectedPart = auiPartIndex;
		}
		
		public function UpdatePartPositions(aPartPosArray:Array) : *
		{
			var minDist:Number = NaN;
			var adjustedPartPos:Point = null;
			var compareIndex:uint = 0;
			var xdist:Number = NaN;
			var ydist:Number = NaN;
			var sqDist:Number = NaN;
			var bumpVec:Point = null;
			var pointDist:Number = NaN;
			var bumpAdjustment:Number = NaN;
			var bumpScale:Number = NaN;
			var adjustMult:Number = NaN;
			var stageWidth:Number = stage.stageWidth;
			var stageHeight:Number = stage.stageHeight;
			var i:uint = 0;
			while(i < aPartPosArray.length && i < this.PartInfos.length)
			{
				if(aPartPosArray[i].x != undefined && aPartPosArray[i].x > 0)
				{
					this.PartInfos[i].visible = true;
					this.PartInfos[i].x = aPartPosArray[i].x * stageWidth;
					this.PartInfos[i].y = aPartPosArray[i].y * stageHeight;
				}
				else
				{
					this.PartInfos[i].visible = false;
				}
				i++;
			}
			var numAdjustments:uint = 2;
			minDist = 80;
			var minDistSq:Number = minDist * minDist;
			var maxAdjustment:Number = 50;
			var partPosAdjustments:Array = new Array();
			for(i = 0; i < this.PartInfos.length; i++)
			{
				partPosAdjustments[i] = new Point(0,0);
			}
			for(var adjustmentIter:uint = 0; adjustmentIter < numAdjustments; adjustmentIter++)
			{
				for(i = 1; i < this.PartInfos.length; i++)
				{
					if(this.PartInfos[i].visible)
					{
						adjustedPartPos = new Point(this.PartInfos[i].x + partPosAdjustments[i].x,this.PartInfos[i].y + partPosAdjustments[i].y);
						for(compareIndex = 0; compareIndex < this.PartInfos.length; compareIndex++)
						{
							if(i != compareIndex && this.PartInfos[compareIndex].visible)
							{
								xdist = this.PartInfos[compareIndex].x - adjustedPartPos.x;
								ydist = this.PartInfos[compareIndex].y - adjustedPartPos.y;
								sqDist = xdist * xdist + ydist * ydist;
								if(sqDist < minDistSq)
								{
									bumpVec = new Point(adjustedPartPos.x - this.PartInfos[compareIndex].x,adjustedPartPos.y - this.PartInfos[compareIndex].y);
									pointDist = bumpVec.length;
									bumpAdjustment = Math.max(0,minDist - pointDist);
									if(pointDist > 0)
									{
										bumpScale = bumpAdjustment / pointDist;
										bumpVec.x = bumpVec.x * bumpScale;
										bumpVec.y = bumpVec.y * bumpScale;
										partPosAdjustments[i].x = partPosAdjustments[i].x + bumpVec.x;
										partPosAdjustments[i].y = partPosAdjustments[i].y + bumpVec.y;
									}
								}
							}
						}
					}
				}
			}
			for(i = 0; i < this.PartInfos.length; i++)
			{
				adjustMult = partPosAdjustments[i].length;
				if(adjustMult > maxAdjustment && adjustMult > 0)
				{
					adjustMult = maxAdjustment / adjustMult;
					partPosAdjustments[i].x = partPosAdjustments[i].x * adjustMult;
					partPosAdjustments[i].y = partPosAdjustments[i].y * adjustMult;
				}
				this.PartInfos[i].x = this.PartInfos[i].x + partPosAdjustments[i].x;
				this.PartInfos[i].y = this.PartInfos[i].y + partPosAdjustments[i].y;
			}
		}
		
		public function FindNearestParts(aNearestParts:Vector.<uint>, auiSelectedPart:uint, aInput:Vector3D, aAngleThresholdDeg:Number) : *
		{
			var selectedPart:PartInfo = null;
			var selectedPartPos:Vector3D = null;
			var comparisonIndices:Vector.<uint> = null;
			var comparisonValues:Vector.<Number> = null;
			var inputPerp:Vector3D = null;
			var angleThresholdRad:* = undefined;
			var partIndex:uint = 0;
			var i:uint = 0;
			var partVec:Vector3D = null;
			aNearestParts.length = 0;
			if(auiSelectedPart < this.PartInfos.length)
			{
				selectedPart = this.PartInfos[auiSelectedPart];
				selectedPartPos = new Vector3D(selectedPart.x,selectedPart.y);
				comparisonIndices = new Vector.<uint>(this.PartInfos.length,true);
				comparisonValues = new Vector.<Number>(this.PartInfos.length,true);
				inputPerp = new Vector3D(-aInput.y,aInput.x);
				angleThresholdRad = aAngleThresholdDeg * Math.PI / 180;
				for(partIndex = 0; partIndex < this.PartInfos.length; partIndex++)
				{
					comparisonIndices[partIndex] = partIndex;
					if(partIndex == auiSelectedPart)
					{
						comparisonValues[partIndex] = -1;
					}
					else
					{
						partVec = new Vector3D(this.PartInfos[partIndex].x,this.PartInfos[partIndex].y);
						partVec.decrementBy(selectedPartPos);
						comparisonValues[partIndex] = Vector3D.angleBetween(aInput,partVec) <= angleThresholdRad?Number(this.PartSelectDistanceWeight * Math.abs(aInput.dotProduct(partVec)) + Math.abs(inputPerp.dotProduct(partVec))):Number(-1);
					}
				}
				comparisonIndices.sort(function(aVal1:uint, aVal2:uint):*
				{
					var compareResult:int = 0;
					if(comparisonValues[aVal1] < comparisonValues[aVal2])
					{
						compareResult = -1;
					}
					else if(comparisonValues[aVal1] > comparisonValues[aVal2])
					{
						compareResult = 1;
					}
					return compareResult;
				});
				i = 0;
				while(i < comparisonIndices.length && aNearestParts.length < this.MAX_NEAREST_PARTS)
				{
					if(comparisonValues[comparisonIndices[i]] >= 0)
					{
						aNearestParts.push(comparisonIndices[i]);
					}
					i++;
				}
			}
		}
		
		public function ProcessPartSelectionInput(aXInput:Number, aYInput:Number, aAngleThresholdDeg:Number) : *
		{
			var input:Vector3D = new Vector3D(aXInput,-aYInput);
			input.normalize();
			var nearestParts:Vector.<uint> = new Vector.<uint>();
			this.FindNearestParts(nearestParts,this.SelectedPart,input,aAngleThresholdDeg);
			if(nearestParts.length > 0)
			{
				this.BGSCodeObj.SelectPart(nearestParts[0]);
			}
		}
		
		public function SetPartChanceToHit(aPart:uint, aChance:uint) : *
		{
			if(aPart < this.PartInfos.length)
			{
				this.PartInfos[aPart].SetChanceToHit(aChance);
			}
		}
		
		public function RefreshActionDisplay(aTargetedPartIndices:Array) : *
		{
			var highestActionIndex:uint = 0;
			var actionCounts:Vector.<uint> = new Vector.<uint>(this.PartInfos.length);
			for(var actionIndex:uint = 0; actionIndex < aTargetedPartIndices.length; actionIndex++)
			{
				actionCounts[aTargetedPartIndices[actionIndex]] = actionCounts[aTargetedPartIndices[actionIndex]] + 1;
				if(actionCounts[aTargetedPartIndices[actionIndex]] >= actionCounts[highestActionIndex])
				{
					highestActionIndex = aTargetedPartIndices[actionIndex];
				}
			}
			for(var partIndex:uint = 0; partIndex < this.PartInfos.length; partIndex++)
			{
				this.PartInfos[partIndex].SetActionCount(actionCounts[partIndex]);
			}
			if(this.getChildAt(this.numChildren - 1) != this.PartInfos[highestActionIndex])
			{
				this.swapChildren(this.getChildAt(this.numChildren - 1),this.PartInfos[highestActionIndex]);
			}
		}
		
		override public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean) : *
		{
			super.SetPlatform(auiPlatform,abPS3Switch);
		}
		
		public function ShowPlaybackButtons() : *
		{
			this.SetResistancesVisible(false);
			this.bShowPlaybackButtons = true;
			this.UpdateButtonVisibility();
			this.DisableCriticalButton();
		}
		
		public function UpdateButtonVisibility() : *
		{
			this.SelectButton.ButtonVisible = this.bShowButtonHelp && !this.bShowPlaybackButtons;
			this.AcceptButton.ButtonVisible = this.bShowButtonHelp && !this.bShowPlaybackButtons;
			this.CancelButton.ButtonVisible = this.bShowButtonHelp && !this.bShowPlaybackButtons;
			this.BodyPartButton.ButtonVisible = this.bShowButtonHelp && !this.bShowPlaybackButtons && this.PartInfos.length > 1;
			this.CycleTargetsButton.ButtonVisible = this.bShowButtonHelp && !this.bShowPlaybackButtons;
			this.ExecuteCriticalButton.ButtonVisible = this.bShowButtonHelp && this.bShowPlaybackButtons;
			this.CancelPlaybackButton.ButtonVisible = this.bShowButtonHelp && this.bShowPlaybackButtons;
		}
		
		public function HideButtonHelp() : *
		{
			this.SetResistancesVisible(false);
			this.bShowButtonHelp = false;
			this.UpdateButtonVisibility();
		}
		
		public function ShowButtonHelp() : *
		{
			this.SetResistancesVisible(this.ResistanceData.length > 0);
			this.bShowButtonHelp = true;
			this.UpdateButtonVisibility();
		}
		
		public function EnableCriticalButton() : *
		{
			this.ExecuteCriticalButton.ButtonDisabled = false;
			this.ExecuteCriticalButton.ButtonFlashing = true;
		}
		
		public function DisableCriticalButton() : *
		{
			this.ExecuteCriticalButton.ButtonFlashing = false;
			this.ExecuteCriticalButton.ButtonDisabled = true;
		}
		
		public function ApplyCritical() : *
		{
			this.ApplyCriticalInstance.visible = true;
			this.ApplyCriticalInstance.gotoAndPlay("Show");
			this.FourLeafInstance.visible = false;
		}
		
		public function DisableAbortButton() : *
		{
			this.CancelPlaybackButton.ButtonDisabled = true;
		}
		
		public function ShowFourLeafClip() : *
		{
			this.FourLeafInstance.visible = true;
			this.FourLeafInstance.gotoAndPlay("Show");
			this.ApplyCriticalInstance.visible = false;
		}
		
		public function SetResistancesVisible(abVisible:Boolean) : *
		{
			this.ResistancesInstance.visible = abVisible;
			this.ResistanceBracketsInstance.visible = abVisible;
		}
		
		public function UpdateTargetInfo() : *
		{
			var entry:ResistanceEntry = null;
			var scale:Number = NaN;
			for(var i:uint = this.ResistancesInstance.Container.numChildren; i < this.ResistanceData.length; i++)
			{
				this.ResistancesInstance.Container.addChild(new ResistanceEntry());
			}
			this.ResistancesInstance.BackgroundInstance.width = 0;
			var currXPos:Number = 0;
			for(i = 0; i < this.ResistancesInstance.Container.numChildren; i++)
			{
				entry = this.ResistancesInstance.Container.getChildAt(i) as ResistanceEntry;
				entry.visible = i < this.ResistanceData.length;
				scale = !!entry.visible?Number(1):Number(0);
				entry.scaleX = scale;
				entry.scaleY = scale;
				entry.x = currXPos;
				entry.y = 0;
				entry.ResistanceValue.autoSize = TextFieldAutoSize.LEFT;
				if(entry.visible)
				{
					entry.ResistanceIcon.gotoAndStop(this.ResistanceData[i].damageType);
					if(this.ResistanceData[i].bImmune)
					{
						entry.ResistanceValue.visible = false;
						entry.ResistanceValue.text = "";
						entry.ImmunityIcon.visible = true;
					}
					else
					{
						entry.ResistanceValue.visible = true;
						entry.ResistanceValue.text = this.ResistanceData[i].text;
						entry.ImmunityIcon.visible = false;
					}
					currXPos = currXPos + (entry.width + this.RESISTANCE_ENTRY_SPACING);
				}
			}
			this.ResistancesInstance.BackgroundInstance.width = this.ResistanceData.length > 0?this.ResistancesInstance.width + this.RESISTANCE_ENTRY_SPACING:0;
			this.ResistancesInstance.x = stage.stageWidth / 2 - this.ResistancesInstance.width / 2;
			this.ResistanceBracketsInstance.width = this.ResistancesInstance.width;
			this.UpdateButtonVisibility();
		}
		
		public function SetTargetLevel(aLevel:uint) : *
		{
			this.ResistancesInstance.Level.text = aLevel;
		}
	}
}
