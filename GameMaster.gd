extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resDict = {
	"circle": preload("res://buttons/circle.png"),
	"bigcircle": preload("res://buttons/bigcircle.png"),
	"a1": preload("res://buttons/a1.png"),
	"a2": preload("res://buttons/a2.png"),
	"s1": preload("res://buttons/s1.png"),
	"s2": preload("res://buttons/s2.png"),
	"d1": preload("res://buttons/d1.png"),
	"d2": preload("res://buttons/d2.png"),
	"w1": preload("res://buttons/w1.png"),
	"w2": preload("res://buttons/w2.png"),
	"char1": preload("res://character_0008.png"),
	"musictest1": preload("res://claptest1_mux.ogg")
}

var BPM = 140
var barLength = 8
var noteBarLength = 8
var majorBeatEvery = 4
var spaceBetweenBeats: float = 0
var yStart = 100
var lPad := 100.0
var rPad := 100
var audioPlayerGlobally
var currCharMover

func createRythmLine():
	var a := Sprite.new()
#	add_child(a)

	var wSize := OS.window_size
	spaceBetweenBeats = (wSize.x - rPad - lPad) / barLength

	for i in range(2):
		var beats = 0
		var posNow := lPad
		var majorBeatCount = 0
		while posNow < (wSize.x - rPad):
			beats = beats + 1
			a=a.duplicate()
			majorBeatCount = majorBeatCount + 1
			if majorBeatCount == majorBeatEvery:
				majorBeatCount = 0
				a.texture = resDict["bigcircle"]
			else:
				a.texture = resDict["circle"]
			
			if beats <= noteBarLength:
				add_child(a)
			a.position = Vector2(posNow,yStart+60*i)
			posNow = posNow + spaceBetweenBeats

func createChar():
	var c := muge_charMover.new()
	add_child(c)
	c.texture = resDict["char1"]
	c.moveSpeed = (BPM / 60.0) * spaceBetweenBeats
	print("SpaceBetweenBeats: ",spaceBetweenBeats," - BPM:",BPM," - BPS: ",(BPM/60)," - MoveSpeed:",c.moveSpeed)
	c.position = Vector2(lPad,yStart)
	c.canMove = true
	c.twoLines = true
	c.ySpaceBetween = 60
	c.startPosition = lPad
	c.endPosition = OS.window_size.x - rPad
	currCharMover = c

func createMusicPlayer():
	var ap := AudioStreamPlayer.new()
	ap.volume_db = 0
	ap.stream = resDict["musictest1"]
	add_child(ap)
	audioPlayerGlobally = ap

func spawnButtonLine(line: String):
	var wSize := OS.window_size
	var beatIdx = -1
	for i in range(2):
		var posNow := lPad
		while posNow < (wSize.x - rPad):
			beatIdx = beatIdx + 1
			var beatChar = line.substr(beatIdx,1)
			if beatChar != " ":
				var a=Sprite.new()
				match beatChar:
					"a":
						a.texture = resDict["a1"]
					"s":
						a.texture = resDict["s1"]
					"d":
						a.texture = resDict["d1"]
					"w":
						a.texture = resDict["w1"]
				add_child(a)
				a.position = Vector2(posNow,yStart+60*i)
			posNow = posNow + spaceBetweenBeats
	
func spawnSpinButton(letter: String):
	var a = Sprite.new()
	a.texture = resDict[letter+"1"]
	a.position = currCharMover.position
	add_child(a)
	var aa := AnimationPlayer.new()
	aa.root_node = a.get_path()
	aa.add_animation("spin",load("res://AnimationSpinnyKey.tres"))
	aa.play("spin")
	add_child(aa)

# Called when the node enters the scene tree for the first time.
func _ready():
	createRythmLine()
	createMusicPlayer()	
	spawnButtonLine("   a   a   a   a")

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		createChar()
		audioPlayerGlobally.play()
	if event.is_action_pressed("ui_up"):
		spawnSpinButton("w")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#	pass
