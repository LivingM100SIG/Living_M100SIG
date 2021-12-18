    * * * WATOR * * *
    (An ecological simulation game)

Model 100 implementation by J. Holovacs 74756,413

Wator is an implementation of the program suggested by A. K. Dewdney in 
Scientific American's Computer Recreations column (12/84).  I recommend you read
the article for his detailed commentary, however a basic summary is as follows.

On the planet Wator there are two significant species, fish (which feed on the 
ever present plankton), and sharks which feed on the fish.  Breeding rates, life
spans, and shark starve times are entered by the user at the beginning of the 
program.  Sharks must feed on fish to survive and reproduce.

If the system is not balanced correctly, sharks will quickly outnumber fish, 
devour them and then starve into extinction.  However, if the reproductive rates
are properly balanced with starvation and life length, a fascinating cyclical 
ecology can be created.  Patterns of movement and even schooling of fish can be 
observed.  The influences are subtle, however, and in playing with the 
parameters one gets to appreciate the delicate balance of real life ecology, 
with its millions of variables.

In the interest of keeping a common ground with the article, I have used the 5 
integers arrays--FIsh, SHarks, FishMove, SharkMove and STarve--(the information 
could actually have been packed into a single integer array).  As suggested in 
the article, the screen wraps around to itself in both directions.  The code is 
fairly modular and commented so changes in the system can easily be made for 
experimentation.

I have made a few modifications to the scenario which seem reasonable when 
applied to reality and seem to make the performance of the model more 
interesting.  These are commented below:
1) Breeding times--Each species breeds only in multiples of its breeding age.  
Similar to the controlled breeding rates of major predators, this prevents well 
fed sharks from multiplying helter skelter once reaching maturity.

2)  Fish escape--Generally, fish will eventually find themselves surrounded by 
hungry sharks, once surrounded there is no chance to form a colony elsewhere.  
Therefore, line 81 allows for a .3 chance of a fish spontaneously appearing at a
random location elsewhere (escaping from the sharks)

3)  First Shark breeding--A problem in the original setup allowed sharks to 
reproduce if their breeding time and starve time were equal, offspring could 
continually replace the adult with no food present.  Line 315 prevents a shark 
from breeding until it has eaten at least once.

An important feature of this version is the opportunity to plot a population 
chart for the variations of the two species.  To use this feature answer "Y" to 
the Census file.  Two files will be generated, one with the statistics and 
parameters of the run spelled out, and the census file with strictly numerical 
data.  Run WATPLT.BA to see a graphic representation of your ecological history;
you will be prompted for file name (give the CENSUS file name) and the number of
chronons actually run.  This information, as well as beginning and final census 
figures, beginning and ending lapsed real time and parameters are recorded in 
the DESCRIPTION file.

Since the program can take quite a while to run, selecting this option allows 
the computer to complete the simulation unattended; it will power off at the 
completion.  If a species disappears or memory overflow occurs, a premature 
abort is activated automatically.  During the run a dummy file is maintained; 
upon memory error condition this file is deleted, allowing enough space for an 
orderly shutdown.

During the run, you can observe the current Chronon (year) count by pressing [F1
].  To orderly terminate the program early when using output files, briefly 
press [F2].  At the end of the current chronon (necessary to keep the final 
census figure correct) the program will write up-to-date info to the file and 
terminate.

I would like to hear any comments, or interesting results.  

Jay Holovacs
74756,413

