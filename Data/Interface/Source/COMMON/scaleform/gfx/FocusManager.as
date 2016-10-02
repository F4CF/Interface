package scaleform.gfx
{
	import flash.display.InteractiveObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public final class FocusManager
	{
		 
		
		public function FocusManager()
		{
			super();
		}
		
		public static function set alwaysEnableArrowKeys(enable:Boolean) : void
		{
		}
		
		public static function get alwaysEnableArrowKeys() : Boolean
		{
			return false;
		}
		
		public static function set disableFocusKeys(disable:Boolean) : void
		{
		}
		
		public static function get disableFocusKeys() : Boolean
		{
			return false;
		}
		
		public static function moveFocus(keyToSimulate:String, startFromMovie:InteractiveObject = null, includeFocusEnabledChars:Boolean = false, controllerIdx:uint = 0) : InteractiveObject
		{
			return null;
		}
		
		public static function findFocus(keyToSimulate:String, parentMovie:DisplayObjectContainer = null, loop:Boolean = false, startFromMovie:InteractiveObject = null, includeFocusEnabledChars:Boolean = false, controllerIdx:uint = 0) : InteractiveObject
		{
			return null;
		}
		
		public static function setFocus(obj:InteractiveObject, controllerIdx:uint = 0) : void
		{
			trace("FocusManager.setFocus is only usable with GFx. Use stage.focus property in Flash.");
		}
		
		public static function getFocus(controllerIdx:uint = 0) : InteractiveObject
		{
			trace("FocusManager.getFocus is only usable with GFx. Use stage.focus property in Flash.");
			return null;
		}
		
		public static function get numFocusGroups() : uint
		{
			return 1;
		}
		
		public static function setFocusGroupMask(obj:InteractiveObject, mask:uint) : void
		{
		}
		
		public static function getFocusGroupMask(obj:InteractiveObject) : uint
		{
			return 1;
		}
		
		public static function setControllerFocusGroup(controllerIdx:uint, focusGroupIdx:uint) : Boolean
		{
			return false;
		}
		
		public static function getControllerFocusGroup(controllerIdx:uint) : uint
		{
			return 0;
		}
		
		public static function getControllerMaskByFocusGroup(focusGroupIdx:uint) : uint
		{
			return 0;
		}
		
		public static function getModalClip(controllerIdx:uint = 0) : Sprite
		{
			return null;
		}
		
		public static function setModalClip(mc:Sprite, controllerIdx:uint = 0) : void
		{
		}
	}
}
