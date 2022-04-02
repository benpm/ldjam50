extends Node2D
class_name LevelManager

onready var spawn_timer: Timer = $spawn_timer

func _ready() -> void:
	_on_spawn_timer_timeout()

func _on_spawn_timer_timeout() -> void:
	for _i in range(10):
		var n: Enemy = Game._enemy_bubble.instance()
		n.position = Vector2(rand_range(-2000, 2000), rand_range(-2000, 2000))
		add_child(n)