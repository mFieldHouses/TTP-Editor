extends Control

# Error windows
@export var error_background : ColorRect
@export var file_error_dialog : AcceptDialog
@export var not_a_project_file_dialog : AcceptDialog

# Toolbar
@export var file_menu_button : MenuButton
@export var editor_menu_button : MenuButton

@export var side_bar_v_split : VSplitContainer

func _ready() -> void:
	# Call function at end of frame to make sure all containers have taken on their correct sizes
	_initialize_container_sizes.call_deferred()
	
	error_background.visible = false
	
	# Connect signals
	file_menu_button.get_popup().id_pressed.connect(_file_option_chosen)
	
	#$NotAProjectFileDialog.popup_centered(Vector2i(50,50))
	#JavaScriptBridge.download_buffer(PackedByteArray([1,5,3,6,1,2,5,1]), "test_file.txt")
	#GlobalFileAccess.open()

func _initialize_container_sizes() -> void:
	side_bar_v_split.set_split_offsets([side_bar_v_split.size.y / 2])

func _file_option_chosen(id : int) -> void:
	match id:
		0: # New Project
			print("New project")
		1: # Open Project
			var error : GlobalProjectManager.ProjectOpenError = await GlobalProjectManager.load_project()
			
			match error:
				GlobalProjectManager.ProjectOpenError.NOT_ZIP:
					_dialog_pop_up(file_error_dialog)
				GlobalProjectManager.ProjectOpenError.NOT_TTP_PROJECT:
					_dialog_pop_up(not_a_project_file_dialog)
			
		2: # Export Project
			print("Export project")

func _dialog_pop_up(dialog : AcceptDialog) -> void:
	error_background.visible = true
	
	dialog.popup_centered()
	
	await dialog.confirmed
	
	error_background.visible = false
