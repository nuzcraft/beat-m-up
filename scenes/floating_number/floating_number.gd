extends Node2D

var target
var offset: Vector2
var pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if target:
		global_position = target.global_position + offset
	elif pos:
		global_position = pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	queue_free()
	
func set_number(number):
	$LabelHolder/Label.text = str(number)
