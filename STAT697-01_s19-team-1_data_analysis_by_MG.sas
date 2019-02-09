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

Limitations: There were no identifiable limitations. Again, all columns being 
used in this analysis were checked for missing values and unusual numeric 
values, which none were found.

;
