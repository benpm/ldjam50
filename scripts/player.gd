extends Bubble
class_name Player

func is_class(name: String) -> bool:
	return .is_class(name) or name == "Player"

var hp_bar: TextureProgress
var evap_rate: float = 0.1

func _ready() -> void:
	._ready()
	hp_bar = Game.ui_node.get_node("container/MarginContainer/hp_bar")
	hp_bar.max_value = max_hp
	print_debug(fire_rate)

func _process(delta: float) -> void:
	._process(delta)
	set_hp(hp - evap_rate * delta)
	var f = hp_bar.value
	hp_bar.value = lerp(f, hp, 0.25)

func set_hp(v: float):
	.set_hp(v)

func _physics_process(delta: float) -> void:
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
	hide()

func _on_fire_timer_timeout() -> void:
	._on_fire_timer_timeout()

func _on_bullet_hit(bullet) -> void:
	._on_bullet_hit(bullet)