extends RigidBody2D

class_name Player

var speed := 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed *= linear_damp

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		self.apply_central_impulse(Vector2(-1, 0) * speed * delta)
	if Input.is_action_pressed("right"):
		self.apply_central_impulse(Vector2(1, 0) * speed * delta)
	if Input.is_action_pressed("down"):
		self.apply_central_impulse(Vector2(0, 1) * speed * delta)
	if Input.is_action_pressed("up"):
		self.apply_central_impulse(Vector2(0, -1) * speed * delta)
	
