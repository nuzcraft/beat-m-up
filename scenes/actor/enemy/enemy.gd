extends Actor
class_name Enemy

func die():
	super()
	remove_from_group("enemies")
