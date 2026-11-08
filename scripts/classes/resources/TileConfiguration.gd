extends Resource
class_name TileConfiguration

@export var uninitialized : bool = true

@export var tile_name : String = "":
	set(x):
		tile_name = x
		
		if x.is_empty():
			tile_name = "Unnamed Tile"
		
		emit_changed()
		
@export var source_texture_name : String = "":
	set(x):
		source_texture_name = x
		emit_changed()
		
@export var tile_size : Vector2i = Vector2i.ONE:
	set(x):
		tile_size = x
		emit_changed()
		
@export var randomization_directions : Vector2i = Vector2i.ZERO:
	set(x):
		randomization_directions = x
		emit_changed()

func initialize_values() -> void:
	tile_name = "New Tile"
	source_texture_name = ""
	tile_size = tile_size
	randomization_directions = randomization_directions

func get_save_object() -> Dictionary[String, Variant]:
	return {
		"tile_name": tile_name,
		"source_texture_name": source_texture_name,
		"tile_size": tile_size,
		"randomization_directions": randomization_directions
	}
