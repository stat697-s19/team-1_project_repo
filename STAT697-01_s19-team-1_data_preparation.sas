*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] Pokemon_GO_Stats

[Dataset Description] The information contained in this dataset include Pokemon 
Go attributes such as Base Stats, HP, Attach, Stamina, CP, etc.  

[Experimental Unit Description] Individual Pokemon attributes

[Number of Observations]  797

[Number of Features] 10

[Data Source] The file https://docs.google.com/spreadsheets/d/1UoCZzfsMNIhDW2YcR
q9nuzDrDiOvtJ6MeAbN0yvtPOQ/edit#gid=1171406684 was downloaded and edited to 
only contain pertinent columns related to the Pokemon Go mobile game and removed
special characters from the unique key in order to join the other data sources.

[Data Dictionary] https://docs.google.com/spreadsheets/d/1UoCZzfsMNIhDW2YcRq9n
uzDrDiOvtJ6MeAbN0yvtPOQ/edit#gid=1171406684

[Unique ID Schema] The column "Dex" is a unique key (not including "Mega" forms).

;
%let inputDataset1DSN = poke_stat;
%let inputDataset1URL = https://github.com/stat697/team-1_project_repo/blob/master/data/Pokemon_GO_Stats.xlsx;
%let inputDataset1Type =xlsx;

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
