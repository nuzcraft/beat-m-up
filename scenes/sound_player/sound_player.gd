extends Node

const SLIME_JUMP = preload("res://assets/sounds/slime_jump.wav")
const SLIME_LAND = preload("res://assets/sounds/slime_land.wav")
const SLIME_DIE = preload("res://assets/sounds/slime_die.wav")
const HIT = preload("res://assets/sounds/hit.wav")
const HERO_HIT = preload("res://assets/sounds/hero_hit.wav")
const HERO_DIE = preload("res://assets/sounds/hero_die.wav")
const WHOOSH = preload("res://assets/sounds/whoosh.wav")
const KNIGHT_HIT = preload("res://assets/sounds/knight_hit.wav")
const TINK = preload("res://assets/sounds/tink.wav")
const HEALTH = preload("res://assets/sounds/health_up.wav")
const IMP_TELEPORT = preload("res://assets/sounds/imp_teleport.wav")
const IMP_FIREBALL = preload("res://assets/sounds/imp_fireball.wav")
const MUSIC = preload("res://assets/sounds/Juhani Junkala Ending.wav")
const CLICK = preload("res://assets/sounds/click.wav")

@onready var audioPlayers := $AudioPlayers
@onready var musicPlayers := $MusicPlayers

func play_sound(sound):	
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

func play_music(sound):	
	for audioStreamPlayer in musicPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
func stop_music():
	for audioStreamPlayer in musicPlayers.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stop()
