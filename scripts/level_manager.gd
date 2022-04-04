extends Node2D
class_name LevelManager

onready var spawn_timer: Timer = $spawn_timer

func _ready() -> void:
	_on_spawn_timer_timeout()
	
func _on_spawn_timer_timeout() -> void:
	if Game.enemy_count < 30:
		for _i in range(10):
			var n: Enemy = Game._enemy_bubble.instance()
			n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
			while n.position.distance_to(Game.player.position) < 1500:
				n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
			add_child(n)
			Game.enemy_count += 1

func restart_level():
	print_debug("restart_level")
	Game.start_game()

func _on_name_text_text_entered(new_text:String) -> void:
	Game.player_name = new_text
