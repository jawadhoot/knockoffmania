extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var x = 1280
var y = 720
var grid_x:int = 5
var grid_y:int = 4
var grid = []

var names = [
	"PaceMan", "Rudd3r", "Prick", "MaXie", "STALL", 
	"PonY", "HoPPy", "BOSS", "Brake", "Trigg",
	"dream", "piXie", "Quick", "Pond","Swift",
	"Axle", "Jinnx" , "close", "PullEM", "HeyJoe",
	"BundL", "Packer", "XiPooh", "Konsole", "ickx" 
]

var ids = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]

var payout = {
	"RANK" : 500,
	"PODIUM3" : 100,
	"PODIUM2" : 3,
	"PODIUM1" : 1,
	"KAPUT" : 0
}

var bets = {}
var result = []
#var rng = RandomNumberGenerator.new()
func _ready():
	pass
	#init()

enum {INIT,BET,DRAW,END}

func init():
	randomize()
	ids.shuffle()
	var w = x/grid_x
	var h = y/grid_y
	
	for j in range(grid_y):	
		for i in range(grid_x):
			var grid_arr = [i * w + 100, w * i + w - 100, j * h + 80, j * h + h  - 80]
			grid.append(grid_arr)
			
	print(ids.slice(0,grid.size()))
	result = []
	bets = {}

func add_bet(name, bet) -> String:
	var id = get_id()
	while id in bet:
		id = get_id()
	var ne_bet = {
		"id": id,
		"name": name,
		"bet" : bet
	}
	bets[id] = ne_bet
	return id

func get_status(result:Array,bet:Array):
	var podium = result.slice(0,3)
	var match_count = get_match(podium,bet)
	if podium == bet:
		return "RANK"
	elif match_count == 3:
		return "PODIUM3"
	elif match_count == 2:
		return "PODIUM2"
	elif match_count == 1:
		return "PODIUM1"
	else:
		return "KAPUT"

func get_match(podium:Array, bet:Array):
	var match_count = 0
	for item in bet:
		if item in podium:
			match_count += 1
	return match_count

func get_results():
	var final_table = []
	for id in bets:
		var bet = bets[id]
		bet["status"] = get_status(result,bet["bet"])
		bet["payout"] = payout[bet["status"]]
		final_table.append(bet)
	return final_table

func get_id():
	var max_id = 10
	var id:PoolStringArray = []
	for i in range(6):
		var b = randi() % max_id
		id.append(str(b))
	return id.join("")
