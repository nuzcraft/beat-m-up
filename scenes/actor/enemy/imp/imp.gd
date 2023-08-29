extends Enemy
class_name Imp

signal summon_projectile(actor)

@export var move_speed: int

@onready var preAttackTimer: Timer = $PreAttackTimer

var effect_scene = preload("res://scenes/effect/effect.tscn")

enum {
	WALKING,
	PRE_ATTACK,
	ATTACK
}

var state = WALKING
var time_elapsed: float = 0

func _ready():
	super()
	
func _process(delta):
	super(delta)
	time_elapsed += delta
	
	set_flip_h(global_position.x < target.global_position.x)
	
	match state:
		WALKING: walking_state(delta)
		PRE_ATTACK: pre_attack_state(delta)
#		ATTACK: attack_state(delta)


func walking_state(delta):
	var new_global_pos: Vector2 = global_position.move_toward(target.global_position, delta * move_speed)
	if global_position.distance_to(target.global_position) > 40:
		new_global_pos.y += sin(time_elapsed)/2
	var diff = new_global_pos - global_position
	global_position = new_global_pos
	if global_position.distance_to(target.global_position) < 15:
		target.global_position += diff
		
func take_damage(amount: int):
	if state != WALKING:
		health -= amount
		if health <= 0:
			dead = true
		animationPlayer.play("take_damage")
		immuneTimer.start()
		return amount
	else:
		teleport()
		return 0
		
func pre_attack_state(delta):
	# literally just here to take damage
	pass
	
func teleport():
	var dir = 1
	if get_flip_h() == false:
		dir = -1
	var old_gp = global_position
	var new_gp = Vector2(global_position.x + (72 * dir), global_position.y)
	global_position = new_gp
	
	var effect_1 = effect_scene.instantiate()
	add_child(effect_1)
	effect_1.global_position = old_gp
	effect_1.global_position.y -= 12
	effect_1.z_index = z_index + 5
	effect_1.play("teleport")
	
	var effect_2 = effect_scene.instantiate()
	add_child(effect_2)
	effect_2.global_position = new_gp
	effect_2.global_position.y -= 12
	effect_2.z_index = z_index + 5
	effect_2.play("teleport")
	
	animationPlayer.play("pre_attack")
	preAttackTimer.start()
	state = PRE_ATTACK
	
func _on_pre_attack_timer_timeout():
#	attackTimer.start()
	summon_projectile.emit(self)
	animationPlayer.stop()
	animationPlayer.play("RESET")
	state = WALKING

