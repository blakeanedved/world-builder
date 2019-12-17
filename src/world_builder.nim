import nigui
import strutils
import parseutils
import tables
import parameter
import builder
import towns
import progressBar

app.init()

#color constants
let red = rgb(255,200,200)
let white = rgb(255,255,255)
let gray = rgb(146,148,148)


type
    TextBoxPair = ref object of RootObj
        box: TextBox
        name: Label
     

#validates integer values
proc validate(textBox: TextBox, size: bool = false): bool =
    var temp: int
    if not size:
        if textBox.text == "" or textBox.text == "0":
            textBox.text = "0"
            textBox.backgroundColor = white
            return true
        elif parseInt(textBox.text, temp) == 0:
            textBox.backgroundColor = red
            return false
        else:
            textBox.backgroundColor = white
            textBox.text = intToStr(temp)
            return true
    else:
        var valid = parseInt(textBox.text, temp)
        if valid == 0 or temp == 0:
            textBox.backgroundColor = red
            return false
        else:
            textBox.backgroundColor = white
            textBox.text = intToStr(temp)
            return true

#window
var window = newWindow("World Builder")
window.height = 550.scaleToDpi
window.width = 700.scaleToDpi
            
#setting up main containers
var container = newLayoutContainer(Layout_Vertical)
window.add(container)
container.height = 550
var mainContainer = newLayoutContainer(Layout_Horizontal)
container.add(mainContainer)
var leftContainer = newLayoutContainer(Layout_Vertical)
mainContainer.add(leftContainer)
leftContainer.height=400
var rightContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(rightContainer)
rightContainer.height = 400

#get basic world info
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

#get biome details
var biomeSelect = newLayoutContainer(Layout_Vertical)
leftContainer.add(biomeSelect)
biomeSelect.height=200

text = newLabel("Biomes (Not implemented):\n")
var biomes: seq[Checkbox]

for i,s in @["Plains","Forest","Desert","Mountains","Swamp","Jungle","Hills","Tundra"]:
    biomes.add(newCheckbox(s))

biomeSelect.add(text)

for i in 0..3:
    var biomeRow = newLayoutContainer(Layout_Horizontal)
    biomeRow.add(biomes[i * 2])
    biomeRow.add(biomes[(i * 2) + 1])
    biomeSelect.add(biomeRow)
    biomeRow.width=200
#generate cities y/n
var generateCities = newLayoutContainer(Layout_Vertical)
rightContainer.add(generateCities)

var cityRow = newLayoutContainer(Layout_Horizontal)
generateCities.add(cityRow)
cityRow.width = 200
var cities = newCheckbox("Generate Cities?")
cityRow.add(cities)

#container for cities
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
for i,s in @["European","Asian","African","Middle East","Human","Elvish","Dwarvish","Halfling","Orc","Goblin","Gnome"]:
    cityTypes.add(TextBoxPair(box: newTextBox(), name: newLabel(s)))
    cityTypes[i].box.width = 50
    
for i in 0..5:
    cityRow = newLayoutContainer(Layout_Horizontal)
    cityRow.add(cityTypes[i * 2].box)
    cityRow.add(cityTypes[i * 2].name)
    if i != 5:
        cityRow.add(cityTypes[(i * 2) + 1].box)
        cityRow.add(cityTypes[(i * 2) + 1].name)
    cityDetails.add(cityRow)
    cityRow.height = 35

#gather details about the pantheon
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

#submit and file path buttons
var submitContainer = newLayoutContainer(Layout_Horizontal)
submitContainer.widthMode = WidthMode_Expand
submitContainer.xAlign = XAlign_Center
submitContainer.yAlign = YAlign_Center
var pathContainer = newLayoutContainer(Layout_Horizontal)
pathContainer.widthMode = WidthMode_Expand
pathContainer.xAlign = XAlign_Center
pathContainer.yAlign = YAlign_Center
var submit = newButton("Generate")
var filePath = newButton("Select Path")
var path = newLabel("Path not chosen")
submitContainer.add(submit)
submitContainer.add(filePath)
submitContainer.height = 50
pathContainer.add(path)
container.add(submitContainer)
container.add(pathContainer)

#file path button
filePath.onClick = proc(event: ClickEvent) =
        var dialog = newSelectDirectoryDialog()
        dialog.title  = "Select Folder"
        dialog.run()
        if dialog.selectedDirectory == "":
            path.text = "Path not chosen"
        else:
            path.text = dialog.selectedDirectory
            path.textColor = rgb(0,0,0)
