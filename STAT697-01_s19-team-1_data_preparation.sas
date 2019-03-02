*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] Pokemon_GO_Stats

[Dataset Description] The information contained in this dataset include Pokemon 
Go attributes such as Base Stats, HP, Attach, Stamina, CP, etc.  

[Experimental Unit Description] Individual Pokemon attributes

[Number of Observations]  708

[Number of Features] 9

[Data Source] The file https://docs.google.com/spreadsheets/d/1UoCZzfsMNIhDW2YcR
q9nuzDrDiOvtJ6MeAbN0yvtPOQ/edit#gid=1171406684 was downloaded and edited to 
only contain pertinent columns related to the Pokemon Go mobile game, removed
special characters from the unique key in order to join the other data sources,
and removed spaces from column names.

[Data Dictionary] https://docs.google.com/spreadsheets/d/1UoCZzfsMNIhDW2YcRq9n
uzDrDiOvtJ6MeAbN0yvtPOQ/edit#gid=1171406684

[Unique ID Schema] The column "Dex" is a unique id that can be used to
join to other tables.

;
%let inputDataset1DSN = poke_stat;
%let inputDataset1URL = 
https://github.com/stat697/team-1_project_repo/blob/master/data/Pokemon_GO_Stats.xlsx?raw=true;
%let inputDataset1Type = xlsx;


* 
[Dataset 2 Name] pokemon_stats_detailed

[Dataset Description] The information contained in this dataset include Base 
Stats, Performance against Other Types, Height, Weight, Classification, Egg 
Steps, Experience Points, Abilities, and more.

[Experimental Unit Description] Individual Pokemon attributes and stats

[Number of Observations] 801

[Number of Features] 41

[Data Source] The file was downloaded from 
https://www.kaggle.com/rounakbanik/pokemon

[Data Dictionary] https://www.kaggle.com/rounakbanik/pokemon

[Unique ID Schema] The column "pokedex_number" is a unique id that can be used 
to join to other tables.
;
%let inputDataset2DSN = poke_stat_dtld;
%let inputDataset2URL = 
https://github.com/stat697/team-1_project_repo/blob/master/data/pokemon_stats_detailed.xlsx?raw=true;
%let inputDataset2Type = xlsx;


* 
[Dataset 3 Name] sightings_09_02_2016

[Dataset Description] Subset of the original source of Pokemon sightings on 
September 2, 2016. It contains coordinates, time, weather, population density, 
distance to pokestops/gyms and additional data about appearances.

[Experimental Unit Description] Each appearance of a Pokemon for the specified 
day.

[Number of Observations] 3,735

[Number of Features] 209

[Data Source] The file was downloaded from 
https://www.kaggle.com/semioniy/predictemall . The date of appearance was 
converted from datestamp to mm/dd/yyyy format using Excel substring & date 
functions to create a new column called "appeared_time", while only 
retaining appearances on 9/2/2016.

[Data Dictionary] https://www.kaggle.com/semioniy/predictemall

[Unique ID Schema] The column "_id" is a unique key, but joins to the other
tables using the "pokemonId" column.

;
%let inputDataset3DSN = sight_9_2_16;
%let inputDataset3URL = 
https://github.com/stat697/team-1_project_repo/blob/master/data/sightings_09_02_2016.xlsx?raw=true;
%let inputDataset3Type = xlsx;


* 
[Dataset 4 Name] sightings_09_03_2016

[Dataset Description] Subset of the original source of Pokemon sightings on 
September 3, 2016. It contains coordinates, time, weather, population density, 
distance to pokestops/ gyms and additional data about appearances.

[Experimental Unit Description] Each appearance of a Pokemon for the specified 
day.

[Number of Observations] 26,999

[Number of Features] 209

[Data Source] https://www.kaggle.com/semioniy/predictemall

[Data Dictionary] The file was downloaded from 
https://www.kaggle.com/semioniy/predictemall . The date of appearance was 
converted from datestamp to mm/dd/yyyy format using Excel substring & date 
functions to create a new column called "appeared_time", while only 
retaining appearances on 9/3/2016.

[Unique ID Schema] The column "_id" is a unique key, but joins to the other
tables using the "pokemonId" column.
;
%let inputDataset4DSN = sight_9_3_16;
%let inputDataset4URL = 
https://github.com/stat697/team-1_project_repo/blob/master/data/sightings_09_03_2016.xlsx?raw=true;
%let inputDataset4Type = xlsx;


