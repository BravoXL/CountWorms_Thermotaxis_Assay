// -----------------------------------------------------------------------------
// Macro: Count_Worms_8Regions_TTX_zxl_Ver1.ijm
// Author: Shangguan Pingchuan
// Email:  zxlearly@gmail.com
// Date:   2025-11-12
// 
// Description:
// Complete workflow for counting worms in 8 regions in Thermotaxis assay.


// Make sure all sub-windows are closed, especially the Results and Log windows
// Step 1: user must manually drag-and-drop the photo, then click “Run this macro”.
waitForUser("Step 1 Open image. File > Open or drag it into Fiji, then press OK");

run("8-bit");
setAutoThreshold("Default dark no-reset");

run("Threshold...");
// Pause macro execution until user sets threshold, clicks “Apply”, and closes the Threshold dialog
waitForUser("Step 2 Set the threshold so worms appear red, click APPLY, then press OK");
// Convert to mask
run("Convert to Mask");

waitForUser("Step 3 Analyze Particles suggestion：30-infinity，0 ，Press OK");

run("Analyze Particles...");


waitForUser("Step 4 Manually edit ROIs as needed. Draw circles on missed worms, press ADD or DEL in ROI Manager, then press OK.");

// Start numbering ROIs
// One-click rename all ROIs and output total count (start from 1)
n = roiManager("count");
for (i = 0; i < n; i++) {
    roiManager("Select", i);
    roiManager("Rename", "ROI_" + (i + 1));  // numbering starts at 1
}
print("Detected Worms " + n);

//----------- Start 8-region statistics
// Get image dimensions
getDimensions(width, height, channels, slices, frames);

// Number of horizontal divisions
nDiv = 8;
regionWidth = width / nDiv;

// Count ROIs
nROI = roiManager("count");
if (nROI == 0) exit("No ROIs in ROI Manager!");

// Init arrays
regionCounts = newArray(nDiv);
regionCoords = newArray(nDiv);
for (i = 0; i < nDiv; i++) {
    regionCounts[i] = 0;
    regionCoords[i] = "";
}

// Process each ROI
for (i = 0; i < nROI; i++) {
    roiManager("Select", i);
    Roi.getBounds(rx, ry, rw, rh);
    xc = rx + rw / 2;
    yc = ry + rh / 2;

    regionIndex = floor(xc / regionWidth);
    if (regionIndex >= nDiv) regionIndex = nDiv - 1;
    if (regionIndex < 0) regionIndex = 0;

    regionCounts[regionIndex]++;

    coordStr = "(" + d2s(xc,1) + ", " + d2s(yc,1) + ")";
    if (regionCounts[regionIndex] == 1)
        regionCoords[regionIndex] = coordStr;
    else
        regionCoords[regionIndex] = regionCoords[regionIndex] + "; " + coordStr;
}

// Total count
totalCount = 0;
for (i = 0; i < nDiv; i++) totalCount += regionCounts[i];

// Print results
print("\\Clear");
print("========== Regional Count ==========");
for (i = 0; i < nDiv; i++) {
    xStart = i * regionWidth;
    xEnd = (i+1) * regionWidth;
    print("Region " + (i+1) + " (X=" + d2s(xStart,0) + "-" + d2s(xEnd,0) + "): " + regionCounts[i] + " worms");
    if (regionCounts[i] > 0) print("  Centroids: " + regionCoords[i]);
}
print("==================================");
print("Total: " + totalCount + " worms");

print("========Concise Version 1==========================");
for (i = 0; i < nDiv; i++) {
    xStart = i * regionWidth;
    xEnd = (i+1) * regionWidth;
    print((i+1) + ", " + regionCounts[i]);
    if (regionCounts[i] > 0) print(regionCoords[i]);
}
print("Total: " + totalCount);

print("========Concise Version 2==========================");
for (i = 0; i < nDiv; i++) {
    xStart = i * regionWidth;
    xEnd = (i+1) * regionWidth;
    print((i+1) + ", " + regionCounts[i]);
}
print("Total: " + totalCount);

//-------------- Save as CSV
waitForUser("Last step – choose the folder to save data. Press OK to start.");
dir = getDirectory("/Users/xiaolinzhang/Desktop/zxl_code/zxl_fiji_macro/zxl_ttx_countWorms/countResults/");   // user home directory

t = getTime();
t1 = d2s(t,0); 
savePath = dir + "worm_count_results_" + t1 + ".csv";

file = File.open(savePath);
print(file, "Region,Count");

for (i = 0; i < nDiv; i++) {
    xStart = i * regionWidth;
    xEnd = (i+1) * regionWidth;
    print(file, (i+1) + "," + regionCounts[i]);
}
print(file, "Total," + totalCount);
File.close(file);
print("Results saved to: " + savePath);

//-------------- Save detailed log
saveAs("Text", dir + "worm_count_results_" + t1 + "Log.txt");

waitForUser("Result here: " + savePath);