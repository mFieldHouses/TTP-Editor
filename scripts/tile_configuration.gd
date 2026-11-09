extends VBoxContainer

# Property editors
@export var tile_name: LineEdit
@export var albedo_texture_name: AutocompleteLineEdit


@export var tile_uninitialized_v_box: VBoxContainer
@export var tile_configuration_properties_v_box: VBoxContainer
@export var initialize_tile_button: Button
@export var clear_tile_button: Button

var edited_configuration : TileConfiguration

func _ready() -> void:
	tile_name.text_changed.connect(_tile_name_changed)
	albedo_texture_name.text_changed.connect(func(text : String): _texture_name_changed(SourceImagesDatabase.ImageCategory.ALBEDO, text))
	SourceImagesDatabase.image_picked.connect(_image_picked)
	
	
	initialize_tile_button.button_down.connect(_initialize_edited_configuration)
	clear_tile_button.button_down.connect(_clear_edited_configuration)
	
func show_tile_configuration(configuration : TileConfiguration) -> void:
	if edited_configuration:
		edited_configuration.changed.disconnect(_load_edited_tile_configuration)
	
	edited_configuration = configuration
	
	if configuration:
		edited_configuration.changed.connect(_load_edited_tile_configuration)
	
		tile_uninitialized_v_box.visible = configuration.uninitialized
		tile_configuration_properties_v_box.visible = !configuration.uninitialized

	if _can_change_edited_configuration():
		_load_edited_tile_configuration()

func _initialize_edited_configuration() -> void:
	edited_configuration.uninitialized = false
	edited_configuration.initialize_values()
	
	show_tile_configuration(edited_configuration)

func _clear_edited_configuration() -> void:
	if !edited_configuration:
		return
	
	edited_configuration.reset_values()

	show_tile_configuration(edited_configuration)

func _load_edited_tile_configuration() -> void:
	if !tile_name.has_focus():
		tile_name.text = edited_configuration.tile_name
	if !albedo_texture_name.has_focus():
		albedo_texture_name.text = edited_configuration.source_texture_names[SourceImagesDatabase.ImageCategory.ALBEDO]

func _tile_name_changed(new_name : String) -> void:
	if _can_change_edited_configuration():
		edited_configuration.tile_name = new_name

func _texture_name_changed(texture_type : SourceImagesDatabase.ImageCategory, new_name : String) -> void:
	if _can_change_edited_configuration():
		edited_configuration.set_texture_name(texture_type, new_name)

func _image_picked(image_type : SourceImagesDatabase.ImageCategory, image_name : String) -> void:
	if _can_change_edited_configuration():
		edited_configuration.set_texture_name(image_type, image_name)

func _can_change_edited_configuration() -> bool:
	if edited_configuration:
		if !edited_configuration.uninitialized:
			return true
	
	return false
