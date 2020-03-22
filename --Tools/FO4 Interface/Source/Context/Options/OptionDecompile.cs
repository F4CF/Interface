using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Xml.Serialization;

namespace FO4_Interface.Context.Options
{
	[Description("Decompiles all swf files in the specified directory.")]
	public class OptionDecompile : Option
	{
		[XmlElement]
		[Description("If 'true', will decompile all swf files without prompting.")]
		public bool SkipPrompt { get; set; }

		[XmlElement]
		[Description("The file path to ffdec.bat which can be downloaded from 'https://github.com/jindrapetrik/jpexs-decompiler/releases'.")]
		public string ExecutablePath { get; set; }


		[XmlElement]
		[Description("The directory containing swf files for decompilation..")]
		public string TargetDirectory { get; set; }


		[XmlElement]
		[Description("The directory to create output results.")]
		public string OutputDirectory { get; set; }

		Logger Log;


		public OptionDecompile()
		{
			Name = "Decompilation";
			SkipPrompt = false;
			ExecutablePath = string.Empty;
			OutputDirectory = string.Empty;
			TargetDirectory = string.Empty;
			Log = new Logger();
		}




		public override bool Run(ProgramContext context)
		{
			if (!File.Exists(ExecutablePath))
			{
				Program.WriteLine(string.Format("The file does not exist.\nMissing:'{0}'\n", ExecutablePath), Format.Error);
				return false;
			}
			else if (!Directory.Exists(TargetDirectory))
			{
				Program.WriteLine(string.Format("The directory does not exist.\nMissing:'{0}'\n", TargetDirectory), Format.Error);
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

			IEnumerable<string> targets = GetTargetFiles();
			if (targets != null && targets.Count() > 0)
			{
				Process.Start(OutputDirectory);
				foreach (string targetFile in targets)
				{
					if (SkipPrompt || Program.PromptYesNo(string.Format("Decompile '{0}'?", targetFile)))
					{
						string name = Path.GetFileNameWithoutExtension(targetFile).Trim();
						string subpath = Path.GetDirectoryName(targetFile.Replace(TargetDirectory, string.Empty)).Trim('\\');
						string outputLocation = Path.Combine(OutputDirectory, subpath, name);
						string outputFile = Path.Combine(outputLocation, name + ".fla");
						string logFile = Path.Combine(outputLocation, name + ".txt");

						ProcessStartInfo start = new ProcessStartInfo
						{
							FileName = ExecutablePath,
							Arguments = GetArguments(outputLocation, targetFile),
							WorkingDirectory = Path.GetDirectoryName(targetFile),
							CreateNoWindow = true,
							UseShellExecute = false,
							RedirectStandardOutput = true,
							RedirectStandardError = true,
						};


						Log.AppendLine(string.Format("FileName:'{0}'\nArguments:'{1}'\nWorking:'{2}'\n{3}",
								start.FileName,
								start.Arguments,
								start.WorkingDirectory,
								Program.ConsoleDivision));

							
						using (Process ffdec = Process.Start(start))
						{
							ffdec.OutputDataReceived += new DataReceivedEventHandler(OutputDataHandler);
							ffdec.ErrorDataReceived += new DataReceivedEventHandler(OutputDataHandler);
							ffdec.BeginOutputReadLine();
							ffdec.BeginErrorReadLine();
							ffdec.WaitForExit();

							if (File.Exists(outputFile))
							{
								TreeDirectory(outputLocation);
								Log.Save(logFile);
							}
						}
						Log.Clear();
					}
					else
					{
						Program.WriteLine(string.Format("Skipping the file '{0}' for decompile.", targetFile), Format.Notify);
					}
				}
			}
			else
			{
				Program.WriteLine(string.Format("Could not find any flash files to decompile in the '{0}' directory.", TargetDirectory), Format.Error);
			}
			return true;
		}



		private void TreeDirectory(string outputLocation)
		{
			if (Directory.Exists(outputLocation))
			{
				ProcessStartInfo startCommandTree = new ProcessStartInfo
				{
					FileName = "cmd",
					Arguments = "/c tree /a /f",
					WorkingDirectory = outputLocation,
					CreateNoWindow = true,
					UseShellExecute = false,
					RedirectStandardOutput = true,
					RedirectStandardError = true
				};
				try
				{
					using (Process tree = Process.Start(startCommandTree))
					{
						tree.OutputDataReceived += new DataReceivedEventHandler(OutputDataHandler);
						tree.ErrorDataReceived += new DataReceivedEventHandler(OutputDataHandler);
						tree.BeginOutputReadLine();
						tree.BeginErrorReadLine();
						tree.WaitForExit();
					}
				}
				catch (Exception exception)
				{
					Console.WriteLine("The process failed: {0}", exception);
				}
			}
		}



		private void OutputDataHandler(object sendingProcess, DataReceivedEventArgs e)
		{
			Log.AppendLine(e.Data);
		}



		[DebuggerStepThrough]
		private string GetArguments(string outputLocation, string targetFile)
		{
			string targetName = Path.GetFileName(targetFile);
			return string.Format("-export fla {0} {1}", outputLocation.WrapQuotes(), targetName.WrapQuotes());
		}


		[DebuggerStepThrough]
		private IEnumerable<string> GetTargetFiles()
		{
			return Directory.EnumerateFiles(TargetDirectory, "*.*", SearchOption.AllDirectories)
					.Where(IsFlashFile);
		}


		[DebuggerStepThrough]
		private bool IsFlashFile(string file)
		{
			string extension = Path.GetExtension(file);
			return new List<string> { ".swf", ".gfx" }.Contains(extension);
		}


	}
}
