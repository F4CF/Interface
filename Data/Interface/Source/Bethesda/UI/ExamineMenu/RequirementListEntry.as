package
{
	import Shared.AS3.BSScrollingListFadeEntry;
	
	public class RequirementListEntry extends BSScrollingListFadeEntry
	{
		 
		
		public function RequirementListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			if(param1.isPerk == true)
			{
				param1.text = param1.name;
			}
			else
			{
				param1.text = param1.name + " " + param1.accountedFor + "/" + param1.requiredCount;
			}
			super.SetEntryText(param1,param2);
			this.textField.alpha = param1.accountedFor < param1.requiredCount || param1.hasPerk == false?Number(0.5):Number(1);
		}
	}
}
