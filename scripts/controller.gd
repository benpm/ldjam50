# The game controller singleton

extends Node2D

onready var music := AudioStreamPlayer.new()
onready var soundFX := Node2D.new()

var lvl = null

const _bullet: PackedScene = preload("res://objects/bullet.tscn")
const _enemy_bubble: PackedScene = preload("res://objects/enemy_bubble.tscn")
const _enemy_sniper_1: PackedScene = preload("res://objects/enemy_sniper_1.tscn")
const _enemy_sniper_2: PackedScene = preload("res://objects/enemy_sniper_2.tscn")
const _enemy_bubble_big: PackedScene = preload("res://objects/enemy_bubble_big.tscn")
const _enemy_bubble_bigger: PackedScene = preload("res://objects/enemy_bubble_bigger.tscn")
const _droplet: PackedScene = preload("res://objects/droplet.tscn")
const _power: PackedScene = preload("res://objects/power.tscn")
const _player: PackedScene = preload("res://objects/player.tscn")

const enemies := [
	[_enemy_bubble, 0, 0.50],
	[_enemy_sniper_1, 2, 0.15],
	[_enemy_sniper_2, 4, 0.15],
	[_enemy_bubble_big, 1, 0.25],
	[_enemy_bubble_bigger, 6, 0.25]
]

var sounds: Dictionary
var t := 0.0

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

func _process(delta: float) -> void:
	t += delta

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




