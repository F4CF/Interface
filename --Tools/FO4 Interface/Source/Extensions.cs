using System;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;

namespace FO4_Interface
{
	[DebuggerStepThrough]
	public static class Extensions
	{

		public static string WrapQuotes(this string text)
		{
			return string.Format("{0}{1}{0}", "\"", text);
		}

		public static int ToInt(this ConsoleKeyInfo consoleKeyInfo)
		{
			if (char.IsDigit(consoleKeyInfo.KeyChar))
			{
				string consoleKey = consoleKeyInfo.KeyChar.ToString();
				int digit = int.Parse(consoleKey);
				return digit;
			}
			else
			{
				return -1;
			}
		}

	}


	[DebuggerStepThrough]
	public static class ReflectionExtensions
	{

		public static bool IsPublic(this PropertyInfo property)
		{
			bool isPublic = property.GetSetMethod() != null;
			return isPublic;
		}


		public static bool IsCollectionType(this Type type)
		{
			if (type == typeof(string))
			
				return false;
			else
				return (type.GetInterface("ICollection") != null);
		}


		public static string GetDescription(this Type type)
		{
			var attributes = type.GetCustomAttributes(typeof(DescriptionAttribute), true);

			if (attributes != null && attributes.Length > 0)
			{
				var attribute = (DescriptionAttribute)attributes.First();
				return attribute.Description;
			}
			else
			{
				return string.Empty;
			}			
		}


		public static string GetDescription(this PropertyInfo type)
		{
			var attributes = type.GetCustomAttributes(typeof(DescriptionAttribute), true);

			if (attributes != null && attributes.Length > 0)
			{
				var attribute = (DescriptionAttribute)attributes.First();
				return attribute.Description;
			}
			else
			{
				return string.Empty;
			}
		}

	}


	[DebuggerStepThrough]
	public static class DirectoryExtensions
	{
		public static bool IsDirectoryEmpty(string path)
		{
			if (Directory.Exists(path))
			{
				return !Directory.EnumerateFileSystemEntries(path).Any();
			}
			else
			{
				return true;
			}			
		}


		public static void Copy(this DirectoryInfo fromDirectory, string toDirectory, bool recursive = false)
		{
			if (fromDirectory.Exists == false)
			{
				string error = string.Format("Source directory does not exist or could not be found: {0}", fromDirectory.FullName);
				Program.WriteLine(error, Format.Error);
			}


			Directory.CreateDirectory(toDirectory);
			FileInfo[] files = fromDirectory.GetFiles();
			foreach (FileInfo file in files)
			{
				string filepath = Path.Combine(toDirectory, file.Name);
				file.CopyTo(filepath, true);
				Program.WriteLine(string.Format("Copied {0} to {1}", file, filepath));
			}

			if (recursive)
			{
				DirectoryInfo[] subdirectories = fromDirectory.GetDirectories();
				foreach (DirectoryInfo subdirectory in subdirectories)
				{
					string path = Path.Combine(toDirectory, subdirectory.Name);
					subdirectory.Copy(path, recursive);
				}
			}
		}
	}


}
