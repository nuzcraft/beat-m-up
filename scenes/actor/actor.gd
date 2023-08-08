extends Node2D
class_name Actor

@onready var characterSprite: AnimatedSprite2D = $CharacterSprite
@onready var attackSprite: AnimatedSprite2D = $AttackSprite
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func flip_h(b: bool):
	characterSprite.flip_h = b
	attackSprite.flip_h = b
	
	attackSprite.position.x = abs(attackSprite.position.x)
	if not b:
		attackSprite.position.x *= -1
		
func attack():
	characterSprite.play("attack")
	attackSprite.play("attack")	
	
func take_damage():
	animationPlayer.play("take_damage")

func _on_attack_sprite_animation_finished():
	if characterSprite.animation == "attack":
		characterSprite.play("idle")
