
//Defines the Location of the Home Folder
homeFolder = getDirectory("Choose The Home Folder");
//Defines the ROI Folder
roiFolder = getDirectory("Choose The Folder Containing Your Image Folders");

list = getFileList(roiFolder);
list = Array.sort(list);
l = list.length;
row = 0;
//Measure the automated datasets data (labelled as such)
for (i=0; i<l; i++) {
	roiManager("reset");
	newImage("Untitled", "8-bit black", 5000, 5000, 1);
	roiName = roiFolder + list[i];
	roiManager("open", roiName);
	n = roiManager("count");
	for (j=0; j<n; j++) {
		roiManager("select", j);
		run("Interpolate", "interval=1 smooth");
		roiManager("Update");
		Roi.getCoordinates(xpoints, ypoints); 
		for (k=0; k<xpoints.length; k++) {
			setResult("Image_Name", row, list[i]);
			setResult("Cell", row, j);
			setResult("Point_Number", row, k);
			setResult("XCoord", row, xpoints[k]);
			setResult("YCoord", row, ypoints[k]);	
			row = row + 1;
		}
	}
	roiManager("reset");
	close("*");
}

csvSave = homeFolder + "Mandy_Wang_Membrane_Coordinates.csv";
saveAs("Results", csvSave);

	