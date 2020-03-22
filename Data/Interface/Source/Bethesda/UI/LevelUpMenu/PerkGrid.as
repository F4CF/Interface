package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import fl.motion.AdjustColor;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.MouseEventEx;
	import scaleform.gfx.TextFieldEx;
	
	public class PerkGrid extends BSUIComponent
	{
		
		public static const TEXTURES_LOADED:String = "PerkGrid::texturesLoaded";
		
		public static const SELECTION_CHANGE:String = "PerkGrid::selectionChange";
		
		public static const ZOOMING:String = "PerkGrid::zooming";
		 
		
		public var Background_mc:MovieClip;
		
		public var PerksHolder_mc:MovieClip;
		
		public var Header_mc:MovieClip;
		
		public var Overlay_mc:MovieClip;
		
		public var SelectionRect_mc:MovieClip;
		
		private var BGSCodeObj:Object;
		
		private var TopLoader:Loader;
		
		private var BottomLoader:Loader;
		
		private var OverlayTopLoader:Loader;
		
		private var OverlayBottomLoader:Loader;
		
		private var EntriesA:Array;
		
		private var bTexturesLoaded:Boolean;
		
		private var uiCurrSelectRow:uint;
		
		private var uiCurrSelectCol:uint;
		
		private var SelectedPerkEntry:Object;
		
		private var SelectedPerkClip:PerkAnimHolder;
		
		private var bDisableInput:Boolean;
		
		private var iManualZoomDirection:int;
		
		private var fNonEmptyTextureHeight:Number;
		
		private const TEX_WIDTH:Number = 2048;
		
		private const TOP_HEIGHT:Number = 1321.5;
		
		private const BOTTOM_HEIGHT:Number = 1726;
		
		private var MoveGridTween:Tween;
		
		private var fLeftStickX:Number;
		
		private var fLeftStickY:Number;
		
		private var HeaderStarHolders:Vector.<SPECIALStarHolder>;
		
		private var uiPerkCount:uint;
		
		private var UnavailableFilter:ColorMatrixFilter;
		
		private var _PlatformIdx:uint;
		
		private var _ratio16x10:Boolean;
		
		private var _DetectDragging:Boolean;
		
		private var _IsDragging:Boolean;
		
		protected var fLastMouseX:Number;
		
		protected var fLastMouseY:Number;
		
		private const PERK_STATE_UNAVAILABLE:uint = 0;
		
		private const PERK_STATE_AVAILABLE:uint = 1;
		
		private const PERK_STATE_EQUIPPED:uint = 2;
		
		private var MIN_X_VAL:Number;
		
		private var MIN_Y_VAL:Number;
		
		private var MAX_X_VAL:Number;
		
		private var MAX_Y_VAL:Number;
		
		private const MIN_SCALE:Number = 0.625;
		
		private const MAX_SCALE:Number = 1.0;
		
		private const BORDER_WIDTH:Number = 1280;
		
		private var BORDER_HEIGHT:Number = 720;
		
		private const MOUSE_HOVER_SCROLL_X_SPEED:Number = 22.5;
		
		private const MOUSE_HOVER_SCROLL_Y_SPEED:Number = 15.0;
		
		private const MOUSE_HOVER_SCROLL_X_MIN:Number = 20.0;
		
		private const MOUSE_HOVER_SCROLL_X_MAX:Number = 1210.0;
		
		private const MOUSE_HOVER_SCROLL_Y_MIN:Number = 10.0;
		
		private const MOUSE_HOVER_SCROLL_Y_MAX:Number = 705.0;
		
		private const MOUSE_DRAG_MOVE_SPEED:Number = 1.0;
		
		public function PerkGrid()
		{
			super();
			this.EntriesA = new Array();
			this.bTexturesLoaded = false;
			this.fNonEmptyTextureHeight = 0;
			this.MAX_X_VAL = 0;
			this.MAX_Y_VAL = 0;
			this.bDisableInput = false;
			this.iManualZoomDirection = 0;
			this._PlatformIdx = 0;
			this._ratio16x10 = false;
			this._DetectDragging = false;
			this._IsDragging = false;
			this.fLastMouseX = Number.MAX_VALUE;
			this.fLastMouseY = Number.MAX_VALUE;
			this.Overlay_mc.mouseEnabled = false;
			this.MoveGridTween = new Tween(this,"y",Strong.easeOut,0,0,10);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Header_mc.STR_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.PER_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.END_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.CHA_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.INT_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.AGI_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.LCK_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.STRShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.PERShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.ENDShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.CHAShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.INTShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.AGIShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Header_mc.LCKShadow_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this.HeaderStarHolders = new Vector.<SPECIALStarHolder>();
			this.HeaderStarHolders.push(this.Header_mc.STRStars_mc);
			this.HeaderStarHolders.push(this.Header_mc.PERStars_mc);
			this.HeaderStarHolders.push(this.Header_mc.ENDStars_mc);
			this.HeaderStarHolders.push(this.Header_mc.CHAStars_mc);
			this.HeaderStarHolders.push(this.Header_mc.INTStars_mc);
			this.HeaderStarHolders.push(this.Header_mc.AGIStars_mc);
			this.HeaderStarHolders.push(this.Header_mc.LCKStars_mc);
			var _loc1_:AdjustColor = new AdjustColor();
			_loc1_.hue = 0;
			_loc1_.saturation = -51;
			_loc1_.brightness = 67;
			_loc1_.contrast = -48;
			this.UnavailableFilter = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
			addEventListener(PerkAnimHolder.MOUSE_OVER,this.onVBMouseOver);
			addEventListener(PerkAnimHolder.MOUSE_OUT,this.onVBMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownDetect);
			this.__setProp_SelectionRect_mc_PerkGrid_Selection_0();
		}
		
		override public function onRemovedFromStage() : void
		{
			super.onRemovedFromStage();
			stage.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
		}
		
		public function get gridEntries() : Array
		{
			return this.EntriesA;
		}
		
		public function get selectedPerkEntry() : Object
		{
			return this.SelectedPerkEntry;
		}
		
		public function get selectedPerkClip() : MovieClip
		{
			return this.SelectedPerkClip;
		}
		
		public function get codeObj() : Object
		{
			return this.BGSCodeObj;
		}
		
		public function set codeObj(param1:Object) : *
		{
			this.BGSCodeObj = param1;
		}
		
		public function set disableInput(param1:Boolean) : *
		{
			this.bDisableInput = param1;
		}
		
		public function set perkCount(param1:uint) : *
		{
			this.uiPerkCount = param1;
		}
		
		public function get isDragging() : Boolean
		{
			return this._IsDragging;
		}
		
		public function set ratio16x10(param1:Boolean) : *
		{
			this._ratio16x10 = param1;
			this.MAX_Y_VAL = !!this._ratio16x10?Number(-50):Number(0);
			this.BORDER_HEIGHT = !!this._ratio16x10?Number(800):Number(720);
		}
		
		public function set platform(param1:uint) : *
		{
			this._PlatformIdx = param1;
		}
		
		private function IsValidEntry(param1:uint, param2:uint) : Boolean
		{
			return this.EntriesA != null && this.EntriesA.length > param1 && this.EntriesA[param1] != null && this.EntriesA[param1].length > param2;
		}
		
		private function GetClipByRowCol(param1:uint, param2:uint) : PerkAnimHolder
		{
			var _loc3_:PerkAnimHolder = null;
			var _loc4_:PerkAnimHolder = null;
			if(this.IsValidEntry(param1,param2))
			{
				_loc4_ = this.PerksHolder_mc.getChildByName("PerkAnim_" + param1 + "_" + param2) as PerkAnimHolder;
				if(_loc4_ != null)
				{
					_loc4_.row = param1;
					_loc4_.col = param2;
					_loc3_ = _loc4_;
				}
			}
			return _loc3_;
		}
		
		private function GetStarHolderByRowCol(param1:uint, param2:uint) : MovieClip
		{
			var _loc3_:MovieClip = null;
			var _loc4_:MovieClip = null;
			if(this.IsValidEntry(param1,param2))
			{
				_loc4_ = this.PerksHolder_mc.getChildByName("StarHolder_" + param1 + "_" + param2) as MovieClip;
				if(_loc4_ != null)
				{
					_loc4_.mouseEnabled = false;
					_loc3_ = _loc4_;
				}
			}
			return _loc3_;
		}
		
		public function onTexturesRegistered() : *
		{
			this.bTexturesLoaded = true;
			this.TopLoader = new Loader();
			this.TopLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onGridTopLoadComplete);
			this.TopLoader.load(new URLRequest("img://GridTop"));
			this.BottomLoader = new Loader();
			this.BottomLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onGridBottomLoadComplete);
			this.BottomLoader.load(new URLRequest("img://GridBottom"));
			this.OverlayTopLoader = new Loader();
			this.OverlayTopLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onOverlayTopLoadComplete);
			this.OverlayTopLoader.load(new URLRequest("img://OverlayTop"));
			this.OverlayBottomLoader = new Loader();
			this.OverlayBottomLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onOverlayBottomLoadComplete);
			this.OverlayBottomLoader.load(new URLRequest("img://OverlayBottom"));
		}
		
		private function onGridTopLoadComplete(param1:Event) : *
		{
			param1.currentTarget.content.scaleX = this.TEX_WIDTH / param1.currentTarget.content.width;
			param1.currentTarget.content.scaleY = param1.currentTarget.content.scaleX;
			this.Background_mc.addChild(param1.currentTarget.content);
			this.TopLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onGridTopLoadComplete);
			this.TopLoader = null;
			this.fNonEmptyTextureHeight = this.fNonEmptyTextureHeight + this.TOP_HEIGHT;
			if(this.TopLoader == null && this.BottomLoader == null && this.OverlayTopLoader == null && this.OverlayBottomLoader == null)
			{
				this.onTexturesFinishedLoading();
			}
		}
		
		private function onGridBottomLoadComplete(param1:Event) : *
		{
			param1.currentTarget.content.scaleX = this.TEX_WIDTH / param1.currentTarget.content.width;
			param1.currentTarget.content.scaleY = param1.currentTarget.content.scaleX;
			param1.currentTarget.content.y = this.TOP_HEIGHT;
			this.Background_mc.addChild(param1.currentTarget.content);
			this.BottomLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onGridBottomLoadComplete);
			this.BottomLoader = null;
			this.fNonEmptyTextureHeight = this.fNonEmptyTextureHeight + this.BOTTOM_HEIGHT;
			if(this.TopLoader == null && this.BottomLoader == null && this.OverlayTopLoader == null && this.OverlayBottomLoader == null)
			{
				this.onTexturesFinishedLoading();
			}
		}
		
		private function onOverlayTopLoadComplete(param1:Event) : *
		{
			param1.currentTarget.content.scaleX = this.TEX_WIDTH / param1.currentTarget.content.width;
			param1.currentTarget.content.scaleY = param1.currentTarget.content.scaleX;
			this.Overlay_mc.addChild(param1.currentTarget.content);
			this.OverlayTopLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onGridTopLoadComplete);
			this.OverlayTopLoader = null;
			if(this.TopLoader == null && this.BottomLoader == null && this.OverlayTopLoader == null && this.OverlayBottomLoader == null)
			{
				this.onTexturesFinishedLoading();
			}
		}
		
		private function onOverlayBottomLoadComplete(param1:Event) : *
		{
			param1.currentTarget.content.scaleX = this.TEX_WIDTH / param1.currentTarget.content.width;
			param1.currentTarget.content.scaleY = param1.currentTarget.content.scaleX;
			param1.currentTarget.content.y = this.TOP_HEIGHT;
			this.Overlay_mc.addChild(param1.currentTarget.content);
			this.OverlayBottomLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onGridBottomLoadComplete);
			this.OverlayBottomLoader = null;
			if(this.TopLoader == null && this.BottomLoader == null && this.OverlayTopLoader == null && this.OverlayBottomLoader == null)
			{
				this.onTexturesFinishedLoading();
			}
		}
		
		private function onTexturesFinishedLoading() : *
		{
			dispatchEvent(new Event(TEXTURES_LOADED,true,true));
			this.gridScale = this.MIN_SCALE;
			this.MoveGrid(this.MAX_X_VAL,this.MAX_Y_VAL,false);
			if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
			{
				this.SetSelectedClip(0,0);
			}
			stage.addEventListener(Event.ENTER_FRAME,this.onUpdate);
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		override public function redrawUIComponent() : void
		{
			this.SelectionRect_mc.visible = iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
			this.PositionSelectedRect();
		}
		
		public function InvalidateGrid() : *
		{
			if(this.EntriesA.length > 0)
			{
				this.PopulateGrid();
				stage.focus = this;
				if(this.selectedPerkClip != null)
				{
					this.SelectedPerkEntry = this.EntriesA[this.uiCurrSelectRow][this.uiCurrSelectCol];
					this.SetVaultBoyAnimating(this.selectedPerkClip,this.SelectedPerkEntry);
					this.SetUpPerkAnimListener(this.selectedPerkClip,this.SelectedPerkEntry.owned == true);
					dispatchEvent(new Event(SELECTION_CHANGE,true,true));
				}
			}
			else
			{
				this.ClearSelectedClip();
				stage.focus = null;
			}
		}
		
		protected function SetSelectedClip(param1:uint, param2:uint) : *
		{
			if(this.SelectedPerkEntry != null && this.SelectedPerkClip != null)
			{
				if(this.SelectedPerkEntry.owned == true)
				{
					this.SetUpPerkAnimListener(this.SelectedPerkClip,false);
				}
			}
			if(this.EntriesA != null && this.EntriesA.length > param1 && this.EntriesA[param1] != null && this.EntriesA[param1].length > param2)
			{
				this.uiCurrSelectRow = param1;
				this.uiCurrSelectCol = param2;
				this.SelectedPerkEntry = this.EntriesA[param1][param2];
				this.SelectedPerkClip = this.GetClipByRowCol(this.uiCurrSelectRow,this.uiCurrSelectCol);
				if(this.SelectedPerkClip != null)
				{
					this.SetVaultBoyAnimating(this.SelectedPerkClip,this.SelectedPerkEntry);
					this.SetUpPerkAnimListener(this.SelectedPerkClip,this.SelectedPerkEntry.owned == true);
					this.PositionSelectedRect();
				}
				dispatchEvent(new Event(SELECTION_CHANGE,true,true));
			}
			else
			{
				this.ClearSelectedClip();
			}
		}
		
		protected function ClearSelectedClip() : *
		{
			if(this.SelectedPerkEntry != null && this.SelectedPerkClip != null)
			{
				if(this.SelectedPerkEntry.owned == true)
				{
					this.SetUpPerkAnimListener(this.SelectedPerkClip,false);
				}
			}
			this.uiCurrSelectRow = 0;
			this.uiCurrSelectCol = 0;
			this.SelectedPerkEntry = null;
			this.SelectedPerkClip = null;
			this.PositionSelectedRect();
			dispatchEvent(new Event(SELECTION_CHANGE,true,true));
		}
		
		protected function PositionSelectedRect() : *
		{
			var _loc1_:Point = null;
			if(this.SelectedPerkClip != null)
			{
				_loc1_ = globalToLocal(this.SelectedPerkClip.border.localToGlobal(new Point(0,0)));
				this.SelectionRect_mc.x = _loc1_.x;
				this.SelectionRect_mc.y = _loc1_.y;
			}
		}
		
		protected function SetUpPerkAnimListener(param1:MovieClip, param2:Boolean) : *
		{
			var _loc3_:MovieClip = param1;
			if(_loc3_ != null)
			{
				_loc3_.removeEventListener(Event.ENTER_FRAME,this.onPerkSelectionAnimUpdate);
				if(param2)
				{
					_loc3_.addEventListener(Event.ENTER_FRAME,this.onPerkSelectionAnimUpdate);
				}
			}
		}
		
		protected function onPerkSelectionAnimUpdate(param1:Event) : *
		{
			if(this.SelectedPerkEntry != null && param1.target.currentFrame == param1.target.totalFrames)
			{
				this.codeObj.PlayPerkSound(this.SelectedPerkEntry.clipName);
			}
		}
		
		protected function PopulateGrid() : *
		{
			var uicol:uint = 0;
			var info:Object = null;
			var clipParent:PerkAnimHolder = null;
			var clipClass:Class = null;
			var starHolder:MovieClip = null;
			var newClip:PerkAnimHolder = null;
			var uirank:uint = 0;
			var _available:Boolean = false;
			var _active:Boolean = false;
			var starClip:MovieClip = null;
			var uirow:uint = 0;
			while(uirow < this.EntriesA.length)
			{
				uicol = 0;
				while(uicol < this.EntriesA[uirow].length)
				{
					info = this.EntriesA[uirow][uicol];
					if(info != null)
					{
						clipParent = this.GetClipByRowCol(uirow,uicol);
						try
						{
							clipClass = getDefinitionByName("PerkClip" + info.clipName.toString(16)) as Class;
						}
						catch(error:ReferenceError)
						{
							trace("Can\'t find perk PerkClip" + info.clipName.toString(16));
							clipClass = getDefinitionByName("DefaultBoy") as Class;
						}
						if(!(clipParent is clipClass))
						{
							trace("Clip mis-match: " + info.text);
							newClip = new clipClass() as PerkAnimHolder;
							this.PerksHolder_mc.addChild(newClip);
							newClip.name = clipParent.name;
							newClip.x = clipParent.x;
							newClip.y = clipParent.y;
							newClip.scaleX = clipParent.scaleX;
							newClip.scaleY = clipParent.scaleY;
							newClip.row = clipParent.row;
							newClip.col = clipParent.col;
							this.PerksHolder_mc.removeChild(clipParent);
							clipParent = newClip;
						}
						this.SetVaultBoyAnimating(clipParent,info);
						starHolder = this.GetStarHolderByRowCol(uirow,uicol);
						if(starHolder != null && info.displayMaxRank != null && (info.displayMaxRank > 1 || info.displayRank == 1))
						{
							uirank = 0;
							while(uirank < info.displayMaxRank)
							{
								_available = info.available == true && info.displayRank == uirank && info.displayRank != 0 && this.uiPerkCount > 0;
								_active = uirank < info.displayRank;
								if(_available || _active)
								{
									if(starHolder.numChildren - 1 <= uirank)
									{
										starClip = new PerkRankStar();
										starHolder.addChild(starClip);
										starClip.x = 0 + 40 * uirank;
										starClip.y = 0;
										starClip.scaleX = 1;
										starClip.scaleY = starClip.scaleX;
									}
									else
									{
										starClip = starHolder.getChildAt(uirank + 1) as MovieClip;
									}
									if(_available)
									{
										starClip.gotoAndStop("Available");
									}
									else if(_active)
									{
										starClip.gotoAndStop("Full");
									}
								}
								uirank++;
							}
						}
						if(uirow == 0)
						{
							this.HeaderStarHolders[uicol].value = info.displayRank;
						}
						info.y = this.PerksHolder_mc.y + clipParent.y + 46.75;
					}
					uicol++;
				}
				uirow++;
			}
		}
		
		private function SetVaultBoyAnimating(param1:MovieClip, param2:Object) : *
		{
			var _loc4_:uint = 0;
			var _loc3_:uint = this.PERK_STATE_UNAVAILABLE;
			if(param2.owned == true)
			{
				_loc3_ = this.PERK_STATE_EQUIPPED;
			}
			else if(param2.available == true)
			{
				_loc3_ = this.PERK_STATE_AVAILABLE;
			}
			if(param1 != null)
			{
				this.SetVBAnimState(param1,_loc3_);
				_loc4_ = 0;
				while(_loc4_ < param1.numChildren)
				{
					if(param1.getChildAt(_loc4_) is MovieClip)
					{
						this.SetVBAnimState(param1.getChildAt(_loc4_) as MovieClip,_loc3_);
					}
					_loc4_++;
				}
			}
		}
		
		private function SetVBAnimState(param1:MovieClip, param2:uint) : *
		{
			switch(param2)
			{
				case this.PERK_STATE_UNAVAILABLE:
					param1.gotoAndStop(1);
					param1.filters = null;
					break;
				case this.PERK_STATE_AVAILABLE:
					param1.gotoAndStop(param1.totalFrames > 1?2:1);
					param1.filters = [this.UnavailableFilter];
					break;
				case this.PERK_STATE_EQUIPPED:
					param1.gotoAndPlay(param1.totalFrames > 1?2:1);
					param1.filters = null;
			}
		}
		
		public function get gridScale() : Number
		{
			return this.scaleX;
		}
		
		public function set gridScale(param1:Number) : *
		{
			this.scaleX = Math.min(Math.max(param1,this.MIN_SCALE),this.MAX_SCALE);
			this.scaleY = this.scaleX;
			this.MIN_X_VAL = -this.width + this.BORDER_WIDTH;
			this.MIN_Y_VAL = -(this.fNonEmptyTextureHeight * this.gridScale) + this.BORDER_HEIGHT;
		}
		
		protected function onVBMouseOver(param1:Event) : *
		{
			if(!this.bDisableInput && this._PlatformIdx == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && (this.SelectedPerkClip == null || param1.target != this.SelectedPerkClip))
			{
				this.SetSelectedClip(param1.target.row,param1.target.col);
			}
		}
		
		protected function onVBMouseOut(param1:Event) : *
		{
			if(!this.bDisableInput && this._PlatformIdx == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
			{
				this.ClearSelectedClip();
			}
		}
		
		public function ZoomGrid(param1:Number) : *
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			if(GlobalFunc.CloseToNumber(param1,0))
			{
				this.iManualZoomDirection = 0;
			}
			else if(!this.bDisableInput && (param1 > 0 && !GlobalFunc.CloseToNumber(this.gridScale,this.MAX_SCALE) && this.gridScale < this.MAX_SCALE || param1 < 0 && !GlobalFunc.CloseToNumber(this.gridScale,this.MIN_SCALE) && this.gridScale > this.MIN_SCALE))
			{
				_loc2_ = 0;
				_loc3_ = 0;
				_loc4_ = 0;
				_loc5_ = 0;
				if(iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					_loc2_ = this.mouseX;
					_loc3_ = this.mouseY;
				}
				else
				{
					_loc2_ = this.SelectionRect_mc.x + this.SelectionRect_mc.width / 2;
					_loc3_ = this.SelectionRect_mc.y + this.SelectionRect_mc.height / 2;
				}
				_loc4_ = (this.x + _loc2_ * (this.width / this.TEX_WIDTH)) / this.BORDER_WIDTH;
				_loc5_ = (this.y + _loc3_ * this.gridScale) / this.BORDER_HEIGHT;
				_loc6_ = this.gridScale;
				this.gridScale = Math.min(this.MAX_SCALE,Math.max(this.MIN_SCALE,this.gridScale + param1));
				if(!GlobalFunc.CloseToNumber(this.gridScale,_loc6_))
				{
					this.codeObj.PlayZoomSound();
					_loc7_ = -(_loc2_ * (this.width / this.TEX_WIDTH)) + this.BORDER_WIDTH * _loc4_;
					_loc8_ = -(_loc3_ * this.gridScale) + this.BORDER_HEIGHT * _loc5_;
					if(iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
					{
						_loc2_ = this.mouseX;
						_loc3_ = this.mouseY;
					}
					else
					{
						_loc2_ = this.SelectionRect_mc.x + this.SelectionRect_mc.width / 2;
						_loc3_ = this.SelectionRect_mc.y + this.SelectionRect_mc.height / 2;
					}
					this.MoveGrid(_loc7_ - this.x,_loc8_ - this.y,false);
					dispatchEvent(new Event(ZOOMING,true,true));
				}
			}
		}
		
		public function MoveGrid(param1:Number, param2:Number, param3:Boolean) : *
		{
			if(!this.bDisableInput)
			{
				this.x = Math.min(Math.max(this.x + param1,this.MIN_X_VAL),this.MAX_X_VAL);
				if(param3)
				{
					this.MoveGridTween.begin = this.y;
					this.MoveGridTween.finish = Math.min(Math.max(this.y + param2,this.MIN_Y_VAL),this.MAX_Y_VAL);
					this.MoveGridTween.start();
				}
				else
				{
					this.MoveGridTween.stop();
					this.y = Math.min(Math.max(this.y + param2,this.MIN_Y_VAL),this.MAX_Y_VAL);
				}
			}
		}
		
		public function onLeftStickInput(param1:Number, param2:Number) : *
		{
			this.fLeftStickX = param1;
			this.fLeftStickY = param2;
		}
		
		private function onUpdate(param1:Event) : *
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			if(this._DetectDragging)
			{
				_loc2_ = stage.mouseX - this.fLastMouseX;
				_loc3_ = stage.mouseY - this.fLastMouseY;
				if(!this._IsDragging)
				{
					this._IsDragging = _loc2_ != 0 || _loc3_ != 0;
				}
			}
			if(this._IsDragging)
			{
				this.MoveGrid(_loc2_ * this.MOUSE_DRAG_MOVE_SPEED,_loc3_ * this.MOUSE_DRAG_MOVE_SPEED,false);
			}
			else if(this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.iManualZoomDirection == 0 && (!GlobalFunc.CloseToNumber(this.fLeftStickX,0) || !GlobalFunc.CloseToNumber(this.fLeftStickY,0)))
			{
				_loc4_ = 0;
				_loc5_ = 0;
				if(stage.mouseX < this.MOUSE_HOVER_SCROLL_X_MIN && (this.fLeftStickX < 0 || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE))
				{
					_loc4_ = this.MOUSE_HOVER_SCROLL_X_SPEED;
				}
				if(stage.mouseX > this.MOUSE_HOVER_SCROLL_X_MAX && (this.fLeftStickX > 0 || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE))
				{
					_loc4_ = -this.MOUSE_HOVER_SCROLL_X_SPEED;
				}
				if(stage.mouseY < this.MOUSE_HOVER_SCROLL_Y_MIN && (this.fLeftStickY > 0 || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE))
				{
					_loc5_ = this.MOUSE_HOVER_SCROLL_Y_SPEED;
				}
				if(stage.mouseY > this.MOUSE_HOVER_SCROLL_Y_MAX && (this.fLeftStickY < 0 || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE))
				{
					_loc5_ = -this.MOUSE_HOVER_SCROLL_Y_SPEED;
				}
				if(!GlobalFunc.CloseToNumber(_loc4_,0) || !GlobalFunc.CloseToNumber(_loc5_,0))
				{
					this.MoveGrid(_loc4_,_loc5_,false);
				}
			}
			this.fLastMouseX = stage.mouseX;
			this.fLastMouseY = stage.mouseY;
		}
		
		private function onKeyDown(param1:KeyboardEvent) : *
		{
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			var _loc4_:Point = null;
			var _loc5_:Point = null;
			var _loc6_:Point = null;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			if(!this.bDisableInput && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
			{
				_loc2_ = this.uiCurrSelectRow;
				_loc3_ = this.uiCurrSelectCol;
				if(param1.keyCode == Keyboard.UP && this.uiCurrSelectRow > 0 && this.IsValidEntry(this.uiCurrSelectRow - 1,this.uiCurrSelectCol))
				{
					this.SetSelectedClip(this.uiCurrSelectRow - 1,this.uiCurrSelectCol);
					param1.stopPropagation();
				}
				else if(param1.keyCode == Keyboard.DOWN && this.uiCurrSelectRow < this.EntriesA.length - 1 && this.IsValidEntry(this.uiCurrSelectRow + 1,this.uiCurrSelectCol))
				{
					this.SetSelectedClip(this.uiCurrSelectRow + 1,this.uiCurrSelectCol);
					param1.stopPropagation();
				}
				else if(param1.keyCode == Keyboard.LEFT && this.uiCurrSelectCol > 0 && this.IsValidEntry(this.uiCurrSelectRow,this.uiCurrSelectCol - 1))
				{
					this.SetSelectedClip(this.uiCurrSelectRow,this.uiCurrSelectCol - 1);
					param1.stopPropagation();
				}
				else if(param1.keyCode == Keyboard.RIGHT && this.uiCurrSelectCol < this.HeaderStarHolders.length - 1 && this.IsValidEntry(this.uiCurrSelectRow,this.uiCurrSelectCol + 1))
				{
					this.SetSelectedClip(this.uiCurrSelectRow,this.uiCurrSelectCol + 1);
					param1.stopPropagation();
				}
				if(_loc3_ != this.uiCurrSelectCol || _loc2_ != this.uiCurrSelectRow)
				{
					_loc4_ = new Point(150,62);
					_loc5_ = new Point(1130,400);
					_loc6_ = new Point(this.SelectionRect_mc.x + this.SelectionRect_mc.width / 2,this.SelectionRect_mc.y + this.SelectionRect_mc.height / 2);
					_loc4_ = globalToLocal(_loc4_);
					_loc5_ = globalToLocal(_loc5_);
					_loc7_ = 0;
					_loc8_ = 0;
					if(_loc6_.x < _loc4_.x)
					{
						_loc7_ = _loc4_.x - _loc6_.x;
					}
					if(_loc6_.x > _loc5_.x)
					{
						_loc7_ = _loc5_.x - _loc6_.x;
					}
					if(_loc6_.y < _loc4_.y)
					{
						_loc8_ = _loc4_.y - _loc6_.y;
					}
					if(_loc6_.y > _loc5_.y)
					{
						_loc8_ = _loc5_.y - _loc6_.y;
					}
					if(_loc2_ != this.uiCurrSelectRow)
					{
						if(this.uiCurrSelectRow == 0)
						{
							_loc8_ = Number.MAX_VALUE;
						}
						else if(this.uiCurrSelectRow == this.EntriesA.length - 1)
						{
							_loc8_ = -Number.MAX_VALUE;
						}
					}
					if(_loc7_ != 0 || _loc8_ != 0)
					{
						this.MoveGrid(_loc7_,_loc8_,true);
					}
				}
			}
		}
		
		protected function onMouseDownDetect(param1:MouseEvent) : *
		{
			if(!this.bDisableInput && param1 is MouseEventEx && (param1 as MouseEventEx).buttonIdx == 1)
			{
				if(iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					this._DetectDragging = true;
					this._IsDragging = false;
					this.fLastMouseX = stage.mouseX;
					this.fLastMouseY = stage.mouseY;
				}
				stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpDetect);
			}
		}
		
		protected function onMouseUpDetect(param1:MouseEvent) : *
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpDetect);
			this._DetectDragging = false;
			this._IsDragging = false;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2 && !this.bDisableInput)
			{
				if(param1 == "Accept" && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.SelectedPerkClip != null)
				{
					this.SelectedPerkClip.onMousePress();
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		function __setProp_SelectionRect_mc_PerkGrid_Selection_0() : *
		{
			try
			{
				this.SelectionRect_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.SelectionRect_mc.bracketCornerLength = 6;
			this.SelectionRect_mc.bracketLineWidth = 1.5;
			this.SelectionRect_mc.bracketPaddingX = 0;
			this.SelectionRect_mc.bracketPaddingY = 0;
			this.SelectionRect_mc.BracketStyle = "horizontal";
			this.SelectionRect_mc.bShowBrackets = true;
			this.SelectionRect_mc.bUseShadedBackground = true;
			this.SelectionRect_mc.ShadedBackgroundMethod = "Flash";
			this.SelectionRect_mc.ShadedBackgroundType = "normal";
			try
			{
				this.SelectionRect_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
