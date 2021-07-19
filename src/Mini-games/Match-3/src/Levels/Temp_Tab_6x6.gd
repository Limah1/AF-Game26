extends Temp_Tab

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = 6
	
	AllTiles = [
		$Fila1.get_children(),
		$Fila2.get_children(),
		$Fila3.get_children(),
		$Fila4.get_children(),
		$Fila5.get_children(),
		$Fila6.get_children(),
	]
	
	alltiles = AllTiles[0] + AllTiles[1] + AllTiles[2] + AllTiles[3] + AllTiles[4] + AllTiles[5]
