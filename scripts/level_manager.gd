extends Node2D
class_name LevelManager

onready var spawn_timer: Timer = $spawn_timer

var wave := 0

func _ready() -> void:
	rand_seed(100)
	_on_spawn_timer_timeout()
	
func _on_spawn_timer_timeout() -> void:
	if Game.enemy_count == 0:
		if wave > 0:
			_on_power_timer_timeout()
		var total_enemy_hp := 0.0
		while total_enemy_hp < (wave + 1) * 25:
			var enemy_packed: PackedScene = null
			while enemy_packed == null:
				var e = Game.enemies[rand_range(0, Game.enemies.size() - 1)]
				var ep: PackedScene = e[0]
				var wave_req: int = e[1]
				var chance: float = e[2]
				if wave >= wave_req and randf() < chance:
					enemy_packed = ep
			var n: Enemy = enemy_packed.instance()
			n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
			while n.position.distance_to(Game.player.position) < 1500:
				n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
			total_enemy_hp += n.hp
			add_child(n)
			Game.enemy_count += 1
		wave += 1


func restart_level():
	print_debug("restart_level")
	Game.start_game()

func _on_name_text_text_entered(new_text:String) -> void:
	Game.player_name = new_text

func _on_power_timer_timeout() -> void:
	var n: Power = Game._power.instance()
	n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
	while n.position.distance_to(Game.player.position) < 1500:
		n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
	add_child(n)
	n.wtype = int(round(rand_range(0, 7)))
