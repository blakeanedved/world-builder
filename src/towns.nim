import random
import tables
import nameList

randomize()
type
    Town* = ref object of RootObj
        name*: string
        population*: int
        race*: string
        posX*: int
        posY*: int

proc rename*(town: Town) = 
    town.name = sample(cityNames[town.race])
proc rename*(town: Town, name: string) = 
    town.name = name
proc newTown*(x, y: int, race: string): Town = 
    result = new Town
    result.race = race
    result.posX = x
    result.posY = y
    result.rename()
proc populationChange*(town: Town) = 
    discard
proc populationChange*(town: Town, population: int) =
    town.population = population