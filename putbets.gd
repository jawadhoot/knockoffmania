extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_selected = []

var SmallLabel = load("res://SmallLabel.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(Global.grid.size()):
		var index = Global.ids[i]
		$DriverList.add_item(Global.names[index])
	pass # Replace with function body.

func _on_AddBet_pressed():
	if $LineEdit.text == "":
		return
	if current_selected.size() == 0:
		return
	
	var id = Global.add_bet($LineEdit.text, current_selected)
	var text = $LineEdit.text + "  " + id + " + " + $SelectedList.text 
	$BetList.add_item(text)
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
	print(current_selected)
	for i in range(current_selected.size()):
		text += str(i + 1) + "  " + Global.names[current_selected[i]] + "   "
	$SelectedList.text = text
	pass # Replace with function body.

func _on_DriverList_nothing_selected():
	current_selected = []
	$SelectedList.text = ""
	pass # Replace with function body.
