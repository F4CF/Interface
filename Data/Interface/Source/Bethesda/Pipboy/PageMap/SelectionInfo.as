package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	
	public class SelectionInfo extends BSUIComponent
	{
		 
		
		public var Background_mc:MovieClip;
		
		public var WorkshopInfo_mc:Selection_WorkshopInfo;
		
		public var Location_tf:TextField;
		
		private var _LocName:String;
		
		private var _IsCleared:Boolean;
		
		private var _IsWorkshopLoc:Boolean;
		
		public function SelectionInfo()
		{
			super();
			this._LocName = "";
			this._IsCleared = false;
			this._IsWorkshopLoc = false;
			this.Location_tf.autoSize = TextFieldAutoSize.CENTER;
			this.Location_tf.wordWrap = true;
		}
		
		public function SetSelectionInfo(param1:Object) : *
		{
			this._LocName = param1.name;
			this._IsCleared = param1.dungeonCleared == true;
			this._IsWorkshopLoc = param1.workshopOwned == true;
			if(this._IsWorkshopLoc)
			{
				this.WorkshopInfo_mc.SetWorkshopInfo(param1.workshopPopulation,param1.workshopHappyPct);
			}
			SetIsDirty();
		}
		
		public function ClearSelectionInfo() : *
		{
			this._LocName = "";
			this._IsCleared = false;
			this._IsWorkshopLoc = false;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:TextLineMetrics = null;
			var _loc3_:uint = 0;
			super.redrawUIComponent();
			if(this._IsCleared)
			{
				GlobalFunc.SetText(this.Location_tf,"$LocationCleared",false);
				GlobalFunc.SetText(this.Location_tf,this._LocName + "\n" + this.Location_tf.text,false);
			}
			else
			{
				GlobalFunc.SetText(this.Location_tf,this._LocName,false);
			}
			if(this._IsWorkshopLoc)
			{
				this.WorkshopInfo_mc.x = 10;
				this.WorkshopInfo_mc.y = this.Location_tf.y + this.Location_tf.height + 15;
				this.WorkshopInfo_mc.visible = true;
			}
			else
			{
				this.WorkshopInfo_mc.visible = false;
			}
			if(this._LocName.length > 0)
			{
				_loc1_ = 0;
				_loc3_ = 0;
				while(_loc3_ < this.Location_tf.numLines)
				{
					_loc2_ = this.Location_tf.getLineMetrics(_loc3_);
					if(_loc2_.width > _loc1_)
					{
						_loc1_ = _loc2_.width;
					}
					_loc3_++;
				}
				if(this.WorkshopInfo_mc.width > _loc1_)
				{
					_loc1_ = this.WorkshopInfo_mc.width;
				}
				this.Background_mc.width = _loc1_ + 20;
				this.Background_mc.height = this.Location_tf.height + (!!this.WorkshopInfo_mc.visible?this.WorkshopInfo_mc.height:0) + 5;
				this.Background_mc.x = -this.Background_mc.width / 2;
				this.Background_mc.visible = true;
			}
			else
			{
				this.Background_mc.visible = false;
			}
		}
	}
}
