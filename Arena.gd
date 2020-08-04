extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var Blob = load("res://Blob.tscn")
	for i in range(20):
		var blob:RigidBody2D = Blob.instance()
		blob.scale = Vector2(0.8,0.8)
		blob.id = i
		blob.position = Vector2(rng.randi_range(40,1220),rng.randi_range(40,640))
		blob.rotation_degrees = rng.randi_range(-180,180)
		$YSort/Blobs.add_child(blob)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $YSort/Blobs.get_child_count() == 1:
		get_tree().paused = true
	var text:PoolStringArray = []
	for blob in $YSort/Blobs.get_children():
		text.append(blob.get_stats())
	$CanvasLayer/Label.text = text.join('\n')

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
	if event.is_action_pressed("ui_select"):
		get_tree().paused = false
