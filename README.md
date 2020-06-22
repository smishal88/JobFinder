# JobFinder
The main idea is to fetch jobs from two deffrent sources (GitHub Jobs, USA Jobs (The search.gov is deprecated)).

While each source may have a completly defferent model, i did an dynamic model to hold both model and present them all compined and sorted by the creating date.

However, these API's is to slow to implement an autocomplete so i did the filteration in a separate view to call the needed API's at once
