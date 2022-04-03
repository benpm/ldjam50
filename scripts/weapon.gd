extends Node
class_name Weapon

func get_class(): return "Weapon"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

export(float) var bullet_size := 1.0
export(float) var speed := 1.0
export(float) var damage := 1.0
export(bool) var penetrate := false
export(bool) var bounce := false
export(float) var precision := 1.0
export(float) var knockback := 1.0
export(float) var recoil := 1.0

func spawn(creator: PhysicsBody2D, pos: Vector2, rot: float) -> Bullet:
	var b: Bullet = Game._bullet.instance()
	b.creator = creator
	b.position = pos
	b.rotation = rot
	b.speed = speed * 1000.0
	b.dmg = damage
	b.scale = Vector2.ONE * bullet_size
	b.knockback = knockback
	if creator == Game.player:
		b.collision_layer = Game.PLAYER_BULLET_LAYER
		b.collision_mask = Game.ENEMY_BULLET_LAYER
	else:
		b.collision_layer = Game.ENEMY_BULLET_LAYER
		b.collision_mask = Game.PLAYER_BULLET_LAYER
	return b
	