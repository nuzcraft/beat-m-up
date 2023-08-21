extends Node2D
class_name Actor

@onready var characterSprite: AnimatedSprite2D = $CharacterSprite
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var comboTimer: Timer = $ComboTimer

@export var health: int
var dead: bool = false
var death_animation_playing: bool = false

enum combo_anim {
	ATTACK_1,
	ATTACK_2,
	ATTACK_3
}
var combo_damage = {
	combo_anim.ATTACK_1: 0,
	combo_anim.ATTACK_2: 1,
	combo_anim.ATTACK_3: 2
}
@export var base_damage: int = 1
var current_combo = combo_anim.ATTACK_1
var current_target
var combo_time: float = 0.5

func _ready():
	animationPlayer.play("RESET")
	pass

func _process(delta):
	if dead and not death_animation_playing:
		die()
	
func set_flip_h(b: bool):
	characterSprite.flip_h = b
	
func get_flip_h():
	return characterSprite.flip_h
		
func jump():
	animationPlayer.play("jump")
	
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		dead = true
	animationPlayer.play("take_damage")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "jump":
		animationPlayer.play("RESET")
	elif anim_name == "RESET":
		characterSprite.play("idle")
		
func die():
	death_animation_playing = true
	var die_tween = get_tree().create_tween()
	die_tween.tween_property(characterSprite, "modulate:a", 0, 0.25)
	die_tween.tween_callback(queue_free)
	
func get_attack(target):
	check_target(target)
	if comboTimer.time_left > 0.0:
		increase_combo()
	else:
		comboTimer.wait_time = combo_time
		comboTimer.start()
	var anim_name = combo_anim.keys()[current_combo].to_lower()
	var damage = base_damage + combo_damage[current_combo]
	attack_anim(target)
	var shake_amount = min(0.15 + (0.075 * current_combo), 0.5)
	return {"anim": anim_name, "damage": damage, "shake_amount": shake_amount, "total_combo_damage": get_combo_damage(current_combo)}
	
func attack_anim(target):
	characterSprite.global_position = Vector2(target.global_position.x, target.global_position.y - 12)
	characterSprite.position.x -= (characterSprite.position.x / 2)
	var tween = get_tree().create_tween()
	tween.tween_property(characterSprite, "position", Vector2(0, -12), 0.1)

func increase_combo():
	current_combo += 1
	if current_combo > combo_anim.size() - 1:
		current_combo = combo_anim.size() - 1
	comboTimer.stop()
	comboTimer.wait_time = combo_time
	comboTimer.start()
	
func reset_combo():
	current_combo = combo_anim.ATTACK_1
	comboTimer.stop()
	comboTimer.wait_time = combo_time

func _on_combo_timer_timeout():
	current_combo = combo_anim.ATTACK_1
	
func set_current_target(target):
	current_target = target
	
func check_target(target):
	if target != current_target:
		reset_combo()
		current_target = target
		
func get_combo_damage(num_in_combo):
	var total_combo_damage = 0
	for dmg in combo_damage.keys().slice(0, num_in_combo+1):
		total_combo_damage += (base_damage + dmg)
	return total_combo_damage
		
