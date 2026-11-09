extends Button
class_name TileButton

@export var represented_tile_configuration : TileConfiguration:
	set(x):
		represented_tile_configuration = x
		represented_tile_configuration.changed.connect(config_changed)

@export var tile_position : Vector2i = Vector2i.ZERO

var texture_rect : TextureRect
var drag_button : Button

func _ready() -> void:
	z_index = 1
	
	drag_button = Button.new()
	
	drag_button.flat = true
	drag_button.icon = preload("res://assets/images/icons/grab.svg")
	drag_button.expand_icon = true
	
	var _size : float = 35
	var offset : float = 0.025
	drag_button.anchor_right = (_size / size.x) + offset
	drag_button.anchor_top = offset
	drag_button.anchor_left = offset
	drag_button.anchor_bottom = (_size / size.y) + offset
	
	add_child(drag_button)
	
	
	texture_rect = TextureRect.new()
	texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	texture_rect.z_index = -1
	texture_rect.modulate = Color(0.5, 0.5, 0.5)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	add_child(texture_rect)

	theme = preload("res://resources/themes/tile_buttons.tres")
	
	represented_tile_configuration = TileConfigurationDatabase.tile_configurations[tile_position]
	
	config_changed()

func _process(delta: float) -> void:
	drag_button.visible = get_global_rect().has_point(get_global_mouse_position())

func config_changed() -> void:
	#if get_parent() is TileContainer:
		#get_parent().update_layout()
	
	if SourceImagesDatabase.imported_images[SourceImagesDatabase.ImageCategory.ALBEDO].has(represented_tile_configuration.source_texture_names[SourceImagesDatabase.ImageCategory.ALBEDO]):
		set_texture(SourceImagesDatabase.imported_images[SourceImagesDatabase.ImageCategory.ALBEDO][represented_tile_configuration.source_texture_names[SourceImagesDatabase.ImageCategory.ALBEDO]])

func remove(pos : Vector2i) -> void:
	if pos == tile_position:
		queue_free()

func set_texture(texture : Texture) -> void:
	texture_rect.texture = texture
