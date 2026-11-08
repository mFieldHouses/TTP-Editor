extends VBoxContainer

@export var texture_preview_texture_rect: TextureRect
@export var remove_texture_button: Button
@export var texture_name_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remove_texture_button.visible = get_global_rect().has_point(get_global_mouse_position())
