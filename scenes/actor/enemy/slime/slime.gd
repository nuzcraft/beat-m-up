extends Enemy
class_name Slime

signal attack(actor, target)

@onready var windUpTimer: Timer = $WindUpTimer
@onready var jumpTimer: Timer = $JumpTimer

@export var target: Actor
@export var speed: int = 1

func _ready():
	randomize()
	jumpTimer.stop()
	jumpTimer.wait_time = randf_range(0, jumpTimer.wait_time)
	jumpTimer.start()
	print(jumpTimer.wait_time)

func _process(delta):
	super(delta)
	if animationPlayer.is_playing() && animationPlayer.assigned_animation == "slime_jump":
		global_position = global_position.move_toward(target.global_position, speed)

func _on_jump_timer_timeout():
	animationPlayer.play("slime_pre_jump")
	windUpTimer.wait_time = 1
	windUpTimer.start()

func _on_animation_player_animation_finished(anim_name):
	super(anim_name)
	if anim_name == "slime_jump":
		animationPlayer.play("RESET")

func _on_wind_up_timer_timeout():
	animationPlayer.play("slime_jump")
	jumpTimer.wait_time = 3.5
	jumpTimer.start()
	if global_position.distance_to(target.global_position) < 30:
		attack.emit(self, target)
