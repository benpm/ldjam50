# The game controller singleton

extends Node2D

onready var music := AudioStreamPlayer.new()
onready var soundFX := Node2D.new()
onready var scene := $"../scene_container/scene"
onready var ui_node := $"../scene_container/UI"
onready var ui := $"../scene_container/UI/container"
var player: Player
onready var nav: Navigation2D = scene.get_node("nav")
onready var ui_death_screen: Control = ui.get_node("death_screen")
onready var ui_score_text: Label = ui_death_screen.get_node("death_container/score_text")
onready var ui_hp_bar: TextureProgress = ui.get_node("hp_bar_container/CenterContainer/hp_bar")
onready var ui_name_text: LineEdit = ui_death_screen.get_node("name_container/name_text")

const _bullet: PackedScene = preload("res://objects/bullet.tscn")
const _enemy_bubble: PackedScene = preload("res://objects/enemy_bubble.tscn")
const _droplet: PackedScene = preload("res://objects/droplet.tscn")
const _player: PackedScene = preload("res://objects/player.tscn")

var player_name: String = ""

var sounds: Dictionary

var enemy_count := 0

var score := 0.0

const MAIN_LAYER: int = 1
const ENEMY_BULLET_LAYER: int = 2
const PLAYER_BULLET_LAYER: int = 4



# Called on game start
func _ready() -> void:

	SilentWolf.configure({
		"api_key": "rae5gwn0aJ5VK7X7qwSMu2OP9euG0U198dLmD3rX",
		"game_id": "ldjam50",
		"game_version": "1.0.2",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/menu.tscn"
	})

	# Load all the audio
	var audioDir = Directory.new()
	audioDir.open("res://audio/")
	audioDir.list_dir_begin(true, true)
	var fname = audioDir.get_next()
	while fname:
		if fname.get_extension() == "ogg":
			var streamName: String = fname.get_basename()
			var stream: AudioStreamOGGVorbis = load("res://audio/" + fname)
			stream.loop = false
			var streamPlayer = AudioStreamPlayer2D.new()
			streamPlayer.name = streamName
			streamPlayer.stream = stream
			streamPlayer.autoplay = false
			streamPlayer.bus = "FX"
			streamPlayer.attenuation = 2.0
			sounds[streamName] = streamPlayer
			soundFX.add_child(streamPlayer)
		fname = audioDir.get_next()
	
	add_child(soundFX)

	# music.stream = load("res://audio/music.mp3")
	# music.stream.loop = true
	# music.play()
	# music.volume_db = -7.0
	# add_child(music)

	start_game()

func start_game():
	ui_death_screen.hide()
	ui_hp_bar.show()
	score = 0.0
	enemy_count = 0
	var scene_children = scene.get_children()
	for c in scene_children:
		if c.is_in_group("game_object"):
			c.get_parent().remove_child(c)
	player = _player.instance()
	add_child(player)

func _process(delta: float) -> void:
	if player and not player.dead:
		score += delta

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.as_text() == "K":
			player.destroy()

# Call to play a sound
func play_sound(name: String, pos = null):
	sounds[name].stop()
	if pos != null:
		sounds[name].position = pos
	sounds[name].play()
# Set sounds to playing or not
func sound_playing(name: String, playing: bool, pos = null):
	if sounds[name].playing != playing:
		sounds[name].playing = playing
	if pos != null:
		sounds[name].position = pos

func make_droplet(pos: Vector2, vel: Vector2, amount: float):
	var node: Droplet = _droplet.instance()
	node.position = pos
	node.hp = amount
	node.vel = vel
	add_child(node)

func player_died():
	ui_death_screen.show()
	ui_score_text.text = "%.1f" % score
	ui_hp_bar.hide()
	SilentWolf.Scores.persist_score(player_name, score)


