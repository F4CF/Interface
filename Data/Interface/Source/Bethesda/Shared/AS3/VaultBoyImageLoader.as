package Shared.AS3
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public dynamic class VaultBoyImageLoader extends BSUIComponent
	{
		 
		
		public var VaultBoyImageInternal_mc:BSUIComponent;
		
		private var SWF:MovieClip;
		
		private var menuLoader:Loader;
		
		private var _bUseFixedQuestStageSize:Boolean = true;
		
		private var _bPlayClipOnce:Boolean = true;
		
		private var _clipAlignment:String = "TopLeft";
		
		private var _defaultBoySwfName:String = "Components/Quest Vault Boys/Miscellaneous Quests/DefaultBoy.swf";
		
		private var _questAnimStageWidth:Number = 550;
		
		private var _questAnimStageHeight:Number = 400;
		
		private var _maxClipHeight:Number = 180;
		
		public var onLastFrame:Function;
		
		public function VaultBoyImageLoader()
		{
			this.onLastFrame = this.onLastFrame_Impl;
			super();
			this.SWF = null;
			this.menuLoader = null;
		}
		
		public function get bUseFixedQuestStageSize() : Boolean
		{
			return this._bUseFixedQuestStageSize;
		}
		
		public function set bUseFixedQuestStageSize(param1:Boolean) : *
		{
			this._bUseFixedQuestStageSize = param1;
		}
		
		public function get bPlayClipOnce() : Boolean
		{
			return this._bPlayClipOnce;
		}
		
		public function set bPlayClipOnce(param1:Boolean) : *
		{
			this._bPlayClipOnce = param1;
		}
		
		public function get ClipAlignment() : String
		{
			return this._clipAlignment;
		}
		
		public function set ClipAlignment(param1:String) : *
		{
			this._clipAlignment = param1;
		}
		
		public function get DefaultBoySwfName() : String
		{
			return this._defaultBoySwfName;
		}
		
		public function set DefaultBoySwfName(param1:String) : *
		{
			this._defaultBoySwfName = param1;
		}
		
		public function get questAnimStageWidth() : Number
		{
			return this._questAnimStageWidth;
		}
		
		public function set questAnimStageWidth(param1:Number) : void
		{
			this._questAnimStageWidth = param1;
		}
		
		public function get questAnimStageHeight() : Number
		{
			return this._questAnimStageHeight;
		}
		
		public function set questAnimStageHeight(param1:Number) : void
		{
			this._questAnimStageHeight = param1;
		}
		
		public function get maxClipHeight() : Number
		{
			return this._maxClipHeight;
		}
		
		public function set maxClipHeight(param1:Number) : void
		{
			this._maxClipHeight = param1;
		}
		
		public function SWFLoad(param1:String) : void
		{
			var aSwfLoaderURL:String = param1;
			this.VaultBoyImageInternal_mc.visible = false;
			if(this.menuLoader)
			{
				this.menuLoader.close();
			}
			this.SWFUnload();
			var loadCompleteCallback:Function = function(param1:Event):*
			{
				onMenuLoadComplete(param1,aSwfLoaderURL);
			};
			var menuLoadRequest:URLRequest = new URLRequest(!!aSwfLoaderURL?aSwfLoaderURL:this.DefaultBoySwfName);
			this.menuLoader = new Loader();
			this.menuLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteCallback);
			this.menuLoader.load(menuLoadRequest);
			SetIsDirty();
		}
		
		public function onMenuLoadComplete(param1:Event, param2:String) : void
		{
			var _loc3_:MovieClip = null;
			if(param1 && param1.currentTarget && param1.currentTarget.content)
			{
				_loc3_ = param1.currentTarget.content as MovieClip;
				_loc3_.SwfLoaderURL = param2;
				this.SetQuestMovieClip(_loc3_);
			}
			else
			{
				this.SWFUnload();
			}
		}
		
		public function SetQuestMovieClip(param1:MovieClip) : void
		{
			var _loc4_:Graphics = null;
			var _loc5_:Rectangle = null;
			this.VaultBoyImageInternal_mc.visible = true;
			this.SWF = param1;
			this.VaultBoyImageInternal_mc.addChild(this.SWF);
			if(this.bPlayClipOnce)
			{
				this.SWF.addEventListener(Event.ENTER_FRAME,this.onSWFEnterFrame);
			}
			if(this.bUseFixedQuestStageSize)
			{
				_loc4_ = this.SWF.graphics;
				_loc4_.clear();
				_loc4_.beginFill(0,0);
				_loc4_.drawRect(0,0,this.questAnimStageWidth,this.questAnimStageHeight);
				_loc4_.endFill();
			}
			var _loc2_:Number = this._maxClipHeight;
			if(bShowBrackets)
			{
				_loc2_ = _loc2_ - 2 * (this.VaultBoyImageInternal_mc.bracketPaddingY + this.VaultBoyImageInternal_mc.bracketLineWidth);
			}
			var _loc3_:Number = _loc2_ / this.SWF.height;
			this.SWF.scaleX = _loc3_;
			this.SWF.scaleY = _loc3_;
			if(this.ClipAlignment == "Center")
			{
				this.SWF.x = -this.questAnimStageWidth * 0.5 * _loc3_;
				this.SWF.y = -this.questAnimStageHeight * 0.5 * _loc3_;
			}
			this.VaultBoyImageInternal_mc.bShowBrackets = false;
			if(bShowBrackets)
			{
				this.VaultBoyImageInternal_mc.UpdateBrackets(true);
				_loc5_ = this.VaultBoyImageInternal_mc.getBounds(this);
				this.VaultBoyImageInternal_mc.x = this.VaultBoyImageInternal_mc.x - _loc5_.x;
				this.VaultBoyImageInternal_mc.y = this.VaultBoyImageInternal_mc.y - _loc5_.y;
			}
			this.menuLoader = null;
			SetIsDirty();
		}
		
		public function onLastFrame_Impl(param1:String) : *
		{
		}
		
		public function onSWFEnterFrame(param1:Event) : *
		{
			if(this.bPlayClipOnce && this.SWF && this.SWF.currentFrame == this.SWF.totalFrames)
			{
				this.SWF.removeEventListener(Event.ENTER_FRAME,this.onSWFEnterFrame);
				this.SWF.stop();
				this.onLastFrame(this.SWF.SwfLoaderURL);
			}
		}
		
		public function SWFUnload() : void
		{
			if(this.SWF)
			{
				this.SWF.removeEventListener(Event.ENTER_FRAME,this.onSWFEnterFrame);
				if(this.VaultBoyImageInternal_mc.contains(this.SWF))
				{
					this.VaultBoyImageInternal_mc.removeChild(this.SWF);
				}
				if(this.SWF.loaderInfo)
				{
					this.SWF.loaderInfo.loader.unload();
				}
			}
			this.SWF = null;
			this.VaultBoyImageInternal_mc.UpdateBrackets(false);
			this.VaultBoyImageInternal_mc.SetIsDirty();
			this.VaultBoyImageInternal_mc.visible = false;
			SetIsDirty();
		}
	}
}
