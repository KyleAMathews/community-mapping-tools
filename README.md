community-mapping-tools
=======================

Upload a csv of names and addresses and get a web app of useful community mapping tools. Right now the tool is tied to the LDS ward membership CSV export data structure. E.g. it expects "Family Name" and "Family Address" columns.

Right now it will show you the closest neighbors of a given individual.
Future tools very possible!

## Installation and running

The following instructions assume you'll be running the app using Docker. This is by far the simplest way to get this running.

First create an account and generate an API key from Mapquest. This app uses their Open APIs to geocode addresses and get driving distances between addresses. http://developer.mapquest.com/web/products/open

Then SSH to a server with Docker already installed.

There we'll need to run two Docker commands. The first to setup a ["data-volume" container](http://docs.docker.io/use/working_with_volumes/#creating-and-mounting-a-data-volume-container) and the second to run the actual web app.

To create the data-volume container run:

`docker run -v /data --name distance_data busybox true`

Then run:

`docker run -p 8080:8080 --env MAPQUEST_API_KEY=YOUR_API_KEY --volumes-from distance_data -d kyma/community-mapping-tools`

Now the app should be running. To upload the LDS ward membership csv, go to http://yoursite.com:8080/import

![screen shot 2014-06-03 at 5 14 16 pm](https://cloud.githubusercontent.com/assets/71047/3167820/d5d43102-eb74-11e3-869f-2376a823a9bc.png)

Then go to http://yoursite.com/8080/hello. There's HTTP Basic Auth setup which atm is hardcoded to "happy day" for the username and "the sun" for the password. Enter that and you should see something like:

![screen shot 2014-06-03 at 5 15 52 pm](https://cloud.githubusercontent.com/assets/71047/3167834/0e001460-eb75-11e3-8dcd-efdcd529797c.png)

Select a family name and the app will go to work querying distances between that family and every other family in the ward. These distances will be pushed to the browser and sorted by who's closest.

![who_s_close_to_who](https://cloud.githubusercontent.com/assets/71047/3167850/840c908e-eb75-11e3-979f-066a34a9df0c.png)
