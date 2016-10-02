package scaleform.clik.utils
{
	import flash.utils.Dictionary;
	
	public class WeakReference
	{
		 
		
		protected var _dictionary:Dictionary;
		
		public function WeakReference(obj:Object)
		{
			super();
			this._dictionary = new Dictionary(true);
			this._dictionary[obj] = 1;
		}
		
		public function get value() : Object
		{
			var dvalue:* = null;
			for(dvalue in this._dictionary)
			{
				return dvalue;
			}
			return null;
		}
	}
}
