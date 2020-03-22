using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Xml.Serialization;

namespace FO4_Interface.Context.Options
{
	[Description("This extracts the specified archive files.")]
	public class OptionExtract : Option
	{
		[XmlElement]
		[Description("If 'true', will extract all swf files without prompting.")]
		public bool SkipPrompt { get; set; }

		[XmlElement]
		[Description("The file path to Archive2.exe which is included with the CreationKit tools.")]
		public string ExecutablePath { get; set; }

		[XmlElement]
		[Description("The directory to create output results.")]
		public string OutputDirectory { get; set; }

		[Description("A collection paths pointing to 'ba2' archive files to be extracted.")]
		[XmlArray("Files")]
		[XmlArrayItem("Location")]
		public List<string> TargetFiles { get; set; }

		Logger Log;


		public OptionExtract()
		{
			Name = "Extraction";
			SkipPrompt = false;
			ExecutablePath = string.Empty;
			OutputDirectory = string.Empty;
			TargetFiles = new List<string>();
			Log = new Logger();
		}



		public override bool Run(ProgramContext context)
		{
			if (!File.Exists(ExecutablePath))
			{
				Program.WriteLine(string.Format("Cannot find the executable file '{0}'.", ExecutablePath), Format.Error);
				return false;
			}
			else if (!Directory.Exists(OutputDirectory))
			{
				if (Program.PromptYesNo(string.Format("The output {0} does not exist.\nWould you like to create it now?", OutputDirectory)))
				{
					Directory.CreateDirectory(OutputDirectory);
				}
				else
				{
					Program.WriteLine(string.Format("The output directory '{0}' must exist to continue.", OutputDirectory), Format.Error);
					return false;
				}
			}

			Process.Start(OutputDirectory);

			foreach (var targetFile in TargetFiles)
			{
				if (SkipPrompt || Program.PromptYesNo(string.Format("Extract '{0}'?", targetFile)))
				{
					if (File.Exists(targetFile))
					{
						string name = Path.GetFileNameWithoutExtension(targetFile);
						string targetDirectory = Path.Combine(OutputDirectory, name);
						string logFile = Path.Combine(targetDirectory, name + ".txt");

						ProcessStartInfo start = new ProcessStartInfo
						{
							FileName = ExecutablePath,
							Arguments = GetArguments(targetFile, targetDirectory),
							CreateNoWindow = true,
							UseShellExecute = false,
							RedirectStandardOutput = true,
							RedirectStandardError = true,
						};
						try
						{
							using (Process archive2 = Process.Start(start))
							{
								archive2.OutputDataReceived += new DataReceivedEventHandler(OutputDataHandler);
								archive2.ErrorDataReceived += new DataReceivedEventHandler(OutputDataHandler);
								archive2.BeginOutputReadLine();
								archive2.BeginErrorReadLine();
								Console.WriteLine(Log.Output);
								archive2.WaitForExit();
							}
							Log.Save(logFile);
						}
						catch (Exception exception)
						{
							Console.WriteLine("The process failed: {0}", exception);
						}
					}
					else
					{
						Program.WriteLine(string.Format("Cannot find the file '{0}'.", targetFile), Format.Error);
					}
				}
				else
				{
					Program.WriteLine(string.Format("Skipping the file '{0}' for extract.", targetFile), Format.Notify);
				}
				
				Log.Clear();
			}

			return true;
		}



		private void OutputDataHandler(object sendingProcess, DataReceivedEventArgs e)
		{
			Log.AppendLine(e.Data);
		}


		[DebuggerStepThrough]
		private string GetArguments(string targetFile, string outputDirectory)
		{
			return string.Concat(targetFile.WrapQuotes(), " -extract=" + outputDirectory.WrapQuotes());
		}


	}
}
