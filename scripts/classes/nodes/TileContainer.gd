extends Control
class_name TileContainer

var tile_buttons : Array[TileButton] = []

signal tile_pos_selected(pos : Vector2i)

signal _remove_tile(pos : Vector2i)

func _ready() -> void:
	TileConfigurationDatabase.configuration_changed.connect(update_layout)
	update_layout.call_deferred()

func clear_old_tile_buttons() -> void:
	for button : TileButton in tile_buttons:
		if button:
			button.queue_free()
	
	tile_buttons.clear()

func update_layout() -> void:
	clear_old_tile_buttons()

	var tiles_to_remove : Array[Vector2i] = []
	
	for pos : Vector2i in TileConfigurationDatabase.tile_configurations.keys():
		var config : TileConfiguration = TileConfigurationDatabase.tile_configurations[pos]
		
		create_tile_button_at_position(pos, config)
		
		if config.tile_size > Vector2i(1,1):
			for x : int in config.tile_size.x:
				for y : int in config.tile_size.y:
					if x == 0 && y == 0:
						continue
					
					tiles_to_remove.append(Vector2i(x + pos.x, y + pos.y))
	
	for tile : Vector2i in tiles_to_remove:
		_remove_tile.emit(tile)

func create_tile_button_at_position(tile_position : Vector2i, tile_configuration : TileConfiguration) -> void:
	var new_button : TileButton = TileButton.new()
	new_button.tile_position = tile_position
	
	# Set up button text
	new_button.text = tile_configuration.tile_name
	new_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	new_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS_FORCE
	
	# Set up button sizing
	new_button.anchor_left = (1.0/8.0) * (tile_position.x)
	new_button.anchor_top = (1.0/8.0) * (tile_position.y)
	new_button.anchor_bottom = (1.0/8.0) * ((tile_position.y + 1) + (tile_configuration.tile_size.y - 1))
	new_button.anchor_right = (1.0/8.0) * (tile_position.x + 1 + (tile_configuration.tile_size.x - 1))
	
	new_button.offset_bottom = 0
	new_button.offset_top = 0
	new_button.offset_left = 0
	new_button.offset_right = 0
	
	# Connect signals
	_remove_tile.connect(new_button.remove)
	new_button.button_down.connect(tile_pos_selected.emit.bind(tile_position))
	
	# Add to our list of buttons
	tile_buttons.append(new_button)
	
	add_child(new_button)
