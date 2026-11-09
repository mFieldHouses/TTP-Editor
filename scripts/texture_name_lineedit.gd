extends AutocompleteLineEdit

@export var type : SourceImagesDatabase.ImageCategory

func _ready() -> void:
	super()
	SourceImagesDatabase.database_changed.connect(_update_names_list)

func _update_names_list() -> void:
	words_list = SourceImagesDatabase.imported_images[type].keys()
