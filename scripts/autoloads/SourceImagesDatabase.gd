extends Node

signal database_changed
signal texture_name_changed(old_name : String, new_name : String)
signal texture_not_right_size
signal image_picked(image_type : ImageCategory, image_name : String)

enum ImageCategory {ALBEDO, COLOR_MODULATION_MASK, ORM, NORMAL}

# Dictionary of all imported images sorted by their type
var imported_images : Dictionary[ImageCategory, Dictionary] = {
	ImageCategory.ALBEDO: {},
	ImageCategory.COLOR_MODULATION_MASK: {},
	ImageCategory.ORM: {},
	ImageCategory.NORMAL: {}
}

func load_image(type : ImageCategory) -> void:
	var file : FileAccess = await GlobalFileAccess.open_image()
	
	if file == null:
		return
	
	var image : Image = Image.load_from_file(file.get_path())
	
	if image.get_width() % GlobalProjectManager.layer_configuration.tile_resolution != 0 || image.get_height() % GlobalProjectManager.layer_configuration.tile_resolution != 0:
		texture_not_right_size.emit()
		return
	
	var texture : ImageTexture = ImageTexture.create_from_image(image)
	
	var texture_name : String = file.get_path().get_file().get_basename()
	
	imported_images[type][texture_name] = texture
	
	database_changed.emit()

func remove_image(image_type : ImageCategory, image_name : String) -> void:
	if imported_images[image_type].has(image_name):
		imported_images[image_type].erase(image_name)
	
	database_changed.emit()

func rename_texture(type : ImageCategory, old_name : String, new_name : String) -> void:
	if imported_images[type].has(old_name):
		imported_images[type][new_name] = imported_images[type][old_name]
		imported_images[type].erase(old_name)
	
	texture_name_changed.emit(old_name, new_name)

func get_image_multiple_size(image_type : ImageCategory, image_name : String) -> Vector2i:
	if !imported_images[image_type].has(image_name):
		return Vector2i.ONE
	
	return Vector2i(
		imported_images[image_type][image_name].get_width() / GlobalProjectManager.layer_configuration.tile_resolution, 
		imported_images[image_type][image_name].get_height() / GlobalProjectManager.layer_configuration.tile_resolution
	)
