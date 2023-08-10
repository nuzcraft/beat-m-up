extends Node2D

@onready var hero: Hero = $Hero

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		hero.flip_h(false)
		var enemy = get_closest_enemy("left")
		move_hero_to_attack(enemy)
	elif Input.is_action_just_pressed("ui_right"):
		hero.flip_h(true)
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
		var distance: Vector2 = target.global_position - hero.global_position
		var normalized: Vector2 = Vector2(distance.x, 0).normalized()
		var new_position: Vector2 = Vector2(target.global_position.x + (24 * -normalized.x), target.global_position.y)
#		hero.global_position = target.global_position
#		hero.global_position.x += (24 * -normalized.x)
		var move_hero_tween = get_tree().create_tween()
		move_hero_tween.set_ease(Tween.EASE_IN_OUT)
		move_hero_tween.tween_property(hero, "global_position", new_position, 0.1)
		move_hero_tween.tween_callback(hero.attack)
		move_hero_tween.tween_callback(target.take_damage)
#
		
