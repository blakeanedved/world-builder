import nigui
import strformat
import strutils
import sequtils
app.init()

type
    TextBoxPair = ref object of RootObj
        box: TextBox
        name: Label

var window = newWindow("World Builder")
window.height = 800.scaleToDpi
window.width = 1200.scaleToDpi
var container = newLayoutContainer(Layout_Vertical)
window.add(container)
var mainContainer = newLayoutContainer(Layout_Horizontal)
container.add(mainContainer)
var leftContainer = newLayoutContainer(Layout_Vertical)
mainContainer.add(leftContainer)
var rightContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(rightContainer)

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
cityDetails.height = 400
#cityDetails.hide()

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
    cityTypes.add(TextBoxPair(box: newTextBox("0"), name: newLabel(s)))
    cityTypes[i].box.width = 50
    


for i in 0..12:
    cityTypes[i].box.onTextChange = proc (event: TextChangeEvent) = 
        echo cityTypes[i].box.text
        if cityTypes[i].box.text.parseFloat is ValueError:
            echo "bad"
            cityTypes[i].name.textColor = rgb(255,0,0)
        else:
            if cityTypes[i].box.text.parseFloat <= 0.0:
                echo i
                cityTypes[i].name.textColor = rgb(0,255,0)
        cityTypes[i].name.forceRedraw()
for i in 0..5:
    cityRow = newLayoutContainer(Layout_Horizontal)
    cityRow.add(cityTypes[i * 2].box)
    cityRow.add(cityTypes[i * 2].name)
    cityRow.add(cityTypes[(i * 2) + 1].box)
    cityRow.add(cityTypes[(i * 2) + 1].name)
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

var createPantheon = newCheckbox("Create Pantheon?")
deityRow.add(createPantheon)

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

var submit = newButton("Generate")
container.add(submit)




window.show()
app.run()




