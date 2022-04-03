extends Area2D
class_name Droplet

func is_class(name: String) -> bool:
	return .is_class(name) or name == "Droplet"

var hp := 1.0 setget set_hp
var vel := Vector2.ZERO

func set_hp(v: float):
	hp = v
	self.scale = Vector2.ONE * v
	if hp <= 0.0:
		get_parent().call_deferred("remove_child", self)

func _ready() -> void:
	set_hp(hp)

func _process(delta: float) -> void:
	set_hp(hp - 0.1 * delta)
	if position.distance_to(Game.player.position) < 150.0:
		vel = vel.linear_interpolate((Game.player.position - position).normalized() * 1000.0, 0.1)
	position += vel * delta
	vel *= 0.99

func _on_droplet_body_entered(body: Node) -> void:
	if body == Game.player or body.is_class("Droplet"):
		get_parent().call_deferred("remove_child", self)
		body.hp += hp

func _on_vanish_timer_timeout() -> void:
	get_parent().call_deferred("remove_child", self)
