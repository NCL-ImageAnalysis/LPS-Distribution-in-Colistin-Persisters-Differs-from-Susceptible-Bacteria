
n = roiManager("count");

xS = newArray();
yS = newArray();
xE = newArray();
yE = newArray();



for (i = 0; i < n; i++) {
	roiManager("select", i);
	roiManager("Measure");
	xStart = getResult("BX");
	yStart = getResult("BY");
	xEnd = xStart + getResult("Width");
	yEnd = yStart + getResult("Height");
	xS = Array.concat(xS,xStart);
	xE = Array.concat(xE,xEnd);
	yS = Array.concat(yS,yStart);
	yE = Array.concat(yE,yEnd);	
}

string = "";
for (i = 0; i < xS.length; i++) {
	if (i==xS.length-1) {
		variable = ")";
	}
	else{
		variable = ",";
	}
	string = string + xS[i] + variable;
}
print("xStart = c(" + string);

string = "";
for (i = 0; i < xS.length; i++) {
	if (i==xS.length-1) {
		variable = ")";
	}
	else{
		variable = ",";
	}
	string = string + yS[i] + variable;
}
print("yStart = c(" + string);

string = "";
for (i = 0; i < xS.length; i++) {
	if (i==xS.length-1) {
		variable = ")";
	}
	else{
		variable = ",";
	}
	string = string + xE[i] + variable;
}
print("xEnd = c(" + string);

string = "";
for (i = 0; i < xS.length; i++) {
	if (i==xS.length-1) {
		variable = ")";
	}
	else{
		variable = ",";
	}
	string = string + yE[i] + variable;
}
print("yEnd = c(" + string);

