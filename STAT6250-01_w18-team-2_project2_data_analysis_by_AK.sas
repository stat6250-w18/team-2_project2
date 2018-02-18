*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research 
questions regarding expulsion trends and free or reduced meals at CA public K-12
schools

Dataset Name: (insert dataset name) created in external file
STAT6250-01_w18-team-2_project2_data_preparation.sas, which is assumed to be in
the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets 
* file names
%include '.\STAT6250-01_w18-team-2_project2_data_preparation.sas';



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question : What are the factors contributing to expulsion?'
;

title2
'Rationale:This would help in focusing more on those factors and help in 
overcoming expulsion.'
;

*
Note : This compares the "Reasons" column across the datasets for the years 
2015-16 and 2016-17.

Methodology: Combine the two datasets to get the total figures for the period 

Limitations: In case of multiple expulsion for same student, there are specific
columns to give the unique expulsion count. However, data has to be analysed to
check how the reasons are treated for multiple expulsions for same student.

Follow-up Steps:

;




