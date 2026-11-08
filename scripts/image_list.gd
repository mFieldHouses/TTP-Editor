extends VBoxContainer

@export var load_image_button: Button
@export var column_count_spin_box: SpinBox
@export var image_list_grid_container: GridContainer

func _ready() -> void:
	column_count_spin_box.value_changed.connect(update_column_count)

func update_column_count(count : int) -> void:
	image_list_grid_container.columns = count
