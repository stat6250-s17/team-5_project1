*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.
[Dataset Name] Dropouts by Race & Gender

[Experimental Units] California public K-12 schools

[Number of Observations] 59,316    

[Number of Features] 36

[Data Source] The file http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?
cLevel=School&cYear=2015-16&cCat=Dropouts&cPage=filesdropouts for dropout 
data for 2015-2016 were downloaded, along with 
ftp://ftp.cde.ca.gov/demo/schlname/pubschls.txt
to cross-reference county, district, and individual school details. They were
each downloaded as text files and imported to Excel in individual sheets as 
tab-delimited text, the schools file was used to provide necessary detail for 
the dropout data file, through VLOOKUP commands. The resulting workbook
is named dropout_dataset_2015_2016.csv.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsdropouts.asp (dropout data)
and http://www.cde.ca.gov/ds/si/ds/fspubschls.asp (school and district data)

[Unique ID] The columns  CDS_CODE, Ethnic(ity), and Gender form a
composite key
;

* setup environmental parameters;
%let inputDatasetURL =

https://github.com/stat6250/team-5_project1/blob/master/dropout_dataset_2015_2016.csv?raw=true
;


* load raw dropout dataset over the wire;
filename tempfile TEMP;
proc http
    method="get"
    url="&inputDatasetURL."
    out=tempfile
    ;
run;
proc import
    out=dropout_raw
	datafile=tempfile
    dbms=csv
	replace;
	delimiter=',';
	getnames=yes;
 	guessingrows=5000;
run;
data 
	set dropout_raw;
	input 
		CDS_CODE
		COUNTY $
		DISTRICT $
		SCHOOL $
		CHARTER_SCHOOL $
		SOC
		SOCType $ 
		EdOpsCode
		EdOpsName $
		EILCode
		EILName $ 
		STATUS $ 
		ETHNIC $
		GENDER $
		E7
		E8
		E9
		E10
		E11
		E12
		EUS
		ETOT
		D7
		D8
		D9
		D10
		D11
		D12
		DUS
		DTOT;
	run;

filename tempfile clear;


* check raw dropout dataset for duplicates with respect to its composite key;
proc sort
        nodupkey
        data=dropout_raw
        dupout=dropout_raw_dups
        out=_null_
    ;
    by
        CDS_CODE
        Ethnic
		Gender
    ;
run;


* build analytic dataset from dropout dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files
;
data dropout_analytic_file;
    retain
     CDS_CODE
		COUNTY $
		DISTRICT $
		SCHOOL $
		CHARTER_SCHOOL $
		SOC
		SOCType $ 
		EdOpsCode
		EdOpsName $
		EILCode
		EILName $ 
		STATUS $ 
		ETHNIC $
		GENDER $
		E7
		E8
		E9
		E10
		E11
		E12
		EUS
		ETOT
		D7
		D8
		D9
		D10
		D11
		D12
		DUS
		DTOT
    ;
     keep
  CDS_CODE
		COUNTY $
		DISTRICT $
		SCHOOL $
		CHARTER_SCHOOL $
		SOC
		SOCType $ 
		EdOpsCode
		EdOpsName $
		EILCode
		EILName $ 
		STATUS $ 
		ETHNIC $
		GENDER $
		E7
		E8
		E9
		E10
		E11
		E12
		EUS
		ETOT
		D7
		D8
		D9
		D10
		D11
		D12
		DUS
		DTOT
    ;
    set dropout_raw;
run;

proc print data = dropout_analytic_file(firstobs= 1 obs= 5000);
   title 'Dropouts Statewide (CA) by County/District/School 2015-16';
run;

