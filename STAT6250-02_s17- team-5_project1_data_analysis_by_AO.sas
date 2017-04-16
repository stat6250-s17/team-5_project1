*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding dropouts from CA public K-12 schools
Dataset Name: project1_analytic_file created in external file
STAT6250-02_s17-team-5_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;
%let dataPrepFileName = STAT6250-02_s17-team-5_project1_data_preparation.sas;
%let sasUEFilePrefix = team-5_project1;

* load external file that generates analytic dataset project1_analytic_file
using a system path dependent on the host operating system, after setting the
relative file import path to the current directory, if using Windows;
%macro setup;
%if
    &SYSSCP. = WIN
%then
    %do;
        X
        "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget
        (SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))"""
        ;           
        %include ".\&dataPrepFileName.";
    %end;
%else
    %do;
        %include "~/&sasUEFilePrefix./&dataPrepFileName.";
    %end;
%mend;
%setup
;


*
Research Question: What are the top three ethnic groups with the highest mean
number of dropouts in California?
Rationale: This should help identify groups of students that are most at risk
of dropping out by ethnicity.
Methodology: Use PROC MEANS to compute the mean of students of a given ethnicity
by total dropout rate of both genders, and output the results to a temportary 
dataset. Use PROC SORT to extract and sort just the means of the temporary dataset, 
and use PROC PRINT to print just the first three observations from the temporary 
dataset.
Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Possible Follow-up Steps: More carefully clean the values of the variables
DTOT and ETOT so that the means computed do not include any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc means mean noprint data=project1_analytic_file;
    class Ethnic;
    var DTOT;
    output out=project1_analytic_file_temp;
run;

proc sort data=project1_analytic_file_temp(where=(_STAT_="MEAN"));
    by descending DTOT;
run;

proc print noobs data=project1_analytic_file_temp(obs=3);
    class Ethnic;
    var DTOT;
run;


*
Research Question: How does the distribution of number of dropouts compare
between male and female students?
Rationale: This would help inform whether outreach should be more focused
on male or female students as being of greatest risk of dropping out.
Methodolody: Compute five-number summaries by Gender variable
Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Possible Follow-up Steps: More carefully clean the values of the variable
DTOT so that the statistics computed do not include any
possible illegal values, and better handle missing data, e.g., by using a
previous year's data or a rolling average of previous years' data as a proxy.
;
proc means min q1 median q3 max data=project1_analytic_file;
    class Gender;
    var DTOT;
run;


*
Research Question: Can Dropouts in Grade 9 (D9) be used to predict greater
risk of dropping out in 12th grade?
Rationale: This would help determine whether outreach performed more 
aggressively among ninth-graders would stem the high school dropout rate.
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of D9 and DTOT
based upon their spread, and use proc freq to cross-tabulate bins.
Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.
Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.
;
proc means min q1 median q3 max data=project1_analytic_file;
    var
        D9
        D12
    ;
run;
proc format;
    value D9_bins
        low-1="Q1 9th grade Dropouts"
        2-5="Q2 9th grade Dropouts"
        6-9="Q3 9th grade Dropouts"
        10-high="Q4 9th grade Dropouts"
    ;
    value DTOT_bins
        low-<1="Q1 12th grade Dropouts"
        2-<5="Q2 12th grade Dropouts"
        6-<9="Q3 12th grade Dropouts"
        10-high="Q4 12th grade Dropouts"
    ;
run;
proc freq data=project1_analytic_file;
    table D9*D12
        / missing norow nocol nopercent
    ;
    format
        D9 D9_bins.
        DTOT DTOT_bins.
    ;
run;
