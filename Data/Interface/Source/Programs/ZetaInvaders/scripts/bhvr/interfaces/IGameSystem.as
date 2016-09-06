package bhvr.interfaces
{
	public interface IGameSystem
	{
		 
		
		function start() : void;
		
		function freeze() : void;
		
		function unfreeze() : void;
		
		function stop() : void;
		
		function pause(param1:Boolean) : void;
	}
}
