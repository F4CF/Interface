package bhvr.interfaces
{
	import flash.geom.Point;
	
	public interface ICharacter
	{
		 
		
		function start() : void;
		
		function stop() : void;
		
		function update(param1:Point) : void;
		
		function pause() : void;
		
		function resume() : void;
	}
}
