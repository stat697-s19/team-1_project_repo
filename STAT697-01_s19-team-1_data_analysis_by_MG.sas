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

Methodology: The initial approach was to use a proc sql to group by and display 
distinct Pokemon types and count the number of sightings with a where clause 
to limit ouput based on max CP greater than or equal to 1200 and appeareances
only from 'America'. The two remaining columns were percentages calculated by
taking the count of sightings that met the where criteria divided by the 
results of two inline queries that returns the total count of sigthings and
sightings of Pokemon with CP > 1200 from 'America' to get the percentage. The
second and current approach uses the proc freq step counting the appearances by
Pokemon type with the same where condition above ordered by frequency in list 
format. 

Followup Steps: Create the same frequency table for all continents to determine 
if the percentage and proportion of Pokemon sightings with a max CP of 1200 is
similar to other continents. This can help players from around the world 
identify if they have the same chances of seeing the various types of Pokemon. 
;

title1 justify=left
'Question: How often did Pokemon with the potential to have a max combat power (CP) of at least 1200 appear for each type of Pokemon between the dates of 9/2/2016 and 9/3/2016 in the North America?'
;

title2 justify=left
'Rationale: A key aspect of Pokemon Go is to capture and assemble a balanced team of Pokemon that you can use to take over gyms by fighting other Pokemon. One of the primary metrics to assess if you captured a strong Pokemon is combat power (CP). The higher the CP, the better suited it is for battle. Based on my experience, a respectable CP starts around 1200.'
;

footnote1 justify=left
'Normal, Fire, & Fairy made up 61% of the sightings with a 1200 max CP potential during these two days.'
;

footnote2 justify=left
'The 3 rarest type of Pokemon with a potential of a 1200 max CP were Dragons, Ghosts, and Ground. Combined they only made up less than 2% of Pokemon sightings with a max CP of 1200.'
;

proc freq data=poke_analytic_file (where =(&condition.) 
    rename=(type1 = Pokemon_type))order=freq;
        table Pokemon_type/list out=type_cnt;
run;

/*

Alternate report view using proc report, but proc freq step provides sufficient
data and desired output without having to reformat.

proc report data=type_cnt;
run;

*/

title;
footnote;

title1 
'Frequency of Appearance by Pokemon Type with Max CP Potential >= 1200 by Continent';

title2 justify=left 
'This chart is a visual representation of the previous table, but also includes other continents for comparison.';

footnote1 justify=left
'Normal type Pokemon had the most appearances with a Max CP of at least 1200 on all continents.';

footnote2 justify=left
'The second and third most frequently spotted Pokemon with the criteria above varies by continent.';
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

Methodology: Use a proc sql step with the average, min, and max functions to 
calculate the descriptive statistics for temperature, wind speed, wind bearing, 
and pressure for sightings in 'America' and max CP > 1200. Reformatted the
output to only display two decimal points.

Followup Steps: Identify alternate SAS steps that can perforn this analysis with
fewer lines of code and subsequently use less system bandwidth such as a modified 
proc freq or mean step. In addition, more advanced analysis such as a
classification decision tree using temperature, wind speed, bearing, and pressure
as independent predictors to identify which of these predictors are statistically 
significant in identifying when certain Pokemon type appear based on the weather 
data points provided in this data set.

;

title1 justify=left
'Question: What were the average weather conditions when Pokemon with a potential max CP of 1200 or greater were sighted during 9/2/2016 through 9/3/2016 in the North America?'
;

title2 justify=left
'Rationale: When the game was launched, it was rumored that certain Pokemon only appeared when real world conditions were met like a specific time of day and weather conditions. This will help determine if some Pokemon can only be seen or are more prevalent during specific weather conditions.'
;

footnote1 justify=left
'At first glance, temperature appears to have some distinguishable affects on Pokemon appearances based on type.'
;

footnote2 justify=left
'For example, average temperature for ghost and ice type were lower compared to other tpyes, which aligns with the game environments where these Pokemone were found.'
;

footnote3 justify=left
'On the other hand, rock and fire types had the highest average temperature when they were sighted, which also aligns with in-game scenarios.'
;

