using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text;
using FO4_Interface.Context;

namespace FO4_Interface
{
	[DebuggerStepThrough]
	public static class Program
	{
		public static string BaseDirectory { get { return AppDomain.CurrentDomain.BaseDirectory; } }
		public static string SettingsPath { get { return Path.Combine(BaseDirectory, "Settings.xml"); } }

		private static ConsoleColor StrongColor = ConsoleColor.White;
		private static ConsoleColor NotifyColor = ConsoleColor.DarkCyan;
		private static ConsoleColor ErrorColor = ConsoleColor.Red;
		private static ConsoleColor UserPromptColor = ConsoleColor.Yellow;
		private static ConsoleColor UserInputColor = ConsoleColor.DarkYellow;
		public const string ConsoleDivision = "==================================================";


		private static void Main()
		{
			ProgramContext context = ProgramContext.Load(SettingsPath);
			if (context != null)
			{
				context.Welcome(clear: false);
			}
			else
			{
				context = ProgramContext.New();
				if (context != null)
				{
					ProgramContext.Save(context, SettingsPath);
					context.Welcome(clear: false);
				}
			}
			Console.ReadKey();
		}


		/// <summary>
		/// Writes formated text to the console.
		/// </summary>
		/// <param name="value">The object to display as text.</param>
		/// <param name="format">The type of formating to use, default is normal.</param>
		public static void WriteLine(object value = null, Format format = Format.Normal)
		{
			if (format == Format.Strong)
			{
				Console.ForegroundColor = StrongColor;
			}
			else if (format == Format.Notify)
			{
				Console.ForegroundColor = NotifyColor;
			}
			else if (format == Format.Error)
			{
				Console.ForegroundColor = ErrorColor;
			}
			else if (format == Format.UserPrompt)
			{
				Console.ForegroundColor = UserPromptColor;
			}
			else if (format == Format.UserInput)
			{
				Console.ForegroundColor = UserInputColor;
			}
			Console.WriteLine(value);
			Console.ResetColor();
		}


		/// <summary>
		/// Writes the description attribute text of an object and its properties as formated text to the console.
		/// </summary>
		/// <param name="instance">The object to display as text.</param>
		/// <param name="verbose">If true, will display the objects properties.</param>
		public static string GetDescription(this object instance, bool verbose)
		{
			StringBuilder result = new StringBuilder();
			var type = instance.GetType();
			var name = instance.ToString();
			var description = type.GetDescription();

			result.AppendFormat("{0}: {1}", name, description);
			
			if (verbose)
			{
				var properties = type.GetProperties();
				foreach (var property in properties)
				{
					if (property.IsPublic())
					{
						result.AppendLine();
						WriteProperty(result, instance, property);
					}
				}
			}

			return result.ToString();
		}



		private static void WriteProperty(StringBuilder result, object instance, PropertyInfo property)
		{
			var name = property.Name;
			var description = property.GetDescription();
			var value = property.GetValue(instance, null);
			var valueType = value.GetType();

			if (valueType.IsCollectionType())
			{
				StringBuilder valueResult = new StringBuilder();
				var collection = value as ICollection;
				foreach (var element in collection)
				{
					valueResult.AppendFormat("\n\t\t{0}", element.ToString(), "", "");
				}
				valueResult.AppendLine();
				value = valueResult.ToString();
			}

			result.AppendFormat("\n\t{0} : {1}\n\t\t-{2}", name, description, value);
		}

		/// <summary>
		/// Prompts the user to press any key.
		/// </summary>
		/// <param name="message">Display a message on the console.</param>
		public static void PromptAnyKey(string message = null)
		{
			WriteLine(string.Format("\n{0}\nPress any key to continue.", message), Format.UserPrompt);
			Console.ReadKey();
			WriteLine(Environment.NewLine);
		}


		/// <summary>
		/// Prompts the user to press a specific key.
		/// </summary>
		/// <param name="message">Display a message on the console.</param>
		/// <returns>The key info for the user selected console key.</returns>
		public static ConsoleKeyInfo PromptKey(string message)
		{
			WriteLine(string.Format("\n{0} Press the required key.", message), Format.UserPrompt);
			Console.ForegroundColor = UserInputColor;
			var key = Console.ReadKey();
			WriteLine(Environment.NewLine);
			Console.ResetColor();
			return key;
		}


		/// <summary>
		/// Prompts the user to press Y for yes or N for no.
		/// </summary>
		/// <param name="message">>Display a message on the console.</param>
		/// <returns>True if the user selected Y for yes.</returns>
		public static bool PromptYesNo(string message)
		{
			WriteLine(string.Format("\n{0}\nSelect yes or no? (y/n)", message), Format.UserPrompt);

			Console.ForegroundColor = UserInputColor;
			var key = Console.ReadKey();
			WriteLine(Environment.NewLine);
			Console.ResetColor();

			if (key.Key == ConsoleKey.Y)
			{
				return true;
			}
			else if (key.Key == ConsoleKey.N)
			{
				return false;
			}
			else
			{
				WriteLine("\nPlease enter 'y' for yes or 'n' for no.", Format.Error);
				return PromptYesNo(message);
			}
		}
	}


	public enum Format
	{
		Normal,
		Strong,
		Notify,
		Error,
		UserPrompt,
		UserInput
	}
}
