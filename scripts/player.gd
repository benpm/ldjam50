extends Bubble
class_name Player

func get_class(): return "Player"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

var evap_rate: float = 0.1
var dead := false

const max_evap := 4.0
var dash := 10000.0
var dash_cost := 1.5

var dir: Vector2

func _ready() -> void:
	hp = 10
	Game.lvl.ui_hp_bar.max_value = 1.0
	Game.lvl.ui_hp_bar.value = -(1.0 / (hp / 20.0 + 1.0)) + 1.0
	Game.lvl.ui_fire_bar.max_value = max_evap

func _process(delta: float) -> void:
	evap_rate = min(evap_rate + delta * 0.0035, max_evap)
	Game.lvl.ui_fire_bar.value = evap_rate
	set_hp(hp - evap_rate * delta)
	Game.lvl.ui_hp_bar.value = lerp(Game.lvl.ui_hp_bar.value, -(1.0 / (hp / 20.0 + 1.0)) + 1.0, 0.25)
	if hp < 5.0:
		Game.lvl.ui_hp_bar.modulate = Color(0x7DBEFF).linear_interpolate(Color.white, sin(Game.t * 20.0) * 0.5 + 1.0)
	else:
		Game.lvl.ui_hp_bar.modulate = Color.white

func _input(event):
	if event.is_action_pressed("dash"):
		Game.play_sound("dash", position)
		apply_central_impulse((get_global_mouse_position() - position).normalized() * dash)
		set_hp(hp - dash_cost)

func _physics_process(delta: float) -> void:
	if dead:
		self.linear_velocity = Vector2.ZERO
		return

	dir = Vector2.ZERO
	if Input.is_action_pressed("left"):
		dir += Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		dir += Vector2(1, 0)
	if Input.is_action_pressed("down"):
		dir += Vector2(0, 1)
	if Input.is_action_pressed("up"):
		dir += Vector2(0, -1)
	
	self.apply_central_impulse(dir.normalized() * speed * (1/(freeze + 1)) * delta)

	if Input.is_action_pressed("fire"):
		fire(get_angle_to(get_global_mouse_position()) + PI/2.0)
	
	sprite.rotation = atan2(self.linear_velocity.y, self.linear_velocity.x)
	sprite.scale.x = min(sprite_init_scale.x * 2, sprite_init_scale.x + self.linear_velocity.length() * 1e-4)

func destroy() -> void:
	if dead: return
	hide()
	$CollisionShape2D.disabled = true
	dead = true
	Game.lvl.player_died()
