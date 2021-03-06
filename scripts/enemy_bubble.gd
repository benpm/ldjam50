extends Bubble
class_name Enemy

func get_class(): return "Enemy"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

var dir: Vector2

var path: PoolVector2Array
var path_idx: int

enum Behavior { Chase, Snipe, Turret, Kamikaze }

export(Behavior) var behavior: int = Behavior.Chase
export(bool) var smart_aim := false

func _ready() -> void:
	var wait_time = $path_timer.wait_time
	$path_timer.start(randf() * wait_time)
	$path_timer.wait_time = wait_time
	recompute_path()

func _process(delta: float) -> void:
	if behavior == Behavior.Turret:
		if position.distance_to(Game.lvl.player.position) < 2000.0:
			sprite.rotation += delta
			if can_fire:
				fire(randf() * TAU)
	elif path_idx < path.size():
		var p: Vector2 = path[path_idx]
		var aim_point: Vector2 = Game.lvl.player.position
		if smart_aim:
			aim_point = Game.lvl.player.position \
				+ Game.lvl.player.linear_velocity * delta * (position.distance_to(Game.lvl.player.position) / 80.0)
		match behavior:
			Behavior.Chase:
				dir = dir.linear_interpolate((p - position).normalized(), 0.05)
				if p.distance_to(Game.lvl.player.position) < 200 and can_fire:
					fire(get_angle_to(aim_point) + PI/2.0)
					dir = Vector2.ZERO
			Behavior.Snipe:
				if p.distance_to(Game.lvl.player.position) < 20:
					sprite.rotation = lerp_angle(sprite.rotation, get_angle_to(aim_point) + PI/2.0, 0.1)
				else:
					dir = dir.linear_interpolate((p - position).normalized(), 0.05)
				if can_fire:
					fire(get_angle_to(aim_point) + PI/2.0)
			Behavior.Kamikaze:
				dir = dir.linear_interpolate((p - position).normalized(), 0.125)
		if dir.length() > 0.1:
			sprite.rotation = atan2(dir.y, dir.x) + PI/2.0
			apply_central_impulse(dir.normalized() * speed * (1/(freeze + 1)) * delta)
		sprite.scale.y = sprite_init_scale.y + dir.length() * 0.035
		if position.distance_to(p) < 10:
			path_idx += 1

func destroy() -> void:
	Game.lvl.enemy_count -= 1
	.destroy()

func _on_path_timer_timeout() -> void:
	recompute_path()

func recompute_path():
	path = Game.lvl.nav.get_simple_path(position, Game.lvl.player.position)
	path_idx = 0



func _on_body_entered(body:Node) -> void:
	if body == Game.lvl.player and behavior == Behavior.Kamikaze:
		body.apply_damage(15.0, 0.0, sprite.rotation, position, speed, 2.0)
		self.apply_damage(100.0, 0.0, -sprite.rotation, body.position, speed, 2.0)
