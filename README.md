# JobFinder
JobFinder is a job search solution that looks into many providers and display results from all the available job providers, at the current stage we are aggregating from 2 providers: Github & USA Jobs (search.gov is deprecated).

## How It Works
The main idea is to fetch jobs from two deffrent sources (GitHub Jobs, USA Jobs (The search.gov is deprecated)), while each source may have a completly defferent model, so i made a dynamic model to hold both data structures and present them all, compined and sorted by the created date.

However, these API's is to slow to implement an autocomplete, so i did the filteration in a separate view to call the needed API's at once.

###### Project Design Pattern
I was decide to use the MVC design pattern for the UI combined with the FACADE Design Pattern for the core, this combination allow me to be more moduler while coding and let the business logic seperate from the model.
