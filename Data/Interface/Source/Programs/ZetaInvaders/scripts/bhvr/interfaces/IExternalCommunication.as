package bhvr.interfaces
{
	public interface IExternalCommunication
	{
		 
		
		function SetPlatform(param1:uint, param2:Boolean) : void;
		
		function ProcessUserEvent(param1:String, param2:Boolean) : Boolean;
		
		function InitProgram() : void;
		
		function SetHighscore(param1:int) : void;
		
		function Pause(param1:Boolean) : void;
	}
}