*
[Dataset 5 Name] combo_sights

[Dataset Description] Combined data observations/rows from sight_9_2_16 & 
sight_9_3_16 into a single data set and also retained only the pertinent columns
needed for analysis

[Experimental Unit Description] Each appearance of a Pokemon for the specified 
day

[Number of Observations] 30,733

[Number of Features] 22

[Data Source] https://www.kaggle.com/semioniy/predictemall

[Data Dictionary] The original files were downloaded from 
https://www.kaggle.com/semioniy/predictemall. This data set was combined from
the sight_9_2_16 & sight_9_3_16 data sets in a Proc SQL Union All step.

[Unique ID Schema] The column "_id" is a unique key, but joins to the other
tables using the "pokemonId" column.
;
%let inputDataset5DSN = combo_sights;
%let inputDataset5URL = 
https://github.com/stat697/team-1_project_repo/blob/v0.3/data/combo_sight-edited.xlsx?raw=true;
%let inputDataset5Type = xlsx;


* set global system options;
options fullstimer;


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
    %do i = 1 %to 5;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets;



proc sql;
    * remove rows with missing unique id components, or with unique ids that
       do not correspond to dex after executing this query, the new
       dataset poke_stat_final will have no duplicate/repeated unique id values,
       and all unique id values will correspond to our experimental units of
       interest this means the column dex in poke_stat is guaranteed to form a 
       composite key;
    create table poke_stat_final as
        select
            *
        from
            poke_stat
        where
            not(missing(dex)) 
        order by
            dex
    ;

    *the combined dataset contains 30,733 rows which equals the total number of 
     rows from sight_9_2_16 (3,734) and sight_9_3_16 (26,999) when combined. 
     this shows that no rows were lost during the union all process;
    create table combo_sights as
        select 
            _id
            ,pokemonId
            ,latitude	
            ,longitude
            ,appeared_time
            ,appearedTimeOfDay
            ,appearedHour	
            ,appearedMinute
            ,city	
            ,continent	
            ,weather	
            ,temperature	
            ,windSpeed	
            ,windBearing	
            ,pressure	
            ,weatherIcon
            ,population_density	
			,closetowater
            ,urban	
            ,suburban	
            ,midurban	
            ,rural	
            ,gymDistanceKm
        from 
            sight_9_2_16
        union all
        select 
            _id
            ,pokemonId
            ,latitude	
            ,longitude
            ,appeared_time
            ,appearedTimeOfDay
            ,appearedHour	
            ,appearedMinute
            ,city	
            ,continent	
            ,weather	
            ,temperature	
            ,windSpeed	
            ,windBearing	
            ,pressure	
            ,weatherIcon
            ,population_density	
			,closetowater
            ,urban	
            ,suburban	
            ,midurban	
            ,rural	
            ,gymDistanceKm
        from 
            sight_9_3_16
        order by 
            pokemonId
            ,_id
    ;

    /* remove rows with missing unique id components, or with unique ids that
       do not correspond to pokedex_number; after executing this query, the 
       new dataset poke_stat_dtld_final will have no duplicate/repeated unique
       id values and all unique id values will correspond to our experimental 
       units of interest; this means the column pokedex_number in 
       poke_stat_dtld is guaranteed to form a composite key */
    create table poke_stat_dtld_final as
        select
            *
        from
            poke_stat_dtld
        where
            /* remove rows with missing unique id value components */
            not(missing(pokedex_number)) 
        order by 
            pokedex_number
    ;

    *Create final analytic file for analysis;
    create table poke_analytic_file as
        select
            C._id as sighting_id
			,C.pokemonID
            ,C.continent
            ,C.city
            ,C.closetowater
            ,C.urban
            ,C.suburban
            ,C.midurban
            ,C.rural
            ,C.weather
            ,C.temperature
            ,C.windspeed
            ,C.windbearing
            ,C.pressure
			,A.*
			,B.*
        from 
            combo_sights as C
        left join 
            (select 
                dex
                ,species
                ,type1
                ,stamina
                ,attack
                ,defense
                ,maxCP
            from poke_stat_final) as A
            on A.dex = C.pokemonID
        left join
            (select
                 pokedex_number
                 ,base_egg_steps
                 ,capture_rate
                 ,experience_growth
                 ,is_legendary
                 ,speed
             from poke_stat_dtld_final) as B
             on B.pokedex_number = C.pokemonID
    ;
quit;

