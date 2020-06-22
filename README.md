# JobFinder
JobFinder is a job search solution that looks into many providers and display results from all the available job providers, at the current stage we are aggregating from 2 providers: Github & USA Jobs (search.gov is deprecated).

## How It Works
The main idea is to fetch jobs from two deffrent sources (GitHub Jobs, USA Jobs (The search.gov is deprecated)), while each source may have a completly defferent model, so i made a dynamic model to hold both data structures and present them all, compined and sorted by the created date.

However, these API's is to slow to implement an autocomplete, so i did the filteration in a separate view to call the needed API's at once.

###### Project Design Pattern
I was decide to use the MVC design pattern for the UI combined with the FACADE Design Pattern for the core, this combination allow me to be more moduler while coding and let the business logic seperate from the model.


## Scalability
If we want in the future to add a new provider, simply we can add a new provider to Firebase Remote Config and it will synced automatically on the lunch of the app.

###### Firebase Credentials
```
url: https://console.firebase.google.com
email: ltm.smishael@gmail.com
password: Sm@151988
Project Name: JobFinder
```
###### Remote Config JSON Structure
```
id -> Sequential integer starting from 1
name -> Provider Name
dataUrl -> Provider Job GET Api
positionParam -> the parameter key for position inside the api query string
locationParam -> the parameter key for location inside the api query string
auth -> The Auth object if exist for the provider 
     *↳* key -> The Auth Key
     *↳* value -> The Auth value
  
keyStrategy (Optional) -> The path of target array of jobs inside the response, this path should be joined by '>' char
preMapping (Optional) -> If we want to map the target array and get a specific value from each object in the array 
dateFormate -> the Date formate for creation date
keys -> The keys refrence inside each model
     *↳* appKey -> The supported keys inside the app which is (jobTitle, company, location, creationDate, detailsUrl, companyLogo(Optional))
     *↳* jsonKey -> The API model key
```
