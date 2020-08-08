extends RigidBody2D

export(int) var id = 1
export(String) var label = "Diver"

export(int, 80, 100, 4) var health_points:int = 180
export(int, 30, 40) var linear_speed = 80
export(int, 60, 90) var angular_speed = 90

export var max_look_time = 1
export var max_move_time = 3

signal dead(id)

enum {LOOK, MOVE}

var enemyaround:bool = false
var enemyinsightL:bool = false
var enemyinsightR:bool = false
var wallinsightL:bool = false
var wallinsightR:bool = false

var time_looking:float = 0
var time_moving:float = 0
var dir:float = 1

var state = MOVE

var rng = RandomNumberGenerator.new()
func _ready():
	print(id," ",label)
	$Sprite.frame = id
	$CanvasLayer/Label.text = label
	$CanvasLayer/Label.set_position(position + Vector2(0,-40))
	rng.randomize()
	pass

func _process(delta):
	pass

func _physics_process(delta):
	state = get_next_step()
	match(state):
		LOOK:
			time_looking += delta
			rotation_degrees += dir * angular_speed * delta
		MOVE:
			time_moving += delta
			linear_velocity = linear_speed * Vector2(cos(rotation), sin(rotation))
	$CanvasLayer/Label.set_position(position + Vector2(0,-40))

func get_stats():
	var dict = {}
	dict["id"] = id
	dict["hp"] = health_points
	dict["ac"] = state
	dict["esl"] = enemyinsightL
	dict["esr"] = enemyinsightR
	dict["wsl"] = wallinsightL
	dict["wsr"] = wallinsightR
	dict["tm"] = round(time_moving)
	dict["tl"] = round(time_looking)
	return dict

func get_next_step():
	cast_rays()
	
	if enemyinsightL and enemyinsightR:
		return MOVE
	
	if enemyinsightL:
		dir = -1
		return LOOK
	
	if enemyinsightR:
		dir = 1
		return LOOK
	
	if time_looking > max_look_time:
		time_looking = 0
		time_moving = 0
		return MOVE
	
	if time_moving > max_move_time:
		dir = rng.randf_range(0.4,1) * [1,-1][rng.randi() % 2]
		time_looking = 0
		time_moving = 0
		return LOOK
	
	if wallinsightL:
		dir = +1 * rng.randf_range(0.4,1)
		return LOOK
	
	if wallinsightR:
		dir = -1 * rng.randf_range(0.4,1)
		return LOOK

	if enemyaround:
		return MOVE
	
	return state

func hurt():
	health_points -= 1
	if health_points < 0:
		emit_signal("dead",id)
		print(id," ",label," eliminated")
		queue_free()
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("hurt")

func scale():
	$RCenter.scale = $RCenter.scale * 1.3
	$LCenter.scale = $LCenter.scale * 1.3
	linear_speed = linear_speed * 1.1

func cast_rays():
	enemyinsightL = false
	enemyinsightR = false
	wallinsightL = false
	wallinsightR = false
	enemyaround = false
		
	if $Left.is_colliding():
		var body = $Left.get_collider()
		if body is StaticBody2D:
			wallinsightL = true
			
	elif $Right.is_colliding():
		var body = $Right.get_collider()
		if body is StaticBody2D:
			wallinsightR = true
	
	if $RCenter.is_colliding():
		var body = $RCenter.get_collider()
		if body is RigidBody2D:
			enemyinsightR = true
		if body is StaticBody2D:
			pass
			#wallinsight = true
	
	if $LCenter.is_colliding():
		var body = $LCenter.get_collider()
		if body is RigidBody2D:
			enemyinsightL = true
		if body is StaticBody2D:
			pass
			
	var bodies = $Sense.get_overlapping_bodies()
	for body in bodies:
		if body != self:
			enemyaround = true
	
	var weponbodies = $Weapon.get_overlapping_bodies()
	for body in weponbodies:
		if body is RigidBody2D:
			if body != self:
				body.hurt()
	
