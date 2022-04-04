extends CanvasItem

export(float) var rate := 1.0

func _process(delta):
	modulate.v = 1.0 + (sin(Game.t * rate) * 0.25 + 0.25)
