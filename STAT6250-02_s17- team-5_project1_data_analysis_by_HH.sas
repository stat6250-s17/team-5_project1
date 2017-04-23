*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding free/reduced-price meals at CA public K-12 schools

Dataset Name: FRPM1516_analytic_file created in external file
STAT6250-02_s17-team-0_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-02_s17-team-5_project1_data_preparation.sas';


*
Research Question: which ethnic has the highest mean value of ratio of dropouts?

Rationale: This question will get the relationship between ethnic and the ratio of dropouts.

Methodology: First of all, using PROC MEANS to calculate the average ratio of each ethnic. Then, Using PROC 
            SORT to figure out the highest ethnic that has the highest drop out rate.

Limitations:  There is code 0(not reported) which can not be calculate. And code7,code9 are not parallel with 
            code 1-6.

Possible Follow-up Steps: none.


*
Research Question: Does male has higher dropout rate than female's?

Rationale: This would figure out the relationship between gender and dropout rate.

Methodology: compute mean value of dropout rate of male and it of female.

Limitations: the samples of male and samples of female is different. 

Possible Follow-up Steps: none.


*
Research Question: Does the class level has great affect with the dropout rate?

Rationale: This would help to figure out which class is most likely to drop out from school.

Methodology: Calculate the average dropout rate for each grade， then compare the dropout rate.

Limitations: be calful other the effect of other variables,like ETOT.

Follow-up Steps: We may fix Correlation coefficient by different ways.

