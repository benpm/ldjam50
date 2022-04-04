extends Camera2D


func _process(delta):
	self.position = Game.lvl.player.position
