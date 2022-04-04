extends RigidBody2D
class_name Bubble

func get_class(): return "Bubble"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

export(float) var hp := 10.0 setget set_hp
export(float) var speed := 10000.0
export(float) var fire_rate := 2.0 setget set_fire_rate

onready var fire_timer: Timer = $fire_timer
onready var sprite: Sprite = $Sprite
onready var init_hp := hp

var sprite_init_scale: Vector2

var can_fire := false
var weapons := []
var freeze := 0.0

func _ready() -> void:
	fire_timer.start((1.0 / fire_rate) * rand_range(0.0, 1.0))
	set_fire_rate(fire_rate)
	sprite_init_scale = sprite.scale
	for child in get_children():
		if child.is_class("Weapon"):
			weapons.append(child)
	
func _process(delta: float) -> void:
	if freeze > 0.0:
		modulate.v = 1.0 + freeze * 0.25
		freeze = clamp(freeze - delta, 0.0, 8.0)
	else:
		modulate.v = 1.0
		freeze = 0.0

func _integrate_forces(state):
	rotation_degrees = 0

func add_weapon(weapon: Weapon):
	weapons.append(weapon)
	add_child(weapon)

func set_fire_rate(v: float):
	fire_rate = v
	if fire_timer != null:
		fire_timer.wait_time = 1.0 / fire_rate

func set_hp(v: float):
	hp = v
	if hp <= 0.0:
		destroy()

func destroy() -> void:
	get_parent().remove_child(self)

func fire(angle: float) -> void:
	if not can_fire: return
	var frate := 0.0
	var fcost := 0.0
	for weapon in weapons:
		var split_offset = (weapon.split - 1) / 2.0
		for i in range(weapon.split):
			var angle_offset = rand_range(-1.0, 1.0) * (1.0 / weapon.precision) * 0.05
			var bullet = weapon.spawn(self, self.position, angle + 0.1 * (i - split_offset) + angle_offset)
			get_parent().add_child(bullet)
			bullet.sprite.texture = weapon.tex
		apply_central_impulse(Vector2(0,1).rotated(angle) * 250.0 * weapon.recoil)
		frate += weapon.rate
		fcost += weapon.cost
	set_fire_rate(frate * (1.0 / (1.0 + freeze)))
	set_hp(hp - fcost)
	can_fire = false

func on_bullet_hit(bullet) -> void:
	if hp <= 0.0: return
	set_hp(hp - bullet.dmg)
	freeze += bullet.freeze
	var r = bullet.rotation - PI / 2.0
	if self != Game.lvl.player:
		Game.lvl.make_droplet(bullet.position,
			Vector2(1,rand_range(-0.7, 0.7)).rotated(r)*bullet.speed*rand_range(0.1, 0.25), rand_range(0.5, 2.0))
		if hp <= 0.0:
			for _i in range(rand_range(init_hp * 0.5, init_hp)):
				Game.lvl.make_droplet(bullet.position,
				Vector2(1,rand_range(-1.2, 1.2)).rotated(r)*bullet.speed*rand_range(0.1, 0.25)*3.0, rand_range(0.5, 2.0))
	apply_central_impulse(Vector2(1,0).rotated(r) * 1000.0 * bullet.knockback)

func _on_fire_timer_timeout() -> void:
	can_fire = true
