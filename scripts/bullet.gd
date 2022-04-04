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

onready var sprite: Sprite = $Sprite

enum BulletAnimation {
	None, Spin
}

var anim: int = BulletAnimation.None

func _ready():
	$vanish_timer.start(vanish_time)

func _physics_process(delta: float) -> void:
	move_local_y(-speed * delta)
	if accelerate:
		speed += 100.0 * delta
	if attractor:
		rotation = lerp_angle(rotation, position.angle_to_point(Game.player.position) - PI/2.0, 0.05)
	match anim:
		BulletAnimation.None:
			pass
		BulletAnimation.Spin:
			sprite.rotation += TAU * 1.5 * delta

func _on_bullet_body_entered(b: Node) -> void:
	if b.is_class("Bubble"):
		b.call_deferred("on_bullet_hit", self)
	
	get_parent().call_deferred("remove_child", self)

func _on_vanish_timer_timeout() -> void:
	get_parent().call_deferred("remove_child", self)
