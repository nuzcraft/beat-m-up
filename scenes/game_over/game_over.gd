extends CanvasLayer

@onready var score_number_label: Label = $VBoxContainer/HBoxContainer/ScoreNumberLabel
@onready var defeated_number_label: Label = $VBoxContainer/HBoxContainer2/DefeatedNumberLabel

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false

func set_score(score:int):
	score_number_label.text = str(score)
	
func set_defeated(num:int):
	defeated_number_label.text = str(num)
