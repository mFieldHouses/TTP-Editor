extends VBoxContainer
class_name ImagePreviewEntry

@export var is_template : bool = true
@export var texture_preview_texture_rect: TextureRect
@export var remove_texture_button: Button
@export var texture_name_line_edit: LineEdit
@export var containing_vbox : VBoxContainer

var texture_type : SourceImagesDatabase.ImageCategory
var texture_name : String

func _ready() -> void:
	remove_texture_button.button_down.connect(_remove_texture_button_pressed)
	texture_preview_texture_rect.gui_input.connect(_texture_rect_gui_input)
	texture_name_line_edit.text_submitted.connect(_change_texture_name)
	
func _process(delta: float) -> void:
	remove_texture_button.visible = get_global_rect().has_point(get_global_mouse_position())

func set_texture(texture : Texture2D) -> void:
	texture_preview_texture_rect.texture = texture

func set_texture_name(texture_name : String) -> void:
	texture_name_line_edit.text = texture_name
	self.texture_name = texture_name

func _remove_texture_button_pressed() -> void:
	SourceImagesDatabase.remove_image(containing_vbox.type, texture_name)

func _change_texture_name(new_name : String) -> void:
	SourceImagesDatabase.rename_texture(texture_type, texture_name, new_name)
	texture_name = new_name

func _texture_rect_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			SourceImagesDatabase.image_picked.emit(texture_type, texture_name)
