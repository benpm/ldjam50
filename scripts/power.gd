extends RigidBody2D
class_name Power

func get_class(): return "Power"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

const WeaponType = {
	ice = 0,
	weight = 1,
	sharp = 2,
	punch = 3,
	bounce = 4,
	penetrate = 5,
	split = 6,
	rate = 7
}

onready var colshape: CollisionShape2D = $CollisionShape2D
onready var icon: Sprite = $icon
onready var weapon: Weapon = Weapon.new()

onready var tex_bounce: Texture = preload("res://sprites/power_bounce.png")
onready var tex_ice: Texture = preload("res://sprites/power_ice.png")
onready var tex_penetrate: Texture = preload("res://sprites/power_penetrate.png")
onready var tex_punch: Texture = preload("res://sprites/power_punch.png")
onready var tex_sharp: Texture = preload("res://sprites/power_sharp.png")
onready var tex_split: Texture = preload("res://sprites/power_split.png")
onready var tex_weight: Texture = preload("res://sprites/power_weight.png")
onready var tex_rate: Texture = preload("res://sprites/power_rate.png")

onready var bullet_tex_basic: Texture = preload("res://sprites/bullet_basic.png")
onready var bullet_tex_5: Texture = preload("res://sprites/bullet_5.png")
onready var bullet_tex_4: Texture = preload("res://sprites/bullet_4.png")
onready var bullet_tex_3: Texture = preload("res://sprites/bullet_3.png")
onready var bullet_tex_6: Texture = preload("res://sprites/bullet_6.png")
onready var bullet_tex_7: Texture = preload("res://sprites/bullet_7.png")
onready var bullet_tex_8: Texture = preload("res://sprites/bullet_8.png")
onready var bullet_tex_9: Texture = preload("res://sprites/bullet_9.png")

var wtype: int = WeaponType.ice setget set_wtype

func set_wtype(v: int):
	wtype = v
	weapon = Weapon.new()
	match wtype:
		WeaponType.ice:
			name = "ice"
			icon.texture = tex_ice
			weapon.freeze = 0.50
			weapon.tex = bullet_tex_9
		WeaponType.weight:
			name = "weight"
			icon.texture = tex_weight
			weapon.speed = -0.25
			weapon.damage = 1.0
			weapon.knockback = 0.25
			weapon.bullet_size = 0.5
			weapon.recoil = 0.35
			weapon.tex = bullet_tex_5
		WeaponType.sharp:
			name = "sharp"
			icon.texture = tex_sharp
			weapon.speed = 0.25
			weapon.damage = 2.0
			weapon.tex = bullet_tex_4
			weapon.precision = 0.5
		WeaponType.punch:
			name = "punch"
			icon.texture = tex_punch
			weapon.knockback = 0.30
			weapon.tex = bullet_tex_7
		WeaponType.bounce:
			name = "bounce"
			icon.texture = tex_bounce
			weapon.bounce = 1
			weapon.tex = bullet_tex_3
			weapon.vanish_time = 1
		WeaponType.penetrate:
			name = "penetrate"
			icon.texture = tex_penetrate
			weapon.penetrate = 1
			weapon.tex = bullet_tex_8
			weapon.vanish_time = 1
		WeaponType.split:
			name = "split"
			icon.texture = tex_split
			weapon.split = 1
			weapon.tex = bullet_tex_6
		WeaponType.rate:
			name = "rate"
			icon.texture = tex_rate
			weapon.rate = 2
	weapon.cost = 0.25

func _process(delta: float) -> void:
	colshape.rotation += 0.5 * delta * sin(Game.t)

func _on_power_body_entered(body: Node) -> void:
	if body == Game.lvl.player:
		body.weapons[0].combine(weapon)
		get_parent().remove_child(self)
		Game.play_sound("ice1", position)
