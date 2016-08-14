// http://help.adobe.com/en_US/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7fe8CS5.html


// Variables
//===========================================================

var SourceFolder = 'file:///D|/Games/Steam/SteamApps/common/Fallout 4/Data/Interface/Source/';
var myFileList = [
	"fonts_en/fonts_en.fla",
	"fonts_console/fonts_console.fla",
	"fonts_programs/fonts_programs.fla",
];

var filesNum = myFileList.length;



// Batch
//===========================================================

fl.outputPanel.clear();
fl.trace('Publishing '+SourceFolder);


for(var i = 0 ; i < filesNum; i++)
{
	if(myFileList[i].substr(myFileList[i].lastIndexOf(".")+1) == 'fla')
	{ //look for fla's
		var doc = fl.openDocument(SourceFolder+'/'+myFileList[i]);
		//toggle the comment on the prefered way of exporting

		//doc.exportSWF(add your location here, useCurrentSettings?);
		doc.publish();

		//doc.testMovie();
		fl.saveDocument(doc);
		fl.closeDocument(doc, false);
		fl.trace(myFileList[i]+' done! ' +(i+1) + " of " + filesNum);
	}
}


fl.trace('all done!');
