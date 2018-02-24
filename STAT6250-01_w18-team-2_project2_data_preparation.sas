*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset 1 Name] EXP1516

[Dataset Description] Expulsion data for 2015-2016 (July 1 – June 30) school year in California

[Experimental Units] California public K-12 schools active in 2016-2017 (July 1 – June 30) school year in California

[Number of Observations] 178878

[Number of Features] 22

[Data Source] ftp://ftp.cde.ca.gov/demo/discipline/exp1516.txt

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsed.asp

[Unique ID Schema] The unique id is the column “School Code” 

--

[Dataset 2 Name] EXP1617

[Dataset Description] Expulsion data for 2016-2017 (July 1 – June 30) school year in California

[Experimental Units] California public K-12 schools active in 2016-2017 (July 1 – June 30) school year in California

[Number of Observations] 178412

[Number of Features] 22

[Data Source] ftp://ftp.cde.ca.gov/demo/discipline/exp1617.txt

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsed.asp

[Unique ID Schema] The unique id is the column “School Code”

--

[Dataset 3 Name] FRPM1617

[Dataset Description] Free or Reduced Price Meals (FRPM) student eligibility data for 2016-2017 (July 1 – June 30) school year in California

[Experimental Units] California public K-12 schools active in 2016-2017 (July 1 – June 30) school year in California

[Number of Observations] 10478

[Number of Features] 28

[Data Source] https://www.cde.ca.gov/ds/sd/sd/documents/frpm1617.xls

[Data Dictionary] https://www.cde.ca.gov/ds/sd/sd/fsspfrpm.asp

[Unique ID Schema] The unique id is the column “School Code”
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

