//define color for each animal
var colorFiller = d3.scaleOrdinal(d3.schemeCategory10);
var animalTypes = ["Cat","Dog","Livestock","Bird","Other","All"];
var animalColorDict = {
    "Cat": 0,
    "Dog": 1,
    "Livestock": 2,
    "Bird": 3,
    "Other": 4,
    "All": 5
};