extends Actor
class_name Hero

func die():
	get_tree().reload_current_scene()

func take_damage(amount: int):
	super(amount)
	immune = true
