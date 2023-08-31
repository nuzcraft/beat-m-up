extends Node

signal spawn(scene)

var slime_scene = preload("res://scenes/actor/enemy/slime/slime.tscn")
var jerry_scene = preload("res://scenes/actor/enemy/slime/jerry/jerry.tscn")
var shield_knight_scene = preload("res://scenes/actor/enemy/shield_knight/shield_knight.tscn")
var imp_scene = preload("res://scenes/actor/enemy/imp/imp.tscn")
var health_scene = preload("res://scenes/actor/enemy/health/health.tscn")

var num_spawned = 0
var max_num_alive = 6
var num_alive = 0

@export var hero: Hero
var spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not spawned:
		spawn.emit(slime_scene)
		spawn.emit(jerry_scene)
		spawn.emit(shield_knight_scene)
		spawn.emit(shield_knight_scene)
		spawn.emit(imp_scene)
		spawn.emit(imp_scene)
		spawn.emit(health_scene)
		spawn.emit(health_scene)
		spawned = true
	print(num_alive)
	
	