#submit button
submit.onClick = proc(event: ClickEvent) = 
        var valid = true
        if worldName.text == "":
            worldName.backgroundColor = red
            valid = false
        else:
            worldName.backgroundColor = white
        
        
        if not validate(worldSizeY, true) or not validate(worldSizeX, true):
            discard validate(worldSizeX, true)
            valid = false
        if cities.checked:
            if not validate(cityNum):
                valid = false
            var forValid = 0
            var sum = 0
            var tempValid = false
            for i in 0..10:
                tempValid = validate(cityTypes[i].box)
                if tempValid:
                    var temp: int
                    discard parseInt(cityTypes[i].box.text, temp)
                    sum += temp
                if not tempValid:
                    forValid += 1
            var temp: int
            discard parseInt(cityNum.text, temp)
            if forValid > 0:
                valid = false
            elif temp != sum:
                cityNum.backgroundColor = red
                valid = false
        if createPantheon.checked and valid:
            if not validate(numDeities):
                valid = false
        if path.text == "Path not chosen" or path.text == "Please select a path":
            path.text = "Please select a path"
            path.textColor = rgb(255,0,0)
            valid = false
        #if everything is valid
        if valid:
            #progress bar
            progress = newProgressBar()
            progressInfo = newLabel("Gathering Data")
            progress.width = 500
            var progressArea = newLayoutContainer(Layout_Vertical)
            progressArea.widthMode = WidthMode_Expand
            progressArea.xAlign = XAlign_Center
            progressArea.yAlign = YAlign_Center
            progressArea.add(progress)
            progressInfo.backgroundColor = rgb(244,242,241)
            progressArea.add(progressInfo)
            container.add(progressArea)
            #put all the data in the stats object
            var stats = newParameters()
            stats.name = worldName.text
            worldName.editable = false
            worldName.textColor = gray
            discard parseInt(worldSizeX.text, stats.width)
            discard parseInt(worldSizeY.text, stats.height)
            worldSizeX.editable = false
            worldSizeX.textColor = gray
            worldSizeY.editable = false
            worldSizeY.textColor = gray
            stats.generate_cities = cities.checked
            cities.enabled = false
            if cities.checked:
                discard parseInt(cityNum.text, stats.num_cities)
                cityNum.editable = false
                cityNum.textColor = gray
                for i,s in ["european","asian","african","middle eastern","human","elvish","dwarven","halfling","orcish","goblin","gnome"]:
                    discard parseInt(cityTypes[i].box.text, stats.cities[s])
                    cityTypes[i].box.editable = false
                    cityTypes[i].box.textColor = rgb(146,148,148)
            stats.generate_pantheon = createPantheon.checked
            createPantheon.enabled = false
            if createPantheon.checked:
                discard parseInt(numDeities.text, stats.num_deities)
                if stats.num_deities > 21:
                    stats.num_deities = 21
                numDeities.editable = false
                numDeities.textColor = gray
            for i,s in @["plains","forest","desert","mountains","swamp","jungle","hills","tundra"]:
                stats.biomes[s] = biomes[i].checked
                biomes[i].enabled = false
            submit.enabled = false
            stats.path = path.text
            filePath.enabled = false
            path.textColor = gray
            generateWorld(stats)
            if createPantheon.checked:
                progress.value = 0.9
                progressInfo.text = "Generating pantheon file"
                writeDeities(stats.num_deities, path.text)
            if cities.checked:
                progress.value = 0.93
                progressInfo.text = "Generating towns file"
                writeTowns(path.text)
                progress.value = 0.95
                progressInfo.text = "Generating NPC file"
                writeNpcs(path.text)
            progress.value = 1
            progressInfo.text = "Generation Complete"


#keyboard shortcuts
window.onKeyDown = proc(event: KeyboardEvent) =
    when hostOS == "macosx":
        if Key_Q.isDown() and Key_Command.isDown():
            app.quit()
    elif hostOS == "windows":
        if Key_Q.isDown() and (Key_ControlL.isDown() or Key_ControlR.isDown()):
            app.quit()

#toggle city details' visibility 
cities.onToggle = proc (event: ToggleEvent) =
    if cities.checked:
        cityDetails.show()
    else:
        cityDetails.hide()

#toggle patheon visibility
createPantheon.onToggle = proc(event: ToggleEvent) =
        if createPantheon.checked:
            numDeityRow.show()
        else:
            numDeityRow.hide()

window.show()
app.run()




