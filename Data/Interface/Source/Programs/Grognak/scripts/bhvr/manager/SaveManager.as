package bhvr.manager
{
	import flash.net.SharedObject;
	import bhvr.data.serializer.GamePersistantDataSerializer;
	import Shared.BGSExternalInterface;
	import bhvr.constants.GameConfig;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	
	public class SaveManager
	{
		
		private static const SAVE_NAME:String = "save";
		
		private static var _instance:bhvr.manager.SaveManager;
		
		private static var _allowInstance:Boolean;
		 
		
		public var BGSCodeObj:Object;
		
		private var _saveData:String = null;
		
		public function SaveManager()
		{
			super();
			if(!SaveManager._allowInstance)
			{
				throw new Error("Error: Use SaveManager.instance instead of new SaveManager().");
			}
		}
		
		public static function get instance() : bhvr.manager.SaveManager
		{
			if(SaveManager._instance == null)
			{
				SaveManager._allowInstance = true;
				SaveManager._instance = new bhvr.manager.SaveManager();
				SaveManager._allowInstance = false;
			}
			return SaveManager._instance;
		}
		
		public function init() : void
		{
			var saveDataObject:SharedObject = null;
			if(!this.isExternalSaveAvailable())
			{
				saveDataObject = SharedObject.getLocal(SAVE_NAME);
				if(saveDataObject.data.hasOwnProperty("save"))
				{
					this._saveData = SharedObject.getLocal(SAVE_NAME).data.save;
				}
			}
		}
		
		public function save() : void
		{
			var saveDataObject:SharedObject = null;
			this._saveData = GamePersistantDataSerializer.serialize();
			if(this.isExternalSaveAvailable())
			{
				BGSExternalInterface.call(this.BGSCodeObj,"setSaveData",GameConfig.GAME_SAVE_DATA_KEY,this._saveData);
			}
			else
			{
				saveDataObject = SharedObject.getLocal(SAVE_NAME);
				saveDataObject.data.save = this._saveData;
				saveDataObject.flush();
			}
		}
		
		public function restoreSave() : void
		{
			if(this.hasSave())
			{
				GamePersistantDataSerializer.deserialize(this._saveData);
			}
		}
		
		public function clearSave() : void
		{
			var saveDataObject:SharedObject = null;
			this._saveData = null;
			if(this.isExternalSaveAvailable())
			{
				BGSExternalInterface.call(this.BGSCodeObj,"setSaveData",GameConfig.GAME_SAVE_DATA_KEY,"");
			}
			else
			{
				saveDataObject = SharedObject.getLocal(SAVE_NAME);
				saveDataObject.data.save = null;
				saveDataObject.flush();
			}
		}
		
		public function hasSave() : Boolean
		{
			return this._saveData != null && this._saveData.length > 0 && GamePersistantDataSerializer.isCompatible(this._saveData);
		}
		
		private function isExternalSaveAvailable() : Boolean
		{
			return CompanionAppMode.isOn || this.BGSCodeObj != null && this.BGSCodeObj["setSaveData"] != null;
		}
		
		public function dispose() : void
		{
			this._saveData = null;
			this.BGSCodeObj = null;
		}
		
		public function SetSaveData(data:String) : void
		{
			this._saveData = data;
		}
	}
}
