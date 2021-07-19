extends Temp_Tab

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = 3
	
	AllTiles = [
		$Fila1.get_children(),
		$Fila2.get_children(),
		$Fila3.get_children(),
	]
	
	alltiles = AllTiles[0] + AllTiles[1] + AllTiles[2]
	
