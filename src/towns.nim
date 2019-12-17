import random
import tables
import nameList
import npc
randomize()



type
    Town* = ref object of RootObj
        name*: string
        population*: int
        race*: string
        posX*: int
        posY*: int
        index*: int
        color*: string
        ruler: Ruler
        military: seq[Military]
        council: seq[Council] 

let colors = {
  "european": "red",
  "asian": "green",
  "african": "dark blue",
  "middle eastern": "orange",
  "human": "purple",
  "elvish": "yellow",
  "dwarven": "black",
  "halfling": "brown",
  "orcish": "white",
  "goblin": "pink",
  "gnome": "light blue"
}.toTable

var towns: seq[Town]
var npcsRul: seq[Ruler]
var npcsMil: seq[Military]
var npcsCou: seq[Council]

proc pickName*(town: Town) = 
    town.name = sample(cityNames[town.race])

proc genPopulation*(town:Town) =
    var min = rand(1000..25000)
    var max = rand(45000..200000)
    town.population = rand(min..max)

proc genNpcs*(town: Town) = 
    town.ruler = newRuler(town.race, town.name)
    npcsRul.add(town.ruler)
    var military, council: int
    case town.population
    of 1000..10000:
        military = 3
        council = 4
    of 10001..30000:
        military = 5
        council = 8
    of 30001..100000:
        military = 9
        council = 15
    else:
        military = 14
        council = 20
    var general = false
    for i in 0..<military:
        var temp = newMilitary(town.race, town.name)
        while temp.rank == "General" and general:
            temp = newMilitary(town.race, town.name)
        if temp.rank == "General":
            general = true
        town.military.add(temp)
        npcsMil.add(temp)
    for i in 0..<council:
        var temp = newCouncil(town.race, town.name)
        town.council.add(temp)
        npcsCou.add(temp)
            





proc newTown*(race: string): int = 
    var temp = new Town
    temp.race = race
    temp.pickName()
    temp.genPopulation()
    temp.index = towns.len + 1
    temp.color = colors[race]
    temp.genNpcs()
    towns.add(temp)
    return towns.len
proc writeTowns*(path: string) = 
    progress.value = 0.8
    let file = open(path & "/townDetails.csv", fmWrite)
    defer: file.close()
    file.writeLine("Name,Population,Race,Color")
   
    for town in towns:
        file.writeLine(town.name & "," & $town.population & "," & town.race & "," & $town.color)
proc writeDeities*(num: int, path: string) =
    var deities: seq[Table[string, string]]
    var temp: Table[string, string]
    for i in 0..<num:
        temp = sample(deitiesList)
        while temp in deities:
            temp = sample(deitiesList)
        deities.add(temp)
    let file = open(path & "/pantheon.csv", fmWrite)
    defer: file.close()
    file.writeLine("Name,Rule,Alignment,Domain")
    for deity in deities:
        file.writeLine(deity["name"] & "," & deity["rule"] & "," & deity["alignment"] & "," & deity["domain"])

proc writeNpcs*(path: string) =
    let file = open(path & "/npcList.csv", fmWrite)
    defer: file.close()
    file.writeLine("Rulers")
    file.writeLine("Name,Race,Gender,Age,Town,Type,Reign")
    for npc in npcsRul:
        file.writeLine(npc.name & "," & npc.race & "," & npc.gender & "," & $npc.age & "," & npc.town & "," & npc.rulerType & "," & $npc.reign)
    file.writeLine("Military")
    file.writeLine("Name,Race,Gender,Age,Town,Rank")
    for npc in npcsMil:
        file.writeLine(npc.name & "," & npc.race & "," & npc.gender & "," & $npc.age & "," & npc.town & "," & npc.rank)
    file.writeLine("Council")
    file.writeLine("Name,Race,Gender,Age,Town,Position,Time Served")
    for npc in npcsCou:
        file.writeLine(npc.name & "," & npc.race & "," & npc.gender & "," & $npc.age & "," & npc.town & "," & npc.position & "," & $npc.servedTime)
