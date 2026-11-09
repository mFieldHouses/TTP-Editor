extends Control
class_name TileContainer

var selected_tile_pos : Vector2i:
	set(x):
		selected_tile_pos = x
		_highlight_button_position(x)

var highlight_rectangle : ColorRect

var tile_buttons : Array[TileButton] = []

signal tile_pos_selected(pos : Vector2i)
signal _remove_tile(pos : Vector2i)

func _ready() -> void:
	TileConfigurationDatabase.configuration_changed.connect(update_layout)
	GlobalProjectManager.project_loaded.connect(update_layout)
	
	highlight_rectangle = ColorRect.new()
	highlight_rectangle.material = preload("res://resources/materials/canvas_item_flash.tres")
	highlight_rectangle.visible = false
	highlight_rectangle.z_index = 1
	add_child(highlight_rectangle)

func clear_old_tile_buttons() -> void:
	highlight_rectangle.reparent(self) # Prevent highlight rectangle from getting removed with possible parent button
	
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
	_set_button_anchors(new_button, tile_position, tile_configuration.tile_size)
	
	# Connect signals
	_remove_tile.connect(new_button.remove)
	new_button.button_down.connect(tile_pos_selected.emit.bind(tile_position))
	new_button.button_down.connect(_tile_button_pressed.bind(new_button))
	
	# Add to our list of buttons
	tile_buttons.append(new_button)
	
	add_child(new_button)

func _set_button_anchors(node : Control, tile_position : Vector2i, tile_size : Vector2i) -> void:
	node.anchor_left = (1.0/8.0) * (tile_position.x)
	node.anchor_top = (1.0/8.0) * (tile_position.y)
	node.anchor_bottom = (1.0/8.0) * ((tile_position.y + 1) + (tile_size.y - 1))
	node.anchor_right = (1.0/8.0) * (tile_position.x + 1 + (tile_size.x - 1))
	
	node.offset_bottom = 0
	node.offset_top = 0
	node.offset_left = 0
	node.offset_right = 0

func _tile_button_pressed(button : TileButton) -> void:
	selected_tile_pos = button.tile_position

func _highlight_button_position(pos : Vector2i) -> void:
	if pos == Vector2i(-1, -1):
		highlight_rectangle.visible = false
	else:
		_set_button_anchors(highlight_rectangle, pos, _get_button_at_position(pos).represented_tile_configuration.tile_size)
		highlight_rectangle.visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			tile_pos_selected.emit(Vector2i(-1, -1))
			selected_tile_pos = Vector2i(-1, -1)

func _get_button_at_position(pos : Vector2i) -> TileButton:
	for button : TileButton in tile_buttons:
		if button.tile_position == pos:
			return button
	
	return null
