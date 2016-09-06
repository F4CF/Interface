package
{
	import Pipboy.COMPANIONAPP.QuestsListItemRenderer;
	
	public dynamic class QuestsItemRendererMc extends QuestsListItemRenderer
	{
		 
		
		public function QuestsItemRendererMc()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
