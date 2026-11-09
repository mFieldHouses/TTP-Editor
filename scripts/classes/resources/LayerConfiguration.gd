extends Resource
class_name LayerConfiguration

var layer_name : String = "New Layer"
var resolution : int = 4
var tile_resolution : int = 64

static func from_save_object(object : Dictionary) -> LayerConfiguration:
	var new_configuration : LayerConfiguration = LayerConfiguration.new()
	
	new_configuration.layer_name = object.layer_name
	new_configuration.resolution = object.resolution
	
	return new_configuration

func get_save_object() -> Dictionary:
	var object : Dictionary = {
		"layer_name": layer_name,
		"resolution": resolution,
		"tiles": TileConfigurationDatabase.get_save_object()
	}
	
	return object
