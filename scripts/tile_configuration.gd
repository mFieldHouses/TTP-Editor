extends VBoxContainer

# Property editors
@export var tile_name: LineEdit

@export var tile_uninitialized_v_box: VBoxContainer
@export var tile_configuration_properties_v_box: VBoxContainer
@export var initialize_tile_button: Button

var edited_configuration : TileConfiguration

func _ready() -> void:
	tile_name.text_changed.connect(_tile_name_changed)
	initialize_tile_button.button_down.connect(_initialize_edited_configuration)

func show_tile_configuration(configuration : TileConfiguration) -> void:
	edited_configuration = configuration
	
	tile_uninitialized_v_box.visible = configuration.uninitialized
	tile_configuration_properties_v_box.visible = !configuration.uninitialized
	
	if edited_configuration:
		if !edited_configuration.uninitialized:
			_load_edited_tile_configuration()

func _initialize_edited_configuration() -> void:
	edited_configuration.uninitialized = false
	edited_configuration.initialize_values()
	
	show_tile_configuration(edited_configuration)

func _load_edited_tile_configuration() -> void:
	tile_name.text = edited_configuration.tile_name

func _tile_name_changed(new_name : String) -> void:
	if edited_configuration:
		edited_configuration.tile_name = new_name
