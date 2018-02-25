*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset 1 Name] EXP1516

[Dataset Description] Expulsion data for 2015-2016 (July 1 – June 30) school 
year in California

[Experimental Units] California public K-12 schools active in 2016-2017 
(July 1 – June 30) school year in California

[Number of Observations] 178878

[Number of Features] 22

[Data Source] ftp://ftp.cde.ca.gov/demo/discipline/exp1516.txt

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsed.asp

[Unique ID Schema] The columns "County Code", "District Code", and "School
Code" form a composite key CDS_CODE

--

[Dataset 2 Name] EXP1617

[Dataset Description] Expulsion data for 2016-2017 (July 1 – June 30) 
school year in California

[Experimental Units] California public K-12 schools active in 2016-2017 
(July 1 – June 30) school year in California

[Number of Observations] 178412

[Number of Features] 22

[Data Source] ftp://ftp.cde.ca.gov/demo/discipline/exp1617.txt

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsed.asp

[Unique ID Schema] The columns "County Code", "District Code", and "School
Code" form a composite key CDS_CODE

--

[Dataset 3 Name] FRPM1617

[Dataset Description] Free or Reduced Price Meals (FRPM) student 
eligibility data for 2016-2017 (July 1 – June 30) school year in California

[Experimental Units] California public K-12 schools active in 2016-2017
(July 1 – June 30) school year in California

[Number of Observations] 10478

[Number of Features] 28

[Data Source] https://www.cde.ca.gov/ds/sd/sd/documents/frpm1617.xls

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsspfrpm.asp

[Unique ID Schema] The columns "County Code", "District Code", and "School
Code" form a composite key CDS_CODE
;


* environmental setup;

* create output formats;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-2_project2/blob/master/data/EXP1516.xls?raw=true
;
%let inputDataset1Type = XLS;
%let inputDataset1DSN = EXP1516_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-2_project2/blob/master/data/EXP1617.xls?raw=true
;
%let inputDataset2Type = XLS;
%let inputDataset2DSN = EXP1617_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-2_project2/blob/master/data/FRM1617.xls?raw=true
;
%let inputDataset3Type = XLS;
%let inputDataset3DSN = FRM1617_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)


* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
proc sort
        nodupkey
        data=EXP1516_raw
        dupout=EXP1516_raw_dups
        out=EXP1516_raw_sorted(where=(not(missing(School_Code))))
    ;
    by
        County_Code
        District_Code
        School_Code
    ;
run;
proc sort
        nodupkey
        data=EXP1617_raw
        dupout=EXP1617_raw_dups
        out=EXP1617_raw_sorted
    ;
    by
        County_Code
        District_Code
        School_Code
    ;
run;
proc sort
        nodupkey
        data=FRM1617_raw
        dupout=FRM1617_raw_dups
        out=FRM1617_raw_sorted
    ;
    by
        County_Code
        District_Code
        School_Code
    ;
run;


* combine expulsions data vertically, combine composite key values into a primary key
 data exp_analytic_file;
    retain
        Academic_year
        Aggregate_level
        County_code
        District_code
        School_Code
        Charter
        Reporting_Category
        Cumulative_Enrollment
        Total_Expulsions
        Unduplicated_count_students_expelled_total
        Expulsion_Rate
        Expulsion_count_Violent_Incident_Injury
        Expulsion_count_Violent_Incident_No_Injury
        Expulsion_count_Weapons_Possession
        Expulsion_count_Illicit_Drug_Related
        Expulsion_count_Defiance_only
        Expulsion_count_Other_Reasons
    ;
    keep
        Academic_year
        Aggregate_Level
        County_code
        District_code
        School_Code
        Charter
        Reporting_Category
        Cumulative_Enrollment
        Total_Expulsions
        Unduplicated_count_students_expelled_total
        Expulsion_Rate
        Expulsion_count_Violent_Incident_Injury
        Expulsion_count_Violent_Incident_No_Injury
        Expulsion_count_Weapons_Possession
        Expulsion_count_Illicit_Drug_Related
        Expulsion_count_Defiance_only
        Expulsion_count_Other_Reasons
    ;
    set
        EXP1516_raw_sorted(in=ay2016_data_row)
        EXP1415_raw_sorted(in=ay2015_data_row)
    ;
    by
        County_Code
        District_Code
        School_Code
    ;
run;


* combine 2016-17 EXP and FRPM datasets horizontally to address research questions in data analysis files
data exp_frpm_analytic_file;
    retain
        County_Code
        District_Code
        School_Code
        Charter
        Cumulative_Enrollment
        Total_Expulsions
        Unduplicated_count_of_students_expelled
        Expulsion_Rate
        NSLP_Provision_status
        Free_Meal_Count_K12
        Percent_Eligible_Free_K12
        FRPM_count_K12
    ;
    keep
        County_Code
        District_Code
        School_Code
        Charter
        Cumulative_Enrollment
        Total_Expulsions
        Unduplicated_count_of_students_expelled
        Expulsion_Rate
        NSLP_Provision_status
        Free_Meal_Count_K12
        Percent_Eligible_Free_K12
        FRPM_count_K12
    ;
    merge
        EXP1617_raw_sorted
        FRPM1617_raw_sorted
    ;
    by
        County_Code
        District_Code
        School_Code
    ;


* Created exp_temp dataset to keep the least 
number of columns and minimal cleaning/transformation needed to address 
research questions in  Q1 by LC.
;

data 
	exp_temp;
	retain 
	Charter
	Expulsion_Rate;
	keep 
	Charter
	Expulsion_Rate;
	set EXP1617_raw_sorted (RENAME = (VAR9=Charter));
	Expulsion_Rate = input(Expulsion_Rate__Total_, 8.);
run;


* Created reason_for_exp dataset to keep the least 
number of columns and minimal cleaning/transformation needed to address 
research questions in  Q2 by LC.
;

data
	reason_for_exp;	
	retain
	Violent_Incident_injury
	Violent_Inciden_no_injury
	Weapons_Possessi
	Illicit_Drug_Rel
	Defiance_only
	Other_Reasons;
	keep
	Violent_Incident_injury
	Violent_Inciden_no_injury
	Weapons_Possessi
	Illicit_Drug_Rel
	Defiance_only
	Other_Reasons;
	set EXP1617_raw_sorted;
	Violent_Incident_injury = input(Expulsion_Count_Violent_Incident, 8.);
	Violent_Inciden_no_injury = input(Expulsion_Count_Violent_Inciden1, 8.);
	Weapons_Possessi = input(Expulsion_Count_Weapons_Possessi, 8.);
	Illicit_Drug_Rel = input(Expulsion_Count_Illicit_Drug_Rel, 8.);
	Defiance_only = input(Expulsion_Count_of_Students_Expe, 8.);
	Other_Reasons = input(Expulsion_Count_Other_Reasons, 8.)
	;
run;


* Added total_exp dataset to answer Q3 by LC.
;

data
	total_exp;
	retain
	School_Name
	School_Code
	Expulsions;
	keep
	School_Name
	School_Code
	Expulsions;
	set EXP1617_raw_sorted;
	Expulsions = input(Total_Expulsions, 8.);
	if cmiss(of School_Name) then delete;
run;


* Sorted total_exp dataset  by total expulsions for Q3 by LC.
;

proc sort 
	data=total_exp
	out=total_exp
	;
	by descending Expulsions;
run;
