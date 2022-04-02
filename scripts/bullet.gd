extends Area2D
class_name Bullet

export(float) var dmg := 1.0
export(float) var speed := 500.0

var creator: PhysicsBody2D = null

func _physics_process(delta: float) -> void:
	move_local_y(-speed * delta)

func on_hit(who: PhysicsBody2D):
	get_parent().remove_child(self)

func _on_bullet_body_entered(body: Node) -> void:
	if body == creator: return
	if body.has_method("on_bullet_hit"):
		body.on_bullet_hit(self)
	get_parent().remove_child(self)