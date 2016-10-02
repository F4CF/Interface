package bhvr.interfaces
{
	public interface IFighterStats
	{
		 
		
		function get fighterName() : String;
		
		function get currentHP() : int;
		
		function get currentBaseInitiative() : int;
		
		function get currentInitiative() : Number;
		
		function set currentInitiative(param1:Number) : void;
		
		function damage(param1:int) : int;
	}
}
