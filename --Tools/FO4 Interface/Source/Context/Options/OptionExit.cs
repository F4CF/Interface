using System;
using System.ComponentModel;

namespace FO4_Interface.Context.Options
{
	[Description("Exits the program.")]
	public class OptionExit : Option
	{
		public OptionExit()
		{
			Name = "Exit";
		}


		public override bool Run(ProgramContext context)
		{
			Environment.Exit(0);
			return true;
		}


	}
}
