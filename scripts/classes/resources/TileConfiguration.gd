extends Resource
class_name TileConfiguration

@export var uninitialized : bool = true

@export var tile_name : String = "":
	set(x):
		tile_name = x
		
		if x.is_empty():
			tile_name = "Unnamed Tile"
		
		if x == "<EMPTY>":
			tile_name = ""
		
		emit_changed()
		
@export var source_texture_names : Dictionary[SourceImagesDatabase.ImageCategory, String] = {
	SourceImagesDatabase.ImageCategory.ALBEDO: "",
	SourceImagesDatabase.ImageCategory.COLOR_MODULATION_MASK: "",
	SourceImagesDatabase.ImageCategory.ORM: "",
	SourceImagesDatabase.ImageCategory.NORMAL: ""
}:
	set(x):
		source_texture_names = x
		
		tile_size = SourceImagesDatabase.get_image_multiple_size(SourceImagesDatabase.ImageCategory.ALBEDO, x[SourceImagesDatabase.ImageCategory.ALBEDO])
		
		emit_changed()
		
@export var tile_size : Vector2i = Vector2i.ONE:
	set(x):
		tile_size = x
		emit_changed()
		
@export var randomization_directions : Vector2i = Vector2i.ZERO:
	set(x):
		randomization_directions = x
		emit_changed()

func _init() -> void:
	SourceImagesDatabase.texture_name_changed.connect(_on_texture_name_changed)

func initialize_values() -> void:
	tile_name = "New Tile"
	source_texture_names = source_texture_names
	tile_size = tile_size
	randomization_directions = randomization_directions

func reset_values() -> void:
	uninitialized = true
	tile_name = "<EMPTY>"
	source_texture_names = {
		SourceImagesDatabase.ImageCategory.ALBEDO: "",
		SourceImagesDatabase.ImageCategory.COLOR_MODULATION_MASK: "",
		SourceImagesDatabase.ImageCategory.ORM: "",
		SourceImagesDatabase.ImageCategory.NORMAL: ""
	}
	tile_size = Vector2i.ONE
	randomization_directions = Vector2i.ZERO

func get_save_object() -> Dictionary[String, Variant]:
	return {
		"tile_name": tile_name,
		"source_texture_names": source_texture_names,
		"tile_size": tile_size,
		"randomization_directions": randomization_directions
	}

func set_texture_name(texture_type: SourceImagesDatabase.ImageCategory, texture_name : String) -> void:
	# Duplicate and set whole dictionary to trigger setter
	var dict : Dictionary[SourceImagesDatabase.ImageCategory, String] = source_texture_names.duplicate()
	dict[texture_type] = texture_name
	source_texture_names = dict

func _on_texture_name_changed(old_name : String , new_name : String) -> void:
	for key : SourceImagesDatabase.ImageCategory in source_texture_names:
		if source_texture_names[key] == old_name:
			source_texture_names[key] = new_name
			emit_changed()
