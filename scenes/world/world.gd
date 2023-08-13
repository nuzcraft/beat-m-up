extends Node2D

@onready var hero: Hero = $Hero

var effect_scene = preload("res://scenes/effect/effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if InputBuffer.is_action_press_buffered("ui_left"):
		hero.set_flip_h(false)
		var enemy = get_closest_enemy("left")
		move_hero_to_attack(enemy)
	elif InputBuffer.is_action_press_buffered("ui_right"):
		hero.set_flip_h(true)
		var enemy = get_closest_enemy("right")
		move_hero_to_attack(enemy)

func get_closest_enemy(direction: String):
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return null
	var closest = null
	for enemy in enemies:
		var x_distance = enemy.global_position.x - hero.global_position.x
		if direction == "right" and x_distance < 0:
			continue
		if direction == "left" and x_distance > 0:
			continue
		if closest == null:
			closest = enemy
		else:
			if abs(x_distance) < abs(closest.global_position.x - hero.global_position.x):
				closest = enemy
	return closest
	
func move_hero_to_attack(target):
	if target:
		var difference: Vector2 = target.global_position - hero.global_position
		var normalized: Vector2 = Vector2(difference.x, 0).normalized()
		var new_position: Vector2 = Vector2(target.global_position.x + (24 * -normalized.x), target.global_position.y)
		if hero.global_position.distance_to(target.global_position) > 24:
			var move_hero_tween = get_tree().create_tween()
			move_hero_tween.set_ease(Tween.EASE_IN_OUT)
			move_hero_tween.tween_property(hero, "global_position", new_position, 0.1)
			hero.jump()
			move_hero_tween.tween_callback(attack.bind(hero, target))
		else:
			attack(hero, target)
		
		
func attack(actor, target):
	var attack_info = actor.get_attack(target)
	target.take_damage(attack_info["damage"])
	var effect = effect_scene.instantiate()
	add_child(effect)
	effect.global_position = Vector2(target.global_position.x, target.global_position.y-12)
	effect.flip_h(actor.get_flip_h())
	effect.play(attack_info["anim"])
#
		
