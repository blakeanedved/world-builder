import random
import tables
import nameList


type
    Npc* = ref object of RootObj
        name*: string
        race*: string
        gender*: string
        age*: int
        town*: string
    
    Ruler* = ref object of Npc
        rulerType*: string
        reign*: int
    
    Military* = ref object of Npc
        rank*: string
    
    Council* = ref object of Npc
        position*: string
        servedTime*: int

randomize()

let ages = {
    "european": {
        "min": 30,
        "max": 70
    }.toTable,
    "asian": {
        "min": 25,
        "max": 70
    }.toTable,
    "african": {
        "min": 20,
        "max": 60
    }.toTable,
    "human": {
        "min": 30,
        "max": 70
    }.toTable,
    "elvish": {
        "min": 125,
        "max": 700
    }.toTable,
    "dwarven": {
        "min": 25,
        "max": 80
    }.toTable,
    "halfling": {
        "min": 20,
        "max": 100
    }.toTable,
    "orcish": {
        "min": 25,
        "max": 65
    }.toTable,
    "goblin": {
        "min": 25,
        "max": 60
    }.toTable,
    "gnome": {
        "min": 30,
        "max": 80
    }.toTable
}.toTable

let rulers = [
    "Mayor",
    "Dictator",
    "Council Chair",
]

let ranks = [
    "General",
    "Officer",
    "Admiral",
    "Commander",
    "Captain"
]

let positions* = [
    "Secretary",
    "Treasurer"
]


proc newNpc*(class: Npc, race: string, town: string) =
    if rand(0..10000) mod 4 == 0:
        class.gender = "female"
    else:
        class.gender = "male" 
    class.name = sample(npcNames[race][class.gender])
    class.age = rand(ages[race]["min"]..ages[race]["max"])
    class.town = town
    class.race = race

proc newRuler*(race: string, town: string): Ruler = 
    result = new Ruler
    result.newNpc(race, town)
    result.rulerType = sample(rulers)
    result.reign = rand(0..15)
    

proc newMilitary*(race: string, town: string): Military =
    result = new Military
    result.newNpc(race, town)
    result.rank = sample(ranks)

proc newCouncil*(race: string, town: string): Council = 
    result = new Council
    result.newNpc(race, town)
    if rand(0..10000) mod 10 == 0:
        result.position = sample(positions)
    else:
        result.position = "Representative"
    result.servedTime = rand(0..7)

    