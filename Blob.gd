extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var id = 1
export(int, 30, 40) var linear_speed = 100
export(int, 60, 90) var angular_speed = 720
export(int, 10, 25) var sense_range = 20
export(int, 60, 90) var sight_range = 70
export(int, 12, 16) var weapon = 12

var health_points:int = 96
var target_point:Vector2 = Vector2(400,200)
var target_angle:float = deg2rad(180)

var sense_enemies = {}
var sight_enemies = {}

var velocity:Vector2 = Vector2.ZERO

signal killed(victim, killer)


enum {IDLE, LOOK, MOVE, ATTACK, DEAD}

var underattack:bool = false
var enemyaround:bool = false
var enemyinsight:bool = false
var enemykilled:bool = false

var state = IDLE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	var action = get_next_step()
	match(action):
		IDLE:
			applied_torque = 0
			applied_force = Vector2.ZERO
		LOOK:
			var diff = target_angle - get_angle_to(Vector2.ZERO)
			if abs(diff) < deg2rad(5):
				state = IDLE
			elif diff > 0:
				applied_torque = +angular_speed
			else:
				applied_torque = -angular_speed
		MOVE:
			if position.distance_to(target_point) < 2:
				state = IDLE
				linear_velocity = Vector2.ZERO
			else:
				print(position.distance_to(target_point))
				linear_velocity = position.direction_to(target_point) * linear_speed
		ATTACK:
			$AnimationPlayer.play("attack")
		DEAD:
			set_process(false)
	pass

func get_stats():
	var dict = {}
	dict["sense"] = sense_enemies.keys()
	dict["sight"] = sight_enemies.keys()
	dict["hp"] = health_points
	dict["action"] = state
	return dict

func _on_Smell_body_entered(body):
	if body.id != id:
		print(id," senses ", body.id)
		sense_enemies[body.id] = body
		enemyaround = true
	pass # Replace with function body.

func _on_See_body_entered(body):
	var angle_to = position.direction_to(body.position)
	$See/RayCast2D.cast_to = angle_to * sight_range
	if body == $See/RayCast2D.get_collider():
		print(id," sees ", body.id)
		sight_enemies[body.id] = body
		enemyinsight = true
	pass

func get_next_step(): 
	pass

func _on_HurtBox_area_entered(area:Area2D):
	if area.get_parent() == self:
		return
	if area.name == "Weapon":
		underattack = true
		health_points = health_points - 16
	if health_points <= 0:
		print(id, " is killed by ", area.get_parent().id)
		emit_signal("killed",id, area.get_parent().id)
		queue_free() 
	pass # Replace with function body.
	
func _on_Smell_body_exited(body):
	if body.id in sense_enemies:
		print(id, sense_enemies.erase(body.id))
	if sense_enemies.size() == 0:
		enemyinsight = false

func _on_See_body_exited(body):
	if body.id in sight_enemies:
		print(id, sight_enemies.erase(body.id))

func _on_HurtBox_area_exited(area):
	if area.get_parent() == self:
		return
	if area.name == "Weapon":
		underattack = false
