extends Actor
class_name Hero

signal hero_died

func die():
	hero_died.emit()

func take_damage(amount: int):
	super(amount)
	immune = true
