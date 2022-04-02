extends Camera2D


func _process(delta):
	self.position = Game.player.position
