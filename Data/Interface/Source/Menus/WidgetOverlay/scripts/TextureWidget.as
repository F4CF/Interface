package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class TextureWidget extends MovieClip
	{
		 
		
		private var TextureLoader:Loader;
		
		private var TextureContainer:MovieClip;
		
		private var StoredWidth:Number;
		
		private var StoredHeight:Number;
		
		public function TextureWidget()
		{
			super();
			this.StoredWidth = 0;
			this.StoredHeight = 0;
		}
		
		public function SetDimensions(param1:Number, param2:Number) : *
		{
			this.StoredWidth = param1;
			this.StoredHeight = param2;
			if(null == this.TextureLoader && null != this.TextureContainer)
			{
				this.TextureContainer.width = this.StoredWidth;
				this.TextureContainer.height = this.StoredHeight;
			}
		}
		
		public function LoadTexture(param1:String) : *
		{
			var _loc2_:URLRequest = null;
			if(null == this.TextureLoader)
			{
				if(null == this.TextureContainer)
				{
					this.TextureContainer = new MovieClip();
					this.TextureContainer.name = "ContainerClip";
				}
				this.TextureLoader = new Loader();
				_loc2_ = new URLRequest(param1);
				this.TextureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onTextureLoadComplete);
				this.TextureLoader.load(_loc2_);
			}
		}
		
		public function RemoveTexture() : *
		{
			if(null != this.TextureContainer)
			{
				this.TextureContainer.removeChildAt(0);
			}
		}
		
		private function onTextureLoadComplete(param1:Event) : *
		{
			if(null != this.TextureLoader)
			{
				if(null != this.TextureContainer)
				{
					this.TextureContainer.addChild(param1.currentTarget.content);
					if(0 != this.StoredWidth)
					{
						this.TextureContainer.width = this.StoredWidth;
					}
					if(0 != this.StoredHeight)
					{
						this.TextureContainer.height = this.StoredHeight;
					}
				}
				this.TextureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onTextureLoadComplete);
				this.TextureLoader = null;
			}
		}
	}
}
