extends Node
class_name Weapon

func get_class(): return "Weapon"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

export(float) var bullet_size := 0.0
export(float) var speed := 0.0
export(float) var damage := 0.0
export(int) var penetrate := 0
export(int) var bounce := 0
export(float) var precision := 0.0
export(float) var knockback := 0.0
export(float) var recoil := 0.0
export(float) var freeze := 0.0
export(int) var split := 0
export(float) var rate := 0.0

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

func combine(other):
	self.bullet_size += other.bullet_size
	self.speed += other.speed
	self.damage += other.damage
	self.penetrate += other.penetrate
	self.bounce += other.bounce
	self.precision += other.precision
	self.knockback += other.knockback
	self.recoil += other.recoil
	self.freeze += other.freeze
	self.split += other.split
	self.rate += other.rate
	print_debug("combine: " + self.name + " + " + other.name)