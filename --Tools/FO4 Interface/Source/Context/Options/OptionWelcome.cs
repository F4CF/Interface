using System.ComponentModel;

namespace FO4_Interface.Context.Options
{
	[Description("Clears the console buffer and displays the welcome message.")]
	public class OptionWelcome : Option
	{
		public OptionWelcome()
		{
			Name = "Welcome";
		}


		public override bool Run(ProgramContext context)
		{
			context.Welcome();
			return true;
		}


	}
}
