extends Button

@export var category : SourceImagesDatabase.ImageCategory

func _ready() -> void:
	button_down.connect(_on_button_down)

func _on_button_down() -> void:
	SourceImagesDatabase.load_image(category)
