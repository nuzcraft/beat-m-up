extends Enemy
class_name Imp

@export var move_speed: int

enum {
	WALKING
}

var state = WALKING

func _ready():
	super()
	
func _process(delta):
	super(delta)
	
	set_flip_h(global_position.x < target.global_position.x)
	
	match state:
		WALKING: walking_state(delta)
#		PRE_ATTACK: pre_attack_state(delta)
#		ATTACK: attack_state(delta)

func walking_state(delta):
	var new_global_pos: Vector2 = global_position.move_toward(target.global_position, delta * move_speed)
	var diff = new_global_pos - global_position
	global_position = new_global_pos
	if global_position.distance_to(target.global_position) < 15:
		target.global_position += diff
