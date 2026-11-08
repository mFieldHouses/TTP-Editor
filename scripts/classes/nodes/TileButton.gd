extends Button
class_name TileButton

@export var represented_tile_configuration : TileConfiguration
@export var tile_position : Vector2i = Vector2i.ZERO

func _ready() -> void:
#	represented_tile_configuration.changed.connect(config_changed)
	
	theme = preload("res://resources/themes/tile_buttons.tres")
	
func config_changed() -> void:
	if get_parent() is TileContainer:
		get_parent().update_layout()

func remove(pos : Vector2i) -> void:
	if pos == tile_position:
		queue_free()
