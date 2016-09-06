package bhvr.data.serializer
{
	import flash.utils.ByteArray;
	import bhvr.debug.Log;
	import bhvr.data.GamePersistantData;
	import bhvr.data.database.Hero;
	import bhvr.module.combat.HeroStats;
	import flash.utils.Dictionary;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.StoryConditionType;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	public class GamePersistantDataSerializer
	{
		
		public static const VERSION:int = 1;
		 
		
		public function GamePersistantDataSerializer()
		{
			super();
		}
		
		public static function serialize() : String
		{
			var bytes:ByteArray = new ByteArray();
			handleBytes(bytes,true);
			return getBase64StringFromBytes(bytes);
		}
		
		public static function deserialize(data:String) : void
		{
			var bytes:ByteArray = getBytesFromBase64String(data);
			Log.info("----- Deserialization START ----- ");
			GamePersistantData.reset();
			try
			{
				handleBytes(bytes,false);
			}
			catch(err:Error)
			{
				Log.error("Error while deserializing : " + err.message);
				Log.warn("Game persistant data will be reset.");
				GamePersistantData.reset();
			}
			Log.info("----- Deserialization END ----- ");
		}
		
		public static function isCompatible(data:String) : Boolean
		{
			var bytes:ByteArray = null;
			var version:int = 0;
			try
			{
				bytes = getBytesFromBase64String(data);
				version = readVersion(bytes);
				return version == VERSION;
			}
			catch(err:Error)
			{
				Log.error("Error while verifying data version : " + err.message);
				Log.warn("Data will be considered invalid.");
			}
			return false;
		}
		
		private static function handleBytes(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			handleMeta(bytes,actionIsSerialization);
			handlePartyMembers(bytes,actionIsSerialization);
			handleStoryConditions(bytes,actionIsSerialization);
			handleGold(bytes,actionIsSerialization);
			handleShopItems(bytes,actionIsSerialization);
			handleCombatEvents(bytes,actionIsSerialization);
		}
		
		private static function handleMeta(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			var version:int = 0;
			if(actionIsSerialization)
			{
				bytes.writeByte(VERSION);
			}
			else
			{
				version = readVersion(bytes);
				if(version != VERSION)
				{
					throw new Error("Can\'t deserialize : data doesn\'t correspond to current serialization version.");
				}
				Log.info("SERIALIZATION VERSION = " + version);
			}
		}
		
		private static function readVersion(bytes:ByteArray) : int
		{
			return bytes.readUnsignedByte();
		}
		
		private static function handlePartyMembers(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			var i:int = 0;
			var hero:Hero = null;
			var partyMember:HeroStats = null;
			var uidToPartyMemberMap:Dictionary = null;
			var partyMembers:Vector.<HeroStats> = null;
			var statByte:int = 0;
			var partyMemberCount:int = 0;
			var bitfield:Bitfield = new Bitfield();
			if(actionIsSerialization)
			{
				uidToPartyMemberMap = new Dictionary();
				partyMembers = GamePersistantData.getPartyMembers();
				bytes.writeBoolean(GamePersistantData.isPartySelectionCompleted);
				for(i = 0; i < partyMembers.length; i++)
				{
					partyMember = partyMembers[i];
					bitfield.setBit(partyMember.hero.uid,true);
					uidToPartyMemberMap[partyMember.hero.uid] = partyMember;
				}
				bytes.writeByte(bitfield.value);
				for(i = 0; i < GameDatabase.heroes.length; i++)
				{
					partyMember = uidToPartyMemberMap[GameDatabase.heroes[i].uid];
					if(partyMember != null)
					{
						bytes.writeByte(partyMember.additionalMaxHP);
						bytes.writeByte(partyMember.currentHP);
						bytes.writeByte(partyMember.additionalMaxFocus);
						bytes.writeByte(partyMember.currentFocus);
						bytes.writeByte(partyMember.additionalBaseInitiative);
						bytes.writeByte(partyMember.additionalMainAttackPower);
					}
				}
			}
			else
			{
				partyMemberCount = 0;
				if(bytes.readBoolean())
				{
					GamePersistantData.setPartySelectionAsCompleted();
					Log.info("Party selection is completed");
				}
				bitfield.value = bytes.readUnsignedByte();
				for(i = 0; i < GameDatabase.heroes.length; i++)
				{
					hero = GameDatabase.heroes[i];
					if(bitfield.getBit(hero.uid))
					{
						partyMember = GamePersistantData.addPartyMember(hero);
						partyMemberCount++;
						Log.info("Party member " + partyMemberCount + " = " + hero.mainName);
						partyMember.addMaxHP(bytes.readUnsignedByte());
						partyMember.damage(partyMember.currentHP);
						partyMember.heal(bytes.readUnsignedByte());
						Log.info("\tHP / Max HP = " + partyMember.currentHP + " / " + partyMember.currentMaxHP);
						partyMember.addMaxFocus(bytes.readUnsignedByte());
						partyMember.useFocus(partyMember.currentFocus);
						partyMember.gainFocus(bytes.readUnsignedByte());
						Log.info("\tFocus / Max Focus = " + partyMember.currentFocus + " / " + partyMember.currentMaxFocus);
						partyMember.addBaseInitiative(bytes.readUnsignedByte());
						Log.info("\tBase init. = " + partyMember.currentBaseInitiative);
						partyMember.addMainAttackPower(bytes.readUnsignedByte());
						Log.info("\tAttack = " + partyMember.currentMinMainAttackPower + "-" + partyMember.currentMaxMainAttackPower);
					}
				}
			}
		}
		
		private static function handleStoryConditions(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			var i:int = 0;
			var bitfieldIdx:int = 0;
			var value:Boolean = false;
			var storyConditionsCount:int = 0;
			var bitfield:Bitfield = new Bitfield();
			if(actionIsSerialization)
			{
				bytes.writeByte(StoryConditionType.MAX_STATIC_CONDITION + 1);
				for(i = 0; i <= StoryConditionType.MAX_STATIC_CONDITION; i++)
				{
					bitfieldIdx = i % 8;
					if(i != 0 && bitfieldIdx == 0)
					{
						bytes.writeByte(bitfield.value);
						bitfield.clear();
					}
					bitfield.setBit(bitfieldIdx,GamePersistantData.isStoryConditionMet(i));
				}
				bytes.writeByte(bitfield.value);
			}
			else
			{
				storyConditionsCount = bytes.readUnsignedByte();
				i = 0;
				while(i < storyConditionsCount && i <= StoryConditionType.MAX_STATIC_CONDITION)
				{
					bitfieldIdx = i % 8;
					if(bitfieldIdx == 0)
					{
						bitfield.value = bytes.readUnsignedByte();
					}
					value = bitfield.getBit(bitfieldIdx);
					GamePersistantData.setStoryCondition(i,value);
					if(value)
					{
						Log.info("Story Condition " + i + " = true");
					}
					i++;
				}
			}
		}
		
		private static function handleGold(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			if(actionIsSerialization)
			{
				bytes.writeShort(GamePersistantData.gold);
			}
			else
			{
				GamePersistantData.useGold(GamePersistantData.gold);
				GamePersistantData.addGold(bytes.readShort());
				Log.info("Gold = " + GamePersistantData.gold);
			}
		}
		
		private static function handleShopItems(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			var i:int = 0;
			var bitfieldIdx:int = 0;
			var shopItemsCount:int = 0;
			var bitfield:Bitfield = new Bitfield();
			if(actionIsSerialization)
			{
				bytes.writeByte(GameDatabase.shopItems.length);
				for(i = 0; i < GameDatabase.shopItems.length; i++)
				{
					bitfieldIdx = i % 8;
					if(i != 0 && bitfieldIdx == 0)
					{
						bytes.writeByte(bitfield.value);
						bitfield.clear();
					}
					bitfield.setBit(bitfieldIdx,GamePersistantData.isShopItemBought(GameDatabase.shopItems[i]));
				}
				bytes.writeByte(bitfield.value);
			}
			else
			{
				shopItemsCount = bytes.readUnsignedByte();
				i = 0;
				while(i < shopItemsCount && i < GameDatabase.shopItems.length)
				{
					bitfieldIdx = i % 8;
					if(bitfieldIdx == 0)
					{
						bitfield.value = bytes.readUnsignedByte();
					}
					if(bitfield.getBit(bitfieldIdx))
					{
						GamePersistantData.setShopItemAsBought(GameDatabase.shopItems[i]);
						Log.info("Shop Item " + GameDatabase.shopItems[i].shopName + " = bought");
					}
					i++;
				}
			}
		}
		
		private static function handleCombatEvents(bytes:ByteArray, actionIsSerialization:Boolean) : void
		{
			var i:int = 0;
			var bitfieldIdx:int = 0;
			var combatEventsCount:int = 0;
			var bitfield:Bitfield = new Bitfield();
			if(actionIsSerialization)
			{
				bytes.writeByte(GameDatabase.combatEvents.length);
				for(i = 0; i < GameDatabase.combatEvents.length; i++)
				{
					bitfieldIdx = i % 8;
					if(i != 0 && bitfieldIdx == 0)
					{
						bytes.writeByte(bitfield.value);
						bitfield.clear();
					}
					bitfield.setBit(bitfieldIdx,GamePersistantData.isCombatEventCompleted(GameDatabase.combatEvents[i]));
				}
				bytes.writeByte(bitfield.value);
			}
			else
			{
				combatEventsCount = bytes.readUnsignedByte();
				i = 0;
				while(i < combatEventsCount && i < GameDatabase.combatEvents.length)
				{
					bitfieldIdx = i % 8;
					if(bitfieldIdx == 0)
					{
						bitfield.value = bytes.readUnsignedByte();
					}
					if(bitfield.getBit(bitfieldIdx))
					{
						GamePersistantData.incrementCombatEventCounter(GameDatabase.combatEvents[i]);
						Log.info("Combat event " + GameDatabase.combatEvents[i].name + " = completed");
					}
					i++;
				}
			}
		}
		
		private static function getBytesFromBase64String(data:String) : ByteArray
		{
			var decoder:Base64Decoder = new Base64Decoder();
			decoder.decode(data);
			return decoder.toByteArray();
		}
		
		private static function getBase64StringFromBytes(bytes:ByteArray) : String
		{
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(bytes);
			return encoder.toString();
		}
	}
}
