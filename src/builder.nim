import parameter
import imageman
import nimnoise
import tables
import towns
import random
import nigui
import progressBar

randomize()

const
  WATER = 85
  BEACH = 88
  MOUNTAINS = 140
  SNOW = 210
  CITY_SIZE = 7

var color: ColorRGBAU
proc setColor(r, g, b: float64) =
  color.r = r.uint8
  color.g = g.uint8
  color.b = b.uint8
  color.a = 255.uint8

proc generateWorld*(P: var Parameters) =
  let
    w = P.width
    h = P.height
  
  var img = initImage[ColorRGBAU](w, h)
  var
    p = newPerlin()
    c = newClamp()
  
  p.setFrequency(0.003)
  
  c.setSourceModule(0, p)
  
  var
    data: seq[seq[float64]]
  
  progressInfo.text = "Generating Noise Data"
  for y in 0..<h:
    data.add(newSeq[float64](w))
    progress.value = 0.7 * (y / h)
    for x in 0..<w:
      data[y][x] = c.getValue(x.float64, y.float64, 0.00001) * 127.0 + 128.0

  progress.value = 0.7
  progressInfo.text = "Coloring Land"
  
  for y in 0..<h:
    progress.value = 0.7 + 0.1 * (y / h)
    for x in 0..<w:
      let val = data[y][x]
      if val < WATER:
        setColor(0, 0, 100)
      elif val < BEACH:
        setColor(215, 200, 105)
      elif val > SNOW:
        setColor(val, val, val)
      elif val > MOUNTAINS:
        setColor(val - 50, val - 50, val - 50)
      else:
        setColor(0, val, 0)
      img.data[y * img.width + x] = color
  
  progress.value = 0.8
  progressInfo.text = "Generating Cities"

  var
    city_pointer = 0
  let cities = @["european", "asian", "african", "middle eastern", "human", "elvish", "dwarven", "halfling", "orcish", "goblin", "gnome"]
  for i in 0..<P.num_cities:
    progress.value = 0.8 + 0.1 * (i / P.num_cities)
    while P.cities[cities[city_pointer]] == 0:
      city_pointer += 1
      if city_pointer == cities.len(): city_pointer = 0
    P.cities[cities[city_pointer]] -= 1
    discard newTown(cities[city_pointer])
    while true:
      let y = rand(CITY_SIZE..<h-CITY_SIZE)
      let x = rand(CITY_SIZE..<w-CITY_SIZE)
      if data[y][x] > WATER and data[y][x] < MOUNTAINS:
        case cities[city_pointer]:
          of "european": setColor(255, 0, 0)
          of "asian": setColor(0, 255, 0)
          of "african": setColor(0, 0, 100)
          of "middle eastern": setColor(255, 165, 0)
          of "human": setColor(255, 0, 255)
          of "elvish": setColor(255, 255, 0)
          of "dwarven": setColor(0, 0, 0)
          of "halfling": setColor(100, 65, 0)
          of "orcish": setColor(255, 255, 255)
          of "goblin": setColor(255, 135, 215)
          of "gnome": setColor(0, 255, 255)

        for ys in -CITY_SIZE..CITY_SIZE:
          for xs in -CITY_SIZE..CITY_SIZE:
            img.data[(y + ys) * img.width + (x + xs)] = color
        
        break

  progress.value = 0.9
  
  img.savePNG(P.path & "/" & P.name & ".png")

