package
{
	import Shared.AS3.BSButtonHint;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSUIComponent;
	import Shared.AS3.COMPANIONAPP.SwipeZone;
	import Shared.CustomEvent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;

	public class Pipboy_Header extends BSUIComponent
	{

		private static const SELECTED_INDEX:uint = 2;

		private static const TAB_SPACING:Number = 12.5;

		public static const PAGE_CLICKED:String = "Pipboy_Header::PageClicked";

		public static const TAB_CLICKED:String = "Pipboy_Header::TabClicked";

		public static const INVALID_VALUE:uint = uint.MAX_VALUE;


		public var PageHeader_mc:MovieClip;

		public var TabHeader_mc:MovieClip;

		public var LeftTriggerButton_mc:BSButtonHint;

		public var RightTriggerButton_mc:BSButtonHint;

		private var pageTextFields:Vector.<TextField>;

		private var pageTextXBounds:Vector.<Point>;

		private var tabTextFields:Vector.<TextField>;

		private var LeftTriggerButton:BSButtonHintData;

		private var RightTriggerButton:BSButtonHintData;

		private var _currPageIndex:uint;

		private var _prevTabIndex:uint;

		private var _currTabIndex:uint;

		private var _TabNames:Array;

		private var _tabSwipeZone:SwipeZone;


		public function Pipboy_Header()
		{
			try //TODO: Error: 1009, null reference exception.
			{
				var _loc3_:TextField = null;
				var _loc4_:Point = null;
				var _loc5_:int = 0;
				var _loc6_:TextField = null;
				this.LeftTriggerButton = new BSButtonHintData("","","PSN_L2_Alt","Xenon_L2_Alt",1,null);
				this.RightTriggerButton = new BSButtonHintData("","","PSN_R2_Alt","Xenon_R2_Alt",0,null);
				super();
				this._currPageIndex = INVALID_VALUE;
				this._prevTabIndex = INVALID_VALUE;
				this._currTabIndex = INVALID_VALUE;
				this.pageTextFields = new <TextField>[this.PageHeader_mc.STAT_tf,this.PageHeader_mc.INV_tf,this.PageHeader_mc.DATA_tf,this.PageHeader_mc.MAP_tf,this.PageHeader_mc.RADIO_tf];
				this.pageTextFields.fixed = true;
				this.pageTextXBounds = new Vector.<Point>();
				var _loc1_:uint = 0;
				while(_loc1_ < this.pageTextFields.length)
				{
					_loc3_ = this.pageTextFields[_loc1_];
					_loc3_.addEventListener(MouseEvent.CLICK,this.onPageClicked);
					Extensions.enabled = true;
					TextFieldEx.setTextAutoSize(_loc3_,TextFieldEx.TEXTAUTOSZ_SHRINK);
					_loc4_ = new Point();
					_loc5_ = _loc3_.x;
					if(true)
					{
						_loc5_ = _loc5_ + _loc3_.getLineMetrics(0).x;
					}
					_loc4_.x = _loc5_ + _loc3_.getCharBoundaries(0).x;
					_loc4_.y = _loc5_ + _loc3_.getCharBoundaries(_loc3_.text.length - 1).right;
					this.pageTextXBounds.push(_loc4_);
					_loc1_++;
				}
				this.pageTextXBounds.fixed = true;
				this.tabTextFields = new <TextField>[this.TabHeader_mc.AlphaHolder.LeftTwo.textField_tf,this.TabHeader_mc.AlphaHolder.LeftOne.textField_tf,this.TabHeader_mc.AlphaHolder.Selected.textField_tf,this.TabHeader_mc.AlphaHolder.RightOne.textField_tf,this.TabHeader_mc.AlphaHolder.RightTwo.textField_tf];
				this.tabTextFields.fixed = true;
				var _loc2_:uint = 0;
				while(_loc2_ < this.tabTextFields.length)
				{
					_loc6_ = this.tabTextFields[_loc2_] as TextField;
					_loc6_.autoSize = TextFieldAutoSize.CENTER;
					_loc6_.addEventListener(MouseEvent.CLICK,this.onTabClicked);
					_loc2_++;
				}
				this.LeftTriggerButton_mc.ButtonHintData = this.LeftTriggerButton;
				this.RightTriggerButton_mc.ButtonHintData = this.RightTriggerButton;
			}
			catch (error:Error)
			{
				trace("[Scrivene07][PipboyMenu.swf][Pipboy_Header](ctor) "+error.toString());
			}
		}


		public function get tabSwipeZone() : SwipeZone
		{
			return this._tabSwipeZone;
		}


		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			if(stage)
			{
				PipboyChangeEvent.Register(stage,this.onPipboyChangeEvent);
			}
		}


		override public function onRemovedFromStage() : void
		{
			if(stage)
			{
				PipboyChangeEvent.Unregister(stage,this.onPipboyChangeEvent);
			}
			super.onRemovedFromStage();
		}


		private function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			if(param1.DataObj.CurrentPage != this._currPageIndex)
			{
				this._currPageIndex = param1.DataObj.CurrentPage;
				this._prevTabIndex = uint.MAX_VALUE;
				this._currTabIndex = param1.DataObj.CurrentTab;
				this._TabNames = param1.TabNames;
				SetIsDirty();
			}
			else if(param1.DataObj.CurrentTab != this._currTabIndex)
			{
				this._prevTabIndex = this._currTabIndex;
				this._currTabIndex = param1.DataObj.CurrentTab;
				SetIsDirty();
			}
		}


		private function onPageClicked(param1:MouseEvent) : void
		{
			var _loc2_:TextField = param1.target as TextField;
			var _loc3_:int = this.pageTextFields.indexOf(_loc2_);
			if(_loc3_ != -1)
			{
				dispatchEvent(new CustomEvent(PAGE_CLICKED,_loc3_ as uint,true,true));
			}
		}


		private function onTabClicked(param1:MouseEvent) : void
		{
			var _loc5_:int = 0;
			var _loc2_:TextField = param1.target as TextField;
			var _loc3_:int = this.tabTextFields.indexOf(_loc2_);
			if(_loc3_ != -1)
			{
				_loc5_ = _loc3_ - SELECTED_INDEX;
			}
			var _loc4_:int = this._currTabIndex + _loc5_;
			if(_loc3_ >= 0)
			{
				dispatchEvent(new CustomEvent(TAB_CLICKED,_loc4_ as uint,true,true));
			}
		}


		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			this.redrawPages();
			this.redrawTabs();
		}


		private function redrawPages() : *
		{
			var _loc1_:Shape = null;
			var _loc2_:Shape = null;
			if(this._currPageIndex != INVALID_VALUE)
			{
				this.PageHeader_mc.Selector_Left.x = this.pageTextXBounds[this._currPageIndex].x - 12.5;
				this.PageHeader_mc.Selector_Right.x = this.pageTextXBounds[this._currPageIndex].y + 12.5;
				_loc1_ = new Shape();
				if(this.PageHeader_mc.getChildByName("leftLine"))
				{
					this.PageHeader_mc.removeChild(this.PageHeader_mc.getChildByName("leftLine"));
				}
				_loc1_.name = "leftLine";
				_loc1_.graphics.lineStyle(3,16777215,1,false,"none");
				_loc1_.graphics.moveTo(this.PageHeader_mc.LeftBorder.x,this.PageHeader_mc.LeftBorder.y);
				_loc1_.graphics.lineTo(this.PageHeader_mc.Selector_Left.x,this.PageHeader_mc.LeftBorder.y);
				this.PageHeader_mc.addChild(_loc1_);
				_loc2_ = new Shape();
				if(this.PageHeader_mc.getChildByName("rightLine"))
				{
					this.PageHeader_mc.removeChild(this.PageHeader_mc.getChildByName("rightLine"));
				}
				_loc2_.name = "rightLine";
				_loc2_.graphics.lineStyle(3,16777215,1,false,"none");
				_loc2_.graphics.moveTo(this.PageHeader_mc.Selector_Right.x,this.PageHeader_mc.RightBorder.y);
				_loc2_.graphics.lineTo(this.PageHeader_mc.RightBorder.x,this.PageHeader_mc.RightBorder.y);
				this.PageHeader_mc.addChild(_loc2_);
				this.LeftTriggerButton.ButtonVisible = this._currPageIndex > 0;
				this.RightTriggerButton.ButtonVisible = this._currPageIndex < this.pageTextFields.length - 1;
			}
		}


		public function redrawTabs() : void
		{
			var _loc1_:Array = null;
			var _loc2_:String = null;
			if(this._prevTabIndex != this._currTabIndex)
			{
				_loc1_ = this._TabNames;
				this.TabHeader_mc.x = (this.pageTextXBounds[this._currPageIndex].x + this.pageTextXBounds[this._currPageIndex].y) / 2;
				if(_loc1_ != null && _loc1_.length > 0)
				{
					GlobalFunc.SetText(this.tabTextFields[SELECTED_INDEX],_loc1_[this._currTabIndex],false);
					_loc2_ = this._currTabIndex >= 1?_loc1_[this._currTabIndex - 1]:"";
					GlobalFunc.SetText(this.tabTextFields[SELECTED_INDEX - 1],_loc2_,false);
					this.TabHeader_mc.AlphaHolder.LeftOne.x = this.TabHeader_mc.AlphaHolder.Selected.x - this.TabHeader_mc.AlphaHolder.Selected.width / 2 - this.TabHeader_mc.AlphaHolder.LeftOne.width / 2 - TAB_SPACING;
					_loc2_ = this._currTabIndex >= 2?_loc1_[this._currTabIndex - 2]:"";
					GlobalFunc.SetText(this.tabTextFields[SELECTED_INDEX - 2],_loc2_,false);
					this.TabHeader_mc.AlphaHolder.LeftTwo.x = this.TabHeader_mc.AlphaHolder.LeftOne.x - this.TabHeader_mc.AlphaHolder.LeftOne.width / 2 - this.TabHeader_mc.AlphaHolder.LeftTwo.width / 2 - TAB_SPACING;
					_loc2_ = this._currTabIndex < _loc1_.length - 1?_loc1_[this._currTabIndex + 1]:"";
					GlobalFunc.SetText(this.tabTextFields[SELECTED_INDEX + 1],_loc2_,false);
					this.TabHeader_mc.AlphaHolder.RightOne.x = this.TabHeader_mc.AlphaHolder.Selected.x + this.TabHeader_mc.AlphaHolder.Selected.width / 2 + this.TabHeader_mc.AlphaHolder.RightOne.width / 2 + TAB_SPACING;
					_loc2_ = this._currTabIndex < _loc1_.length - 2?_loc1_[this._currTabIndex + 2]:"";
					GlobalFunc.SetText(this.tabTextFields[SELECTED_INDEX + 2],_loc2_,false);
					this.TabHeader_mc.AlphaHolder.RightTwo.x = this.TabHeader_mc.AlphaHolder.RightOne.x + this.TabHeader_mc.AlphaHolder.RightOne.width / 2 + this.TabHeader_mc.AlphaHolder.RightTwo.width / 2 + TAB_SPACING;
					this.TabHeader_mc.visible = true;
				}
				else
				{
					this.TabHeader_mc.visible = false;
				}
				if(this._prevTabIndex != uint.MAX_VALUE)
				{
					if(this._prevTabIndex < this._currTabIndex)
					{
						this.TabHeader_mc.gotoAndPlay("prevPage");
					}
					else if(this._prevTabIndex > this._currTabIndex)
					{
						this.TabHeader_mc.gotoAndPlay("nextPage");
					}
				}
			}
		}


	}
}
