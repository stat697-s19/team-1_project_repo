*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file generating "analytic file" dataset poke_analytic_file
from which all data analyses below begin;
%include '.\STAT697-01_s19-team-1_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1 justify=left
'Question: Within each Pokemon type, what are the top 5 strongest Pokemons based on combat power (CP)?' 
;

title2 justify=left
'Rationale: To determine which Pokemons are worth catching for battles. The combat power (CP) determines the strength of a Pokemon during battle.'
;

footnote1 justify=left 
'There are Pokemons that are have never been sighted. Thusly, we adjust our research question to Top 5 within each Type that have been sighted in America." 
;
footnote2 justify=left
'Within each type, the Pokemon with highest CP were also most sighted and vice versa.'
;
 
*
Note: Rank order CP from Pokemon_GO_Stats dataset for each primary Pokemon type, 
i.e. fire, water, poison, rock, etc. and select the top 5 pokemon in each 
segment.  Some Pokemon may have combination of type, thusly we only look at the
primary type.

Limitations: Values of "Maximum CP" equal to zero should be excluded from this 
analysis, since they are potentially missing data values. The sights data is
only based on two days data.
;

proc sql;
    create table pokemon_analysis as
    select 
        dex       
        ,aa.type1 
        ,species  
        ,maxcp    
        ,n_pokemon
        ,sight_type
        ,count(*) as Sightings
        ,calculated sightings/sight_type as sight_type_pct format = percent15.2
    from 
        poke_analytic_file aa
	left join
	(select 
             type1
	     ,count(distinct dex) as n_pokemon
             ,sum(case when continent = "America" then 1
		      else 0 end) as sight_type
	from  
	    poke_analytic_file
	group by 
	    type1) bb
	on aa.type1=bb.type1
    where 
        continent = "America"
    group by 
        dex
        ,aa.type1
        ,species
        ,maxcp
	,n_pokemon
	,sight_type
    order by 
        aa.type1
        ,maxcp desc
    ;
quit;

/*
title "Total Sightings in America";
proc sql;
    select 
        count(*) as sightings format = comma10.0
    from 
        poke_analytic_file
    where 
        continent = "America"
    group by continent
    ;
quit;
*/
data type_top5 ;
    label
        type1     = "Type"
        n_pokemon = "# of Unique Pokemon"
        seq_id    = "Rank"
        dex       = "Pokemon ID"
        species   = "Pokemon"
        maxcp     = "Max CP"
        sightings = "# of Sightings"
        sight_type_pct="% of Type"
    ;
    set 
        pokemon_analysis
    ;
    by 
        type1
    ;
    if 
        first.type1 then seq_id=0
    ;
    seq_id+1
    ;
    if 
        seq_id<=5 then output 
    ;
    format
        sight_type_pct percent15.2	    
	maxcp comma10.0
    ;
run;

proc print 
    data = type_top5 noobs label
    ;
    var 
        type1 
	n_pokemon 
	seq_id 
	species 
	maxcp 
	sightings 
	sight_type_pct
    ;
run;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What are the least common Pokemon sightings in each Pokemon type?'
;

title2 justify=left
'Rationale: To determine which Pokemons are least frequently sighted. What makes them rare? Basically are the rarest sighting the most desireable for battle?'
;

footnote1 justify=left
'There are Pokemons that are have never been sighted. Thusly, we adjust our research question to Top 5 rarest sightings in America for each Type.'
;

footnote2 justify=left
'Within each type, the Pokemon with highest CP were also most sighted and vice versa."
;
 
*
Note: Firstly, full join sight_9_2_16 & sight_9_3_16 tables into one table.
Filter the the column continent using like statement "America%". Summarize by
"pokemonid" column then join to column "dex" in the poke_stat table. Summarize
the results by "type1" and "dex" columns to calculate "Average % of sightings."
Within each "type1" values, rank order "Average % of sightings" in descending 
order and print top 5 of each "type1".

Limitations: Values of "Average % of sightings" equal to zero should
be excluded from this analysis, since they are potentially missing data values.
;
proc sort 
    data = type_top5
    ; 
    by 
        type1 
        sightings
    ; 
run;

data type_top5 ;
    label
        type1     = "Type"
        n_pokemon = "# of Unique Pokemon"
        seq_id    = "Rank"
        dex       = "Pokemon ID"
        species   = "Pokemon"
        maxcp     = "Max CP"
        sightings = "# of Sightings"
        sight_type_pct="% of Type"
    ;
    set 
        type_top5
    ;
    by 
        type1
    ;
    if 
        first.type1 then seq_id=0
    ;
    seq_id+1
    ;
    if 
        seq_id<=5 then output 
    ;
    format
        sight_type_pct percent15.2
        maxcp comma10.0
    ;
run;

proc print 
    data = type_top5 noobs label
    ;
    var 
        type1 
	n_pokemon 
	seq_id 
	species 
	maxcp 
	sightings 
	sight_type_pct
    ;
run;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Are the rarest sightings the most desireable Pokemons for battle?'
;

title2 justify=left
'Rationale: To answer the question what makes a Pokemon rare? Are they rarest Pokemon sightings the most desirable for battle?'
;

footnote1 justify=left
'Assuming the variables MaxCP and Sightings are normally distributed, the above inferential analysis shows that there is a fairly weak negative correlation between MaxCP and Sightings.'
;
 
footnote2 justify=left
'Sightings and Max CP have statistical insignificant negative linear relationship. As assume, the rarest sighted Pokemons have stronger maximum combat power.  However, Max CP can only explain 13.8% of the 
 variability in sightings (r=0.1385,p<0.0001). In addition, the assumptions of constant variance and residual normality of a simple linear regression are not met.  Therefore, MaxCP alone cannot predict sightings.'
;

*
Note: The most desirable Pokemons are the ones with highest combat power (CP).
Therefore, we can use the table generated from research question 2 to also 
determine if there is a correlation between "Maximum CP" and 
"Average % of sightings". We can also build a simple regression model to test
whether "Maximum CP" can predict "Average % of sightings".

Limitations: Values of "Maximum CP" and  "Average % of sightings" equal to zero 
should be excluded from this analysis, since they are potentially missing data
values.
;

proc corr
    pearson spearman fisher (biasadj = no) nomiss
    data = pokemon_analysis
    ;
    var 
        maxcp
        sightings
    ;
run;

title1 justify=left
'Plot illustrating the negative correlation between MaxCP and Sightings.'
;
footnote1 justify=left
'In the above plot, we can see how values of Sightings tend to decrease as values of MaxCP increase.'
;

proc sgplot
    data = pokemon_analysis
    ;
    scatter x= maxcp y = sightings
    ;
    loess   x= maxcp y = sightings/nomarkers
    ;
    loess   x= maxcp y = sightings/smooth = 1 nomarkers
    ;
    ellipse x= maxcp y = sightings/type=predicted
    ;
run;
title;
footnote;

proc glm
    data = pokemon_analysis
	plots= RESIDUALS
    ;
    model
        sightings = maxcp
	    /solution
    ;
    output 
        out = resids
        r = res
    ;
run;
quit;
title;
footnote;

proc univariate normal plot;
/* Tells SAS to run tests of normality and give a QQ-plot */
var res;
run;
/* Since Shapiro-Wilk  < 0.05, reject Ho, residuals are NOT normally distributed*/
