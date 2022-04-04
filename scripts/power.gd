extends RigidBody2D
class_name Power

func get_class(): return "Power"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

	