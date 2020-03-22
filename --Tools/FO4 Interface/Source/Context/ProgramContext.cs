using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Xml.Serialization;
using Bethesda.Platforms;
using FO4_Interface.Context.Options;

namespace FO4_Interface.Context
{
	[Description("This application will assist with generating source files for the Fallout 4 user interface.")]
	public class ProgramContext
	{
		[XmlElement]
		[Description("The fallout 4 installation directory that contains the file 'Fallout4.exe'.")]
		public string GameDirectory { get; set; }


		[XmlArrayItem(Type = typeof(OptionExit))]
		[XmlArrayItem(Type = typeof(OptionWelcome))]
		[XmlArrayItem(Type = typeof(OptionStage))]
		[XmlArrayItem(Type = typeof(OptionExtract))]
		[XmlArrayItem(Type = typeof(OptionDecompile))]
		[Description("A collection of application options for the program to run.")]
		public List<Option> Options { get; set; }


		public ProgramContext()
		{
			GameDirectory = Fallout4.GetInstallLocation();
			Options = new List<Option>();
		}



		public void Welcome(bool clear = true)
		{
			if (clear) 
				Console.Clear();
			
			Program.WriteLine("WELCOME", Format.Strong);
			Program.WriteLine("To make configuration changes, open and edit the settings file. Then restart the application.");
			Program.WriteLine(Program.SettingsPath);
			Program.WriteLine(Program.ConsoleDivision);
			Program.WriteLine(this.GetDescription(true));
			Program.WriteLine(Program.ConsoleDivision);

			PromptForOption();
		}



		private void PromptForOption()
		{
			Program.WriteLine();
			Program.WriteLine("OPTIONS", Format.Strong);

			Program.WriteLine(Program.ConsoleDivision);
			Options.ForEach(option => ShowOption(option));
			Program.WriteLine(Program.ConsoleDivision);

			var keyInfo = Program.PromptKey("Select an option ID for the application to complete.");
			int optionIndex = keyInfo.ToInt();
			SelectOption(optionIndex, keyInfo);
			
			PromptForOption();
		}




		private void ShowOption(Option option)
		{
			int index = Options.IndexOf(option);
			string description = option.GetDescription(verbose: false);
			string result = string.Format("ID {0} | {1}", index, description);
			Program.WriteLine(result);
		}




		private void SelectOption(int optionIndex, ConsoleKeyInfo keyInfo)
		{
			if (optionIndex < 0 || optionIndex >= Options.Count)
			{
				Program.WriteLine(string.Format("The console key '{0}' is not an option.", keyInfo.KeyChar), Format.Error);
				return;
			}
			else
			{
				Option option = Options[optionIndex];

				if (option != null)
				{
					Program.WriteLine("Selected the " + option.Name + " option.", Format.Strong);
					Program.WriteLine(option.GetDescription(verbose: true));

					if (Program.PromptYesNo("Continue with the '" + option.Name + "' option?"))
					{
						bool completed = option.Run(this);
						if (completed)
						{
							
							Program.WriteLine("The " + option.Name + " option has completed.", Format.Notify);
						}
						else
						{
							Program.WriteLine("The " + option.Name + " option ended unexpectedly.", Format.Error);
						}
					}
					else
					{
						Program.WriteLine("The " + option.Name + " option was aborted.", Format.Notify);
					}
				}
				else
				{
					Program.WriteLine("Could not find an option at index " + optionIndex, Format.Notify);
				}
			}
		}





