package
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;


	public class Overlay extends MovieClip
	{

		public var Focus:MovieClip;
		public var Background:MovieClip;
		private var _NumWidgets:uint;


		public function Overlay()
		{
			super();
			this._NumWidgets = 0;
			this.Focus.visible = false;
		}


		public function AddWidget(param1:String) : MovieClip
		{
			var symbolClass:Class = null;
			var aSymbol:String = param1;
			var widgetClip:MovieClip = null;
			if(null != aSymbol && aSymbol.length > 0)
			{
				try
				{
					symbolClass = getDefinitionByName(aSymbol) as Class;
					widgetClip = new symbolClass();
				}
				catch(error:ReferenceError)
				{
					trace("AddWidget error: invalid class!");
				}
			}
			else
			{
				widgetClip = new MovieClip();
			}
			if(null != widgetClip)
			{
				widgetClip.name = (null != aSymbol && aSymbol.length > 0?aSymbol:"Widget") + this._NumWidgets.toString();
				this._NumWidgets++;
				this.addChild(widgetClip);
			}
			return widgetClip;
		}


		public function RemoveWidget(param1:MovieClip) : *
		{
			if(null != param1)
			{
				this.removeChild(param1);
				this._NumWidgets--;
			}
		}


		public function SetPosition(param1:Number, param2:Number) : *
		{
			this.x = param1;
			this.y = param2;
		}


		public function SetDimensions(param1:Number, param2:Number) : *
		{
			this.Background.width = param1;
			this.Background.height = param2;
		}


		public function SetFocus(param1:Boolean) : *
		{
			this.Focus.visible = param1;
		}


		public function get NumWidgets() : uint
		{
			return this._NumWidgets;
		}



	}
}
