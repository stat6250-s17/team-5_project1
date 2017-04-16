
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

Methodology: 

Limitations:

Possible Follow-up Steps:
;

*
[Research Question 2] In different counties and same ethnics, which county has more females dropped out school and which county has
more males dropped out school?

Rationale:  This would help us to know which counties in California has higher female drop-out rate, which counties has higher male 
drop-out rate, which have not difference.

Methodology: 

Limitations:

Possible Follow-up Steps:
;

*
[Research Question 3] People always saying Asian parents more like to push their kids hard for education, So does Asian (Code2) has 
lower drop-out rate than other ethnics?

Rationale:  This would help us to know if Asian actually does has lower drop-out rate than other ethnic, a interesting research question 
to test this stereotype.

Methodology: 

Limitations:

Possible Follow-up Steps:
;

