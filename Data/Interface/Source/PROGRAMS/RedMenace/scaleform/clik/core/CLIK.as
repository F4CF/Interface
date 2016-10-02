package scaleform.clik.core
{
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import scaleform.gfx.Extensions;
	import scaleform.clik.managers.FocusHandler;
	import scaleform.clik.managers.PopUpManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public dynamic class CLIK
	{
		
		public static var stage:Stage;
		
		public static var initialized:Boolean = false;
		
		public static var disableNullFocusMoves:Boolean = false;
		
		public static var disableDynamicTextFieldFocus:Boolean = false;
		
		public static var disableTextFieldToNullFocusMoves:Boolean = true;
		
		public static var useImmediateCallbacks:Boolean = false;
		
		protected static var isInitListenerActive:Boolean = false;
		
		protected static var firingInitCallbacks:Boolean = false;
		
		protected static var initQueue:Dictionary;
		
		protected static var validDictIndices:Vector.<uint>;
		 
		
		public function CLIK()
		{
			super();
		}
		
		public static function initialize(stage:Stage, component:UIComponent) : void
		{
			if(initialized)
			{
				return;
			}
			CLIK.stage = stage;
			Extensions.enabled = true;
			initialized = true;
			FocusHandler.init(stage,component);
			PopUpManager.init(stage);
			initQueue = new Dictionary(true);
			validDictIndices = new Vector.<uint>();
		}
		
		public static function getTargetPathFor(clip:DisplayObjectContainer) : String
		{
			var targetPath:String = null;
			if(!clip.parent)
			{
				return clip.name;
			}
			targetPath = clip.name;
			return getTargetPathImpl(clip.parent as DisplayObjectContainer,targetPath);
		}
		
		public static function queueInitCallback(ref:UIComponent) : void
		{
			var parents:Array = null;
			var numParents:uint = 0;
			var dict:Dictionary = null;
			var path:String = getTargetPathFor(ref);
			if(useImmediateCallbacks || firingInitCallbacks)
			{
				Extensions.CLIK_addedToStageCallback(ref.name,path,ref);
			}
			else
			{
				parents = path.split(".");
				numParents = parents.length - 1;
				dict = initQueue[numParents];
				if(dict == null)
				{
					dict = new Dictionary(true);
					initQueue[numParents] = dict;
					validDictIndices.push(numParents);
					if(validDictIndices.length > 1)
					{
						validDictIndices.sort(sortFunc);
					}
				}
				dict[ref] = path;
				if(!isInitListenerActive)
				{
					isInitListenerActive = true;
					stage.addEventListener(Event.EXIT_FRAME,fireInitCallback,false,0,true);
				}
			}
		}
		
		protected static function fireInitCallback(e:Event) : void
		{
			var i:uint = 0;
			var numParents:uint = 0;
			var dict:Dictionary = null;
			var ref:* = null;
			var comp:UIComponent = null;
			firingInitCallbacks = true;
			stage.removeEventListener(Event.EXIT_FRAME,fireInitCallback,false);
			for(isInitListenerActive = false; i < validDictIndices.length; )
			{
				numParents = validDictIndices[i];
				dict = initQueue[numParents] as Dictionary;
				for(ref in dict)
				{
					comp = ref as UIComponent;
					Extensions.CLIK_addedToStageCallback(comp.name,dict[comp],comp);
					dict[comp] = null;
				}
				i++;
			}
			validDictIndices.length = 0;
			clearQueue();
			firingInitCallbacks = false;
		}
		
		protected static function clearQueue() : void
		{
			var numDict:* = undefined;
			for(numDict in initQueue)
			{
				initQueue[numDict] = null;
			}
		}
		
		protected static function sortFunc(a:uint, b:uint) : Number
		{
			if(a < b)
			{
				return -1;
			}
			if(a > b)
			{
				return 1;
			}
			return 0;
		}
		
		protected static function getTargetPathImpl(clip:DisplayObjectContainer, targetPath:String = "") : String
		{
			var _name:String = null;
			if(!clip)
			{
				return targetPath;
			}
			_name = Boolean(clip.name)?clip.name + ".":"";
			targetPath = _name + targetPath;
			return getTargetPathImpl(clip.parent as DisplayObjectContainer,targetPath);
		}
	}
}
