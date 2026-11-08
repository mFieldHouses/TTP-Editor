extends Button
class_name TileButton

@export var represented_tile_configuration : TileConfiguration
@export var tile_position : Vector2i = Vector2i.ZERO

var drag_button : Button

func _ready() -> void:
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

	theme = preload("res://resources/themes/tile_buttons.tres")

func _process(delta: float) -> void:
	drag_button.visible = get_global_rect().has_point(get_global_mouse_position())

func config_changed() -> void:
	if get_parent() is TileContainer:
		get_parent().update_layout()

func remove(pos : Vector2i) -> void:
	if pos == tile_position:
		queue_free()
