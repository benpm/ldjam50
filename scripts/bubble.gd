extends RigidBody2D
class_name Bubble

signal bullet_hit(bullet)

export(float) var hp := 10.0 setget set_hp 
export(float) var speed := 500.0 setget set_speed
export(float) var fire_rate := 2.0 setget set_fire_rate

onready var fire_timer: Timer = $fire_timer

var can_fire := false
var weapons := [ ]

func _ready() -> void:
	set_fire_rate(fire_rate)
	mode = MODE_CHARACTER
	
func set_fire_rate(v: float):
	if fire_timer != null:
		fire_rate = v
		fire_timer.start(1.0 / fire_rate)
		print_stack()
		print_debug("%f %f" % [fire_timer.wait_time, fire_rate])

func set_speed(v: float):
	speed = v * linear_damp

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
	can_fire = false

func _on_bullet_hit(bullet) -> void:
	if bullet.creator != self:
		set_hp(hp - bullet.dmg)


func _on_fire_timer_timeout() -> void:
	can_fire = true
