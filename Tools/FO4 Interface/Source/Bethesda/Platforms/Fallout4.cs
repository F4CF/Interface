using System;
using System.Diagnostics;
using System.IO;
using Bethesda.Platforms.PC;

namespace Bethesda.Platforms
{
	[DebuggerStepThrough]
	public static class Fallout4
	{
		private const int SteamAppID = 377160;



		#region Windows

		public static string GetDocumentsPath()
		{
			string path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "My Games", "Fallout4");
			return Path.GetFullPath(path);
		}


		public static string GetAppDataPath()
		{
			string path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Fallout4");
			return Path.GetFullPath(path);
		}

		#endregion



		#region Steam

		public static string GetInstallLocation()
		{
			string path = SteamApp.ReadValue(SteamAppID, AppValue.InstallLocation) as string;
			return Path.GetFullPath(path);
		}


		public static string GetDisplayIcon()
		{
			return SteamApp.ReadValue(SteamAppID, AppValue.DisplayIcon) as string;
		}


		public static string GetDisplayName()
		{
			return SteamApp.ReadValue(SteamAppID, AppValue.DisplayName) as string;
		}


		public static string GetPublisher()
		{
			return SteamApp.ReadValue(SteamAppID, AppValue.Publisher) as string;
		}


		public static string GetHelpLink()
		{
			return SteamApp.ReadValue(SteamAppID, AppValue.HelpLink) as string;
		}


		public static string GetUrlInfoAbout()
		{
			return SteamApp.ReadValue(SteamAppID, AppValue.UrlInfoAbout) as string;
		}


		public static string GetUninstallString()
		{
			return SteamApp.ReadValue(SteamAppID, AppValue.UninstallString) as string;
		}

		#endregion

	}
}
