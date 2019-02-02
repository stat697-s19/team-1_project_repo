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
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the least common Pokemon sightings in each Pokemon type?

Rationale: To determine which Pokemons are least frequently sighted. What makes
them rare? Basically are the rarest sighting the most desireable for battle?

Note: Calculate average % of sightings by Pokemons and rank order from 
sight_9_2_16 & sight_9_3_16 datasets.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Are the rarest sightings the most desireable Pokemons for battle?

Rationale: To answer the question what makes a Pokemon rare? Are they rarest
Pokemon sightings the most desirable for battle?

Note: Find a correlation between % of sightings and combat power (CP). Firstly,
full join sight_9_2_16 & sight_9_3_16.  Then join this table to Pokemon_GO_Stats
by pokemon dex. Summarize sightings rate and average CP by pokemon and run 
proc correlation.
;

