/*
 * Macro template to process multiple images in a folder
 * Script is suitable for Zeiss microscope output files
 * For other output, change of script maybe required
 */

/*get the folder info and process all czi files*/

input = getDirectory("Input directory");
output = getDirectory("Output directory");

suffix = ".czi";

processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

/*
 * process all images on frame bases
 * each ratio map was calculated from two channel images on pixel by pixel calculation
 * images are background subtracted and picked out from combined channels
 * depending on file output type, channel orders may be different
 * range of display can be changed according to desired results
*/

function processFile(input, output, file) {
	open(input + file);
	run("Duplicate...", "title=G duplicate channels=1");
	selectWindow(file);
	run("Duplicate...", "title=B duplicate channels=3");
	selectWindow("G");
	run("Subtract Background...", "rolling=100");
	selectWindow("B");
	run("Subtract Background...", "rolling=100");
	imageCalculator("Divide create 32-bit", "B","G");
    run("physics");
//	run("Brightness/Contrast...");
	setMinAndMax(0, 4);
    saveAs("tif", output + file);
	saveAs("jpeg", output + file);
//	close();
	close(file);
	close("B");
	close("G");
	close("Result of B");
}
