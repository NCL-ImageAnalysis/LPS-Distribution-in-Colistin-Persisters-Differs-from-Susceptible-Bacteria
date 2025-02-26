# LPS-Distribution-in-Colistin-Persisters-Differs-from-Susceptible-Bacteria
Repository for dSTORM image processing and data analysis in association with the manuscript of the same name

LPS distribution in colistin persisters differs from susceptible bacteria
Fengyi Wang 1,2, George Merces 3,4, Dominic Alderson 2, Adam J M Wollman 2, Mark Geoghegan 5, Chien-Yi Chang 1,2

1 School of Dental Sciences, Faculty of Medical Sciences, Newcastle University, Newcastle Upon Tyne, UK

2 Biosciences Institute, Faculty of Medical Sciences, Newcastle University, Newcastle Upon Tyne, UK

3 Biosciences Institute, Innovation, Methodology and Application (IMA) research Theme, Faculty of Medical Sciences, Newcastle University, Newcastle Upon Tyne, NE2 4HH, UK

4 Image Analysis Unit, Faculty of Medical Sciences, Newcastle University, Newcastle Upon Tyne, NE2 4HH, UK

5 School of Engineering, Newcastle University, Newcastle Upon Tyne, UK


Basic Overview of Process

1. Open image representation of dSTORM data in FIJI [CITATION]
2. Flip image vertically to ensure FIJI coordinates match to csv dSTORM coordinates
3. Using the Rectangular ROI drawing tool, draw around each individual cell visible in the image, adding each to the FIJI ROI Manager
4. Open macro named "Extract_Coordinates_from_Image_ROIs.ijm" and run (detailed description of the code later)
5. Copy the output coordinate locations for later transfer to R code
6. Open R Code in RStudio named "20240815_MW_Multi_Cell_Analysis.R"
7. Paste the saved ROI coordinate locations, one section for each raw image
8. Run the Code for all images (detailed description later)
9. Open the FIJI Code called "20240925_Mandy_Wang_Membrane_Analysis.ijm"
10. For each image, open within FIJI. Using the polygon ROI drawing tool, draw on the membrane region for each cell individually, making sure to add to the FIJI ROI Manager
11. Save the output ROI Zip files to an appropriate folder location, using a consistent naming strategy to be able to match the files to your original datasets (ideally use the exact same name, but with a .zip extension instead of .csv/.tif/.png etc)
12. Run the FIJI code and direct it to the appropriate folders when prompted (detailed description of the code later)
13. Once the code is completed and a csv file is output with coordinate points for each cell of interest in each image, open the RStudio code named ""20240925_MW_Membrane_Analysis.R"
14. Adapt the RStudio code to direct files to the correct locations, then run the code (detailed description of the code later)




**DETAILED DESCRIPTIONS OF CODE USED WITHIN THIS STUDY**


**Extract_Coordinates_from_Image_ROIs.ijm**
Count ROIs: The macro starts by determining the total number of ROIs in the ROI Manager using roiManager("count").

Initialize Arrays: Empty arrays are created to store the starting and ending coordinates for the x and y positions (xS, yS, xE, yE).

1. Loop through ROIs:

  For each ROI, the macro selects it in the ROI Manager and measures its position and size.
  The getResult() function is used to obtain the coordinates of the ROI: BX (starting x), BY (starting y), Width, and Height.
  The ending coordinates are calculated by adding the width to the starting x-coordinate (xEnd = xStart + Width) and adding the height to the starting y-coordinate (yEnd = yStart + Height).
  These coordinates are then appended to the respective arrays for start and end points (xS, yS, xE, yE).

2. Format and Output Results:

  The macro constructs a formatted string for each of the four coordinate arrays (xS, yS, xE, yE).
  It loops through each array and concatenates the values into a string, ensuring that the values are separated by commas. The final value of each string is closed with a parenthesis.
  These formatted strings are printed to the log, with the start and end coordinates labeled as xStart, yStart, xEnd, and yEnd.
  Output:
  The results are printed in a format similar to c(x1, x2, ..., xn), which is necessary for the subsequent steps in R


**20240815_MW_Multi_Cell_Analysis.R**

1. Data Import and Preparation:

  The script begins by reading cell coordinate data from a CSV file that contains X and Y coordinates for individual cells in various images.
  The data is split into separate cells based on their X and Y coordinates, defining a rectangular boundary for each cell using the xStart, xEnd, yStart, and yEnd coordinates.

2. Spatial Data Transformation:

  The coordinate data is then converted into a spatial object (sf object) using the st_as_sf() function, enabling spatial operations to be performed on it.

3. Data Visualization:

  A basic scatter plot of the X and Y coordinates is created using ggplot2, with the color of each point representing its X-coordinate value. This plot provides a visual representation of cell distribution across the image for sense-checks

4. Nearest Neighbor Calculation:

  The code calculates the number of neighboring cells for each cell at different distance thresholds (0.1, 0.2, 0.3, 0.4, and 0.5 µm).
  The st_join() function is used to join the spatial data with itself based on proximity, and the number of neighbors within each distance threshold is computed.

