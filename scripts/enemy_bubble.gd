extends Bubble
class_name Enemy

func get_class(): return "Enemy"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

var dir: Vector2

var path: PoolVector2Array
var path_idx: int

func _ready() -> void:
	var wait_time = $path_timer.wait_time
	$path_timer.start(randf() * wait_time)
	$path_timer.wait_time = wait_time
	recompute_path()

func _process(delta: float) -> void:
	if path_idx < path.size():
		var p: Vector2 = path[path_idx]
		dir = dir.linear_interpolate((p - position).normalized(), 0.05)
		if p.distance_to(Game.player.position) < 200 and can_fire:
			fire(get_angle_to(p) + PI/2.0)
			dir = Vector2.ZERO
		sprite.rotation = atan2(dir.y, dir.x)
		sprite.scale.x = sprite_init_scale.x + dir.length() * 0.035
		if position.distance_to(p) < 50:
			path_idx += 1

func _physics_process(delta: float) -> void:
	apply_central_impulse(dir * speed * delta)

func on_bullet_hit(bullet) -> void:
	.on_bullet_hit(bullet)

func destroy() -> void:
	Game.enemy_count -= 1
	.destroy()

func _on_path_timer_timeout() -> void:
	recompute_path()

func recompute_path():
	path = Game.nav.get_simple_path(position, Game.player.position)
	path_idx = 0