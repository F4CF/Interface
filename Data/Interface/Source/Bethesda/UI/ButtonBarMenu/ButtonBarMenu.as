package
{
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;

	public dynamic class ButtonBarMenu extends IMenu
	{

		public var PromptMenuPanel_mc:MovieClip;
		public var ButtonBarHolder_mc:MovieClip;


		public function ButtonBarMenu()
		{
			super();
			trace("[ButtonBarMenu](ctor) Begin");
			this.ButtonBarHolder_mc.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			trace("[ButtonBarMenu](ctor) End");
		}


		override protected function onSetSafeRect():void
		{
			trace("[ButtonBarMenu](onSetSafeRect) Begin");
			GlobalFunc.LockToSafeRect(this.ButtonBarHolder_mc, "BC", SafeX, SafeY);
			GlobalFunc.LockToSafeRect(this.PromptMenuPanel_mc, "TL", SafeX, SafeY);
			trace("[ButtonBarMenu](onSetSafeRect) End");
		}


	}
}
