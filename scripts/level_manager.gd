extends Node2D
class_name LevelManager

onready var spawn_timer: Timer = $spawn_timer

onready var ui_node := $"../UI"
onready var ui := $"../UI/container"

onready var ui_death_screen: Control = ui.get_node("death_screen")
onready var ui_pause_screen: Control = ui.get_node("pause_screen")
onready var ui_score_text: Label = ui_death_screen.get_node("death_container/score_text")
onready var ui_hp_bar: TextureProgress = ui.get_node("hp_bar_container/CenterContainer/hp_bar")
onready var ui_fire_bar: TextureProgress = ui.get_node("fire_bar_container/CenterContainer/fire_bar")
onready var ui_name_text: LineEdit = ui_death_screen.get_node("name_container/name_text")

onready var nav: Navigation2D = $"nav"

var wave := 0
var score := 0.0
var enemy_count := 0

var player = null
var player_name: String = ""

var paused := false setget set_paused

func _enter_tree() -> void:
	self.player = Game._player.instance()

func _ready() -> void:
	rand_seed(Game.t)
	Game.lvl = self
	restart_level()
	set_paused(false)
	
func _on_spawn_timer_timeout() -> void:
	if enemy_count == 0:
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
			while n.position.distance_to(player.position) < 1500:
				n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
			total_enemy_hp += n.hp
			add_child(n)
			enemy_count += 1
		wave += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_paused(!paused)

func set_paused(v: bool):
	paused = v
	get_tree().paused = paused
	if paused:
		ui_pause_screen.show()
	else:
		ui_pause_screen.hide()

func restart_level():
	print_debug("restart_level")
	ui_death_screen.hide()
	ui_hp_bar.show()
	ui_fire_bar.show()
	score = 0.0
	enemy_count = 0
	var scene_children = get_children()
	for c in scene_children:
		if c.is_in_group("game_object"):
			c.get_parent().remove_child(c)
	player = Game._player.instance()
	add_child(player)
	_on_spawn_timer_timeout()

func _process(delta: float) -> void:
	if player and not player.dead:
		score += delta

func _on_name_text_text_entered(new_text:String) -> void:
	player_name = new_text

func _on_power_timer_timeout() -> void:
	var n: Power = Game._power.instance()
	n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
	while n.position.distance_to(player.position) < 1500:
		n.position = Vector2(rand_range(-3000, 3000), rand_range(-3000, 3000))
	add_child(n)
	n.wtype = int(round(rand_range(0, 7)))

func make_droplet(pos: Vector2, vel: Vector2, amount: float):
	var node: Droplet = Game._droplet.instance()
	node.position = pos
	node.hp = amount
	node.vel = vel
	add_child(node)

func player_died():
	ui_death_screen.show()
	ui_score_text.text = "%.1f" % score
	ui_hp_bar.hide()
	ui_fire_bar.hide()
	# TODO: Scores
	# SilentWolf.Scores.persist_score(player_name, score)

func _on_button_exit_pressed() -> void:
	set_paused(false)
	get_tree().change_scene("res://levels/menu.tscn")

func _on_button_continue_pressed() -> void:
	set_paused(false)
