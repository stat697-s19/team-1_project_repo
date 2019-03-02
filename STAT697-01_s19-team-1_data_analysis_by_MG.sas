*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file;
%include '.\STAT697-01_s19-team-1_data_preparation.sas';

%let condition =  maxcp>=1200 and continent='America';
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: How often (count and percentage of total sightings) did Pokemon with 
the potential to have a max combat power (CP) of at least 1200 appear for each 
type of Pokemon (i.e. fire, water, etc.) between the dates of 9/2/2016 and 
9/3/2016 in North America?

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

title1 justify=left
'Question: How often did Pokemon with the potential to have a max combat power 
 (CP) of at least 1200 appear for each type of Pokemon between the dates of 
 9/2/2016 and 9/3/2016 in the North America.'
;

title2 justify=left
'Rationale: A key aspect of Pokemon Go is to capture and assemble a balanced 
 team of Pokemon that you can use to take over gyms by fighting other Pokemon. 
 One of the primary metrics to assess if you captured a strong Pokemon is combat 
 power (cp). The higher the CP, the better suited it is for battle. Based on 
 my experience, a respectable CP starts around 1200.'
;

footnote1 justify=left
'Normal, Fire, & Fairy made up 62% of the sightings with a 1200 max CP potential 
 during these two days. These 3 types with a 1200 max CP potential only made up 
 3% of the total sightings.'
;

footnote2 justify=left
'The 3 rarest type of Pokemon with a potential of a 1200 max CP were Dragons, 
 Ghosts, and Electric. Combined they only made up less than 3% of Pokemon
 sightings with a max CP of 1200.'
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
                    poke_analytic_file 
                where 
                    maxcp>=1200
                    and continent="America")) 
           as pcnt_sght_1200 format = percent8.
           ,(count(*)/(
                select 
                    count(*) 
                from 
                    poke_analytic_file))
           as pcnt_ttl_sght format = percent7.6
        from
            poke_analytic_file
        where
            &condition.
        group by
            type1
        ;
quit;

proc print data=cnt_type_max_cp; 
run;

title;
footnote;

title1 
'Frequency of Appearance by Pokemon Type with Max CP Potential >= 1200 by Continent';

title2 justify=left 
'This chart is a visual representation of the previous table, but also includes 
 other continents for comparison.';

footnote1 justify=left
'Normal type Pokemon had the most appearances with a Max CP of at least 1200 on
 all continents.';

footnote2 justify=left
'The second and third most frequently spotted Pokemon with the criteria above 
 varies by continent.';
;

proc sgplot data=poke_analytic_file (where=(maxcp>=1200));
    vbar type1/group=Continent groupdisplay=cluster categoryorder=respdesc;
    xaxis display=(NOLABEL);
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What were the average weather conditions when Pokemon with a 
potential max CP of 1200 or greater were sighted during 9/2/2016 through 
9/3/2016 in North America?

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

title1 justify=left
'Question: What were the average weather conditions when Pokemon with a 
 potential max CP of 1200 or greater were sighted during 9/2/2016 through 
 9/3/2016 in the North America?'
;

title2 justify=left
'Rationale: When the game was launched, it was rumored that certain Pokemon
 only appeared when real world conditions were met like a specific time of day 
 and weather conditions. This will help determine if some Pokemon can only be 
 seen or are more prevalent during specific weather conditions.'
;

footnote1 justify=left
'At first glance, temperature appears to have any distinguishable affects on
 Pokemon appearances based on type.'
;

footnote2 justify=left
'For example, average temperature for ghost and ice type was lower compared to
 other tpyes, which aligns with the game environments where these Pokemone were
 found.'
;

footnote3 justify=left
'On the other hand, rock and fire types had the highest average temperature when
 they were sighted.'
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
            poke_analytic_file
         where
             &condition.
         group by
            type1
       ;
quit;

proc print data = cnt_type_whtr;
run;

title;
footnote;

title1 justify=left;
'There can be some validity to the theory that temperature can influence the 
 type of Pokemon based on weather and/or temperature by looking at some of the
 average temperature during sightings by type.'
;

title2 justify=left;
'As an additional analysis, a TTest was conducted between Fire and Ice type 
 Pokemon and the mean temperature of the two groups when they appeared to 
 determine if there is some validity to the claim above.'
;

footnote1 justify=left
'The p-value was <.0001, meaning that the mean difference between the two groups
 is significant. This is strong evidence that temperature is a factor when Ice 
 type Pokemon appear in colder weather and vice versa for Fire type in warmer
 temperatures.'
;

footnote2 justify=left
'An increase sample size of Ice type Pokemon would help future analysis and 
 additional comparisons of the mean temperature of other types of Pokemon need 
 to conducted for increase credibility to the hypothesis that certain types of
 Pokemon are more likely to appear in certain weather conditions and 
 temperature.'
;

proc ttest data=poke_analytic_file (where=(&condition. and type1 in ('Fire', 'Ice')));; 
     class type1; 
     var temperature; 
run;

title;
footnote;

*Aditional analysis can be done by counting the nominal weather type for each
type of Pokemon when they appear, but does not provide additional insight after
initial pass;
/*
	proc sql noprint;
	    select 
	        distinct weather into :iterationList separated by "|"
	    from
	        poke_analytic_file;
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
	                poke_analytic_file
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
*/
/* merge all weather tpye data sets to form singular weather data set
    data cnt_type_whtr_1;
        merge &currentIteration. cnt_type_whtr;
	run;
*/
/*
	%end;
	%mend;
	%weather(weather);
*/
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which cities in the North America during 9/2/2016 to 9/3/2016 saw the 
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

title1 justify=left
'Question: Which cities in the North America during 9/2/2016 to 9/3/2016 saw the 
most Pokemon with a potential max CP of 1200 or greater for each type?'
;

title2 justify=left
'Rationale: Geography influences the types of Pokemon that spawn in an area. For 
example, beaches typically see a variety of water based Pokemon. This analysis 
would help identify where certain Pokemon with a potential max CP of 1200 or 
greater can be found.'
;

footnote1 justify=left
"New York seemed to have the most activity for each type of Pokemon with a 
 potential max CP of 1200. A possibly reason for this is due to New York's 
 diverse terrain (i.e. close to water, large urban park, etc) and population
 density."
;

footnote2 justify=left
'Interestingly, 40% of dragon (extremely rare) sightings occurred in New 
 York during these 2 days in North America.'
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
            poke_analytic_file
         where
             &condition.
         group by
            type1 
            ,city
         order by 
            type1
            ,ttl_count desc
        ;
quit;

proc print data=cnt_type_loc;
run;

title;
footnote;
