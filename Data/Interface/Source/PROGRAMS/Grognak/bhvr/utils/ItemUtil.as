package bhvr.utils
{
	import bhvr.data.database.BaseItem;
	import bhvr.data.database.Item;
	import bhvr.data.database.StoryItem;
	import mx.utils.StringUtil;
	import bhvr.data.LocalizationStrings;
	import bhvr.data.GamePersistantData;
	import bhvr.module.combat.HeroStats;
	
	public class ItemUtil
	{
		 
		
		public function ItemUtil()
		{
			super();
		}
		
		public static function getItemDescription(baseItem:BaseItem) : String
		{
			return getItemDescriptionUsingName(baseItem,baseItem.name);
		}
		
		public static function getItemReceivedDescriptionPart(baseItem:BaseItem) : String
		{
			return getItemDescriptionUsingName(baseItem,baseItem.receiveName);
		}
		
		private static function getItemDescriptionUsingName(baseItem:BaseItem, name:String) : String
		{
			var boostStrs:Vector.<String> = null;
			var item:Item = null;
			if(baseItem is StoryItem)
			{
				return name;
			}
			item = baseItem as Item;
			boostStrs = new Vector.<String>();
			if(item.hpBoost > 0)
			{
				boostStrs.push(StringUtil.substitute(LocalizationStrings.ITEM_BOOST_DESCRIPTION,LocalizationStrings.HP_BOOST_NAME,item.hpBoost));
			}
			if(item.maxHpBoost > 0)
			{
				boostStrs.push(StringUtil.substitute(LocalizationStrings.ITEM_BOOST_DESCRIPTION,LocalizationStrings.MAX_HP_BOOST_NAME,item.maxHpBoost));
			}
			if(item.focusBoost > 0)
			{
				boostStrs.push(StringUtil.substitute(LocalizationStrings.ITEM_BOOST_DESCRIPTION,LocalizationStrings.FOCUS_BOOST_NAME,item.focusBoost));
			}
			if(item.maxFocusBoost > 0)
			{
				boostStrs.push(StringUtil.substitute(LocalizationStrings.ITEM_BOOST_DESCRIPTION,LocalizationStrings.MAX_FOCUS_BOOST_NAME,item.maxFocusBoost));
			}
			if(item.baseInitiativeBoost > 0)
			{
				boostStrs.push(StringUtil.substitute(LocalizationStrings.ITEM_BOOST_DESCRIPTION,LocalizationStrings.INITIATIVE_BOOST_NAME,item.baseInitiativeBoost));
			}
			if(item.attackPowerBoost > 0)
			{
				boostStrs.push(StringUtil.substitute(LocalizationStrings.ITEM_BOOST_DESCRIPTION,LocalizationStrings.ATTACK_POWER_BOOST_NAME,item.attackPowerBoost));
			}
			if(boostStrs.length == 0)
			{
				return name;
			}
			if(boostStrs.length == 1)
			{
				return StringUtil.substitute(!!item.boostsApplyToWholeParty?LocalizationStrings.ITEM_DESCRIPTION_WITH_SINGLE_BOOST_WHOLE_PARTY:LocalizationStrings.ITEM_DESCRIPTION_WITH_SINGLE_BOOST,name,boostStrs[0]);
			}
			return StringUtil.substitute(!!item.boostsApplyToWholeParty?LocalizationStrings.ITEM_DESCRIPTION_WITH_MULTIPLE_BOOSTS_WHOLE_PARTY:LocalizationStrings.ITEM_DESCRIPTION_WITH_MULTIPLE_BOOSTS,boostStrs.join(", "),boostStrs.pop());
		}
		
		public static function substituteTextWithItemInfo(text:String, baseItem:BaseItem) : String
		{
			var item:Item = null;
			var result:String = text;
			if(baseItem is Item)
			{
				item = baseItem as Item;
				result = result.replace("{hpBoost}",item.hpBoost);
				result = result.replace("{focusBoost}",item.focusBoost);
				result = result.replace("{maxHpBoost}",item.maxHpBoost);
				result = result.replace("{maxFocusBoost}",item.maxFocusBoost);
				result = result.replace("{baseInitiativeBoost}",item.baseInitiativeBoost);
				result = result.replace("{attackPowerBoost}",item.attackPowerBoost);
			}
			return result;
		}
		
		public static function assignItemToAll(item:Item) : void
		{
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			for(var i:int = 0; i < partyMembers.length; i++)
			{
				assignItemToHero(partyMembers[i],item);
			}
		}
		
		public static function assignItemToHero(hero:HeroStats, item:Item) : void
		{
			hero.addMaxHP(item.maxHpBoost);
			hero.heal(item.hpBoost);
			hero.addMaxFocus(item.maxFocusBoost);
			hero.gainFocus(item.focusBoost);
			hero.addBaseInitiative(item.baseInitiativeBoost);
			hero.addMainAttackPower(item.attackPowerBoost);
		}
		
		public static function doesItemNeedAssignment(baseItem:BaseItem) : Boolean
		{
			var item:Item = Boolean(baseItem)?baseItem as Item:null;
			return item && !item.boostsApplyToWholeParty && item.hasBoost;
		}
	}
}
