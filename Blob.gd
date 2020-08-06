extends RigidBody2D

export(int) var id = 1
export(int, 80, 100, 4) var health_points:int = 97
export(int, 30, 40) var linear_speed = 80
export(int, 60, 90) var angular_speed = 90

export var max_look_time = 1
export var max_move_time = 3

signal killed(victim, killer)

enum {LOOK, MOVE, ATTACK, DEAD}
# FOLLOW

var enemyaround:bool = false
var enemyinsight:bool = false
var enemykilled:bool = false
var enemyinrange:bool = false
var wallinsight:bool = false
var underattack:bool = false

var objectinsight = null
var time_looking:float = 0
var time_moving:float = 0
var target_angle:float = 0
var time_damage:float = 0
var dir:float = 1


var state = LOOK

var rng = RandomNumberGenerator.new()
func _ready():
	$Sprite.frame = id
	$Label.text = str(id)
	rng.randomize()
	pass

func _process(delta):
	pass

func _physics_process(delta):
	state = get_next_step()
	#$AnimationPlayer.stop()
	match(state):
		DEAD:
			pass
		
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
	
	if state == DEAD:
		return DEAD

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
	
	if underattack:
		dir = dir * rng.randf_range(1,2)
		return LOOK
	
	elif time_looking > max_look_time:
		time_looking = 0
		time_moving = 0
		return MOVE
	
	elif time_moving > max_move_time:
		dir = rng.randf_range(0.4,1) * [1,-1][rng.randi() % 2]
		print(dir)
		time_looking = 0
		time_moving = 0
		return LOOK
	
	elif wallinsight:
		dir = dir * rng.randf_range(0.4,1)
		return LOOK
		
	elif state == ATTACK:
		return LOOK
		
	else:
		return state


func cast_rays():
	enemyinsight = false
	wallinsight = false
	objectinsight = null
	underattack = false
	
	if $Left.is_colliding():
		var body = $Left.get_collider()
		if body is StaticBody2D:
			wallinsight = true
			dir = 1 
			
	elif $Right.is_colliding():
		var body = $Right.get_collider()
		if body is StaticBody2D:
			wallinsight = true
			dir = -1 
	
	if $RCenter.is_colliding():
		var body = $RCenter.get_collider()
		if body is RigidBody2D:
			enemyinsight = true
			objectinsight = body
		if body is StaticBody2D:
			pass
			#wallinsight = true
	
	if $LCenter.is_colliding():
		var body = $LCenter.get_collider()
		if body is RigidBody2D:
			enemyinsight = true
			objectinsight = body
		if body is StaticBody2D:
			pass
			#wallinsight = true
			
	var areas = $HitBox.get_overlapping_areas()
	for area in areas:
		if area.name == "Weapon":
			health_points -= 1
			if health_points < 0:
				queue_free()
			break

	var bodies = $Sense.get_overlapping_bodies()
	for body in bodies:
		if body != self:
			if 0 > position.angle_to_point(body.position):
				dir = 1
			else:
				dir = -1
			underattack = true
	
