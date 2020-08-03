extends RigidBody2D

export(int) var id = 1
export(int, 80, 100, 4) var health_points:int = 97
export(int, 30, 40) var linear_speed = 100
export(int, 60, 90) var angular_speed = 60

export var max_look_time = 1.2
export var max_move_time = 4

signal killed(victim, killer)

enum {LOOK, MOVE, ATTACK, DEAD}
# FOLLOW

var enemyaround:bool = false
var enemyinsight:bool = false
var enemykilled:bool = false
var enemyinrange:bool = false
var wallinsight:bool = false

var objectinsight = null
var time_looking:float = 0
var time_moving:float = 0
var target_angle:float = 0
var time_damage:float = 0
var attackers:int = 0
var dir:float = 1


var state = LOOK

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	$Label.text = str(id)
	$AnimationPlayer.play("attack")
	pass

func _process(delta):
	pass

func _physics_process(delta):
	state = get_next_step()
	#$AnimationPlayer.stop()
	match(state):
		LOOK:
			time_looking += delta
			rotation_degrees += dir * angular_speed * delta
		MOVE:
			time_moving += delta
			linear_velocity = linear_speed * Vector2(cos(rotation), sin(rotation))
		ATTACK:
			$AnimationPlayer.play("attack")
		DEAD:
			set_process(false)
	pass

func get_stats():
	var dict = {}
	dict["id"] = id
	dict["hp"] = health_points
	dict["ac"] = state
	dict["es"] = enemyinsight
	dict["er"] = enemyinrange
	dict["ws"] = wallinsight
	dict["ta"] = round(target_angle)
	dict["tm"] = round(time_moving)
	dict["tl"] = round(time_looking)
	return dict

func get_next_step():
	cast_rays()

	if enemyinrange:
		return ATTACK
	
	elif enemyinsight:
		target_angle = rad2deg(get_angle_to(objectinsight.position))
		if abs(target_angle) < 5:
			return MOVE
		elif target_angle < 0:
			dir = -1
			return LOOK
		else:
			dir = 1
			return LOOK
	
	elif wallinsight:
		return LOOK
	
	elif time_looking > max_look_time:
		time_looking = 0
		time_moving = 0
		return MOVE
	
	elif time_moving > max_move_time:
		dir = rng.randi_range(0.4,1) * [1,-1][randi() % 2]
		time_looking = 0
		time_moving = 0
		return LOOK
		
	elif state == ATTACK:
		return LOOK
		
	else:
		return state


func cast_rays():
	enemyinsight = false
	wallinsight = false
	objectinsight = null
	var iamblocked = false
	
	if $Center.is_colliding():
		var body = $Center.get_collider()
		if body is RigidBody2D:
			enemyinsight = true
			objectinsight = body
		if body is StaticBody2D:
			iamblocked = true
	
	if iamblocked:
		if $Left.is_colliding():
			var body = $Left.get_collider()
			if body is StaticBody2D:
				wallinsight = true
				dir = 1 * rng.randi_range(0.4,1)
			
		elif $Right.is_colliding():
			var body = $Right.get_collider()
			if body is StaticBody2D:
				wallinsight = true
				dir = -1 * rng.randi_range(0.4,1)
	
	var areas = $HitBox.get_overlapping_areas()
	for area in areas:
		if area.name == "Weapon":
			queue_free()
