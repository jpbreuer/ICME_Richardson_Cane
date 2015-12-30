# ICME_Richardson_Cane
Matlab script to pull ICME data from http://www.srl.caltech.edu/ACE/ASC/DATA/level3/icmetable2.htm

Due to several inconsistancies in the data and some errors in the HTML code (missing </td> tags, for example), a fixed version of the HTML code was written (see index.html).
The new version of index.html is up at jpb.ninja/index.html for visualisation purposes.

Feel free to pull the table from there directly (default) or, after updating the path, via the index.html page provided (saves you 30-50 seconds). Just uncomment as necessary within the get_ICME_tabledata function.
