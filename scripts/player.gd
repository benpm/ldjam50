extends Bubble
class_name Player

func _ready() -> void:
	._ready()
	print_debug(fire_rate)

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