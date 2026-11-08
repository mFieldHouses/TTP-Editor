extends VBoxContainer

@export var tile_configuration_container : VBoxContainer
@export var no_tile_selected_label : Label

func show_tile_configuration(configuration : TileConfiguration) -> void:
	tile_configuration_container.visible = configuration != null
	no_tile_selected_label.visible = configuration == null
	
	tile_configuration_container.show_tile_configuration(configuration)