		/// <summary>
		/// Creates a new ProgramContext for the Program.
		/// </summary>
		/// <returns>A new context with default values initialized.</returns>
		public static ProgramContext New()
		{
			var context = new ProgramContext();
			string outputDefault = Path.Combine(context.GameDirectory, "Output");

			context.Options.Add(new OptionExit());
			context.Options.Add(new OptionWelcome());

			var extract = new OptionExtract()
			{
				ExecutablePath = Path.Combine(context.GameDirectory, @"Tools\Archive2\Archive2.exe"),
				OutputDirectory = Path.Combine(outputDefault, "Extracted"),
				TargetFiles = new List<string>() 
				{
					Path.Combine(context.GameDirectory, @"Data\Fallout4 - Interface.ba2"),
					Path.Combine(context.GameDirectory, @"Data\DLCNukaWorld - Main.ba2"),
					Path.Combine(context.GameDirectory, @"Data\DLCCoast - Main.ba2"),
					Path.Combine(context.GameDirectory, @"Data\DLCRobot - Main.ba2")
				}
			};
			context.Options.Add(extract);


			var decompile = new OptionDecompile()
			{
				SkipPrompt = false,
				ExecutablePath = Path.Combine(context.GameDirectory, @"Tools\FFDec\ffdec.bat"),
				OutputDirectory = Path.Combine(outputDefault, "Decompiled"),
				TargetDirectory = extract.OutputDirectory
			};
			context.Options.Add(decompile);


			var stage = new OptionStage()
			{
				Destination = Path.Combine(outputDefault, "Repository"),
				Locations = new List<string>() 
				{
					@"Tools\FO4 Interface\Source",
					@"Mods\FO4 Interface",
					@"Data\Interface\Source",
					@"Data\Interface\fonts_en.swf",
					@"Data\Interface\fonts_console.swf",
					@"Data\Programs\fonts_programs.swf"
				}
			};
			context.Options.Add(stage);

			Directory.CreateDirectory(extract.OutputDirectory);
			Directory.CreateDirectory(decompile.OutputDirectory);
			Directory.CreateDirectory(stage.Destination);


			Program.WriteLine(string.Format("The application created a new context for '{0}'.", context), Format.Notify);
			return context;
		}


		/// <summary>
		/// Loads a ProgramContext from disk.
		/// </summary>
		/// <param name="filepath">The file path to a ProgramContext xml file.</param>
		/// <returns>The loaded ProgramContext else null.</returns>
		public static ProgramContext Load(string filepath)
		{
			if (File.Exists(filepath))
			{
				var serializer = new XmlSerializer(typeof(ProgramContext));
				using (FileStream fileStream = new FileStream(filepath, FileMode.Open))
				{
					var context = (ProgramContext)serializer.Deserialize(fileStream);
					if (context != null)
					{
						Program.WriteLine(string.Format("Loaded '{0}' from '{1}' successfully.", context, filepath), Format.Notify);
					}
					else
					{
						Program.WriteLine(string.Format("Could not save application settings for '{0}'.", context), Format.Error);
					}

					return context;
				}
			}
			else
			{
				Program.WriteLine(string.Format("Cannot load the settings file '{0}' because it does not exist.", filepath), Format.Error);
				return null;
			}
		}


		/// <summary>
		/// Saves a ProgramContext to disk as xml.
		/// </summary>
		/// <param name="context">The context to save.</param>
		/// <param name="filepath">The path, name, and extension to save the context.</param>
		/// <returns>True if the save was successful.</returns>
		public static bool Save(ProgramContext context, string filepath)
		{
			string fileDirectory = Path.GetDirectoryName(filepath);

			if (context == null)
			{
				Program.WriteLine(string.Format("Cannot save null xml file."), Format.Error);
				return false;
			}
			else if (!Directory.Exists(fileDirectory))
			{
				Program.WriteLine(string.Format("Cannot save xml file {0} to {1}. The directory does not exist.", context, fileDirectory), Format.Error);
				return false;
			}
			else if (File.Exists(filepath))
			{
				Program.WriteLine(string.Format("Cannot create xml file. {0} because it already exists.", filepath), Format.Error);
				return false;
			}
			else
			{
				try
				{
					var serializer = new XmlSerializer(typeof(ProgramContext));
					using (TextWriter writer = new StreamWriter(filepath))
					{
						serializer.Serialize(writer, context);
						Program.WriteLine(string.Format("Saved a settings file to '{0}' for '{1}'.", filepath, context), Format.Notify);
						return true;
					}

				}
				catch (Exception exception)
				{
					if (File.Exists(filepath))
					{
						Program.WriteLine(string.Format("Deleting the temporary xml file {0}", filepath), Format.Notify);
						File.Delete(filepath);
					}

					Program.WriteLine(exception.ToString(), Format.Error);
					return false;
				}
			}
		}


		public override string ToString()
		{
			return "Program Context";
		}



	}
}
