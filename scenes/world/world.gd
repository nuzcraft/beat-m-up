extends Node2D

@onready var hero: Hero = $Hero

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		hero.flip_h(false)
		var enemy = get_closest_enemy(Vector2i(-1, 0))
		move_hero_to_attack(enemy)
	elif Input.is_action_just_pressed("ui_right"):
		hero.flip_h(true)
		var enemy = get_closest_enemy(Vector2i(1, 0))
		move_hero_to_attack(enemy)

func get_closest_enemy(direction: Vector2):
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return null
	var closest = enemies[0]
	for enemy in enemies:
		var enemy_x = enemy.global_position.x
		var hero_x = hero.global_position.x
		var closest_x = closest.global_position.x
		if abs(enemy_x - hero_x) < abs(closest_x - hero_x) and \
			enemy_x - hero_x * direction.x > 0:
			closest = enemy
	return closest
	
func move_hero_to_attack(target):
	var distance: Vector2 = target.global_position - hero.global_position
	var normalized: Vector2 = Vector2(distance.x, 0).normalized()
	hero.global_position = target.global_position
	hero.global_position.x += (24 * -normalized.x)
	
		
