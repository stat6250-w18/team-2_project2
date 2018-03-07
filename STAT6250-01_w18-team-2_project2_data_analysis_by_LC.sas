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


* load external file that generates analytic datasets (All file names);
%include '.\STAT6250-01_w18-team-2_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Do charter schools have higher expulsion rates than regular public schools?'
;

title2
'Rationale: This would help identify which type of school has higher expulsion rates and could help policy makers better allocate funds.'
;

footnote1
"Based on this data charter schools have a lower expulsion rate than those that are not charter schools."
;

footnote2
"This may be because charter schools have policies that differ from public schools regarding expulsions"
;

*
Note: This compares the column "school type" and "total expulsions" from EXP1516
to the column of the same name from EXP1617.

Methodology: Use proc means and compare the rate of expulsions between both school types.

Limitations: Missing data isn't accounted for.

Follow-up Steps: Omit all rows that have missing information.
;
proc means
	data = exp_temp mean
	;
	class Charter;
	var exprate;
run;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the most likely cause of expulsion?'
;

title2
'Rationale: This would help identify which behaviors are most problematic'
;

title3
'"and could help school administration and counselors target more at risk students.'
;

footnote1
"Based on the output above, illicit drug use was the most common cause of expulsion."
;


*
Note: This compares all columns with reasons for expulsion.

Methodology: Use proc mean

Limitations: Not all primary keys are unique.

Follow-up Steps: Use a composite key.
;

proc sql;
	create table Total_reasons_for_exp as
	select sum(Defiance_only) as Defiance_Expulsions,
	sum(Violent_Incident_injury) as Violent_incident_injury,
	sum(Violent_Inciden_no_injury) as Violent_Incident_no_injury,
	sum(Weapons_Possessi) as Weapons_Possession,
	sum(Illicit_Drug_Rel) as Illicit_Drug_Related,
	sum(Other_Reasons) as Other
	from reason_for_exp;
quit;
proc transpose 
	data=Total_reasons_for_exp
	out=Total_reasons_for_exp
 (KEEP=_NAME_ COL1
 RENAME=(COL1=Total));
run;
proc gchart  data=Total_reasons_for_exp;
	pie _Name_ / sumvar=Total
              percent=arrow
              slice=arrow
              noheading;
run;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which schools have the highest expulsion rates?'
;

title2
'Rationale: This would allow policy makers to target specific schools in trying to alleviate expulsion rates.'
;

footnote1
"Las Plumas High School has the highest number of expulsions in the state of California"
;

footnote2
"Las Plumas High School is located in Oroville and has a student body of about 1,100"
;

*
Note: This compares the column "total expulsions" from EXP1617 to the column 
"total reduced and free meals" from FRPM1617.

Methodology: Use proc freq

Limitations: Missing data isn't accounted for.

Follow-up Steps: Omit all rows that have missing information.
;

proc print
	data = total_exp(obs=5);
run;
title;
footnote;
