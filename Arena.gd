extends Node2D

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	
	var Blob = load("res://Blob.tscn")
	for i in range(Global.grid.size()):
		var blob:RigidBody2D = Blob.instance()
		blob.id = Global.ids[i]
		blob.label = Global.names[blob.id]
		var grid = Global.grid[i]
		blob.position = Vector2(rng.randi_range(grid[0],grid[1]),rng.randi_range(grid[2],grid[3]))
		blob.rotation_degrees = rng.randi_range(-180,180)
		blob.connect("dead",self,"blob_dead")
		$YSort/Blobs.add_child(blob)
	get_tree().paused = true
	$AnimationPlayer.play("ready")
	yield($AnimationPlayer,"animation_finished")
	get_tree().paused = false
	
func blob_dead(id):
	Global.result.append(id)
	
func _process(delta):
	if $YSort/Blobs.get_child_count() == 1:
		set_process(false)
		Global.result.append($YSort/Blobs.get_child(0).id)
		get_tree().paused = true
		Global.set_podium()
		print(Global.podium)
		$CanvasLayer/VBoxContainer/First.text = "1. " + Global.names[Global.podium[0]]
		$CanvasLayer/VBoxContainer/Second.text = "2. " + Global.names[Global.podium[1]]
		$CanvasLayer/VBoxContainer/Third.text = "3. " + Global.names[Global.podium[2]]
		print(Global.podium)
		$AnimationPlayer.play("Finish")
		yield($AnimationPlayer,"animation_finished")
		get_tree().paused = false
		get_tree().change_scene("res://results.tscn")
		
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == true:
			get_tree().paused = false
		else:
			get_tree().paused = true

func _on_Timer_timeout():
	print("scaled")
	for blob in $YSort/Blobs.get_children():
		blob.scale()
	pass
