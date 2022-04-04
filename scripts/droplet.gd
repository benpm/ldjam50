extends Area2D
class_name Droplet

func get_class(): return "Droplet"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

var hp := 1.0 setget set_hp
var vel := Vector2.ZERO
var taken := false

func set_hp(v: float):
	hp = v
	if hp <= 0.0 and !taken:
		taken = true

func _ready() -> void:
	set_hp(hp)
	scale = Vector2.ZERO

func _process(delta: float) -> void:
	set_hp(hp - 0.35 * delta)

	if !Game.bounds.has_point(position):
		get_parent().remove_child(self)
		return

	if taken:
		vel = Vector2.ZERO
		position = lerp(position, Game.player.position, 0.2)
		if scale.length() < 0.05:
			get_parent().remove_child(self)
	else:
		if position.distance_to(Game.player.position) < 150.0:
			vel = vel.linear_interpolate((Game.player.position - position).normalized() * 1000.0, 0.1)
		position += vel * delta
		vel *= 0.99
	
	scale = lerp(scale, Vector2.ONE * sqrt(hp), 0.15)

func _on_droplet_body_entered(obj: Node) -> void:
	if !taken and self.hp > 0 and obj == Game.player:
		obj.hp += hp
		set_hp(0)

func _on_droplet_area_entered(obj: Area2D) -> void:
	if !taken and randf() < 0.25 and obj.is_class("Droplet") and !obj.taken:
		obj.hp = (obj.hp + self.hp)
		set_hp(0)
