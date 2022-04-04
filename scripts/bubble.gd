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

func _ready() -> void:
	set_fire_rate(fire_rate)
	sprite_init_scale = sprite.scale

func _process(delta: float) -> void:
	sprite.scale = sprite_init_scale + (linear_velocity / 15000.0).abs()

func _integrate_forces(state):
	rotation_degrees = 0

func set_fire_rate(v: float):
	fire_rate = v
	if fire_timer != null:
		var dur = 1.0 / fire_rate
		fire_timer.start(dur * rand_range(0.0, 1.0))
		fire_timer.wait_time = dur

func set_hp(v: float):
	hp = v
	if hp <= 0.0:
		destroy()

func destroy() -> void:
	get_parent().remove_child(self)

func fire(angle: float) -> void:
	if not can_fire: return
	for child in get_children():
		if child is Weapon:
			var bullet = child.spawn(self, self.position, angle)
			get_parent().add_child(bullet)
			apply_central_impulse(Vector2(0,1).rotated(angle) * 250.0 * child.recoil)
	can_fire = false

func on_bullet_hit(bullet) -> void:
	set_hp(hp - bullet.dmg)
	var r = bullet.rotation - PI / 2.0
	if self != Game.player:
		Game.make_droplet(bullet.position,
			Vector2(1,rand_range(-0.7, 0.7)).rotated(r)*bullet.speed*rand_range(0.1, 0.25), rand_range(0.5, 2.0))
		if hp <= 0.0:
			for _i in range(rand_range(init_hp * 0.5, init_hp)):
				Game.make_droplet(bullet.position,
				Vector2(1,rand_range(-1.2, 1.2)).rotated(r)*bullet.speed*rand_range(0.1, 0.25)*3.0, rand_range(0.5, 2.0))
	apply_central_impulse(Vector2(1,0).rotated(r) * 1000.0 * bullet.knockback)

func _on_fire_timer_timeout() -> void:
	can_fire = true
