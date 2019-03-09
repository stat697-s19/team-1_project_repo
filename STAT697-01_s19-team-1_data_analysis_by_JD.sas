*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file generating "analytic file" dataset poke_analytic_file, from 
which all data analyses below begin;
%include '.\STAT697-01_s19-team-1_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left  
'Question: Which city has the highest number of pokemon appeared?'
;

title2 justify=left
'Rationale: We can find out in which city we are likely to catch a pokemon easily.'
;

footnote1 justify=left
"From the output we can see that New York has the highest toatal pokemon number, whichi is 4792"
;

*
Note: This compares the column "city" from sighting_09_02_2016 and 
sighting_09_03_2016 to the column "pokemonId" from the same datasets.

Limitations: There were no limitations identified due to the fact there were no 
missing values in the columns from the tables being referenced in this analysis.

Methodology: Use GROUP BY clause in proc sql to output the total number of 
pokemon by city, and then use ORDER BY to sort the Total_pokemon variable in 
descending order.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data.
;

proc sql;
	select 
		city
		, count(pokemonId) 
		as Total_pokemon
	from 
		combo_sights
	group by 
		city
	order by 
		Total_pokemon desc
	;
quit;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What is the top 3 pokemons that have the highest attack scores in America?'
;

title2 justify=left
'Rationale: This helps us identify three pokemons that have strongest attack skill in America.'
;

footnote1 justify=left
"From the output, the pokemon dex 149 and 136 in America have highest attack score of 250 and 236, respectively"
;

*
Note: This compares the column "Attack" from Pokemon_Go_Stats and the column 
"continent" from datasets sighting_09_02_2016 and sighting_09_03_2016.

Limitations: There were no limitations identified due to the fact there were no 
missing values in the columns from the tables being referenced in this analysis.

Methodology: Use WHERE clause in proc sql to constrain the continent value to
"America", and then use ORDER BY to sort the value of attack in descending 
order.Use outobs= to limit the number of output.Use PROC GLM for modeling.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data.
;

proc sql outobs=3;
	select
		dex
		,attack
		,continent
	from
		poke_analytic_file
	where
		continent = 'America'
	order by
		attack desc
	;
quit;

title3 justify=left
'Explore relationship between Attack score and Defense score'
;

footnote1 justify=left
"From the ANOVA table, we find that the p value is very small, indicating that there is a relationship between defense score and attack score"
;

*Use PROC GLM to develop a regression model for analyzing the relationship between 
values of defense and attack;

proc glm
	data= poke_analytic_file
	;
	model 	
		attack = defense/ soluiton
	;
run;
		
* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What is the average Defense scores of pokemons that appeared in different species?'
;

title2 justify=left
'Rationale: This shows the descriptive pokemon data of each species'
;

footnote1 justify=left
"From the new table, we can notice that Blastoise has the highest average defense score of 222."
;

*
Note: This compares the column "Defense" from Pokemon_Go_Stats and the column 
"species" from datasets sighting_09_02_2016 and sighting_09_03_2016.

Limitations: There were no limitations identified due to the fact there were no 
missing values in the columns from the tables being referenced in this analysis.

Methodology: Use PROC SQL to create a table containing the average values of 
defense scores for each species, and then use PROC SGPLOT to plot a bar graph
to visualize the result.

Followup Steps: Try other methods of data visualization that allows us to see
the results and generate insights easier.
;

proc sql;
	create table
		  	poke_analytic_file_q3
	as
		select 
			avg(defense) as Avg_Defense
			,species
		from 
			poke_analytic_file
		group by
	 		species
		order by
			Avg_Defense desc
	;
quit;

title3 justify=left
'Make the bar graph of average defense score from different species'
;

footnote1 justify=left
"From the bar graph, we can see the order of average defense scores more clearly."
;

footnote2 justify=left
"However, since there are too many species, the x-axie lables are hard to see."
;

proc sgplot
	data= poke_analytic_file_q3
	;
	vbar 
		species/ response= Avg_Defense
    ;
run;
		
* clear titles/footnotes;
title;
footnote;
