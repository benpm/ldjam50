extends Area2D
class_name Droplet

var hp := 1.0
var vel := Vector2.ZERO

func _process(delta: float) -> void:
	if position.distance_to(Game.player.position) < 150.0:
		vel = vel.linear_interpolate((Game.player.position - position).normalized() * 1000.0, 0.1)
	position += vel * delta
	vel *= 0.99

func _on_droplet_body_entered(body: Node) -> void:
	if body == Game.player:
		get_parent().call_deferred("remove_child", self)
		Game.player.hp += hp

func _on_vanish_timer_timeout() -> void:
	get_parent().call_deferred("remove_child", self)
