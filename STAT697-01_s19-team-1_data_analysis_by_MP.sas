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
Question: What are the top 5 strongest Pokemons? 

Rationale: To determine which Pokémons are worth catching.

Note: Rank order CP from pokemon_stat1 dataset. 
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the most common Pokemon sightings?

Rationale: To determine which Pokémons are frequently sighted.

Note: Calculate average % of sightings by Pokemons and rank order from 
pokemon_sightings_20160805 and pokemon_sightings_20160806 datasets.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Can CP predict Pokemon sightings? 

Rationale: To determine the likelihood of strong Pokemon sightings.

Note: Build a simple linear regression model using CP as independent variable 
and sightings as Y dependent variable.]
;

