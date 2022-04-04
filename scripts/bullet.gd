extends Area2D
class_name Bullet

func is_class(n: String) -> bool:
	return .is_class(n) or n == "Bullet"

var dmg := 1.0
var speed := 500.0
var knockback := 1.0
var attractor := false
var accelerate := false
var vanish_time := 2.0
var creator: PhysicsBody2D = null
var bounce := 0
var penetrate := 0
var freeze := 0.0

var last_hit: Node = null

onready var sprite: Sprite = $Sprite

enum BulletAnimation {
	None, Spin
}

var anim: int = BulletAnimation.None
var last_pos: Vector2 = Vector2.ZERO

onready var vanish_timer: Timer = $vanish_timer

func _ready():
	vanish_timer.start(vanish_time)
	last_pos = position

func _process(delta: float) -> void:
	last_pos = position
	move_local_y(-speed * delta)
	if accelerate:
		speed += 150.0 * delta
	if attractor:
		rotation = lerp_angle(rotation, position.angle_to_point(Game.lvl.player.position) - PI/2.0, 0.05)
	match anim:
		BulletAnimation.None:
			pass
		BulletAnimation.Spin:
			sprite.rotation += TAU * 1.5 * delta
	if vanish_timer.time_left < 0.25:
		sprite.modulate.a = max(0.0, vanish_timer.time_left) / 0.25

func _on_bullet_body_entered(b: Node) -> void:
	if last_hit == b: return
	if b.is_class("Bubble"):
		b.call_deferred("on_bullet_hit", self)
		penetrate -= 1
		last_hit = b
	else:
		bounce -= 1
		rotation += PI
		position = last_pos
	if bounce < 0 || penetrate < 0:
		get_parent().call_deferred("remove_child", self)

func _on_vanish_timer_timeout() -> void:
	get_parent().remove_child(self)
