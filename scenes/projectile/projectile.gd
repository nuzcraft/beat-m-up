extends Node2D
class_name Projectile

signal attack(actor, target)

@export var move_speed: int

@onready var sprite: Sprite2D = $Sprite2D

var target: Hero
var parent_actor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = global_position.y + 1
	if not sprite.flip_h:
		global_position.x -= move_speed * delta
	else:
		global_position.x += move_speed * delta
		
	if target and parent_actor:
		if (global_position.distance_to(target.global_position) <= 6 and global_position.y >= target.global_position.y)	or (global_position.distance_to(target.global_position) <= 18 and global_position.y < target.global_position.y):
			attack.emit(parent_actor, target)
			queue_free()

func set_flip_h(b: bool):
	sprite.flip_h = b

