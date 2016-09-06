package bhvr.interfaces
{
	public interface IExternalCommunication
	{
		 
		
		function SetPlatform(param1:uint, param2:Boolean) : void;
		
		function ProcessUserEvent(param1:String, param2:Boolean) : Boolean;
		
		function OnLeftStickInput(param1:Number, param2:Number, param3:Number = 0.016) : void;
		
		function OnRightStickInput(param1:Number, param2:Number, param3:Number = 0.016) : void;
		
		function InitProgram() : void;
		
		function SetHighscore(param1:int) : void;
		
		function Pause(param1:Boolean) : void;
		
		function ConfirmQuit() : void;
		
		function onCodeObjCreate() : void;
		
		function onCodeObjDestruction() : void;
	}
}
