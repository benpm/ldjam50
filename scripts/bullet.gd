extends Area2D
class_name Bullet

export(float) var dmg := 1.0
export(float) var speed := 500.0

var creator: PhysicsBody2D = null

func _physics_process(delta: float) -> void:
	move_local_y(-speed * delta)
