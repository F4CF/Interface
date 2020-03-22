package
{
	import flash.display.MovieClip;

	public dynamic class WeaponArmorHolder extends MovieClip
	{


		public function WeaponArmorHolder()
		{
			super();
			addFrameScript(0, this.frame1);
		}


		function frame1():*
		{
			stop();
		}


	}
}
