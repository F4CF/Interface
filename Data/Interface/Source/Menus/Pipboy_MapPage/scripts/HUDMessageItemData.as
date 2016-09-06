package
{
	public class HUDMessageItemData
	{
		 
		
		public var messageText:String;
		
		public var isWarning:Boolean;
		
		public var isRadioStation:Boolean;
		
		public function HUDMessageItemData(param1:String, param2:Boolean, param3:Boolean)
		{
			super();
			this.messageText = param1;
			this.isWarning = param2;
			this.isRadioStation = param3;
		}
	}
}
