# project-g2
Members:

1) Vitid Nakareseisoon

2) Wenjia Wang

Project Planning: Providing visualization for Animal Services Intake Data

Dataset: https://data.lacity.org/A-Well-Run-City/Animal-Services-Intake-Data/8cmr-fbcu

We can incorporate some visualizations such that:

(1) Create Proportional Symbol on the LA map to illustrate how many animals adopted by each shelter

(2) Create Sunburst chart to illustrate a relationship between animal's Group and Breed

(3) Create Time-Series chart to illustrate how many animals adopted per day/week/etc.

#Changes after the group critiques

## Topic: Austin, TX Animal Services Intake Information
## Target: Shelter officers
## Aim: 
* Found frequent location: officer can use our visualization to find the location where animal frequently lost and allocate their resources accordingly.
* Users can investigate the trend
* Relationship of intake animals adopted by LA shelters
* Num. of intake and outgoing, display the # of balance of intake and outgoing.

## New Dataset:
* Intake data(up-to-date): [~60,000 records]  https://data.austintexas.gov/Health/Austin-Animal-Center-Intakes/wter-evkm
* Animal outcomes data(up-to-date):[~60,000 records] https://data.austintexas.gov/Health/Austin-Animal-Center-Outcomes/9t4d-g238

## User Activities
* Track #animals adopted by each location
* Investigate the general trend of intake animals
* Look for taxonomy of intake animals adopted by each shelter
* Uncover seasonal patterns of intake animals
* Dig into the difference of # of animal outgoing on different breed or sex type.

## Pre-processing
* Map Location string to (longtitude, latitude) by using google-map api
* Join incoming and outgoing animal dataset based on timeframe/animalID.(can be used to solve the problem of one animal being intake several times.)
* Combine the mix type into original breed type.(pit bull mix -> pit bull)
* Categorize animal age into 5 group

## Existing visualization
* https://www.kaggle.com/apapiu/shelter-animal-outcomes/visualizing-breeds-and-ages-by-outcome
* Only the outgoing data, we can extend it to combine the income and outgoing data.
* Mainly use stack bar chart. And because we want to explore the overview details of more than 3 attributes in one chart, we will use Sankey Diagram.

## Our visualization
* Geomap display location where animals were found based on type of animal ot time period: 
* Time series line chart(intake outgoing balance)
* 2 Sankey diagrams to reflect the proportion of different kinds of animal
* Calendar View: intake and adopt time point for frequent adopted animal.

## Changes in visualization
* Geomap: display animal found location rather than the shelter location because such data are not provided by the new dataset
* Add time series line chart based on outgoing data and add the balance calculation in the chart too.
* Replace sunburst by Sankey diagram to explore overview details of various relationships.
* Due to the outcome dataset, we can add the outgoing data into a calendar view chart for animals that were adopted multiple times.

## Technology
* D3, R, Bootstrap, and Leaflet(http://leafletjs.com/)








