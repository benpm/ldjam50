extends Bubble
class_name Player

func get_class(): return "Player"
func is_class(name): return name == get_class() or name == .get_class() or .is_class(name)

var evap_rate: float = 0.1
var dead := false

func _ready() -> void:
	._ready()
	Game.ui_hp_bar.max_value = 1.0
	Game.ui_hp_bar.value = -(1.0 / (hp / 20.0 + 1.0)) + 1.0

func _process(delta: float) -> void:
	._process(delta)
	set_hp(hp - evap_rate * delta)
	Game.ui_hp_bar.value = lerp(Game.ui_hp_bar.value, -(1.0 / (hp / 20.0 + 1.0)) + 1.0, 0.25)

func set_hp(v: float):
	.set_hp(v)

func _physics_process(delta: float) -> void:
	if dead:
		self.linear_velocity = Vector2.ZERO
		return

	if Input.is_action_pressed("left"):
		self.apply_central_impulse(Vector2(-1, 0) * speed * delta)
	if Input.is_action_pressed("right"):
		self.apply_central_impulse(Vector2(1, 0) * speed * delta)
	if Input.is_action_pressed("down"):
		self.apply_central_impulse(Vector2(0, 1) * speed * delta)
	if Input.is_action_pressed("up"):
		self.apply_central_impulse(Vector2(0, -1) * speed * delta)
	
	if Input.is_action_pressed("fire"):
		fire(get_angle_to(get_global_mouse_position()) + PI/2.0)

func destroy() -> void:
	if dead: return
	hide()
	$CollisionShape2D.disabled = true
	dead = true
	Game.player_died()
