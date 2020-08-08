extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var results = Global.get_results()
	for result in results:
		var text = Global.bet_result_string(result)
		$ItemList.add_item(text)
	$Podium.text = Global.podium_string

func _on_Quit_pressed():
	get_tree().quit()

func _on_NextRound_pressed():
	get_tree().change_scene("res://putbets.tscn")
