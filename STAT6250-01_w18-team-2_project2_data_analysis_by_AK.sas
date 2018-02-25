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

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


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

Methodology: Combine the two expulsion datasets to get the total figures
for the period. Both the expulsion datasets are combined on the County,
District and School codes.

Limitations: In case of multiple expulsion for same student, there are specific
columns to give the unique expulsion count. However, data has to be analysed to
check how the reasons are treated for multiple expulsions for same student.

Follow-up Steps:Analyze and clean the data for any redundant expulsion counts.
;
proc means
	data=exp_analytic_file(where=(Aggregate_Level='S')) 
	mean
;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How does charter schools compare to public schools in 
expulsion?'
;

title2
'Rationale:This will help in identifying which schools perform better and look 
at adopting any best practices.'
;

*
Note: Compares the expulsion count by Charter school type across both the 
datasets for the years 2015-16 and 2016-17.

Methodology: Combine the two expulsion datasets to get the total figures
for the period.Both the expulsion datasets are combined on the County,
District and School codes.

Limitations: Charter schools vary by funding types.Further drill down by
Charter school funding type is not possible with only these datasets.

Followup Steps:Analyse the data to check if any School level aggregates
have a NULL value for Charter Type.
;

proc freq 
	data=exp_analytic_file (where=(Aggregate_Level='S'))  
	order=freq;
	tables Charter*Unduplicated_count_students_expelled_total/ norow nocol
;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Does Reduced Meals program help in controlling the 
expulsion?'
;

title2
'Rationale: This can help in identifying if student benefits, encourage 
students to grow up with good beahivours controlling the expulsion 
scenarios.
;

*
Note: Compare the expulsion data with student free meal eligibility datasets
and identify a pattern.

Methodology: Combine the 2016-17 expulsion and FRPM datasets using the country
code,district code and school code. 

Limitations:These two datasets may not have accounted for all Schools Data
and hence this research will not give a complete picture of the relation
between Reduced Meals program and Expulsions.

Followup Steps:Analyze and clean the data to verify if all the records in 
Expulsion and FRPM datasets were mapped. This is to identify if any of 
these datasets have uncaptured schools.
;

proc freq 
	data=exp_frpm_analytic_file (where=(Aggregate_Level='S'))  
	order=freq;
	tables Percent_Eligible_Free_K12*Unduplicated_count_students_expelled_total/ norow nocol
;
run;





