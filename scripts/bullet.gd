extends Area2D
class_name Bullet

func is_class(n: String) -> bool:
	return .is_class(n) or n == "Bullet"

var dmg := 1.0
var speed := 500.0
var knockback := 1.0

var creator: PhysicsBody2D = null

func _physics_process(delta: float) -> void:
	move_local_y(-speed * delta)

func _on_bullet_body_entered(b: Node) -> void:
	if b.is_class("Bubble"):
		b.call_deferred("on_bullet_hit", self)
	
	get_parent().call_deferred("remove_child", self)

func _on_vanish_timer_timeout() -> void:
	get_parent().call_deferred("remove_child", self)
