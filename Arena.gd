extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
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
		$YSort/Blobs.add_child(blob)
	get_tree().paused = true
	$AnimationPlayer.play("ready")
	yield($AnimationPlayer,"animation_finished")
	get_tree().paused = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $YSort/Blobs.get_child_count() == 1:
		get_tree().paused = true
		$AnimationPlayer.play("Finish")
		yield($AnimationPlayer,"animation_finished")
		get_tree().quit()
#	var text:PoolStringArray = []
#	for blob in $YSort/Blobs.get_children():
#		text.append(blob.get_stats())
#	$CanvasLayer/Label.text = text.join('\n')

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
	if event.is_action_pressed("ui_select"):
		get_tree().paused = false
