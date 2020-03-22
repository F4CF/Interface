using System.Diagnostics;
using System.IO;
using System.Text;

namespace FO4_Interface
{
	public class Logger
	{
		StringBuilder Builder = new StringBuilder();

		public string Output { get { return Builder.ToString(); } }


		public Logger()
		{
			Builder = new StringBuilder();
		}


		[DebuggerStepThrough]
		public void AppendLine(string value)
		{
			if (!string.IsNullOrEmpty(value))
			{
				Builder.AppendLine(value);
				Program.WriteLine(value);
			}
		}


		public void Clear()
		{
			Builder.Clear();
		}


		public void Save(string file)
		{
			Directory.CreateDirectory(Path.GetDirectoryName(file));
			File.WriteAllText(file, Output);
		}


	}
}
