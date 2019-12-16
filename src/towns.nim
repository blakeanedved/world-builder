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
        index*: int

proc pickName*(town: Town) = 
    town.name = sample(cityNames[town.race])
proc genPopulation*(town:Town) =
    var min = rand(1000..25000)
    var max = rand(45000..200000)
    town.population = rand(min..max)
var towns: seq[Town]

proc newTown*(race: string): int = 
    var temp = new Town
    temp.race = race
    temp.pickName()
    temp.genPopulation()
    temp.index = towns.len + 1
    towns.add(temp)
    return towns.len

proc writeTowns*() = 
    let file = open("townDetails.csv", fmWrite)
    defer: file.close()
    file.writeLine("Name,Population,Race,Map Key")
    for town in towns:
        file.writeLine(town.name & "," & town.population.astToStr() & "," & town.race & "," & town.index.astToStr())