proc sql;
    create table cnt_type_whtr as
        select
            distinct type1
            ,count(type1) as type_cnt
            ,avg(temperature) as temp format = 5.2
            ,min(temperature) as min_temp format = 5.2
            ,max(temperature) as max_temp format = 5.2
            ,avg(windSpeed) as wnd_spd format = 5.2
            ,min(windSpeed) as min_wnd_spd format = 5.2
            ,max(windSpeed) as max_wnd_spd format = 5.2
            ,avg(windBearing) as wnd_bear format = 6.2
            ,min(windBearing) as min_wnd_bear format = 6.2
            ,max(windBearing) as max_wnd_bear format = 6.2
            ,avg(pressure) as pressure format = 7.2
            ,min(pressure) as min_presre format = 7.2
            ,max(pressure) as max_presre format = 7.2
         from
            poke_analytic_file
         where
             &condition.
         group by
            type1 
         order by
            type_cnt DESC
       ;
quit;

proc print data = cnt_type_whtr;
run;

title;
footnote;

title1 justify=left
'There can be some validity to the theory that temperature can influence the type of Pokemon based on weather and/or temperature by looking at some of the average temperatures when certain types appeared.'
;

title2 justify=left
'As an additional analysis, a TTest was conducted between Fire and Ice type Pokemon and the mean temperature of the two groups when they appeared to determine if there was some validity to the claim above and statistically significant.'
;

footnote1 justify=left
'The p-value was <.0001, meaning that the mean difference between the two groups is significant. This is strong evidence that temperature is a factor when Ice type Pokemon appear in colder weather and vice versa for Fire type in warmer temperatures.'
;

footnote2 justify=left
'An increase sample size of Ice type Pokemon and additional mean temperature data points of other types of Pokemon would provide more support to prove or disprove the hypothesis that certain types of Pokemon are more likely to appear in certain weather conditions and temperature.'
;

proc ttest data=poke_analytic_file (where=(&condition. 
	and type1 in ('Fire', 'Ice')));
        class type1; 
        var temperature; 
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which cities in the America continent in this data set during 9/2/2016 
to 9/3/2016 saw the most Pokemon with a potential max CP of 1200 or greater for 
each type?

Rationale: Geography influences the types of Pokemon that spawn in an area. For 
example, beaches typically see more water based Pokemon. A person would have to 
travel to find a specific type of Pokemon based on the region. This analysis 
would help identify where certain Pokemon with a potential max CP of 1200 or 
greater can be found.

Note: In addition to the steps and specified columns previously mentioned in 
the first research question, I will also need to use the "city" column in the 
combined sightings table.

Limitations: There were no identifiable limitations. All columns being used in 
this analysis were checked for missing values and unusual numeric values, 
which none were found.

Methodology: I created a Proc SQL step that sums the number of appearances and 
type of areas (proximity to water, urban, suburb, and rural) by Pokemon type, 
and city. The output is a list where end users can look for a specific type
of Pokemon and identify the cities in which they appear the most with additional
details of the type of areas within the city they appeared in. 

Followup Steps: A next step could be to drill down on more specific cities within
the United States and develop a logistic regression model for select cities
with sufficient volume where the output is a binary outcome if a specific Pokemon
type will appear based on specific variables and temperature. This approach will
also help identify which independent variables are statistically signficant to 
the model.
;

title1 justify=left
'Question: Which cities in the North America during 9/2/2016 to 9/3/2016 saw the most Pokemon with a potential max CP of 1200 or greater for each type?'
;

title2 justify=left
'Rationale: Geography influences the types of Pokemon that spawn in an area. For example, beaches typically see a variety of water based Pokemon. This analysis would help identify where certain Pokemon with a potential max CP of 1200 or greater can be found.'
;

footnote1 justify=left
"New York seemed to have the most activity for each type of Pokemon with a potential max CP of 1200. A possibly reason for this is due to New York's diverse terrain (i.e. close to water, large urban park, etc) and population density."
;

footnote2 justify=left
'Interestingly, 40% of dragon (extremely rare) sightings occurred in New York during these 2 days in North America.'
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
