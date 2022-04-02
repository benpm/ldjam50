extends Bubble
class_name Enemy

var dir: Vector2

func _process(delta: float) -> void:
	dir = dir.linear_interpolate((Game.player.position - position).normalized(), 0.2)
	if position.distance_to(Game.player.position) < 400:
		dir *= 0.9
	
	if can_fire:
		fire(get_angle_to(Game.player.position) + PI/2.0)

func _physics_process(delta: float) -> void:
	apply_central_impulse(dir * speed * delta)

func _on_bullet_hit(bullet) -> void:
	._on_bullet_hit(bullet)