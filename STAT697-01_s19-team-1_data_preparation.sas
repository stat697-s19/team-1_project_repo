*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] 
[Dataset Description] 
[Experimental Unit Description] 
[Number of Observations]   
[Number of Features]
[Data Source] 
[Data Dictionary] 
[Unique ID Schema] 
;
%let inputDataset1DSN = ;
%let inputDataset1URL = ;
%let inputDataset1Type =;

* 
[Dataset 2 Name] 
[Dataset Description] 
[Experimental Unit Description] 
[Number of Observations]   
[Number of Features]
[Data Source] 
[Data Dictionary] 
[Unique ID Schema] 
;
%let inputDataset2DSN = ;
%let inputDataset2URL = ;
%let inputDataset2Type =;


* 
[Dataset 3 Name] 
[Dataset Description] 
[Experimental Unit Description] 
[Number of Observations]   
[Number of Features]
[Data Source] 
[Data Dictionary] 
[Unique ID Schema] 
;
%let inputDataset3DSN = ;
%let inputDataset3URL = ;
%let inputDataset3Type =;


* 
[Dataset 4 Name] 
[Dataset Description] 
[Experimental Unit Description] 
[Number of Observations]   
[Number of Features]
[Data Source] 
[Data Dictionary] 
[Unique ID Schema] 
;
%let inputDataset4DSN = ;
%let inputDataset4URL = ;
%let inputDataset4Type =;



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
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
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
%macro loadDatasets;
    %do i = 1 %to 4;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets;
