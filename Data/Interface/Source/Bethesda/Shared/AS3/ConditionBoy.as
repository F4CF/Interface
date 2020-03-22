package Shared.AS3
{
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public dynamic class ConditionBoy extends BSUIComponent
	{
		 
		
		private var BodyClip_mc:MovieClip;
		
		private var HeadClip_mc:MovieClip;
		
		private var _BodyFlags:uint;
		
		private var _HeadFlags:uint;
		
		private var _UpdateHead:Boolean;
		
		private var _UpdateBody:Boolean;
		
		private var Condition_Head_Loader:PipboyLoader;
		
		private var Condition_Body_Loader:PipboyLoader;
		
		public function ConditionBoy()
		{
			super();
			this.BodyClip_mc = null;
			this.HeadClip_mc = null;
			this._BodyFlags = uint.MAX_VALUE;
			this._HeadFlags = uint.MAX_VALUE;
			this._UpdateBody = false;
			this._UpdateHead = false;
			this.Condition_Head_Loader = new PipboyLoader();
			var _loc1_:URLRequest = new URLRequest("Components/ConditionClips/Condition_Head.swf");
			var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			this.Condition_Head_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onConditionHeadLoadComplete);
			this.Condition_Head_Loader.load(_loc1_,_loc2_);
		}
		
		public function set BodyFlags(param1:uint) : void
		{
			var _loc2_:URLRequest = null;
			var _loc3_:LoaderContext = null;
			if(this._BodyFlags != param1)
			{
				this._BodyFlags = param1;
				if(this.Condition_Body_Loader)
				{
					this.Condition_Body_Loader.unloadAndStop();
				}
				this.Condition_Body_Loader = new PipboyLoader();
				_loc2_ = new URLRequest("Components/ConditionClips/Condition_Body_" + this._BodyFlags + ".swf");
				_loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				this.Condition_Body_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onConditionBodyLoadComplete);
				this.Condition_Body_Loader.load(_loc2_,_loc3_);
			}
		}
		
		public function set HeadFlags(param1:uint) : void
		{
			if(this._HeadFlags != param1)
			{
				this._UpdateHead = true;
				this._HeadFlags = param1;
				SetIsDirty();
			}
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			if(this.BodyClip_mc && this.HeadClip_mc)
			{
				if(this._UpdateBody)
				{
					if(numChildren > 0)
					{
						removeChildAt(0);
					}
					this.BodyClip_mc.Head_mc.addChild(this.HeadClip_mc);
					this.BodyClip_mc.scaleX = 1.2;
					this.BodyClip_mc.scaleY = this.BodyClip_mc.scaleX;
					addChild(this.BodyClip_mc);
					this._UpdateHead = true;
					this._UpdateBody = false;
				}
				if(this._UpdateHead)
				{
					this.HeadClip_mc.gotoAndStop(this._HeadFlags + 1);
					this._UpdateHead = false;
				}
			}
			if(this._UpdateBody || this._UpdateHead)
			{
				SetIsDirty();
			}
		}
		
		private function onConditionBodyLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onConditionBodyLoadComplete);
			this.BodyClip_mc = this.Condition_Body_Loader.contentLoaderInfo.content as MovieClip;
			this.Condition_Body_Loader = null;
			this._UpdateBody = true;
			SetIsDirty();
		}
		
		private function onConditionHeadLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onConditionHeadLoadComplete);
			this.HeadClip_mc = this.Condition_Head_Loader.contentLoaderInfo.content as MovieClip;
			this.Condition_Head_Loader = null;
			this._UpdateHead = true;
			SetIsDirty();
		}
	}
}
