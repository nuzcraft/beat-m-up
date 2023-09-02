extends Enemy
class_name Slime

@onready var windUpTimer: Timer = $WindUpTimer
@onready var jumpTimer: Timer = $JumpTimer

@export var speed: int = 50

func _ready():
	super()
	randomize()
	jumpTimer.stop()
	jumpTimer.wait_time = randf_range(0, jumpTimer.wait_time)
	jumpTimer.start()

func _process(delta):
	super(delta)
	if animationPlayer.is_playing() && animationPlayer.assigned_animation == "slime_jump":
		global_position = global_position.move_toward(target.global_position, speed * delta)
		
	if global_position.distance_to(target.global_position) < 20:
		attack.emit(self, target)

func _on_jump_timer_timeout():
	animationPlayer.play("slime_pre_jump")
	windUpTimer.wait_time = 1
	windUpTimer.start()

func _on_animation_player_animation_finished(anim_name):
	super(anim_name)
	if anim_name == "slime_jump":
		SoundPlayer.play_sound(SoundPlayer.SLIME_LAND)
		animationPlayer.play("RESET")

func _on_wind_up_timer_timeout():
	animationPlayer.play("slime_jump")
	jumpTimer.wait_time = 3.5
	jumpTimer.start()
	SoundPlayer.play_sound(SoundPlayer.SLIME_JUMP)
	
func die():
	super()
	SoundPlayer.play_sound(SoundPlayer.SLIME_DIE)
