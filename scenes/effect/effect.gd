extends Node2D

@onready var effect_sprite = $EffectSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_effect_sprite_animation_finished():
	queue_free()
	
func play(anim: String):
	effect_sprite.play(anim)
	
func flip_h(b: bool):
	effect_sprite.flip_h = b
