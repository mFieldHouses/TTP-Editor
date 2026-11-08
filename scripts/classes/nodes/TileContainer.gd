extends Control
class_name TileContainer

var tile_buttons : Array[TileButton] = []

signal remove_tile(pos : Vector2i)

func _ready() -> void:
	TileConfigurationDataBase.configuration_changed.connect(update_layout)
	update_layout.call_deferred()

func clear_old_tile_buttons() -> void:
	for button : TileButton in tile_buttons:
		if button:
			button.queue_free()
	
	tile_buttons.clear()

func update_layout() -> void:
	clear_old_tile_buttons()

	var tiles_to_remove : Array[Vector2i] = []
	
	for pos : Vector2i in TileConfigurationDataBase.tile_configurations.keys():
		var config : TileConfiguration = TileConfigurationDataBase.tile_configurations[pos]
		
		create_tile_button_at_position(pos, config.tile_size)
		
		if config.tile_size > Vector2i(1,1):
			for x : int in config.tile_size.x:
				for y : int in config.tile_size.y:
					if x == 0 && y == 0:
						continue
					
					tiles_to_remove.append(Vector2i(x + pos.x, y + pos.y))
	
	for tile : Vector2i in tiles_to_remove:
		remove_tile.emit(tile)

func create_tile_button_at_position(tile_position : Vector2i, tile_size : Vector2i) -> void:
	var new_button : TileButton = TileButton.new()
	new_button.tile_position = tile_position
	
	new_button.size = (size / 16.0)
	new_button.position = (size / 16.0) * Vector2(tile_position)
	
	# This doesn't work right
	new_button.anchor_left = (1.0/16.0) * (tile_position.x)
	new_button.anchor_top = (1.0/16.0) * (tile_position.y)
	new_button.anchor_bottom = (tile_size.y/16.0) * (tile_position.y + 1)
	new_button.anchor_right = (tile_size.x/16.0) * (tile_position.x + 1)
	
	remove_tile.connect(new_button.remove)
	
	new_button.button_down.connect(
		func():
			TileConfigurationDataBase.tile_configurations[tile_position].tile_size.x += 1
	)
	
	tile_buttons.append(new_button)
	
	add_child(new_button)
