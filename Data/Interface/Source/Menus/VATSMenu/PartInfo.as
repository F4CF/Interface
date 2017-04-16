package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class PartInfo extends MovieClip
	{
		
		static const PART_INFO_BORDER_WIDTH:Number = 6;
		
		static const PART_INFO_BORDER_WIDTH_MIN:Number = 60;
		
		static const BRACKET_WIDTH_INSET:Number = 12;
		
		static const BRACKET_HEIGHT_INSET:Number = 20;
		 
		
		public var GraphicInstance:MovieClip;
		
		public var TargetBracketsInstance:MovieClip;
		
		public var HealthBar:MovieClip;
		
		public var HealthBarIndicator:MovieClip;
		
		public var ChanceToHit:TextField;
		
		public var NameTextField:TextField;
		
		public var InfoBracketInstance:MovieClip;
		
		private var ActionCount:uint = 0;
		
		private var HealthPercent:Number = 0;
		
		private var bOffsetPosition:Boolean;
		
		private var bSelected:Boolean;
		
		public function PartInfo()
		{
			super();
			addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
			this.TargetBracketsInstance = this.GraphicInstance.TargetBracketsInstance;
			this.HealthBar = this.GraphicInstance.TintedContainer.AnimationInstance.PartHealth;
			this.HealthBarIndicator = this.HealthBar.BarInstance;
			this.ChanceToHit = this.GraphicInstance.TintedContainer.AnimationInstance.HitChance;
			this.ChanceToHit.visible = false;
			this.NameTextField = this.GraphicInstance.TintedContainer.AnimationInstance.Name;
			this.InfoBracketInstance = this.GraphicInstance.TintedContainer.AnimationInstance.InfoBracketInstance;
			this.SetActionCount(0);
			this.bSelected = false;
		}
		
		public function SetOffsetPosition(abOffset:Boolean) : *
		{
			this.bOffsetPosition = abOffset;
		}
		
		public function SetSelected(abSelected:Boolean) : *
		{
			if(abSelected != this.bSelected)
			{
				this.bSelected = abSelected;
				if(abSelected)
				{
					this.GraphicInstance.TintedContainer.gotoAndPlay("flashing");
				}
				else
				{
					this.GraphicInstance.TintedContainer.gotoAndPlay("default");
				}
				this.UpdateElementVisibility();
			}
		}
		
		public function SetActionCount(aCount:uint) : *
		{
			var center:Point = null;
			this.ActionCount = aCount;
			if(this.ActionCount == 0)
			{
				this.TargetBracketsInstance.visible = false;
			}
			else
			{
				this.TargetBracketsInstance.scaleX = 1;
				this.TargetBracketsInstance.scaleY = 1;
				this.TargetBracketsInstance.visible = true;
				this.TargetBracketsInstance.gotoAndStop(Math.min(this.ActionCount,4));
				this.TargetBracketsInstance.width = this.TargetBracketsInstance.width + this.GraphicInstance.TintedContainer.width - BRACKET_WIDTH_INSET;
				this.TargetBracketsInstance.height = this.TargetBracketsInstance.height + this.GraphicInstance.TintedContainer.height - BRACKET_HEIGHT_INSET;
				center = new Point(this.GraphicInstance.TintedContainer.x,this.InfoBracketInstance.y);
				center = this.InfoBracketInstance.parent.localToGlobal(center);
				center = this.TargetBracketsInstance.parent.globalToLocal(center);
				this.TargetBracketsInstance.y = center.y;
			}
		}
		
		public function SetHealthPercent(aHealthPercent:Number) : *
		{
			this.HealthPercent = aHealthPercent;
			this.HealthBarIndicator.scaleX = Math.max(aHealthPercent,0);
			this.UpdateElementVisibility();
		}
		
		public function SetName(aName:String) : *
		{
			var nameFormat:TextFormat = this.NameTextField.getTextFormat();
			this.NameTextField.text = aName.toUpperCase();
			this.NameTextField.setTextFormat(nameFormat);
			this.NameTextField.autoSize = TextFieldAutoSize.CENTER;
		}
		
		public function SetChanceToHit(aChance:uint) : *
		{
			var chanceFormat:TextFormat = this.ChanceToHit.getTextFormat();
			this.ChanceToHit.text = aChance.toString();
			this.ChanceToHit.setTextFormat(chanceFormat);
			this.ChanceToHit.visible = true;
		}
		
		public function UpdateElementVisibility() : *
		{
			this.HealthBar.visible = this.HealthPercent < 1 || this.ActionCount > 0 || this.bSelected;
			this.NameTextField.visible = this.bSelected;
			this.HealthBar.scaleX = 1;
			this.HealthBar.scaleY = 1;
			this.NameTextField.scaleX = 1;
			this.NameTextField.scaleY = 1;
			var boundsHeight:Number = this.ChanceToHit.y + this.ChanceToHit.height;
			var top:Number = !!this.NameTextField.visible?Number(this.NameTextField.y):!!this.HealthBar.visible?Number(this.HealthBar.y - 6):Number(this.ChanceToHit.y);
			boundsHeight = boundsHeight - top;
			var boundsWidth:Number = Math.max(!!this.NameTextField.visible?Number(this.NameTextField.width):Number(0),!!this.HealthBar.visible?Number(this.HealthBar.width):Number(0),this.ChanceToHit.width);
			this.InfoBracketInstance.height = boundsHeight;
			this.InfoBracketInstance.width = Math.max(boundsWidth + PART_INFO_BORDER_WIDTH,PART_INFO_BORDER_WIDTH_MIN);
			this.InfoBracketInstance.y = top + boundsHeight / 2;
			var scale:Number = !!this.HealthBar.visible?Number(1):Number(0);
			this.HealthBar.scaleX = scale;
			this.HealthBar.scaleY = scale;
			scale = !!this.NameTextField.visible?Number(1):Number(0);
			this.NameTextField.scaleX = scale;
			this.NameTextField.scaleY = scale;
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame3() : *
		{
			stop();
		}
	}
}
