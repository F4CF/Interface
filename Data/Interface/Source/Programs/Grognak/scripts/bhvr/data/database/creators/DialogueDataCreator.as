package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	import flash.utils.Dictionary;
	
	public class DialogueDataCreator extends BaseDialogueDataCreator
	{
		 
		
		public function DialogueDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			with(tree("dialogueKingsmanGuard"))
			{
				
				with(dialogue("Welcome to King\'s Arch, the 46th Outpost of Hidragore! Thanks for taking the path instead of walking through my cucumber patch. You wouldn\'t believe some people... Anyway, do you want to cross Manticore\'s Bridge?"))
				{
					
					with(option("Yes"))
					{
						
						with(dialogue("No problem. The winch is here, so you can just head out and the bridge will be down by the time you get there."))
						{
							
							option("Leave").thatTriggersStoryCondition(StoryConditionType.BRIDGE_LOWERED);
						}
					}
					with(option("No"))
					{
						
						with(dialogue("Well, you\'re welcome to stay, but I need to tend to my tomato plants while the sun is still up."))
						{
							
							option("Leave");
						}
					}
				}
				with(dialogue("The bridge is already down. Unless you want to learn how to grow a perfect parsnip, there\'s nothing more I can do for you.",StoryConditionType.BRIDGE_LOWERED))
				{
					
					option("Leave");
				}
			}
			with(tree("dialogueConjurer"))
			{
				
				with(dialogue("I can help you reach Grelok, man, but I need the Dawnlight Locket and the Tome of the Duskborn to work my mojo. You\'ll find them up North, but Manticore\'s Bridge is up, so maybe check out the Docks?"))
				{
					
					option("Leave").thatTriggersStoryCondition(StoryConditionType.CONJURER_MET);
				}
				with(dialogue("That\'s excellent, man. The Lighthouse is East of here, but you have to hurry. Grelok is just totally throwing off my good vibes.",StoryConditionType.LIGHTHOUSE_KEY))
				{
					
					option("Leave");
				}
				with(dialogue("When I was young I would frolic naked in the sea by the light of that Lighthouse and commune with the Water Nymphs. Those were weird times, man...",StoryConditionType.LIGHTHOUSE_ON))
				{
					
					option("Leave");
				}
				with(dialogue("Still looking for the Tome and Locket? Just close your eyes, man, and let the Universe guide you. It knows what you need better than you do.",StoryConditionType.PASSAGE_SHIP))
				{
					
					option("Leave");
				}
				with(dialogue("You have the Locket! Did you know it was first worn by the Asmadorian Medusa Queen? She knew how to throw a groovy party, man, and it kept her guests from getting stoned. Now all I need is the Tome.",StoryConditionType.DAWNSTAR_LOCKET))
				{
					
					option("Leave");
				}
				with(dialogue("The Tome! That\'s great, man, but don\'t read it. I tried 40 years ago and woke up a week later in some faraway jungle being worshipped by Bat-Babies. Not as cool as it sounds. Now I just need the Locket.",StoryConditionType.TOME_DUSKBORN))
				{
					
					option("Leave");
				}
				with(dialogue("Groovy. With the Tome and Locket I can cast a Spell of Ghostly Calling to reveal the heinous force blocking Foulwind Pass. Then you can truck on through and show Grelok who\'s boss. Are you ready?",StoryConditionType.DAWNSTAR_LOCKET,StoryConditionType.TOME_DUSKBORN))
				{
					
					with(option("Yes").thatTriggersSound(SoundList.SOUND_INTERACTION_CONJURER))
					{
						
						with(dialogue("Here we go... GHISS IF NOJHS, JHISS IF KRUAUK, O CIMMAUNK SHUU SI SHIW WIERSULF SI SHU LOZONJ WIRLK, SI LU AUNCHIRUK SI SHU LOJHS ON SPHOROS AUNK ON FRUSK... Whoa, trippy."))
						{
							
							option("Leave").thatTriggersStoryCondition(StoryConditionType.CONJURER_REVELATION);
						}
					}
					with(option("No"))
					{
						
						with(dialogue("What\'s the hold up, man? The end is nigh and the good times are definitely not rolling..."))
						{
							
							option("Leave");
						}
					}
				}
				with(dialogue("This is some heavy stuff, man. Fate of the world heavy. You head North-East to find Foulwind Pass and I\'ll see about decorating with more attuned crystals. We\'re in this together, man.",StoryConditionType.CONJURER_REVELATION))
				{
					
					option("Leave");
				}
				with(dialogue("Grelok\'s eyes are on us now, man. I can feel him throwing negative vibes our way. You have to stop him once and for all so the healing process of the land can begin, you know?",StoryConditionType.DEFEAT_DREAD_WRAITH))
				{
					
					option("Leave");
				}
			}
			with(tree("dialogueCorsairQueen"))
			{
				
				with(dialogue("Grognak, it\'s very nice to see you again, but the Mad Mermaid isn\'t going anywhere while the Lighthouse is off. Here\'s the key to the front door. Turn that light on, then we\'ll talk business."))
				{
					
					option("Leave").thatTriggersStoryCondition(StoryConditionType.LIGHTHOUSE_KEY);
				}
				with(dialogue("Grognak, it\'s not that I don\'t enjoy your company, but neither your smile nor your glistening muscles will get the Mad Mermaid going. So how about checking on the Lighthouse?",StoryConditionType.LIGHTHOUSE_KEY))
				{
					
					option("Leave");
				}
				with(dialogue("Superb! You may be thick but you can always get the job done. Now, pro bono isn\'t my style, but I\'ll give you a discount. 80 Gold will get you unlimited trips between North and South.",StoryConditionType.LIGHTHOUSE_ON))
				{
					
					option("Pay").withPrice(80).thatTriggersStoryCondition(StoryConditionType.PASSAGE_SHIP).thatTriggersShipTravel();
					option("Leave");
				}
				with(dialogue("Back for another trip? Not a problem, Grognak, as long as you take a bath first. You may be a sight for sore eyes, but my nose has an entirely different opinion.",StoryConditionType.PASSAGE_SHIP))
				{
					
					option("Travel").thatTriggersShipTravel();
					option("Stay");
				}
			}
			with(tree("dialogueZil"))
			{
				
				with(dialogue("Welcome to the Pit. Are you looking to join the next free-for-all? Oh, the Dawnlight Locket? You\'ll need to beat me to get it, and I\'ve never lost. What do you say?"))
				{
					
					option("Fight").thatTriggersCombat("ZilBattle");
					with(option("Decline"))
					{
						
						with(dialogue("Ha! I didn\'t take you for the sort to back down from a challenge, but then again I guess my reputation precedes me. The offer\'s still on the table, so come back if ever you let go of your mother\'s skirt."))
						{
							
							option("Leave");
						}
					}
				}
				with(dialogue("Grognak, I\'ve tried to find you more opponents, but after beating me, no one dares step into the Pit with you!",StoryConditionType.DAWNSTAR_LOCKET))
				{
					
					option("Leave");
				}
			}
			with(tree("dialogueMingyel"))
			{
				
				with(dialogue("The Tome of the Duskborn? An old man once told me a wild-eyed barbarian might someday show up asking about that book. You can have it if you beat me."))
				{
					
					option("Fight").thatTriggersCombat("MingyelBattle");
					with(option("Decline"))
					{
						
						with(dialogue("Then I guess you aren\'t the one. A shame, really. The boys are getting restless and a fight against a brute like you would have been quality entertainment. Come back if you change your mind."))
						{
							
							option("Leave");
						}
					}
				}
				with(dialogue("Grognak, have you ever thought about paid mercenary work? I swear, you and your friends could make a fortune working for me.",StoryConditionType.TOME_DUSKBORN))
				{
					
					option("Leave");
				}
			}
			with(tree("dialogueSouthChapel"))
			{
				
				with(revivalDialogue("Have no fear. You are in a house of Tain Decch. Do any of you require the sound of his healing shout? For such a service, a 15 Gold donation is standard."))
				{
					
					withReshownText("May your ears always ring with his presence. Does anyone else need to be revived?");
					withRevivalPrice(15);
					option("Leave");
				}
				with(dialogue("Welcome. You are in a house of Tain Decch. If you ever require his healing, please return here. In the meantime, feel free to exalt him.",StoryConditionType.DYNAMIC_ALL_PARTY_MEMBERS_ALIVE))
				{
					
					option("Leave");
				}
			}
			with(tree("dialogueNorthChapel"))
			{
				
				with(revivalDialogue("Have no fear. You are in a house of Tain Decch. Do any of you require the sound of his healing shout? For such a service, a 30 Gold donation is standard."))
				{
					
					withReshownText("May your ears always ring with his presence. Does anyone else need to be revived?");
					withRevivalPrice(30);
					option("Leave");
				}
				with(dialogue("Welcome. You are in a house of Tain Decch. If you ever require his healing, please return here. In the meantime, feel free to exalt him.",StoryConditionType.DYNAMIC_ALL_PARTY_MEMBERS_ALIVE))
				{
					
					option("Leave");
				}
			}
			with(tree("dialogueShop1"))
			{
				
				with(inventoryDialogue("A barbarian, eh? Come see, I think I\'ve got just what you need..."))
				{
					
					withReshownText("That will only get you so far, though. What else will you be taking?");
					item("itemBrownBeanPowder").withPrice(20).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("itemCircletOfProtection").withPrice(32).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("itemOrcforgedMaul").withPrice(48).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("focusGem1").withPrice(15).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					option("Leave");
				}
			}
			with(tree("dialogueShop2"))
			{
				
				with(inventoryDialogue("I only have the best here. I\'m a straight shooter and that\'s just the honest truth."))
				{
					
					withReshownText("It\'s simply good business to keep customers informed. So before you go, take a look at these.");
					item("itemCelerityStone").withPrice(36).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("itemBroochOfVitality").withPrice(58).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("itemGaleForcePendant").withPrice(86).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("focusGem2").withPrice(26).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					option("Leave");
				}
			}
			with(tree("dialogueShop3"))
			{
				
				with(inventoryDialogue("Come right in! I\'ve got just the thing for a brave adventurer like yourself!"))
				{
					
					withReshownText("But wait, there\'s more!");
					item("itemEyeOfAlertness").withPrice(65).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("itemDragonscalePlate").withPrice(104).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("itemBalorsFireWhip").withPrice(155).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					item("focusGem3").withPrice(38).thatTriggersSound(SoundList.SOUND_INTERACTION_SHOP_PURCHASE);
					option("Leave");
				}
			}
		}
	}
}
