/*

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.

*/



/*

To execute, open desired FLA with missing fonts and double click this file to open in Flash.

To install as a command, copy this file into:

Operating system	Location
------------------------------
Windows 7			boot drive\Users\username\AppData\Local\Adobe\Flash CS6\language\Configuration\Commands
Windows Vista		boot drive\Users\username\Local Settings\Application Data\Adobe\Flash CS6\language\Configuration\Commands
Windows XP			boot drive\Documents and Settings\user\Local Settings\Application Data\Adobe\Flash CS6\language\Configuration\Commands
Mac OS X			Macintosh HD/Users/userName/Library/Application Support/Adobe/Flash CS6/language/Configuration/Commands

It will automatically appear in the Commands menu in Flash.

*/



/*

This JSFL command iterates through every library item in an FLA and finds 
all dynamic and input TextField instances.

*/



// ----------------------------------------------------------------------------
// Init



function listFonts()
{
	var all_items = dom.library.items;
	
	
	
	// ----------------------------------------------------------------------------
	// Find embedded fonts
	
	
	
	fl.outputPanel.trace("");
	fl.outputPanel.trace("");
	fl.outputPanel.trace("Embedded fonts");
	fl.outputPanel.trace("=======================================");
	
	
	var i = all_items.length;
	
	
	while(i--)
	{
		var library_item = all_items[i];
		
		
		// Skip non-fonts
		// 
		if("font" != library_item.itemType)
		{
			continue;
		}
		
		
		var font_name = library_item.name;
		
		
		// Remove folder from font name if applicable.
		// 
		if(-1 != font_name.indexOf("/"))
		{
			font_name = font_name.substr(font_name.lastIndexOf("/") + 1);
		}
		
		font_name = fill(font_name, 30, " ");
		font_name += library_item.font;
		
		var installed = "";
		
		if(fl.isFontInstalled(library_item.font))
		{
			installed = "\tInstalled";
		}
		else
		{
			installed = "\tNot installed";
		}
		
		font_name = fill(font_name, 60, " ");
		font_name += installed;
		
		fl.outputPanel.trace(font_name);
	}
	
	
	
	// ----------------------------------------------------------------------------
	// Find all TextField instances
	
	
	fl.outputPanel.trace("");
	fl.outputPanel.trace("");
	fl.outputPanel.trace("TextFields");
	fl.outputPanel.trace("=======================================");
	
	
	var i = all_items.length;
	
	
	// Library items
	// 
	while(i--)
	{
		var library_item = all_items[i];
		
		
		// Should we skip the current library item?
		// 
		if("movie clip" != library_item.itemType && "graphic" != library_item.itemType && "button" != library_item.itemType)
		{
			continue;
		}
		
		
		var layers = library_item.timeline.layers;
		var j = layers.length;
		
		var layer_instance_names = [];
		
		var buffer = "\n\n" + library_item.symbolType + ": " + library_item.name + "\n";
		
		
		// Layers
		// 
		while(j--)
		{
			var layer = layers[j];
			var frames = layer.frames;
			var k = frames.length;
			
			
			// Frames
			// 
			while(k--)
			{
				var elements = frames[k].elements;
				var m = elements.length;
				
				
				// Stage elements
				// 
				elementLoop: while(m--)
				{
					var element = elements[m];
					
					
					// --------------------------------
					// Stage instance type check
					
					
					// If the current stage element is not a TextField, we can move on
					// 
					if("text" != element.elementType)
					{
						continue;
					}
					
					// If the current TextField is static, we must skip it
					// 
					if("static" == element.textType)
					{
						buffer += "   ";
						buffer += fill("", 30, " ");
						buffer += fill("(Skipping static TextField)", 50, " ");
						buffer += fill(layer.name, 30, " ");
						buffer += "\n";
						
						continue;
					}
					
					
					// --------------------------------
					// Check duplicates
					
					
					var c = layer_instance_names.length;
					var layer_instance_name = library_item.name + "_" + layer.name + "_" + element.name;
					
					
					while(c--)
					{
						if(layer_instance_name[c] == layer_instance_name)
						{
							break elementLoop;
						}
					}
					
					
					// --------------------------------
					// Output
					
					
					var text_runs = element.textRuns;
					
					
					if(0 != text_runs.length)
					{
						font_name = text_runs[0].textAttrs.face;
					}
					else
					{
						font_name = "[Unknown]";
					}
					
					
					buffer += "   ";
					buffer += fill(element.name, 30, " ");
					buffer += fill(font_name, 50, " ");
					buffer += fill(layer.name, 30, " ");
					
					fl.outputPanel.trace(buffer);
					
					buffer = "";
					
					layer_instance_names.push(layer_instance_name);
				}
			}
		}
	}
}



/*
Function: fill
Returns: A string with a fixed with of len that starts with 'str' and ends with 'filler'.
Params:
	str - The base string.
	len - Desired length.
	filler - Desired filler character, ideally this is a single character.

fill("Hello, world", 20, ".") => "Hello, world......."
fill("Hello, world", 25, " ") => "Hello, world            "
fill("Hello, world", 6, "-") => "Hello-"
fill("Hello, world", 10, " ") => "Hello, wo "

*/
function fill(str, len, filler)
{
	var i = len;
	
	var filler_str = "";
	
	
	while(i--)
	{
		filler_str += filler;
	}
	
	
	str = str.substr(0, len - 1);
	
	filler_str = filler_str.substr(0, Math.max(0, len - str.length));
	
	
	return str + filler_str;
}



// ----------------------------------------------------------------------------
// Execute



var dom = fl.getDocumentDOM();


if(dom)
{
	listFonts();
}
else
{
	alert("You must have at least one FLA document open to run this command.");
}
