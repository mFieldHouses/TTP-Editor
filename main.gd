extends Control

# Containers
@export var side_bar_root_panel_container: PanelContainer


# (Error) windows
@export var error_background : ColorRect

@export var upload_file_window : Window
@export var upload_file_window_progress_bar : ProgressBar

@export var file_error_dialog : AcceptDialog
@export var not_a_project_file_dialog : AcceptDialog
@export var texture_not_right_size_dialog: AcceptDialog

# Labels
@export var open_create_project_prompt_label: Label

# Toolbar
@export var file_menu_button : MenuButton
@export var editor_menu_button : MenuButton

@export var side_bar_v_split : VSplitContainer

# Miscellaneous nodes
@export var tile_container: TileContainer
@export var tile_configuration_parent: VBoxContainer

func _ready() -> void:
	# Call function at end of frame to make sure all containers have taken on their correct sizes
	_initialize_container_sizes.call_deferred()
	
	error_background.visible = false
	upload_file_window.min_size = upload_file_window.get_child(0).size
	GlobalFileAccess.progress_changed.connect(upload_file_window_progress_bar.set_value)
	
	# Connect signals
	file_menu_button.get_popup().id_pressed.connect(_file_option_chosen)
	tile_container.tile_pos_selected.connect(_tile_button_pressed)
	GlobalProjectManager.project_loaded.connect(func(): side_bar_root_panel_container.modulate.a = 1.0)
	GlobalProjectManager.project_loaded.connect(open_create_project_prompt_label.set_visible.bind(false))
	SourceImagesDatabase.texture_not_right_size.connect(_dialog_pop_up.bind(texture_not_right_size_dialog))
	
	side_bar_root_panel_container.modulate.a = 0.0
	
	
	#$NotAProjectFileDialog.popup_centered(Vector2i(50,50))
	#JavaScriptBridge.download_buffer(PackedByteArray([1,5,3,6,1,2,5,1]), "test_file.txt")
	#GlobalFileAccess.open()

func _initialize_container_sizes() -> void:
	side_bar_v_split.set_split_offsets([side_bar_v_split.size.y / 2])

func _file_option_chosen(id : int) -> void:
	match id:
		0: # New Project
			GlobalProjectManager.new_project()
		1: # Open Project
			_notification_pop_up(upload_file_window)
			var error : GlobalProjectManager.ProjectOpenError = await GlobalProjectManager.load_project()
			_notification_pop_out(upload_file_window)
			
			match error:
				GlobalProjectManager.ProjectOpenError.NOT_ZIP:
					_dialog_pop_up(file_error_dialog)
				GlobalProjectManager.ProjectOpenError.NOT_TTP_PROJECT:
					_dialog_pop_up(not_a_project_file_dialog)
			
		2: # Export Project
			GlobalProjectManager.save_project("test")

func _dialog_pop_up(dialog : AcceptDialog) -> void:
	error_background.visible = true
	
	dialog.popup_centered()
	
	await dialog.confirmed
	
	error_background.visible = false

func _notification_pop_up(window : Window) -> void:
	error_background.visible = true
	window.popup_centered()

func _notification_pop_out(window : Window) -> void:
	error_background.visible = false
	window.visible = false

func _tile_button_pressed(pos : Vector2i) -> void:
	if pos == Vector2i(-1, -1):
		tile_configuration_parent.show_tile_configuration(null)
	else:
		tile_configuration_parent.show_tile_configuration(TileConfigurationDatabase.tile_configurations[pos])
