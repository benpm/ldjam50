# The game controller singleton

extends Node2D

onready var music := AudioStreamPlayer.new()
onready var soundFX := Node2D.new()

var lvl = null

const _bullet: PackedScene = preload("res://objects/bullet.tscn")
const _enemy_bubble: PackedScene = preload("res://objects/enemy_bubble.tscn")
const _enemy_sniper_1: PackedScene = preload("res://objects/enemy_sniper_1.tscn")
const _enemy_sniper_2: PackedScene = preload("res://objects/enemy_sniper_2.tscn")
const _enemy_sniper_3: PackedScene = preload("res://objects/enemy_sniper_3.tscn")
const _enemy_bubble_big: PackedScene = preload("res://objects/enemy_bubble_big.tscn")
const _enemy_bubble_bigger: PackedScene = preload("res://objects/enemy_bubble_bigger.tscn")
const _enemy_spikey: PackedScene = preload("res://objects/enemy_spikey.tscn")
const _enemy_spikey_2: PackedScene = preload("res://objects/enemy_spikey_2.tscn")
const _enemy_knife: PackedScene = preload("res://objects/enemy_knife.tscn")
const _droplet: PackedScene = preload("res://objects/droplet.tscn")
const _power: PackedScene = preload("res://objects/power.tscn")
const _player: PackedScene = preload("res://objects/player.tscn")

const enemies := [
	[_enemy_bubble, 0, 0.50],
	[_enemy_sniper_1, 2, 0.15],
	[_enemy_sniper_2, 4, 0.15],
	[_enemy_sniper_3, 4, 0.05],
	[_enemy_bubble_big, 1, 0.25],
	[_enemy_bubble_bigger, 6, 0.25],
	[_enemy_spikey, 0, 0.25],
	[_enemy_spikey_2, 4, 0.25],
	[_enemy_knife, 1, 1.00]
]

var sounds: Dictionary
var t := 0.0

var music_muted := false
var sound_muted := false

const MAIN_LAYER: int = 1
const ENEMY_BULLET_LAYER: int = 2
const PLAYER_BULLET_LAYER: int = 4

const audio_break = preload("res://audio/break.ogg")
const audio_break_small = preload("res://audio/break_small.ogg")
const audio_dash = preload("res://audio/dash.ogg")
const audio_hit1 = preload("res://audio/hit1.ogg")
const audio_hit2 = preload("res://audio/hit2.ogg")
const audio_hit3 = preload("res://audio/hit3.ogg")
const audio_hit4 = preload("res://audio/hit4.ogg")
const audio_ice1 = preload("res://audio/ice1.ogg")
const audio_pop1 = preload("res://audio/pop1.ogg")
const audio_wave = preload("res://audio/wave.ogg")

func load_audio(stream_name: String, stream: AudioStreamOGGVorbis):
	stream.loop = false
	var streamPlayer = AudioStreamPlayer2D.new()
	streamPlayer.name = stream_name
	streamPlayer.stream = stream
	streamPlayer.autoplay = false
	streamPlayer.bus = "FX"
	streamPlayer.attenuation = 2.0
	sounds[stream_name] = streamPlayer
	soundFX.add_child(streamPlayer)

# Called on game start
func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS

	SilentWolf.configure({
		"api_key": "rae5gwn0aJ5VK7X7qwSMu2OP9euG0U198dLmD3rX",
		"game_id": "ldjam50",
		"game_version": "1.0.2",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://levels/menu.tscn"
	})

	# Load all the audio
	load_audio("break", audio_break)
	load_audio("break_small", audio_break_small)
	load_audio("dash", audio_dash)
	load_audio("hit1", audio_hit1)
	load_audio("hit2", audio_hit2)
	load_audio("hit3", audio_hit3)
	load_audio("hit4", audio_hit4)
	load_audio("ice1", audio_ice1)
	load_audio("pop1", audio_pop1)
	load_audio("wave", audio_wave)
	
	add_child(soundFX)

	music.stream = load("res://audio/music.mp3")
	music.stream.loop = true
	music.play()
	music.volume_db = -7.0
	music.bus = "Music"
	add_child(music)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and lvl != null:
		lvl.set_paused(!lvl.paused)

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




