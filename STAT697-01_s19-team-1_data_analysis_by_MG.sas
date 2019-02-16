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
Question: How often (count and percentage of total sightings) did Pokemon with 
the potential to have a max combat power (CP) of at least 1200 appear for each 
type of Pokemon (i.e. fire, water, etc.) between the dates of 9/2/2016 and 
9/3/2016 in the United States?

Rationale: A key aspect of Pokemon Go is to capture and assemble a balanced 
team of Pokemon that you can use to take over gyms by fighting other Pokemon. 
One of the primary metrics to assess if you captured a strong Pokemon is combat 
power (cp). The higher the CP, the better suited it is for battle. Based on 
my experience, a respectable CP starts around 1200. This will help assess how
frequent or rare a Pokemon with the potential to have a 1200 CP occurred during
the selected timeframe.

Note: This analysis will require me to union the sight_9_2_16 & sight_9_3_16
datasets into a single table. From this combined table, I will utilize the 
"continent" column to filter for only "America" and take the values
from the "pokemonid" column as the key to join to the column "dex" in the 
poke_stat table. I will then group findings by Pokemon and type by using the 
"species" and "type1" columns in the poke_stat dataset and filter by "maxcp" to 
be equal or greater than 1200.

Limitations: There were no limitations identified due to the fact there were no 
missing values in the columns from the tables being referenced in this analysis.
;

proc sql;
    create table cnt_type_max_cp as
        select 
           distinct type1
           ,count(*) as cnt_sight
           ,(count(*)/(
                select 
                    count(*) 
                from 
                    pokemon_stats_all_v2 
                where 
                    maxcp>=1200
                    and continent="America")) 
           as pcnt_sght_1200 format = percent8.
           ,(count(*)/(
                select 
                    count(*) 
                from 
                    pokemon_stats_all_v2))
           as pcnt_ttl_sght format = percent7.6
        from
            pokemon_stats_all_v2
        where
            maxcp>=1200
            and continent="America"
        group by
            type1
        ;
quit;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What were the average weather conditions when Pokemon with a 
potential max CP of 1200 or greater were sighted during 9/2/2016 through 
9/3/2016 in the United States?

Rationale: When the game was launched, it was rumored that certain Pokemon
only appeared when real world conditions were met like a specific time of day 
and weather conditions. This will help determine if some Pokemon can only be 
seen or are more prevalent during specific weather conditions.

Note: In addition to the steps and specified columns previously mentioned, I 
will also need to take the average of each of the following columns: 
"temperature", "windspeed", "windbearing", & "pressure".

Limitations: All columns being used in this analysis contained no missing values 
and no suspicious numeric values were identified using basic descriptive 
statistics methods. The only questionable data point is the accuracy of the 
weather metrics, but it will be difficult to QA for accuracy.
;

proc sql;
    create table cnt_type_whtr as
	    select 
	        distinct type1
	        ,count(type1) as count
            ,avg(temperature) as temp format = 5.2
            ,min(temperature) as min_temp format = 5.2
            ,max(temperature) as max_temp format = 5.2
            ,avg(windSpeed) as wnd_spd format = 5.2
            ,min(windSpeed) as min_spd format = 5.2
            ,max(windSpeed) as max_spd format = 5.2
            ,avg(windBearing) as wnd_bear format = 6.2
            ,min(windBearing) as min_bear format = 6.2
            ,max(windBearing) as max_bear format = 6.2
            ,avg(pressure) as pressure format = 7.2
            ,min(pressure) as min_presre format = 7.2
            ,max(pressure) as max_presre format = 7.2
	     from
	        pokemon_stats_all_v2
	     where
	        maxcp>=1200
	        and continent="America"
         group by
            type1
       ;
quit;

*Aditional analysis can be done by counting the nominal weather type for each
type of Pokemon when they appear, but does not provide additional insight after
initial pass;

proc sql noprint;
    select 
        distinct weather into :iterationList separated by "|"
    from
        pokemon_stats_all_v2;
quit;

%macro weather(
    column
);

%let numberOfIterations = %sysfunc(countw(&iterationList.,|));

%do i = 1 %to %eval(&numberOfIterations.);
%let currentIteration = %scan(&iterationList.,&i.,|);
    proc sql; 
        create table &currentIteration. as
            select 
                distinct type1
                ,count(weather) as &currentIteration.
            from
                pokemon_stats_all_v2
            where
                maxcp>=1200
                and continent="America"
                and &column. = "&currentIteration."
            group by 
                type1
                ,weather
            ;
            quit
            ;

    proc sort data = &currentIteration.;
        by type1;
    run; 

/* merge all weather tpye data sets to form singular weather data set
    data cnt_type_whtr_1;
        merge &currentIteration. cnt_type_whtr;
	run;
*/

%end;
%mend;
%weather(weather);

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which cities in the United States during 9/2/2016 to 9/3/2016 saw the 
most (count and percentage of total sightings) Pokemon with a potential max CP 
of 1200 or greater for each type?


Rationale: Geography influences the types of Pokemon that spawn in an area. For 
example, beaches typically see a variety of water based Pokemon. A person would
have to travel to find a specific type of Pokemon based on the region. This 
analysis would help identify where certain Pokemon with a potential max CP of 
1200 or greater can be found.


Note: In addition to the steps and specified columns previously mentioned in 
the first research question, I will also need to use the "city" column in the 
combined sightings table.

Limitations: There were no identifiable limitations. All columns being used in 
this analysis were checked for missing values and unusual numeric values, 
which none were found.

;

proc sql;
    create table cnt_type_loc as
	    select 
	        distinct type1
            ,city
            ,count(type1) as ttl_count
            ,sum(closetowater) as water_prox
            ,sum(urban) as urban
            ,sum(suburban) as suburb
            ,sum(rural) as rural
         from
            pokemon_stats_all_v2
         where
            maxcp>=1200
            and continent="America"
         group by
            type1 
            ,city
         order by 
            type1
            ,ttl_count desc
        ;
quit;
