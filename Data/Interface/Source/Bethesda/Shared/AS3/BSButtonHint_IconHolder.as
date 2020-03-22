// Note: UNUSED: This has been re-implemented as frame scripts. -Scrivener07
package
{
	import flash.display.MovieClip;

	public dynamic class BSButtonHint_IconHolder extends MovieClip
	{
		public var IconAnimInstance:MovieClip;


		public function BSButtonHint_IconHolder()
		{
			super();
			addFrameScript(0, this.frame1, 59, this.frame60);
			trace("[BSButtonHint_IconHolder] CTOR");
		}


		function frame1():*
		{
			stop();
			trace("[BSButtonHint_IconHolder] Stop");
		}


		function frame60():*
		{
			gotoAndPlay("Flashing");
			trace("[BSButtonHint_IconHolder] Flashing");
		}


	}
}
