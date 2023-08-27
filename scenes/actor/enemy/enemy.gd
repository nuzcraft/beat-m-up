extends Actor
class_name Enemy

signal died(pts)
signal attack(actor, target)

@export var target: Actor
@export var points: int = 100

func die():
	super()
	remove_from_group("enemies")
	died.emit(points)

