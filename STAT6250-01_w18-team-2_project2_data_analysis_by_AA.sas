*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding expulsion trends and free or reduced meals at CA public 
K-12 schools

Dataset Name: (insert dataset name) created in external file
STAT6250-01_w18-team-2_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets (All file names)
%include '.\STAT6250-01_w18-team-2_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top three districts that have experienced the most expulsions from 2015 to 2017?'
;

title2
'Rationale: This could help us identify which districts have the most expulsions and consequently consider the appropriate outreach program using datasets EXP1516 and EXP1617.'
;

*
Note: This compares the column "districts" and "total expulsions" from EXP1516
to the column of the same name from EXP1617.

Methodology: After combining EXP1516 and EXP1617 during data preparation.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
        data=(Dataset name)(obs=3)
    ;
    id
        district_name
    ;
    var
        total_expulsion
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top five schools that have experienced the most expulsion from 2015 to 2017?'
;

title2
'Rationale: This would help us continue on from our previous research question and identify exactly which schools have the highest expulsion using datasets Exp1516 and Exp1617.'
;

*
Note: This compares the column "School name" and "total expulsions from EXP1516
to the column of the same name from EXP1617.

Methodology: Use proc print to display the first five schools with highest 
expulsion. May need to use prof freq.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc print
        data=(Dataset name)(obs=5)
    ;
    id
        school_name
    ;
    var
        total_expulsion
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Can Student Poverty Free or Reduced Price Meals be used to predict the number of expulsions in 2016-2017?'
;

title2
"Rationale: By using dataset EXP1617 and FRPM1617 we can identify if there is a relationship between the two"
;

*
Note: This compares the column "total expulsions" from EXP1617 to the column 
"total reduced and free meals" from FRPM1617.

Methodology: 

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for values
outside of admissable values. This also does not account for students that 
are in poverty but not in the FRPM1617 data.

Followup Steps: More carefully clean the values of variables so that the
statistics computed do not include any possible illegal values, and better
handle missing data, e.g., by using a previous year's data or a rolling average
of previous years' data as a proxy.
;
