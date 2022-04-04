extends CanvasLayer


func _ready():
	$'container/main_screen/VBoxContainer/HBoxContainer4/button_music'.pressed = Game.music_muted
	$'container/main_screen/VBoxContainer/HBoxContainer3/button_sound'.pressed = Game.sound_muted

func _on_button_play_pressed() -> void:
	get_tree().change_scene("res://levels/start.tscn")

func _on_button_leaderboard_pressed() -> void:
	get_tree().change_scene("res://levels/leaderboard.tscn")


func _on_button_music_toggled(button_pressed:bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), button_pressed)
	Game.music_muted = button_pressed

func _on_button_sound_toggled(button_pressed:bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("FX"), button_pressed)
	Game.sound_muted = button_pressed