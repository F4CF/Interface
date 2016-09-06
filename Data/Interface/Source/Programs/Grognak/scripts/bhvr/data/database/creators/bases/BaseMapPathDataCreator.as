package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapPath;
	import flash.utils.Dictionary;
	
	public class BaseMapPathDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapPathDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createMapPath(id:String) : MapPath
		{
			var obj:MapPath = new MapPath();
			addObjectToSharedData(id,obj);
			return obj;
		}
	}
}
