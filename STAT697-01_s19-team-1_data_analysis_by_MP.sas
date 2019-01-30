*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file;
%include '.\STAT697-01_s19-team-1_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: 

Rationale:

Note: 
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: 

Rationale:

Note: 
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: 

Rationale:

Note: 
;

