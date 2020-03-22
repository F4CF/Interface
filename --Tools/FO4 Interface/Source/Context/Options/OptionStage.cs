using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Xml.Serialization;

namespace FO4_Interface.Context.Options
{
	[Description("Stages files for backup or version control by copying them to another location.")]
	public class OptionStage : Option
	{
		[XmlElement]
		[Description("If 'true', will copy all files and folders without prompting.")]
		public bool SkipPrompt { get; set; }

		[Description("The location to copy project related files and folders to. Intended for staging files with version control or local file backup.")]
		public string Destination { get; set; }


		[Description("These are files or folders that are relative to the Fallout 4 installation directory.")]
		[XmlArray("FilesAndFolders")]
		[XmlArrayItem("Location")]
		public List<string> Locations { get; set; }



		public OptionStage()
		{
			Name = "Stage Files";
			SkipPrompt = false;
			Destination = string.Empty;
			Locations = new List<string>();
		}



		public override bool Run(ProgramContext context)
		{
			if (!Directory.Exists(Destination))
			{
				if (Program.PromptYesNo(string.Format("The destination {0} does not exist.\nWould you like to create it now?", Destination)))
				{
					Directory.CreateDirectory(Destination);
				}
				else
				{
					Program.WriteLine(string.Format("The destination directory '{0}' must exist to continue.", Destination), Format.Error);
					return false;
				}
			}

			foreach (var location in Locations)
			{
				if (SkipPrompt || Program.PromptYesNo(string.Format("Copy the location '{0}' for staging?", location)))
				{
					if (Path.IsPathRooted(location))
					{
						Program.WriteLine(string.Format("Cannot resolve rooted path '{0}' to '{1}'.", location, Destination), Format.Error);
					}
					else
					{
						string currentLocation = Path.Combine(context.GameDirectory, location);
						string destinationLocation = Path.Combine(Destination, location);

						stage(currentLocation, destinationLocation);
					}
				}
				else
				{
					Program.WriteLine(string.Format("Skipping the location '{0}' for staging.", location), Format.Notify);
				}
			}
			
			return true;
		}



		private void stage(string gameLocation, string destinationLocation)
		{
			if (File.Exists(gameLocation))
			{
				Directory.CreateDirectory(Path.GetDirectoryName(destinationLocation));
				File.Copy(gameLocation, destinationLocation, true);
				Program.WriteLine(string.Format("Copied a file from '{0}' to '{1}'.", gameLocation, destinationLocation));
			}
			else if (Directory.Exists(gameLocation))
			{
				new DirectoryInfo(gameLocation).Copy(destinationLocation, true);
				Program.WriteLine(string.Format("Copied a directory from '{0}' to '{1}'.", gameLocation, destinationLocation));
			}
			else
			{
				Program.WriteLine(string.Format("The location '{0}' does not exist.", gameLocation), Format.Error);
			}
		}


	}
}
