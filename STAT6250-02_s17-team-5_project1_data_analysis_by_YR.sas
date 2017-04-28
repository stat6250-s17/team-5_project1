
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
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-02_s17-team-5_project1_data_preparation.sas';

*
[Research Question 1] Does different county have different student drop out rate when we are picking same gender and same ethnic?

Rationale:  This would help us to know which county in California has lower drop out rate which has higher dropout rate, helps us 
to know which country maybe need more help in early school dropout issue.

Methodology: Compute five-number summaries by Gender variable.

Limitations:This methodology does not account for schools with missing data, nor does it attempt to validate data in any way, like 
filtering for percentages between 0 and 1.

Possible Follow-up Steps:More carefully clean the values of the variable DTOT so that the statistics computed do not include any
possible illegal values, and better handle missing data, e.g., by using a previous year's data or a rolling average of previous 
years' data as a proxy.
;
proc means min q1 median q3 max data=project1_analytic_file;
    class Gender;
    var DTOT;
run;

*
[Research Question 2] In different counties and same ethnics, which county has more females dropped out school and which county has
more males dropped out school?

Rationale:  This would help us to know which counties in California has higher female drop-out rate, which counties has higher male 
drop-out rate, which have not difference.

Methodology: Limitations:Compute five-number summaries by Gender variable Limitations: This methodology does not account for schools
with missing data, nor does it attempt to validate data in any way, like filtering for percentages between 0 and 1.

Possible Follow-up Steps: More carefully clean the values of the variable DTOT so that the statistics computed do not include any 
possible illegal values, and better handle missing data, e.g., by using a previous year's data or a rolling average of previous 
years' data as a proxy.
;
proc means min q1 median q3 max data=project1_analytic_file;
    class Gender;
    var DTOT;
run;

*
[Research Question 3] People always saying Asian parents more like to push their kids hard for education, So does Asian (Code2) has 
lower drop-out rate than other ethnics?

Rationale:  This would help us to know if Asian actually does has lower drop-out rate than other ethnic, a interesting research question 
to test this stereotype.

Methodology: Use PROC MEANS to compute the mean of students of a given ethnicity of Asian(Ethnic = 2) or others(Ethnic<2 or Ethnic>2)
by total dropout rate, and output the results to a temportary dataset. Use PROC SORT to extract and sort just the means of the temporary
dataset, and use PROC PRINT to print just the first three observations from the temporary dataset.

Limitations: This methodology does not account for districts with missing data, nor does it attempt to validate data in any way, 
like filtering for percentages between 0 and 1.

Possible Follow-up Steps: More carefully clean the values of the variables DTOT and ETOT so that the means computed do not include any 
possible illegal values.
;
DATA project_2;
  SET project1_analytic_file;
  IF (Ethnic < 2) AND (class Ethnic > 2) AND (class Ethnic = 2);
run;

proc means mean noprint data=project1_2;
    class Ethnic = 2;
    class Ethnic < 2;
    class Ethnic > 2;
    var DTOT;
    output out=project1_analytic_file_temp;
run;

proc sort data=project1_2(where=(_STAT_="MEAN"));
    by descending DTOT;
run;

proc print noobs data=project1_2(obs=3);
    class Ethnic = 2;
    class Ethnic < 2;
    class Ethnic > 2;
    var DTOT;
run;
