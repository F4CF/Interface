using System.Xml.Serialization;

namespace FO4_Interface.Context
{
	public abstract class Option
	{
		[XmlIgnore]
		public string Name { get; protected set; }

		public abstract bool Run(ProgramContext context);


		public override string ToString()
		{
			if (string.IsNullOrEmpty(Name))
				return base.ToString();
			else
				return Name;
		}


	}
}
