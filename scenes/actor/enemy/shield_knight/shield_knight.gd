extends Enemy
class_name ShieldKnight

@export var move_speed: int

@onready var walkingTimer = $WalkingTimer
@onready var preAttackTimer = $PreAttackTimer
@onready var attackTimer = $AttackTimer

var effect_scene = preload("res://scenes/effect/effect.tscn")

enum {
	WALKING,
	PRE_ATTACK,
	ATTACK
}

var state = WALKING

func _ready():
	super()
	
func _process(delta):
	super(delta)
	
	set_flip_h(global_position.x < target.global_position.x)
	
	match state:
		WALKING: walking_state(delta)
		PRE_ATTACK: pre_attack_state(delta)
		ATTACK: attack_state(delta)
		
func walking_state(delta):
	var new_global_pos: Vector2 = global_position.move_toward(target.global_position, delta * move_speed)
	var diff = new_global_pos - global_position
	global_position = new_global_pos
	if global_position.distance_to(target.global_position) < 15:
		target.global_position += diff
		
func pre_attack_state(delta):
	# literally just here to take damage
	pass
	
func attack_state(delta):
	var all_effects = get_tree().get_nodes_in_group("effect")
	if all_effects.size() < 5:
		var effect = effect_scene.instantiate()
		add_child(effect)
		randomize()
		var x_pos = global_position.x
		if get_flip_h():
			x_pos += randf() * 24 + 12
		else:
			x_pos += -randf() * 24 - 12
		var y_pos = -randf() * 24 + global_position.y
		effect.global_position = Vector2(x_pos, y_pos)
		effect.z_index = target.z_index + 1
		effect.flip_h(get_flip_h())
		effect.play("attack_3")
		
	if global_position.distance_to(target.global_position) <= 24:
		attack.emit(self, target)

func take_damage(amount: int):
	if state == PRE_ATTACK:
		health -= amount
		if health <= 0:
			dead = true
		animationPlayer.play("take_damage")
		immuneTimer.start()
		return amount
	else:
		return 0

func _on_walking_timer_timeout():
	preAttackTimer.start()
	animationPlayer.play("pre_attack")
	state = PRE_ATTACK	

func _on_pre_attack_timer_timeout():
	attackTimer.start()
	animationPlayer.stop()
	animationPlayer.play("RESET")
	state = ATTACK 

func _on_attack_timer_timeout():
	walkingTimer.start()
	state = WALKING
