package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	import flash.text.TextFieldAutoSize;
	
	public class Graph extends MovieClip
	{
		 
		
		public var XMinLabel:TextField;
		
		public var XMaxLabel:TextField;
		
		public var XLabel:TextField;
		
		public var YMinLabel:TextField;
		
		public var YMaxLabel:TextField;
		
		public var YLabel:TextField;
		
		public var Data:Array;
		
		private var Plot:MovieClip;
		
		private var LineColor:int;
		
		private var LineWidth:Number;
		
		private var XMax:Number;
		
		private var XMin:Number;
		
		private var XGridStep:Number;
		
		private var YMax:Number;
		
		private var YMin:Number;
		
		private var YGridStep:Number;
		
		private var Height:Number;
		
		private var Width:Number;
		
		private var PlotHeight:Number;
		
		private var PlotWidth:Number;
		
		private var bDrawWidgetBorder:Boolean;
		
		private var bDrawGraphBorder:Boolean;
		
		private var bDrawGraphGrid:Boolean;
		
		private const PLOT_BORDER:Number = 20;
		
		public function Graph()
		{
			super();
			this.XMinLabel.autoSize = TextFieldAutoSize.LEFT;
			this.XMaxLabel.autoSize = TextFieldAutoSize.LEFT;
			this.YMinLabel.autoSize = TextFieldAutoSize.LEFT;
			this.YMaxLabel.autoSize = TextFieldAutoSize.LEFT;
			this.Data = new Array();
			this.Plot = new MovieClip();
			this.Plot.name = "PlotClip";
			this.addChild(this.Plot);
			this.XMax = 0;
			this.XMin = 0;
			this.XGridStep = 0;
			this.YMax = 0;
			this.YMin = 0;
			this.YGridStep = 0;
			this.LineColor = 65280;
			this.LineWidth = 2;
			this.bDrawWidgetBorder = true;
			this.bDrawGraphBorder = true;
			this.bDrawGraphGrid = true;
			this.SetSize(100,100);
		}
		
		public function SetLabels(param1:String, param2:String) : *
		{
			GlobalFunc.SetText(this.XLabel,param1,false);
			GlobalFunc.SetText(this.YLabel,param2,false);
		}
		
		public function SetShowLabels(param1:Boolean, param2:Boolean) : *
		{
			this.XLabel.visible = param1;
			this.XMinLabel.visible = param1;
			this.XMaxLabel.visible = param1;
			this.YLabel.visible = param2;
			this.YMinLabel.visible = param2;
			this.YMaxLabel.visible = param2;
			this.SetSize(this.Width,this.Height);
		}
		
		public function SetLineColor(param1:int) : *
		{
			this.LineColor = param1;
		}
		
		public function SetLineWidth(param1:Number) : *
		{
			this.LineWidth = param1;
		}
		
		public function SetSize(param1:Number, param2:Number) : *
		{
			this.Width = param1;
			this.Height = param2;
			this.PositionLabels();
			var _loc3_:* = !!this.YLabel.visible?this.PLOT_BORDER:0;
			var _loc4_:* = !!this.XLabel.visible?this.PLOT_BORDER:0;
			this.Plot.x = _loc3_;
			this.Plot.y = param2 - _loc4_;
			this.PlotHeight = param2 - _loc4_;
			this.PlotWidth = param1 - _loc3_;
			this.DrawBackground();
		}
		
		private function PositionLabels() : *
		{
			var _loc1_:Number = !!this.YLabel.visible?Number(this.PLOT_BORDER):Number(0);
			var _loc2_:Number = !!this.XLabel.visible?Number(this.PLOT_BORDER):Number(0);
			this.XLabel.y = this.Height - this.PLOT_BORDER;
			this.XMinLabel.y = this.XLabel.y;
			this.XMinLabel.x = _loc1_ - this.XMinLabel.width / 2;
			this.XMaxLabel.y = this.XMinLabel.y;
			this.XMaxLabel.x = this.Width - this.XMaxLabel.width / 2;
			this.YLabel.y = this.Height - this.PLOT_BORDER;
			this.YMinLabel.y = this.Height - _loc2_ - this.YMinLabel.height / 2;
			this.YMinLabel.x = this.PLOT_BORDER - this.YMinLabel.width;
			this.YMaxLabel.y = -this.YMaxLabel.height / 2;
			this.YMaxLabel.x = this.PLOT_BORDER - this.YMaxLabel.width;
		}
		
		public function SetDrawBackground(param1:Boolean, param2:Boolean, param3:Boolean) : *
		{
			this.bDrawWidgetBorder = param1;
			this.bDrawGraphBorder = param2;
			this.bDrawGraphGrid = param3;
			this.DrawBackground();
		}
		
		public function DrawBackground() : *
		{
			var _loc1_:Number = NaN;
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			this.graphics.clear();
			this.graphics.lineStyle(1,0,100,false,"none");
			if(this.bDrawWidgetBorder)
			{
				this.graphics.moveTo(0,0);
				this.graphics.lineTo(0,this.Height);
				this.graphics.lineTo(this.Width,this.Height);
				this.graphics.lineTo(this.Width,0);
				this.graphics.lineTo(0,0);
			}
			if(this.bDrawGraphBorder)
			{
				this.graphics.moveTo(this.Plot.x,this.Plot.y);
				this.graphics.lineTo(this.Plot.x + this.PlotWidth,this.Plot.y);
				this.graphics.lineTo(this.Plot.x + this.PlotWidth,0);
				this.graphics.lineTo(this.Plot.x,0);
				this.graphics.lineTo(this.Plot.x,this.Plot.y);
			}
			if(this.bDrawGraphGrid)
			{
				if(this.XMax != this.XMin)
				{
					_loc1_ = this.XGridStep / (this.XMax - this.XMin) * this.PlotWidth;
					_loc2_ = _loc1_ + this.Plot.x;
					while(_loc2_ < this.Width && _loc1_ > 0)
					{
						this.graphics.moveTo(_loc2_,this.Plot.y);
						this.graphics.lineTo(_loc2_,0);
						_loc2_ = _loc2_ + _loc1_;
					}
				}
				if(this.YMax != this.YMin)
				{
					_loc3_ = this.YGridStep / (this.YMax - this.YMin) * this.PlotHeight;
					_loc4_ = this.Plot.y - _loc3_;
					while(_loc4_ > 0 && _loc3_ > 0)
					{
						this.graphics.moveTo(this.Plot.x,_loc4_);
						this.graphics.lineTo(this.Width,_loc4_);
						_loc4_ = _loc4_ - _loc3_;
					}
				}
			}
		}
		
		public function SetXExtents(param1:Number, param2:Number, param3:Number) : *
		{
			this.XMax = param1;
			GlobalFunc.SetText(this.XMaxLabel,String(param1),false);
			this.XMin = param2;
			GlobalFunc.SetText(this.XMinLabel,String(param2),false);
			this.XGridStep = param3;
			this.PositionLabels();
			this.DrawBackground();
		}
		
		public function SetYExtents(param1:Number, param2:Number, param3:Number) : *
		{
			this.YMax = param1;
			GlobalFunc.SetText(this.YMaxLabel,String(param1),false);
			this.YMin = param2;
			GlobalFunc.SetText(this.YMinLabel,String(param2),false);
			this.YGridStep = param3;
			this.PositionLabels();
			this.DrawBackground();
		}
		
		public function Clear() : *
		{
			this.Plot.graphics.clear();
		}
		
		public function PlotLine() : *
		{
			var _loc1_:Number = NaN;
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			if(this.XMax != this.XMin && this.YMax != this.YMin)
			{
				_loc1_ = this.PlotWidth / (this.XMax - this.XMin);
				_loc2_ = -this.PlotHeight / (this.YMax - this.YMin);
				if(this.Data.length > 1)
				{
					this.Plot.graphics.lineStyle(this.LineWidth,this.LineColor,100,false,"none","none","miter");
					this.Plot.graphics.moveTo(_loc1_ * (this.Data[0] - this.XMin),_loc2_ * (this.Data[1] - this.YMin));
					_loc3_ = 2;
					while(_loc3_ < this.Data.length - 1)
					{
						this.Plot.graphics.lineTo(_loc1_ * (this.Data[_loc3_] - this.XMin),_loc2_ * (this.Data[_loc3_ + 1] - this.YMin));
						_loc3_ = _loc3_ + 2;
					}
				}
			}
		}

		
	}
}
