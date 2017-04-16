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

* set relative file import path to current directory (using standard SAS trick;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget
(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset project1_analytic_file;
%include '.\STAT6250-02_s17-team-5_project1_data_preparation.sas';


*
Research Question: What are the top twenty districts with the highest mean
values of "Percent (%) Eligible FRPM (K-12)"?
Rationale: This should help identify the school districts in the most need of
outreach based upon child poverty levels.
Methodology: Use PROC MEANS to compute the mean of Percent_Eligible_FRPM_K12
for District_Name, and output the results to a temportatry dataset. Use PROC
SORT extract and sort just the means the temporary dateset, and use PROC PRINT
to print just the first twenty observations from the temporary dataset.
Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Possible Follow-up Steps: More carefully clean the values of the variable
Percent_Eligible_FRPM_K12 so that the means computed do not include any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;
proc means mean noprint data=FRPM1516_analytic_file;
    class District_Name;
    var Percent_Eligible_FRPM_K12;
    output out=FRPM1516_analytic_file_temp;
run;

proc sort data=FRPM1516_analytic_file_temp(where=(_STAT_="MEAN"));
    by descending Percent_Eligible_FRPM_K12;
run;

proc print noobs data=FRPM1516_analytic_file_temp(obs=20);
    id District_Name;
    var Percent_Eligible_FRPM_K12;
run;


*
Research Question: How does the distribution of "Percent (%) Eligible FRPM
(K-12)" for charter schools compare to that of non-charter schools?
Rationale: This would help inform whether outreach based upon child poverty
levels should be provided to charter schools.
Methodolody: Compute five-number summaries by charter-school indicator variable
Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.
Possible Follow-up Steps: More carefully clean the values of the variable
Percent_Eligible_FRPM_K12 so that the statistics computed do not include any
possible illegal values, and better handle missing data, e.g., by using a
previous year's data or a rolling average of previous years' data as a proxy.
;
proc means min q1 median q3 max data=FRPM1516_analytic_file;
    class Charter_School;
    var Percent_Eligible_FRPM_K12;
run;


*
Research Question: Can "Enrollment (K-12)" be used to predict "Percent (%)
Eligible FRPM (K-12)"?
Rationale: This would help determine whether outreach based upon child poverty
levels should be provided to smaller schools. E.g., if enrollment is highly
correlated with FRPM rate, then only larger schools would tend to have high
child poverty rates.
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Enrollment_K12 and Percent_Eligible_FRPM_K12
based upon their spread, and use proc freq to cross-tabulate bins.
Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.
Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.
;
proc means min q1 median q3 max data=FRPM1516_analytic_file;
    var
        Enrollment_K12
        Percent_Eligible_FRPM_K12
    ;
run;
proc format;
    value Enrollment_K12_bins
        low-262="Q1 Enrollment"
        263-510="Q2 Enrollment"
        511-740="Q3 Enrollment"
        741-high="Q4 Enrollment"
    ;
    value Percent_Eligible_FRPM_K12_bins
        low-<.36="Q1 FRPM"
        .36-<.67="Q2 FRPM"
        .67-<.86="Q3 FRPM"
        .86-high="Q4 FRPM"
    ;
run;
proc freq data=FRPM1516_analytic_file;
    table Enrollment_K12*Percent_Eligible_FRPM_K12
        / missing norow nocol nopercent
    ;
    format
        Enrollment_K12 Enrollment_K12_bins.
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
    ;
run;