5. Distance Calculation:

  The code also calculates the distances between each cell and its 5 closest neighbors. These distances are stored and processed for further analysis.

6. Results Visualization:

  For each cell, the number of neighbors within a specific distance threshold is visualized using a scatter plot where the color represents the number of neighbors. This provides insights into the local density of cells in the image.

7. Statistical Analysis:

  The script performs statistical tests to assess whether there are significant differences in the number of neighbors and minimum distances across different images and cell groups.
  Pairwise Wilcoxon tests are used to compare groups, and adjustments for multiple comparisons are made using the Bonferroni method.

8. Collating Results:

  The results for each image and cell are saved in individual CSV files. These files are later combined into a single collated dataset for further analysis.
  This dataset includes the minimum distances to the 5 closest neighbors, the number of neighbors at various distance thresholds, and the mean distance for each cell.

9. Final Data Processing and Graphing:

  The final collated dataset is read back into R for statistical testing and visualization.
  The code generates additional plots comparing the distances to the closest neighbors across different image conditions (e.g., with or without colistin treatment).
  Statistical tests are performed to determine if the number of neighbors and minimum distances significantly differ between conditions.

10. File Output:

  The results are saved to a designated output folder, and the collated dataset is written to a CSV file for further use in downstream analysis.



**20240925_Mandy_Wang_Membrane_Analysis.ijm**
1. Folder Selection
  The user is prompted to choose the Home Folder (where the results will be saved) and the ROI Folder (which contains subfolders with images that will be processed).
2. Processing Each Image Folder
  The macro gets a list of all the files within the ROI Folder and sorts them alphabetically.
  For each image folder, the macro:
  Resets any previous ROIs in the ROI Manager.
  Creates a new blank image (5000 x 5000 pixels, 8-bit).
  Opens the current ROI file from the selected image folder.
  Counts the number of ROIs in the file and iterates through them.
3. Interpolation and Coordinate Extraction
  For each ROI, the macro performs an interpolation (to smooth the ROI), updates the ROI Manager, and retrieves the coordinates (X, Y) of the ROI.
  The macro stores these coordinates, along with the image name and the ROI number, in a table.
4. Saving Results
  Once all the images and ROIs are processed, the macro saves the extracted coordinates (X, Y) along with metadata (such as image name and ROI index) into a CSV file named Mandy_Wang_Membrane_Coordinates.csv. This file is stored in the Home Folder.
5. File Cleanup
  The macro resets the ROI Manager and closes all open images before continuing to the next image folder.






1. Data Import
The script imports multiple CSV files containing spot data using the dir() function to list all file names within a specified folder.
Each file is read, collated into a single dataset using do.call(rbind, lapply(...)), and a new column (name) is added to store the file name.
Another dataset, membranePoints, containing membrane coordinates, is read from a specified CSV file. This dataset includes the coordinates (X, Y) for each membrane point.
2. Data Transformation
A new column, membraneImg, is created in the membranePoints dataset by extracting the image name from the Image_Name column.
The X and Y coordinates of membrane points are converted into microns by multiplying by a scaling factor (0.02), and the results are stored in xCoordMicron and yCoordMicron columns.
3. Spot Count Calculation
The script calculates the number of spots within specified distance thresholds (10, 20, 50, and 100 microns) around each membrane point.
For each membrane point, the script:
Subsets the spots data for the corresponding image.
Filters spots within the specified distance from the membrane point.
Counts the number of spots within this region and assigns the count to a new column in the membranePoints dataset.
The spotCount10, spotCount20, spotCount50, and spotCount100 columns are created for different distance thresholds.
4. Data Saving
The processed data is saved to a CSV file (Membrane_Analysis_Spot_Count.csv) for later use.
If the data has already been saved, the script allows for re-loading the dataset for subsequent analysis.
5. Statistical Summary
The script calculates the mean and variance of spot counts within the defined thresholds for each combination of image (membraneImg) and cell using the group_by() and summarise() functions from the dplyr package.
6. Condition Categorization
A new column (Condition) is created to categorize the data based on the image file name. This helps group the data into different experimental conditions, such as "FM464 No Colistin", "FM464 With Colistin", "RBPB No Colistin", and "RBPB With Colistin".
7. Graphical Visualization
The script generates several scatter plots (geom_jitter()) to visualize the mean and variance of spot counts across different conditions:
Mean_spotCount10 - Mean number of fluorescent spots within 10 nm
Mean_spotCount20 - Mean number of fluorescent spots within 20 nm
Mean_spotCount50 - Mean number of fluorescent spots within 50 nm
Mean_spotCount100 - Mean number of fluorescent spots within 100 nm
Variance_spotCount10 - Variance of fluorescent spots within 10 nm
Variance_spotCount20 - Variance of fluorescent spots within 20 nm
Variance_spotCount50 - Variance of fluorescent spots within 50 nm
Variance_spotCount100 - Variance of fluorescent spots within 100 nm
Each plot is saved as a PNG file in a specified output folder (Output_Graphs/).
8. Output
The generated plots are saved in the Output_Graphs/ folder as PNG images for easy inspection and further analysis.

