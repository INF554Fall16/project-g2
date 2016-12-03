# project-g2
Members:

1) Vitid Nakareseisoon

2) Wenjia Wang

The project is hosted as [this site](http://www-scf.usc.edu/~nakarese/inf554)

The visualization paper can be found [here](Visualization_Paper.pdf)

# Rough Ideas[Oct. 7]

Project Planning: Providing visualization for Animal Services Intake Data

Dataset: https://data.lacity.org/A-Well-Run-City/Animal-Services-Intake-Data/8cmr-fbcu

We can incorporate some visualizations such that:

(1) Create Proportional Symbol on the LA map to illustrate how many animals adopted by each shelter

(2) Create Sunburst chart to illustrate a relationship between animal's Group and Breed

(3) Create Time-Series chart to illustrate how many animals adopted per day/week/etc.



# Changes after the group critiques[Oct. 20]

Topic: Visualize Texas Austin Animal Services Intake and Outcome Data


Target: Shelter officers, Pet researcher

# Aim: 
* Investigate the trends of incoming and outgoing animals
* Explore locations where adopted animals were found. Data can be displayed based on timePeriod/animalType
* Provide overview details of incoming & outgoing animals based on various proportions such as animalType, sex, neutralStatus, ageGroup, etc.
* Discover animals that were adopted by the shelter multiple times

# Dataset:
* Intake data(up-to-date): [~60,000 records]  https://data.austintexas.gov/Health/Austin-Animal-Center-Intakes/wter-evkm
* Animal outcomes data(up-to-date):[~60,000 records] https://data.austintexas.gov/Health/Austin-Animal-Center-Outcomes/9t4d-g238

# Pre-processing Steps
* Map location string to (longtitude, latitude) by using google-map api
* Join incoming and outgoing animal dataset based on timeframe/animalID
* Simplify animalBreed categories
* Categorize animalAge into 5 groups

# Existing Visualization
* https://www.kaggle.com/apapiu/shelter-animal-outcomes/visualizing-breeds-and-ages-by-outcome
* The work offers information based solely on the outgoing data. We decide to extend the information provided by combining both incoming and outgoing data
* Main visualization used is a stacked bar chart. We will use visualizations such as line chart, map, and Sankey Diagram to explore other angles in data

# Planned Visualization
* Time series/line chart(displays #incoming, #outgoing, #balance animals)
* Geomap displays locations where animals were found. Data can be displayed based on timePeriod/animalType 
* 2 Sankey Diagrams to reflect the proportion of various animal's attributes. One diagram for incoming animals and another for outgoing animals
* For animal that were adopted multiple times, we use Calendar View to display time when those animals came to and left the shelter

# Changes in Visualization
* Because of the new dataset, we display animal found location rather than the adopted shelter location
* Add outgoing and balance data to the time series chart
* Remove Sunburst chart
* Add outgoing data to Calendar View chart

# Technology
* D3, R, Bootstrap, and Leaflet(http://leafletjs.com/)
