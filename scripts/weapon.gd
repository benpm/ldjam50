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
export(float) var cost := 0.0
export(Texture) var tex: Texture = null
export(bool) var attractor := false
export(Bullet.BulletAnimation) var anim := Bullet.BulletAnimation.None
export(bool) var accelerate := false
export(float) var vanish_time := 2.0

func spawn(creator: PhysicsBody2D, pos: Vector2, rot: float) -> Bullet:
	var b: Bullet = Game._bullet.instance()
	b.creator = creator
	b.position = pos
	b.rotation = rot
	b.speed = speed * 1000.0
	b.dmg = damage
	b.scale = Vector2.ONE * bullet_size
	b.knockback = knockback
	b.attractor = attractor
	b.anim = anim
	b.accelerate = accelerate
	b.vanish_time = vanish_time
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
	self.cost += other.cost
	if other.tex != null:
		self.tex = other.tex
	self.attractor = self.attractor || other.attractor
