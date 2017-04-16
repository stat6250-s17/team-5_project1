*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.
[Dataset Name] Dropouts by Race & Gender

[Experimental Units] California public K-12 schools

[Number of Observations] 58,876    

[Number of Features] 20

[Data Source] The file http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=
School&cYear=2014-15&cCat=Dropouts&cPage=filesdropouts was
downloaded as a text file and imported to Excel as tab-delimited text, then edited
to produce file project1_datasetv4.cvs by setting all numeric values to number 
types and the column labels and gender codes to text.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsdropouts.asp

[Unique ID] CDS_ CODE
;

* setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat6250/team-5_project1/blob/master/project1_datasetv4.cvs?raw=true
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
    file=tempfile
    out=project1_raw
    dbms=cvs;
run;
filename tempfile clear;


* check raw dropout dataset for duplicates with respect to its composite key;
proc sort nodupkey data=project1_raw dupout=project1_raw_dups out=_null_;
    by CDS_CODE;
run;


* build analytic dataset from dropout dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data project1_analytic_file;
    retain
        CDS_CODE
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
        D7
        D8
        D9
        D10
        D11
        D12
        DUS
        DTOT
    ;
    set project1_raw;
run;
