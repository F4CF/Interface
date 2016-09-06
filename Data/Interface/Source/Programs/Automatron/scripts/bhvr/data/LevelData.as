package bhvr.data
{
	import flash.utils.Dictionary;
	
	public class LevelData
	{
		 
		
		public var humansNum:uint;
		
		public var enemiesNum:Dictionary;
		
		public function LevelData()
		{
			super();
			this.humansNum = 0;
			this.enemiesNum = new Dictionary(true);
		}
	}
}
