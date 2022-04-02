extends Node2D
class_name LevelManager

onready var spawn_timer: Timer = $spawn_timer

func _on_spawn_timer_timeout() -> void:
	for _i in range(5):
		var bubble: Bubble = Game._bubble.instance()
		bubble.position = Vector2(rand_range(-2000, 2000), rand_range(-2000, 2000))
		add_child(bubble)