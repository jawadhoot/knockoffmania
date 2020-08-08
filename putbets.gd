extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_selected = []

var SmallLabel = load("res://SmallLabel.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.bets:
		for id in Global.bets:
			var bet = Global.bets[id]
			$BetList.add_item(Global.bet_entry_string(bet))
	else:
		Global.init()
	for i in range(Global.grid.size()):
		var index = Global.ids[i]
		$DriverList.add_item(Global.names[index])
	pass # Replace with function body.

func _on_AddBet_pressed():
	if $LineEdit.text == "":
		return
	if current_selected.size() == 0:
		return
	
	var bet = Global.add_bet($LineEdit.text, current_selected, $SelectedList.text )
	print(bet)
	$BetList.add_item(Global.bet_entry_string(bet))
	current_selected = []
	$SelectedList.text = ""
	$LineEdit.text = ""
	pass # Replace with function body.

func _on_DriverList_item_selected(index):
	var id = Global.ids[index]
	if current_selected.size() == 3:
		return
	current_selected.append(id)
	var text = ""
	for i in range(current_selected.size()):
		text += str(i + 1) + "  " + Global.names[current_selected[i]] + "   "
	$SelectedList.text = text
	pass # Replace with function body.

func _on_DriverList_nothing_selected():
	current_selected = []
	$SelectedList.text = ""
	pass # Replace with function body.

func _on_Info_pressed():
	get_tree().change_scene("res://info.tscn")

func _on_Begin_pressed():
	get_tree().change_scene("res://Arena.tscn")
