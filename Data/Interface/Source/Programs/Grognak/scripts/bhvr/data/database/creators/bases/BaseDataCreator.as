package bhvr.data.database.creators.bases
{
	import flash.utils.Dictionary;
	
	public class BaseDataCreator
	{
		 
		
		private var _sharedData:Dictionary;
		
		public function BaseDataCreator(sharedData:Dictionary)
		{
			super();
			this._sharedData = sharedData;
		}
		
		public function createData() : void
		{
		}
		
		public function addObjectToSharedData(id:String, obj:Object) : void
		{
			if(this._sharedData[id] != null)
			{
				throw new Error("An object already exists with id \'" + id + "\'.");
			}
			this._sharedData[id] = obj;
		}
		
		public function getObjectFromSharedData(id:String, classType:Class) : Object
		{
			var obj:Object = this._sharedData[id] as classType;
			if(obj == null)
			{
				throw new Error("No object of type \'" + classType + "\' exists for id \'" + id + "\'.");
			}
			return obj;
		}
	}
}
