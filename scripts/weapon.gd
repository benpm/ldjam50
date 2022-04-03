extends Node
class_name Weapon

func is_class(name: String) -> bool:
	return .is_class(name) or name == "Weapon"

export(float) var bullet_size := 1.0
export(float) var speed := 1.0
export(float) var damage := 1.0
export(bool) var penetrate := false
export(bool) var bounce := false
export(float) var precision := 1.0
export(float) var knockback := 1.0

func spawn(creator: PhysicsBody2D, pos: Vector2, rot: float) -> Bullet:
	var b: Bullet = Game._bullet.instance()
	b.creator = creator
	b.position = pos
	b.rotation = rot
	b.speed = speed * 1000.0
	b.dmg = damage
	b.scale = Vector2.ONE * bullet_size
	b.knockback = knockback
	return b
	