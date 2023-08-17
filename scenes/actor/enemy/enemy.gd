extends Actor
class_name Enemy

@export var points: int = 100
signal died(pts)

func die():
	super()
	remove_from_group("enemies")
	died.emit(points)

