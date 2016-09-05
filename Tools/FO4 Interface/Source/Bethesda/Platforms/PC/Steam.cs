using System.Diagnostics;
using Microsoft.Win32;

namespace Bethesda.Platforms.PC
{
	[DebuggerStepThrough]
	public static class Steam
	{
		public static string GetLanguage()
		{
			using (var key = Registry.CurrentUser.OpenSubKey("Software\\Valve\\Steam"))
			{
				if (key != null)
				{
					return key.GetValue("Language") as string;
				}
			}
			return null;
		}
	}
}
