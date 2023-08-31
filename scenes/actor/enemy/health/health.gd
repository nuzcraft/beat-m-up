extends Enemy
class_name Health

@export var move_speed: int
var dir: int = 1

func _ready():
	super()
	if global_position.direction_to(target.global_position).x <= 0:
		dir = -1
	

func _process(delta):
	super(delta)
	global_position.x += move_speed * delta * dir
	
func set_target(trgt):
	target = trgt
	if global_position.direction_to(target.global_position).x <= 0:
		dir = -1
	
