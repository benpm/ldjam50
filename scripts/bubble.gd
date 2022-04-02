extends RigidBody2D
class_name Bubble

export(float) var hp := 10.0 setget set_hp 
export(float) var speed := 500.0 setget set_speed
export(float) var fire_rate := 2.0 setget set_fire_rate

onready var fire_timer: Timer = $fire_timer

var can_fire := false

func _ready() -> void:
	set_fire_rate(fire_rate)
	mode = MODE_CHARACTER
	
func set_fire_rate(v: float):
	if fire_timer != null:
		fire_rate = v
		fire_timer.wait_time = 1.0 / fire_rate
		print_debug("fire_rate: ", fire_rate)

func set_speed(v: float):
	print_stack()
	speed = v * linear_damp

func set_hp(v: float):
	hp = v
	if hp <= 0.0:
		destroy()

func destroy() -> void:
	get_parent().remove_child(self)

func fire(angle: float, vel: float, dmg: float, size: float) -> void:
	if not can_fire: return
	var bullet: Bullet = Game._bullet.instance()
	bullet.creator = self
	bullet.position = self.position
	bullet.rotation = angle
	bullet.speed = vel
	bullet.dmg = dmg
	bullet.scale = Vector2.ONE * size
	get_parent().add_child(bullet)
	can_fire = false

func _on_intersect_area(area: Area2D) -> void:
	if area is Bullet and area.creator != self:
		set_hp(hp - area.dmg)

func _on_fire_timer_timeout() -> void:
	can_fire = true
