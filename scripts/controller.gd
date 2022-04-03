# The game controller singleton

extends Node2D

onready var music := AudioStreamPlayer.new()
onready var soundFX := Node2D.new()
onready var scene := $"../scene_container/scene"
onready var ui_node := $"../scene_container/UI"
onready var player: Player = scene.get_node("player")
onready var nav: Navigation2D = scene.get_node("nav")

const _bullet: PackedScene = preload("res://objects/bullet.tscn")
const _enemy_bubble: PackedScene = preload("res://objects/enemy_bubble.tscn")
const _droplet: PackedScene = preload("res://objects/droplet.tscn")

var sounds: Dictionary

var enemy_count := 0

# Called on game start
func _ready() -> void:

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