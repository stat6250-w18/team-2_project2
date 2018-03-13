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


* load external file that generates analytic datasets;
%include '.\STAT6250-01_w18-team-2_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question : What are the factors contributing to expulsion?'
;

title2
'Rationale:This would help in focusing more on those factors and help in overcoming expulsion.'
;

footnote1
"Initial analysis done for Expulsion due to Violent Injuries which is not a significant contributor for Expulsions."
;

footnote2
"Further analysis should be done for all other factors."
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

proc sql;
	create table Expulsion_Reasons as
	select sum(input(Expulsion_Violent_Injury, 8.)) as Expulsion_Violent_Injury,
    	sum(input(Expulsion_Violent_No_Injury, 8.)) as Expulsion_Violent_No_Injury,
    	sum(input(Expulsion_Weapons, 8.)) as Expulsion_Weapons,
    	sum(input(Expulsion_Drug_Related, 8.)) as Expulsion_Drug_Related,
    	sum(input(Expulsion_Defiance, 8.)) as Expulsion_Defiance,
    	sum(input(Expulsion_Other_Reasons, 8.)) as Expulsion_Other_Reasons
	from Exp_analytic_file_ak
    	where Aggregate_Level="T";
quit;
proc transpose 
	data=Expulsion_Reasons
	out=Expulsion_Reasons
 (KEEP=_NAME_ COL1
 RENAME=(COL1=Total));
run;
proc gchart  data=Expulsion_Reasons;
    title1 'Reasons for Expulsion 2015-17';
	label _NAME_='Expulsion Reason' Total='Number of Expulsions';
	vbar _Name_ / discrete type=mean sumvar=Total mean;
run;
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How does charter schools compare to public schools in expulsion?'
;

title2
'Rationale:This will help in identifying which schools perform better and look at adopting any best practices.'
;

footnote1
"Initial review shows lesser expulsions in Charter Schools compared to Non charter schools."
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

proc sql;
	create table Expulsion_Charter as
	select Charter_School,
	sum(input(Expulsion_Rate, 8.)) as Expulsion_Rate
    	from Exp_analytic_file_ak
    	where Aggregate_Level="S"
	group by Charter_School;
quit;
proc sql;
	select *
	from Expulsion_Charter;
quit;
run;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Does Reduced Meals program help in controlling the expulsion?'
;

title2
'Rationale: This can help in identifying if student benefits, encourage students to grow up with good beahivours controlling the expulsion scenarios.'
;

footnote1
"There is no clear relationship between Free meals and Expulsions."
;

footnote2
"However, on most occasions, expulsions reduced with free meal count."
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
Expulsion and FRPM datasets were mapped.This is to identify if any of 
these datasets have uncaptured schools.
;

proc sql;
	create table Expulsion_Free_Meals as
	select Unduplicated_Total_Expulsion,
	sum(Free_Meal_count) as Free_Meal_Count
	from Exp_frpm_analytic_file
	where School_Code > 0
    group by Unduplicated_Total_Expulsion;
quit;
proc sql
	select *
	from Expulsion_Free_Meals
quit;
run;
title;
footnote;
