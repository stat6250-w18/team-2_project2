*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding expulsion trends and free or reduced meals at CA public 
K-12 schools

Dataset Name: EXP_ANALYTIC_FILE created in external file
STAT6250-01_w18-team-2_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets EXP1617_RAW_SORTED, 
  EXP1516_RAW_SORTED, FRM1617_RAW_SORTED;
%include '.\STAT6250-01_w18-team-2_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top three districts that have experienced the most expulsions due to violent incidents with injury from 2015 to 2017?'
;

title2
'Rationale: This could help us identify which districts have the most expulsions with violence and consequently consider the appropriate outreach program using datasets EXP1516 and EXP1617.'
;

footnote1
"The top three districts are missing district and school codes and consequently cannot be identified."
;

footnote2
"The district that can be identified with the highest expulsion rate is district 62166"
;

footnote3
"Further analysis and data cleaning needs to be completed to properly answer the research question."
;

*
Note: This compares the column "District Code" and "Violent Incident
Injury" from EXP1516 to the column of the same name from EXP1617.

Methodology: After combining EXP1516 and EXP1617 during data preparation
and sorting through the data, use proc print to display the first ten
rows of the sorted dataset.

Limitations: This methodology does not account for schools with missing 
data, nor does it attempt to validate data in any way, like filtering for
percentages between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any 
possible illegal values, and better handle missing data, e.g., by using 
a previous year's data or a rolling average of previous years' data as 
a proxy. Ensuring schools report everything correctly.
;

Proc Print 
	data=sortedAA (obs=10)
     ;
     var 
	Violent_Incident_Injury district_code School_code
     ;
     title 
	'Districts with highest injury related expulsions between 2015-2017 in CA'
     ;
     title2 
	'Listed by district and school code'
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

footnote1
"The top five schools are Las Plumas High, Pershing Continuation High, Lemoore High, Oroville High, Liberty Middle."
;

footnote2
"County name is also listed to identify if schools with highest expulsion rates are from the same county"
;

footnote3
"This suggests Butte and Kings County need more outreach programs to decrease expulsion rate."
;

footnote4
"The number of expulsion rates may be much higher in other schools hence this does not account for missing or unreported data"
;

*
Note: This compares the column "School Name" and "Expulsions"
from EXP1516 to the column of the same name from EXP1617.

Methodology: After combining EXP1516 and EXP1617 during data preparation
and sorting dataset. Use proc print to display the top five schools
with highest expulsion. 

Limitations: This methodology does not account for schools with missing 
data, nor does it attempt to validate data in any way, like filtering for
percentages between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any 
possible illegal values, and better handle missing data, e.g., by using 
a previous year's data or a rolling average of previous years' data as 
a proxy.
;

proc print
        data=total_exp(obs=10)
    ;
    id
        school_name
    ;
    var
        expulsions county_name
    ;
    title 
       'Top schools with the highest number of expulsions between 2015-2017';
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top ten counties had the highest drug related expulsions?'
;

title2
"Rationale: By using dataset EXP1516 and EXP1617 we can identify which counties are having the highest drug related problems and if law enforcement should get involved."
;

footnote1
"The County with the highest expulsion due to drugs is missing County Name therefore cannot be identified."
;

footnote2
"The most problematic counties are located in Southern California."
;

footnote3
"This suggests drugs are being traded near this region and further investigation with law enforcement should be made to elimate drug abuse."
;

*
Note: This compares the column "Illicit Drug Rel" and "County Name"
from EXP1516 to the column of the same name from EXP1617.

Methodology: After combining expulsions 2015-16 and 2016-2017, use 
proc sort to sort by "Illicit Drug Rel" and proc print for the
top ten observations.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for values
outside of admissable values. 

Follow up Steps: More carefully clean the values of variables so that the
statistics computed do not include any possible illegal values, and better
handle missing data, e.g., by using a previous year's data or a rolling 
average of previous years' data as a proxy.
;

proc print
        data=Drug_Sorted_AA (obs=10)
    ;
    id
        County_name
    ;
    var
        illicit_Drug_Rel District_code
    ;
    title 
        'Top counties in CA with the highest number of drug related expulsions between 2015-2017';
run;

title;
footnote;
