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
Question: Which city has the highest number of pokemon appeared?

Rationale: We can find out in which city we are likely to catch a pokemon easily.

Note: This compares the column "city" from sighting_09_02_2016 and 
sighting_09_03_2016 to the column "pokemonId" from the same datasets.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the top 3 pokemons that have the highest attack scores in 
America?

Rationale: This helps us identify three pokemons that have strongest attack 
skill in America.

Note: This compares the column "Attack" from Pokemon_Go_Stats and the column 
"continent" from datasets sighting_09_02_2016 and sighting_09_03_2016.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the average Defense scores of pokemons that appeared in 
different weather?

Rationale: This shows the descriptive pokemon data of each weather   

Note: This compares the column "Defense" from Pokemon_Go_Stats and the column 
"weather" from datasets sighting_09_02_2016 and sighting_09_03_2016.
;
