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
Question: Within each Pokemon type, what are the top 5 strongest Pokemons based 
on combat power (CP)? 

Rationale: To determine which Pokemons are worth catching for battles. The 
combat power (CP) determines the strength of a Pokemon during battle.

Note: Rank order CP from Pokemon_GO_Stats dataset for each primary Pokemon type, 
i.e. fire, water, poison, rock, etc. and select the top 5 pokemon in each 
segment.  Some Pokemon may have combination of type, thusly we only look at the
primary type.

Limitations: Values of "Maximum CP" equal to zero should be excluded from this 
analysis, since they are potentially missing data values. 
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the least common Pokemon sightings in each Pokemon type?

Rationale: To determine which Pokemons are least frequently sighted. What makes
them rare? Basically are the rarest sighting the most desireable for battle?

Note: Firstly, full join sight_9_2_16 & sight_9_3_16 tables into one table.
Filter the the column continent using like statement "America%". Summarize by
"pokemonid" column then join to column "dex" in the poke_stat table. Summarize
the results by "type1" and "dex" columns to calculate "Average % of sightings."
Within each "type1" values, rank order "Average % of sightings" in descending 
order and print top 5 of each "type1".

Limitations: Values of "Average % of sightings" equal to zero should
be excluded from this analysis, since they are potentially missing data values.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Are the rarest sightings the most desireable Pokemons for battle?

Rationale: To answer the question what makes a Pokemon rare? Are they rarest
Pokemon sightings the most desirable for battle?

Note: The most desirable Pokemons are the ones with highest combat power (CP).
Therefore, we can use the table generated from research question 2 to also 
determine if there is a correlation between "Maximum CP" and 
"Average % of sightings". We can also build a simple regression model to test
whether "Maximum CP" can predict "Average % of sightings".

Limitations: Values of "Maximum CP" and  "Average % of sightings" equal to zero 
should be excluded from this analysis, since they are potentially missing data
values.
;

