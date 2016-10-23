#required libraries:
#pandas, googlemaps
import requests.packages.urllib3
requests.packages.urllib3.disable_warnings()

import pandas as pd
import googlemaps

#place google API key in api.key
yourAPIKey = open('api.key').read()
gmaps = googlemaps.Client(key=yourAPIKey,queries_per_second=100)

#change focus to the locations of animals that were adopted multiple times...
#previous crawling result on full dataset(not yet finished) is kept in mapLatLng.csv.bak and errorLocations.csv.bak
#df = pd.read_csv('../data/Austin_Animal_Center_Intakes.csv',usecols=['Found Location'])
df = pd.read_csv('../data/animalAdoptedMultipleTimes.csv',usecols=['Found.Location'])

##read the previous crawling result
#column: lat,lng,location
decodedDf = pd.read_csv('mapLatLng.csv')
#column: location
errorsDf = pd.read_csv('errorLocations.csv')

#for testing...
#df = df.head()

dictParseNames = {}
errorNames = {}

for location in decodedDf['location']:
    dictParseNames[location] = 1
for location in errorsDf['location']:
    errorNames[location] = 1

lineNumber = 1
numDecoded = 0
for location in df['Found.Location']:
    location = location.strip()
    print("lineNumber:{}".format(lineNumber))
    lineNumber += 1
    if location in dictParseNames or location in errorNames:
        continue
    try:
        numDecoded += 1
        geocodeResult = gmaps.geocode(location)
        if(len(geocodeResult) == 0):
            print("[Got zero result]{}".format(location))
            errorsDf.loc[errorsDf.shape[0]] = [location]
            errorNames[location] = 1
        else:
            lat = geocodeResult[0]['geometry']['location']['lat']
            lng = geocodeResult[0]['geometry']['location']['lng']
            decodedDf.loc[decodedDf.shape[0]] = [lat,lng,location]
            dictParseNames[location] = 1
    except:
        print("[Can't decode lat/long]{}".format(location))
        errorsDf.loc[errorsDf.shape[0]] = [location]
        errorNames[location] = 1
    #write out very 50 api calls
    #api limits/day = 2500
    if(numDecoded % 50 == 0):        
        decodedDf.to_csv('mapLatLng.new.csv',index=False)
        errorsDf.to_csv('errorLocations.new.csv',index=False)

decodedDf.to_csv('mapLatLng.new.csv',index=False)
errorsDf.to_csv('errorLocations.new.csv',index=False)
