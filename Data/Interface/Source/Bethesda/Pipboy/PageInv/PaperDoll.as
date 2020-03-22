package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public class PaperDoll extends BSUIComponent
	{
		 
		
		public var Helmet_mc:MovieClip;
		
		public var LeftLeg_mc:MovieClip;
		
		public var LeftArm_mc:MovieClip;
		
		public var Torso_mc:MovieClip;
		
		public var Goggles_mc:MovieClip;
		
		public var GasMask_mc:MovieClip;
		
		public var RightLeg_mc:MovieClip;
		
		public var RightArm_mc:MovieClip;
		
		public var Head_Resist_mc:PaperDoll_ResistEntry;
		
		public var Torso_Resist_mc:PaperDoll_ResistEntry;
		
		public var LArm_Resist_mc:PaperDoll_ResistEntry;
		
		public var RArm_Resist_mc:PaperDoll_ResistEntry;
		
		public var LLeg_Resist_mc:PaperDoll_ResistEntry;
		
		public var RLeg_Resist_mc:PaperDoll_ResistEntry;
		
		private var _DisplayedDamageType:uint;
		
		private const IDX_UNDERWEAR:uint = 0;
		
		private const IDX_LEFT_LEG:uint = 1;
		
		private const IDX_RIGHT_LEG:uint = 2;
		
		private const IDX_LEFT_ARM:uint = 3;
		
		private const IDX_RIGHT_ARM:uint = 4;
		
		private const IDX_TORSO:uint = 5;
		
		private const IDX_HELMET:uint = 6;
		
		private const IDX_GOGGLES:uint = 7;
		
		private const IDX_GAS_MASK:uint = 8;
		
		private var _SlotResists:Array;
		
		private var _SelectedInfoObj:Array;
		
		private const UNDERWEAR_NONE:uint = 0;
		
		private const UNDERWEAR_GENERIC:uint = 0;
		
		private const UNDERWEAR_VAULT:uint = 0;
		
		private var _UnderwearType:uint;
		
		private var _DisplayDamageTypes:Array;
		
		public function PaperDoll()
		{
			this._DisplayDamageTypes = new Array(1,4,6);
			super();
			addFrameScript(0,this.frame1);
			this._SelectedInfoObj = new Array();
			this._UnderwearType = 0;
			this._DisplayedDamageType = 0;
		}
		
		public function get selectedInfoObj() : Array
		{
			return this._SelectedInfoObj;
		}
		
		public function set underwearType(param1:uint) : *
		{
			this._UnderwearType = param1;
		}
		
		public function set slotResists(param1:Array) : *
		{
			this._SlotResists = param1;
		}
		
		public function IncrementDisplayedDamageType() : *
		{
			if(this._DisplayedDamageType == this._DisplayDamageTypes.length - 1)
			{
				this._DisplayedDamageType = 0;
			}
			else
			{
				this._DisplayedDamageType++;
			}
			SetIsDirty();
		}
		
		public function onDataChange() : *
		{
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:Number = NaN;
			super.redrawUIComponent();
			if(this._SelectedInfoObj.length > 0)
			{
				gotoAndStop(this._UnderwearType + 1);
				if(this._SelectedInfoObj[this.IDX_LEFT_LEG])
				{
					this.LeftLeg_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.LeftLeg_mc.gotoAndStop("Shown");
				}
				this.LeftLeg_mc.visible = this._SelectedInfoObj[this.IDX_LEFT_LEG] || this._SlotResists[this.IDX_LEFT_LEG].length > 0;
				if(this._SelectedInfoObj[this.IDX_RIGHT_LEG])
				{
					this.RightLeg_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.RightLeg_mc.gotoAndStop("Shown");
				}
				this.RightLeg_mc.visible = this._SelectedInfoObj[this.IDX_RIGHT_LEG] || this._SlotResists[this.IDX_RIGHT_LEG].length > 0;
				if(this._SelectedInfoObj[this.IDX_LEFT_ARM])
				{
					this.LeftArm_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.LeftArm_mc.gotoAndStop("Shown");
				}
				this.LeftArm_mc.visible = this._SelectedInfoObj[this.IDX_LEFT_ARM] || this._SlotResists[this.IDX_LEFT_ARM].length > 0;
				if(this._SelectedInfoObj[this.IDX_RIGHT_ARM])
				{
					this.RightArm_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.RightArm_mc.gotoAndStop("Shown");
				}
				this.RightArm_mc.visible = this._SelectedInfoObj[this.IDX_RIGHT_ARM] || this._SlotResists[this.IDX_RIGHT_ARM].length > 0;
				if(this._SelectedInfoObj[this.IDX_TORSO])
				{
					this.Torso_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.Torso_mc.gotoAndStop("Shown");
				}
				this.Torso_mc.visible = this._SelectedInfoObj[this.IDX_TORSO] || this._SlotResists[this.IDX_TORSO].length > 0;
				if(this._SelectedInfoObj[this.IDX_HELMET])
				{
					this.Helmet_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.Helmet_mc.gotoAndStop("Shown");
				}
				this.Helmet_mc.visible = this._SelectedInfoObj[this.IDX_HELMET] || this._SlotResists[this.IDX_HELMET].length > 0;
				if(this._SelectedInfoObj[this.IDX_GOGGLES])
				{
					this.Goggles_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.Goggles_mc.gotoAndStop("Shown");
				}
				this.Goggles_mc.visible = this._SelectedInfoObj[this.IDX_GOGGLES] || this._SlotResists[this.IDX_GOGGLES].length > 0;
				if(this._SelectedInfoObj[this.IDX_GAS_MASK])
				{
					this.GasMask_mc.gotoAndPlay("Animate");
				}
				else
				{
					this.GasMask_mc.gotoAndStop("Shown");
				}
				this.GasMask_mc.visible = this._SelectedInfoObj[this.IDX_GAS_MASK] || this._SlotResists[this.IDX_GAS_MASK].length > 0;
				_loc1_ = 0;
				_loc1_ = this.GetSlotResist(this.IDX_HELMET);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_GOGGLES);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_GAS_MASK);
				this.Head_Resist_mc.SetData(this._DisplayDamageTypes[this._DisplayedDamageType],_loc1_);
				_loc1_ = this.GetSlotResist(this.IDX_TORSO);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_UNDERWEAR);
				this.Torso_Resist_mc.SetData(this._DisplayDamageTypes[this._DisplayedDamageType],_loc1_);
				_loc1_ = this.GetSlotResist(this.IDX_LEFT_ARM);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_UNDERWEAR);
				this.LArm_Resist_mc.SetData(this._DisplayDamageTypes[this._DisplayedDamageType],_loc1_);
				_loc1_ = this.GetSlotResist(this.IDX_RIGHT_ARM);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_UNDERWEAR);
				this.RArm_Resist_mc.SetData(this._DisplayDamageTypes[this._DisplayedDamageType],_loc1_);
				_loc1_ = this.GetSlotResist(this.IDX_LEFT_LEG);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_UNDERWEAR);
				this.LLeg_Resist_mc.SetData(this._DisplayDamageTypes[this._DisplayedDamageType],_loc1_);
				_loc1_ = this.GetSlotResist(this.IDX_RIGHT_LEG);
				_loc1_ = _loc1_ + this.GetSlotResist(this.IDX_UNDERWEAR);
				this.RLeg_Resist_mc.SetData(this._DisplayDamageTypes[this._DisplayedDamageType],_loc1_);
				this.visible = true;
			}
			else
			{
				this.visible = false;
			}
		}
		
		private function GetSlotResist(param1:uint) : Number
		{
			var _loc3_:Object = null;
			var _loc2_:Number = 0;
			for each(_loc3_ in this._SlotResists[param1])
			{
				if(_loc3_.type == this._DisplayDamageTypes[this._DisplayedDamageType])
				{
					_loc2_ = _loc3_.value;
				}
			}
			return _loc2_;
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
