extends Node

signal spawn(scene)

var slime_scene = preload("res://scenes/actor/enemy/slime/slime.tscn")
var jerry_scene = preload("res://scenes/actor/enemy/slime/jerry/jerry.tscn")
var shield_knight_scene = preload("res://scenes/actor/enemy/shield_knight/shield_knight.tscn")
var imp_scene = preload("res://scenes/actor/enemy/imp/imp.tscn")
var health_scene = preload("res://scenes/actor/enemy/health/health.tscn")

@onready var spawnTimer: Timer = $SpawnTimer

var num_spawned = 0
var max_num_alive = 6
var num_alive = 0

@export var hero: Hero
var first_spawn = false
var jerry_spawn = false
var first_knight_spawn = false
var first_imp_spawn = false

var rng = RandomNumberGenerator.new()

var spawn_dict = {
	"slime": 1.0
	, "knight": 0.0
	, "imp": 0.0
	, "health": 0.0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not first_spawn:
		pick_new_monster()
		pick_new_monster()
		pick_new_monster()
		pick_new_monster()
		first_spawn = true
		
	if num_spawned == 10:
		max_num_alive = 12
		
	if num_spawned >= 12 and not jerry_spawn:
		spawn_new_monster("jerry")
		jerry_spawn = true
		
	if num_spawned >= 18 and not first_knight_spawn:
		spawn_dict = {
			"slime": 0.8
			, "knight": 0.95
			, "imp": 0.0
			, "health": 1.0
		}
		spawn_new_monster("knight")
		spawn_new_monster("health")
		first_knight_spawn = true
		
	if num_spawned >= 26 and not first_imp_spawn:
		spawn_dict = {
			"slime": 0.7
			, "knight": 0.85
			, "imp": 0.95
			, "health": 1.0
		}
		spawn_new_monster("imp")
		spawn_new_monster("health")
		first_imp_spawn = true
		
	if num_spawned >= 50:
		spawn_dict = {
			"slime": 0.5
			, "knight": 0.75
			, "imp": 0.95
			, "health": 1.0
		}
		spawn_new_monster("knight")
		spawn_new_monster("health")
		
func pick_new_monster():
	var num: float = rng.randf()
	var chosen: float = 1.0
	var enemy_string: String = "slime"
	for enemy in spawn_dict.keys():
		var new_num: float = spawn_dict[enemy]
		if new_num >= num and new_num <= chosen:
			chosen = new_num
			enemy_string = enemy
	spawn_new_monster(enemy_string)
	
func spawn_new_monster(string):
	if string == "slime":
		spawn.emit(slime_scene)
	elif string == "jerry":
		spawn.emit(jerry_scene)
	elif string == "knight":
		spawn.emit(shield_knight_scene)
	elif string == "imp":
		spawn.emit(imp_scene)
	elif string == "health":
		spawn.emit(health_scene)

func _on_spawn_timer_timeout():
	if num_alive < max_num_alive:
		pick_new_monster()
	spawnTimer.start()
