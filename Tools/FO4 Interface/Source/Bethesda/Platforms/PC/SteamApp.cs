using System;
using System.Diagnostics;

namespace Bethesda.Platforms.PC
{
	[DebuggerStepThrough]
	public static class SteamApp
	{
		public static object ReadValue(int appid, AppValue value)
		{
			if (appid <= 0)
			{
				throw new ArgumentOutOfRangeException("appid");
			}

			try
			{
				const string RegistryAppPath = "SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall";
				string name = string.Concat(RegistryAppPath, "\\Steam App ", appid);
				using (var key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(name))
				{
					if (key != null)
					{
						return key.GetValue(value.ToRegistryKey());
					}
				}
			}
			catch (Exception)
			{
				throw;
			}

			return null;
		}

		/// <summary>
		/// Extension method converts and AppValue to its string registry key.
		/// </summary>
		/// <param name="value">The AppValue enum value to convert.</param>
		/// <returns>The steam registry key for the given value.</returns>
		public static string ToRegistryKey(this AppValue value)
		{
			switch (value)
			{
				case AppValue.DisplayIcon:
					return "DisplayIcon";
				case AppValue.DisplayName:
					return "DisplayName";
				case AppValue.HelpLink:
					return "HelpLink";
				case AppValue.InstallLocation:
					return "InstallLocation";
				case AppValue.Publisher:
					return "Publisher";
				case AppValue.UninstallString:
					return "UninstallString";
				case AppValue.UrlInfoAbout:
					return "UrlInfoAbout";
			}
			return string.Empty;
		}
	}


	public enum AppValue
	{
		DisplayIcon,
		DisplayName,
		HelpLink,
		InstallLocation,
		Publisher,
		UninstallString,
		UrlInfoAbout,
	}

}
