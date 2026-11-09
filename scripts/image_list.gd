extends VBoxContainer

@export var type : SourceImagesDatabase.ImageCategory
@export var load_image_button: Button
@export var column_count_spin_box: SpinBox
@export var image_list_grid_container: GridContainer
@export var image_template_entry: ImagePreviewEntry

func _ready() -> void:
	column_count_spin_box.value_changed.connect(_update_column_count)
	SourceImagesDatabase.database_changed.connect(_update_image_list)

func _update_column_count(count : int) -> void:
	image_list_grid_container.columns = count

func _clear_image_list() -> void:
	for child : Node in image_list_grid_container.get_children():
		if child is ImagePreviewEntry:
			if !child.is_template:
				child.queue_free()

func _update_image_list() -> void:
	print("update image list")
	
	_clear_image_list()
	
	for texture_name : String in SourceImagesDatabase.imported_images[type]:
		var texture : ImageTexture = SourceImagesDatabase.imported_images[type][texture_name]
		
		var new_image_preview_entry : ImagePreviewEntry = image_template_entry.duplicate()
		new_image_preview_entry.is_template = false
		new_image_preview_entry.visible = true
		
		new_image_preview_entry.set_texture(texture)
		new_image_preview_entry.set_texture_name(texture_name)
		
		image_list_grid_container.add_child(new_image_preview_entry)
		print(new_image_preview_entry)
