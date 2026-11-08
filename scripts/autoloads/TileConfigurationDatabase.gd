extends Node

var tile_configurations : Dictionary[Vector2i, TileConfiguration] = {}

signal configuration_changed()

func _ready() -> void:
	initialize_configurations(8)
	
	tile_configurations[Vector2i(4,1)].tile_size = Vector2i(3,2)

func initialize_configurations(resolution : int) -> void:
	for x : int in resolution:
		for y : int in resolution:
			var new_config : TileConfiguration = TileConfiguration.new()
			new_config.changed.connect(configuration_changed.emit)
			tile_configurations[Vector2i(x,y)] = new_config

func clear_configurations() -> void:
	pass

func load_configurations() -> void:
	pass

func get_save_object() -> Dictionary[Vector2i, Dictionary]:
	var result : Dictionary[Vector2i, Dictionary] = {}
	
	for pos : Vector2i in tile_configurations.keys():
		var config : TileConfiguration = tile_configurations[pos]
		
		if !config.uninitialized:
			result[pos] = config.get_save_object()
	
	return result
