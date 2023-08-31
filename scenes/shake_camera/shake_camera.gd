extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
#@export (NodePath) var target  # Assign the node this camera will follow.

var shake_strength = 0.0  # Current shake strength.
var shake_power = 2  # shake exponent. Use [2, 3].

@onready var noise = FastNoiseLite.new()
var noise_y = 0
var noise_x: float

var base_offset: Vector2

func _ready():
	base_offset = offset
	randomize()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.set_seed(randi())
	noise.frequency = 4
	noise_x = randf()

func add_shake(amount):
	shake_strength = min(shake_strength + amount, 0.5)

func _process(delta):
#	if target:
#		global_position = get_node(target).global_position
	if shake_strength:
		shake_strength = max(shake_strength - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(shake_strength, shake_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise_x, noise_y)
	offset.x = (max_offset.x * amount * noise.get_noise_2d(noise_x*2, noise_y)) + base_offset.x
	offset.y = (max_offset.y * amount * noise.get_noise_2d(noise_x*3, noise_y)) + base_offset.y
