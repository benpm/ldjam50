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

	if taken:
		vel = Vector2.ZERO
		position = lerp(position, Game.lvl.player.position, 0.2)
	else:
		if position.distance_to(Game.lvl.player.position) < 500.0:
			vel = vel.linear_interpolate((Game.lvl.player.position - position).normalized() * 1000.0, 0.1)
		position += vel * delta
		vel *= 0.98
	
	scale = lerp(scale, Vector2.ONE * sqrt(hp), 0.15)
	if scale.length() < 0.05 || hp < -1.0:
		get_parent().remove_child(self)

func _on_droplet_body_entered(obj: Node) -> void:
	if !taken and self.hp > 0 and obj == Game.lvl.player:
		obj.hp += hp
		set_hp(0)
		Game.play_sound("pop1", position)

func _on_droplet_area_entered(obj: Area2D) -> void:
	if !taken and randf() < 0.25 and obj.is_class("Droplet") and !obj.taken and obj.hp >= self.hp:
		obj.hp = (obj.hp + self.hp)
		set_hp(0)
