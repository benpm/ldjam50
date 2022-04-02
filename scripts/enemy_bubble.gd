extends Bubble
class_name Enemy

var dir: Vector2

func _process(delta: float) -> void:
	var path = Game.nav.get_simple_path(position, Game.player.position)
	if path.size() > 1:
		dir = dir.linear_interpolate((path[1] - position).normalized(), 0.05)
		if can_fire:
			fire(get_angle_to(path[1]) + PI/2.0)

func _physics_process(delta: float) -> void:
	apply_central_impulse(dir * speed * delta)

func _on_bullet_hit(bullet) -> void:
	._on_bullet_hit(bullet)

func destroy() -> void:
	Game.enemy_count -= 1
	.destroy()