extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var x = 1280
var y = 720
var grid_x:int = 5
var grid_y:int = 3
var grid = []

var names = [
	"PaceMan", "Rudd3r", "Prick", "MaXie", "STALL", 
	"PonY", "HoPPy", "BOSS", "Brake", "Trigg",
	"dream", "piXie", "Quick", "Pond","Swift",
	"Axle", "Jinnx" , "close", "PullEM", "HeyJoe",
	"BundL", "Packer", "XiPooh", "Konsole", "ickx" 
]

var ids = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]

#var rng = RandomNumberGenerator.new()
func _ready():
	randomize()
	ids.shuffle()
	var w = x/grid_x
	var h = y/grid_y
	
	for i in range(grid_x):	
		for j in range(grid_y):
			var arr = [i * w + 32, w * i + w - 32, j * h + 16, j * h + h  - 16]
			grid.append(arr)
	print(grid)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
