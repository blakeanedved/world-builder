import tables

type
  Parameters* = ref object of RootObj
    name*: string
    width*, height*: int
    biomes*: Table[string, bool]
    generate_pantheon*: bool
    generate_cities*: bool
    num_cities*: int
    num_deities*: int
    cities*: Table[string, int]

proc newParameters*(): Parameters =
  result = new Parameters
  result.name = ""
  result.width = 0
  result.height = 0
  result.generate_pantheon = false
  result.generate_cities = false
  result.num_cities = 0
  result.num_deities = 0
  result.biomes = {
    "plains": false,
    "forest": false,
    "desert": false,
    "mountains": false,
    "swamp": false,
    "jungle": false,
    "hills": false,
    "tundra": false
  }.toTable
  result.cities = {
    "european": 0,
    "asian": 0,
    "african": 0,
    "middle eastern": 0,
    "human": 0,
    "elvish": 0,
    "dwarven": 0,
    "halfling": 0,
    "orcish": 0,
    "goblin": 0,
    "gnome": 0,
    "dragonborn": 0,
    "tiefling": 0
  }.toTable