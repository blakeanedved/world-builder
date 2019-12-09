import nigui
import strformat
import strutils
import sequtils
import parseutils
import parameter

app.init()

type
    TextBoxPair = ref object of RootObj
        box: TextBox
        name: Label

var window = newWindow("World Builder")
window.height = 500.scaleToDpi
window.width = 700.scaleToDpi
var container = newLayoutContainer(Layout_Vertical)
window.add(container)

container.height = 500
var mainContainer = newLayoutContainer(Layout_Horizontal)
container.add(mainContainer)
var leftContainer = newLayoutContainer(Layout_Vertical)
mainContainer.add(leftContainer)
leftContainer.height=400
var rightContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(rightContainer)
rightContainer.height = 400

var worldSpecs = newLayoutContainer(Layout_Vertical)
worldSpecs.height = 90
leftContainer.add(worldSpecs)
var worldContainer = newLayoutContainer(Layout_Horizontal)
worldContainer.height = 35
var worldNameLb = newLabel("World Name: ")
var worldName = newTextBox()
worldName.width = 250
worldContainer.add(worldNameLb)
worldContainer.add(worldName)
worldSpecs.add(worldContainer)
worldContainer = newLayoutContainer(Layout_Horizontal)
worldContainer.height = 35
var worldSizeLb = newLabel("World Size: ")
var worldSizeX = newTextBox()
var text = newLabel("X")
var worldSizeY = newTextBox()
worldSizeX.width = 100
worldSizeY.width = 100
worldContainer.add(worldSizeLb)
worldContainer.add(worldSizeX)
worldContainer.add(text)
worldContainer.add(worldSizeY)
worldSpecs.add(worldContainer)

var biomeSelect = newLayoutContainer(Layout_Vertical)
leftContainer.add(biomeSelect)
biomeSelect.height=200

text = newLabel("Biomes:\n")
var biomes: seq[Checkbox]

for i,s in ["Plains","Forest","Desert","Mountains","Swamp","Jungle","Hills","Tundra"]:
    biomes.add(newCheckbox(s))

biomeSelect.add(text)

for i in 0..3:
    var biomeRow = newLayoutContainer(Layout_Horizontal)
    biomeRow.add(biomes[i * 2])
    biomeRow.add(biomes[(i * 2) + 1])
    biomeSelect.add(biomeRow)
    biomeRow.width=200

var generateCities = newLayoutContainer(Layout_Vertical)
rightContainer.add(generateCities)

var cityRow = newLayoutContainer(Layout_Horizontal)
generateCities.add(cityRow)
cityRow.width = 200
var cities = newCheckbox()
text = newLabel("Generate Cities?")
cityRow.add(text)
cityRow.add(cities)

var cityDetails = newLayoutContainer(Layout_Vertical)
generateCities.add(cityDetails)
cityDetails.height = 350
cityDetails.width = 250
cityDetails.hide()

cityRow = newLayoutContainer(Layout_Horizontal)
text = newLabel("Number of Cities: ")

var cityNum = newTextBox()
cityNum.width = 50
cityRow.add(text)
cityRow.add(cityNum)
cityDetails.add(cityRow)
cityRow.height = 50

var cityTypes: seq[TextBoxPair]
for i,s in @["European","Asian","African","Middle East","Human","Elvish","Dwarvish","Halfling","Orc","Goblin","Gnome","Dragonborn","Tiefling"]:
    cityTypes.add(TextBoxPair(box: newTextBox(), name: newLabel(s)))
    cityTypes[i].box.width = 50
    
for i in 0..5:
    cityRow = newLayoutContainer(Layout_Horizontal)
    cityRow.add(cityTypes[i * 2].box)
    cityRow.add(cityTypes[i * 2].name)
    cityRow.add(cityTypes[(i * 2) + 1].box)
    cityRow.add(cityTypes[(i * 2) + 1].name)
    cityDetails.add(cityRow)
    cityRow.height = 35
cityRow = newLayoutContainer(Layout_Horizontal)
cityRow.add(cityTypes[12].box)
cityRow.add(cityTypes[12].name)
cityDetails.add(cityRow)
cityRow.height = 35
cities.onToggle = proc (event: ToggleEvent) =
    if cities.checked:
        cityDetails.show()
    else:
        cityDetails.hide()

var deities = newLayoutContainer(Layout_Vertical)
leftContainer.add(deities)

var deityRow = newLayoutContainer(Layout_Horizontal)
deities.add(deityRow)
deities.height=70

var createPantheon = newCheckbox("Create Pantheon?")
deityRow.add(createPantheon)
deityRow.width=300
var numDeityRow = newLayoutContainer(Layout_Horizontal)
deities.add(numDeityRow)
numDeityRow.hide()
text = newLabel("Number of deities: ")
var numDeities = newTextBox()
numDeities.width = 50
numDeityRow.add(text)
numDeityRow.add(numDeities)
numDeityRow.height = 35

createPantheon.onToggle = proc(event: ToggleEvent) =
        if createPantheon.checked:
            numDeityRow.show()
        else:
            numDeityRow.hide()

var submitContainer = newLayoutContainer(Layout_Horizontal)
submitContainer.widthMode = WidthMode_Expand
submitContainer.xAlign = XAlign_Center
submitContainer.yAlign = YAlign_Center
var submit = newButton("Generate")
submitContainer.add(submit)
container.add(submitContainer)

var red = rgb(255,200,200)
var white = rgb(255,255,255)

proc validate(textBox: TextBox): bool =
    var temp: int
    if parseInt(textBox.text, temp) == 0:
        textBox.backgroundColor = red
        return false
    else:
        textBox.backgroundColor = white
        textBox.text = intToStr(temp)
        return true


submit.onClick = proc(event: ClickEvent) = 
        var valid = true
        if worldName.text == "":
            worldName.backgroundColor = red
            valid = false
        else:
            worldName.backgroundColor = white
        
        valid = validate(worldSizeX)
        valid = validate(worldSizeY)
        if cities.checked:
            valid = validate(cityNum)
            var forValid = 0
            for i in 0..12:
                valid = validate(cityTypes[i].box)
                if not valid:
                    forValid += 1
            if forValid > 0:
                valid = false
        if createPantheon.checked:
            valid = validate(numDeities)
        if valid:
            var stats = newParameters()
            stats.name = worldName.text
            discard parseInt(worldSizeX.text, stats.width)
            discard parseInt(worldSizeY.text, stats.height)
            discard parseInt(cityNum.text, stats.num_cities)
            discard parseInt(numDeities.text, stats.num_deities)
            stats.generate_cities = cities.checked
            if cities.checked:
                for i,s in @["european","asian","african","middle east","human","elvish","dwarvish","halfling","orc","goblin","gnome","dragonborn","tiefling"]:
                    var temp: int
                    discard parseInt(cityTypes[i].box.text, temp)
                   # stats.cities[s] = temp
            stats.generate_pantheon = createPantheon.checked
            
window.show()
app.run()




