extends Node2D

@onready var hero: Hero = $Hero
@onready var shakeCamera: Camera2D = $ShakeCamera
@onready var healthLabel: Label = $HUD/HUDControls/ScoreContainer/HealthLabel
@onready var spawner = $EnemySpawner
@onready var game_over_layer: CanvasLayer = $GameOver

var effect_scene = preload("res://scenes/effect/effect.tscn")
var floating_number_scene = preload("res://scenes/floating_number/floating_number.tscn")
var projectile_scene = preload("res://scenes/projectile/projectile.tscn")

var score: int = 0

var rng = RandomNumberGenerator.new()

var first_input = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	update_score_number_label(score)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.died.connect(_on_enemy_died)
		enemy.attack.connect(_on_enemy_attack)
	for imp in get_tree().get_nodes_in_group("imps"):
		imp.summon_projectile.connect(_on_summon_projectile)
	spawner.spawn.connect(_on_spawner_spawn)
	hero.hero_died.connect(_on_hero_died)
	
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
	healthLabel.text = str(hero.health)
	
	if hero.global_position.x < 0:
		hero.global_position.x = 0
	if hero.global_position.x > 576:
		hero.global_position.x = 576
	if hero.global_position.y < 144:
		hero.global_position.y = 144
	if hero.global_position.y > 288:
		hero.global_position.y = 288
		
func _input(event):
	if first_input == false:
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventScreenTouch:
			SoundPlayer.play_music(SoundPlayer.MUSIC)
			first_input = true
		
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
		if target.global_position.x <= 552 and target.global_position.x >= 24:
			if hero.global_position.distance_to(target.global_position) > 24:
				var move_hero_tween = get_tree().create_tween()
				move_hero_tween.set_ease(Tween.EASE_IN_OUT)
				move_hero_tween.tween_property(hero, "global_position", new_position, 0.1)
				hero.jump()
				move_hero_tween.tween_callback(attack.bind(hero, target))
				SoundPlayer.play_sound(SoundPlayer.WHOOSH)
			else:
				attack(hero, target)		
		
func attack(actor, target):
	var attack_info = actor.get_attack(target)
	if not target.immune:
		var taken_damage = target.take_damage(attack_info["damage"])
		var ttl_cmbo_dmg = attack_info["total_combo_damage"]
		if taken_damage == 0:
			ttl_cmbo_dmg = 0
		var floating_number = floating_number_scene.instantiate()
		floating_number.set_number(ttl_cmbo_dmg)
		for num in get_tree().get_nodes_in_group("floating_number"):
			if num.target == target:
				num.queue_free()
		floating_number.target = target
		floating_number.offset = Vector2(-10, -24)
		floating_number.z_index = target.z_index + 2
		add_child(floating_number)
		var effect = effect_scene.instantiate()
		add_child(effect)
		effect.global_position = Vector2(target.global_position.x, target.global_position.y-12)
		effect.z_index = target.z_index + 1
		effect.flip_h(actor.get_flip_h())
		effect.play(attack_info["anim"])
		var shk_amt = attack_info["shake_amount"]
		if taken_damage == 0:
			shk_amt = 0.1
		shakeCamera.add_shake(shk_amt)
		var dir = actor.global_position.direction_to(target.global_position)
		if target is Hero:
			target.knock_back(dir, 50)
			SoundPlayer.play_sound(SoundPlayer.HERO_HIT)
		else:
			if taken_damage == 0:
				SoundPlayer.play_sound(SoundPlayer.TINK)
			else:
				SoundPlayer.play_sound(SoundPlayer.HIT)

func _on_enemy_died(points, enemy):
	score += points
	update_score_number_label(score)
	var floating_number = floating_number_scene.instantiate()
	floating_number.set_number("+" + str(points))
	floating_number.target = $HUD/HUDControls/ScoreContainer/ScoreNumberLabel
	floating_number.offset = Vector2(5, -5)
	add_child(floating_number)
	if enemy is Health:
		hero.health += 1
		SoundPlayer.play_sound(SoundPlayer.HEALTH)
	spawner.num_alive -= 1
	
func _on_enemy_attack(actor, target):
	attack(actor, target)
	
func update_score_number_label(number:int):
	$HUD/HUDControls/ScoreContainer/ScoreNumberLabel.text = str(number)
	
func _on_summon_projectile(imp: Imp):
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.global_position.x = imp.global_position.x
	projectile.global_position.y = imp.global_position.y-12
	projectile.set_flip_h(imp.get_flip_h())
	projectile.parent_actor = imp
	projectile.target = hero
	projectile.attack.connect(_on_enemy_attack)
	
func _on_spawner_spawn(scene: PackedScene):
	var enemy = scene.instantiate()
	enemy.target = hero
	enemy.died.connect(_on_enemy_died)
	enemy.attack.connect(_on_enemy_attack)
	if enemy is Imp:
		enemy.summon_projectile.connect(_on_summon_projectile)
	add_child(enemy)
	enemy.global_position.y = rng.randi_range(144, 288)
	if randf() >= 0.5:
		enemy.global_position.x = rng.randi_range(432, 600)
	else:
		enemy.global_position.x = rng.randi_range(-24, 144)
	if enemy is Health:
		enemy.set_target(hero)
	spawner.num_alive += 1
	spawner.num_spawned += 1
	
func _on_hero_died():
	game_over()	
	SoundPlayer.play_sound(SoundPlayer.HERO_DIE)
	
func game_over():
	game_over_layer.set_score(score)
	game_over_layer.set_defeated(spawner.num_spawned - spawner.num_alive)
	game_over_layer.show()
	get_tree().paused = true

