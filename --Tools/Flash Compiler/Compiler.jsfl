/**
* Grant Skinner www.gskinner.com
* https://blog.gskinner.com/archives/2004/08/jsfl_fla_batch.html
* https://blog.gskinner.com/archives/2004/08/jsfl_fla_batch_1.html
*
* Set Up for Preloading command by Grant Skinner. Aug 12, 2004
* Visit www.gskinner.com for documentation, updates and more free code.
*
* Notice: All JSFL commands have the ability to damage your files. It is recommended
* that you run these commands on copies of your files. You take all responsibility
* for any problems or damage incurred directly or indirectly from running this command.
*
* You may distribute this code freely, as long as this comment block remains intact.
*/


// execute a function, mainly just so that we can exit whenever we want:
execute();
var dirURI = "";
var error = false;
var log = "";
var openDocs = {};


function execute()
{
	// first, ask for the compile_schema to scan:
	var schemaURI = fl.browseForFileURL("open", "Please select your compile schema:", false);
	if (schemaURI == null)
	{
		return;
	}

	// pre-parse the schema, so that we can opt out if the schema is broken:
	if (schemaURI.substr(schemaURI.length-4) != ".txt")
	{
		alert(">> ERROR: Selected schema is not a .txt file.");
		return;
	}

	var schemaStr = FLfile.read(schemaURI);
	if (schemaStr == null)
	{
		alert(">> ERROR: Could not read the schema file.");
		return;
	}

	// first, clean up carriage returns:
	var schema = schemaStr.split(String.fromCharCode(10)).join(String.fromCharCode(13)).split(String.fromCharCode(13) + String.fromCharCode(13)).join(String.fromCharCode(13)).split(String.fromCharCode(13));
	if (schema.length < 1)
	{
		alert(">> ERROR: Schema is empty or could not be read.");
		return;
	}

	// find our working directory:
	dirURI = schemaURI.substr(0, schemaURI.lastIndexOf("/") + 1);

	startLog("Running compile on "+l+" files at: "+dirURI);
	var mainSwf;

	/*
	// save a list of open documents, so that we can leave them open:
	var l = fl.documents.length;
	appendToLog(l);
	for (var i=0; i<l; i++)
	{
		// need to convert to a URI:
		openDocs[fl.documents[i].path] = true;
	}
	*/

	var l = schema.length;
	for (var i=0; i<l; i++)
	{
		var row = schema[i].split(String.fromCharCode(9));
		var flaName = row[0];
		appendToLog("\n---------------------------------------------------------------------------\nCompiling "+flaName+"\n---------------------------------------------------------------------------");
		if (flaName == undefined || flaName.length < 3)
		{
			appendToLog(">> ERROR: Empty FLA name.");
			error=true;
			continue;
		}

		if (!FLfile.exists(dirURI+flaName))
		{
			appendToLog(">> ERROR: FLA not found: "+flaName);
			error=true;
			continue;
		}
		compile(dirURI+flaName, row[2], flaName);

		var swfName = flaName.substr(0, flaName.lastIndexOf(".")+1)+"swf";
		if (!FLfile.exists(dirURI+swfName))
		{
			appendToLog(">> ERROR: File did not compile correctly: "+flaName);
			error=true;
			continue;
		}

		if (i == 0)
		{
			mainSwf = dirURI+swfName;
		}

		appendToLog("Compiled "+flaName+" successfully.");

		if (row[1] != null && row[1] != "")
		{
			var newSwfName = row[1];
			var ok = move(dirURI+swfName, dirURI+newSwfName, swfName);
			if (!ok)
			{
				appendToLog(">> ERROR: File was not moved correctly: "+swfName);
				if (i == 0)
				{
					mainSwf = undefined;
				};
					error=true;
				}
			else
			{
				appendToLog("Moved "+swfName+" to "+newSwfName+" successfully.");
				if (i==0)
				{
					mainSwf = dirURI+newSwfName;
				}
			}
		}
	}

	// open mainSwf?
	if (mainSwf != undefined)
	{
		fl.openScript(mainSwf);
	}
	fl.trace(FLfile.read(dirURI+"FlashCompiler_Log.txt"));
	if (error)
	{
		alert("Error(s) encountered. Please check the log file for details.");
	}
}


function compile(p_fileURI, p_profile, p_fileName)
{
	fl.outputPanel.clear();
	var doc = fl.openDocument(p_fileURI);
	if (p_profile != null && p_profile != "")
	{
		doc.currentPublishProfile = p_profile;
		if (doc.currentPublishProfile != p_profile)
		{
			appendToLog(">> ERROR: Could not set publish profile ("+p_profile+"): "+p_fileName);
			error=true;
		}
	}
	doc.publish();
	appendToLog("");
	fl.outputPanel.save(dirURI+"FlashCompiler_Log.txt", true);
	fl.outputPanel.clear();
	fl.closeDocument(fl.documents[0], false); // close fla without saving
}


function move(p_file, p_newName, p_fileName)
{
	// delete old swf:
	FLfile.remove(p_newName);
	var ok;
	ok = FLfile.copy(p_file, p_newName);
	if (!ok)
	{
		return false;
	}
	if (FLfile.exists(p_newName) == true)
	{
		// delete original:
		ok = FLfile.remove(p_file);
		if (!ok)
		{
			appendToLog(">> ERROR: Original file not deleted: "+p_fileName);
			error=true;
		}
		return true;
	}
}


function appendToLog(p_str)
{
	log += "\n"+p_str;
	FLfile.write(dirURI+"FlashCompiler_Log.txt", "\n"+p_str, "append");
}


function startLog(p_str)
{
	log = p_str;
	FLfile.write(dirURI+"FlashCompiler_Log.txt", p_str);
}
