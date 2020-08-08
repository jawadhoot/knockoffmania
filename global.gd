extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var x = 1280
var y = 720
var grid_x:int = 5
var grid_y:int = 4


var names = [
	"PaceMan", "Rudd3r", "Prick", "MaXie", "STALL", 
	"PonY", "HoPPy", "BOSS", "Brake", "Trigg",
	"dream", "piXie", "Quick", "Pond","Swift",
	"Axle", "Jinnx" , "close", "PullEM", "HeyJoe",
	"BundL", "Packer", "XiPooh", "Konsole", "ickx" 
]

var ids = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]

var payout = {
	"ALL_ON_PODIUM_IN_ORDER" : 100,
	"ALL_ON_PODIUM" : 20,
	"TOP_2_ON_SPOT" : 10,
	"PICKED_TOP_2" : 5,
	"2_ON_PODIUM" : 3,
	"PICKED_THE_WINNER" : 2,
	"1_ON_PODIUM" : 1,
	"SORRY" : 0
}

var grid = []
var bets = {}
var result = []
var podium = []
var podium_string = ""
#var rng = RandomNumberGenerator.new()
func _ready():
	pass
	#init()

enum {INIT,BET,DRAW,END}

func set_podium():
	podium_string = ""
	podium = []
	while podium.size() < 3:
		var a = result.pop_back()
		if not a in podium:
			podium.append(a)
	podium_string = "1 "+ names[podium[0]] + " 3 "+ names[podium[1]] + " 3 "+ names[podium[2]]

func init():
	randomize()
	ids.shuffle()
	var w = x/grid_x
	var h = y/grid_y
	grid = []
	for j in range(grid_y):	
		for i in range(grid_x):
			var grid_arr = [i * w + 100, w * i + w - 100, j * h + 80, j * h + h  - 80]
			grid.append(grid_arr)
			
	print(ids.slice(0,grid.size()))
	
	result = []
	podium_string = ""
	podium = []
	bets = {}

func add_bet(name, bet, bet_string) -> String:
	var id = get_id()
	while id in bet:
		id = get_id()
	var ne_bet = {
		"id": id,
		"name": name,
		"bet" : bet,
		"bet_string" : bet_string
	}
	bets[id] = ne_bet
	return ne_bet

func get_status(podium:Array,bet:Array):
	var match_count3 = get_match(podium,bet)
	var match_count2 = get_match(podium.slice(0,2),bet)
	var match_count1 = get_match(podium.slice(0,1),bet)
	if match_count3 == 3:
		if podium == bet:
			return "ALL_ON_PODIUM_IN_ORDER"
		else:
			return "ALL_ON_PODIUM"
	elif match_count3 == 2:
		if podium.slice(0,2) == bet.slice(0,2):
			return "TOP_2_ON_SPOT"
		elif match_count2 == 2:
			return "PICKED_TOP_2"
		else:
			return "2_ON_PODIUM"
	elif match_count3 == 1:
		if match_count1 == 1:
			return "PICKED_THE_WINNER"
		else:
			return "1_ON_PODIUM"
	else:
		return "SORRY"

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
		bet["status"] = get_status(podium,bet["bet"])
		bet["payout"] = payout[bet["status"]]
		final_table.append(bet)
	final_table.sort_custom(self, "id_sort")
	return final_table

func id_sort(a,b):
	if a["id"] < b["id"]:
		return true
	return false

func get_id() -> String:
	var max_id = 10
	var id:PoolStringArray = []
	for i in range(6):
		var b = randi() % max_id
		id.append(str(b))
	return id.join("")

func bet_entry_string(bet) -> String:
	var string:PoolStringArray = []
	string.append(pad(bet["id"],8))
	string.append(pad(bet["name"],20))
	string.append(bet["bet_string"])
	return string.join(" ")

func bet_result_string(bet) -> String:
	var string:PoolStringArray = []
	string.append(pad(bet["id"],8))
	string.append(pad(bet["status"],12))
	string.append(pad(str(bet["payout"]),30))
	string.append(pad(bet["name"],18))
	string.append(bet["bet_string"])
	return string.join(" ")

func pad(input:String,pad:int) -> String:
	var string:PoolStringArray = []
	input.strip_edges()
	var diff = pad - input.length()
	string.append(input)
	for i in range(diff):
		string.append(" ")
	return string.join(" ")
