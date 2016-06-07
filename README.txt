To analyze CME data...
1) create a folder for your experimental condition.
2) Inside of that folder put a folder called "orig_movies".
3) Inside of the orig_movies folder put any number of *.tif movies.
     (If files are *.tiff simply delete the second 'f', *.tiff files will be ignored.)
4) In Matlab add cmeAnalysis_modified_by_Kural_lab and subfolders to you file path.
     (Go to 'Set Path' under the Home tab and 'Add with Subfolders'.)
5) In Matlab run
	comb_run('as\much\file\path\as\you\want\experimental_condition',frame_rate,threshold,section_size)
     (Providing the data as it applies to your experiment, of course.)
     (see code documentation for more details on this specific code)
6) Data will be output to the orig_movies folder in the form of *.mat files containing the 3D array Threshfxyc.
6b optional) Load the *.mat file and run in matlab
	fxyc_struct = fxyc_to_struct(Threshfxyc);

Data structures
Threshfxyc is a 3D array of size (length_of_longest_trace x 13 x number_of_traces)
The 13 columns are...
Frame, x position, y position, classification, intensity, and the rest don't matter.

fxyc_struct is a 1D structure of length equal to the number of traces with 6 fields:
frame(v), x position(v), y position(v), classification(s), intensity(v), lifetime(s)
(v) = vector, (s) = scalar
test