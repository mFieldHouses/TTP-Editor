extends Node

var fd : FileDialog = FileDialog.new()

signal progress_changed(progress_factor : float)

enum FileDialogCloseStatus {SUCCESS, CANCEL, ERROR}
signal _file_dialogue_closed(status : FileDialogCloseStatus, path : String, data : PackedByteArray)

func _ready() -> void:
	fd = FileDialog.new()
	fd.use_native_dialog = true
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	
	fd.canceled.connect(_file_dialogue_closed.emit.bind(FileDialogCloseStatus.CANCEL, "", 0))
	fd.file_selected.connect(_fd_file_selected)
	
	add_child(fd)
	
	WebFileAccess.progress.connect(_progress_changed)

## Opens a project file from the device.
func open(filters : String = "*") -> FileAccess:
	match OS.get_name():
		"Web":
			return await _open_project_web(filters)
		"Linux", "macOS", "Windows":
			return await _open_project_native(filters)
		
	return null

func save(file : FileAccess) -> Error:
	match OS.get_name():
		"Web":
			_save_project_web(file)
		"Linux", "macOS", "Windows":
			await _save_project_native(file)
	
	return OK

## Function that handles loading files when running in Web
func _open_project_web(filters : String) -> FileAccess:
	WebFileAccess.open(filters)
	
	var results : Array = await _file_dialogue_closed
	
	if results[0] != FileDialogCloseStatus.SUCCESS:
		return null
	
	var file_name : String = results[1]
	var file_contents : String = results[2]
	
	if !DirAccess.dir_exists_absolute("user://imported"):
		DirAccess.make_dir_absolute("user://imported")
	
	var file : FileAccess = FileAccess.open("user://imported/" + file_name, FileAccess.WRITE)
	file.store_buffer(Marshalls.base64_to_raw(file_contents))
	file.close()
	
	file = FileAccess.open("user://imported/" + file_name, FileAccess.READ)
	
	return file

## Function that handles loading files when running native mode (including as an addon)
func _open_project_native(filters : String) -> FileAccess:
	fd.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	fd.add_filter("*.zip", "ZIP Files", "application/zip")
	fd.popup_file_dialog()
	
	var results : Array = await _file_dialogue_closed
	
	if results[0] != FileDialogCloseStatus.SUCCESS:
		return null
	
	var result_path : String = results[1]
	
	if !DirAccess.dir_exists_absolute("user://imported"):
		DirAccess.make_dir_absolute("user://imported")
	
	var origin_file : FileAccess = FileAccess.open(result_path, FileAccess.READ)
	var target_file : FileAccess = FileAccess.open("user://imported/" + result_path.get_file(), FileAccess.WRITE)
	
	target_file.store_buffer(origin_file.get_buffer(origin_file.get_length()))
	target_file.close()
	
	target_file = FileAccess.open("user://imported/" + result_path.get_file(), FileAccess.READ)
	
	return target_file

func _open_texture_web() -> void:
	pass

func _open_texture_native() -> void:
	pass

func _progress_changed(current_count : int, max_count : int) -> void:
	progress_changed.emit(float(current_count)/float(max_count))

func _save_project_web(file : FileAccess) -> void:
	JavaScriptBridge.download_buffer(file.get_buffer(file.get_length()), file.get_path().get_file(), "application/zip")

func _save_project_native(file : FileAccess) -> void:
	fd.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	fd.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	fd.add_filter("*.zip", "ZIP Files", "application/zip")
	fd.popup_file_dialog()
	
	var result_path : String = await fd.file_selected
	var target_file : FileAccess = FileAccess.open(result_path, FileAccess.WRITE)
	
	target_file.store_buffer(file.get_buffer(file.get_length()))
	target_file.close()

func _fd_file_selected(path : String) -> void:
	GlobalFileAccess._file_dialogue_closed.emit(FileDialogCloseStatus.SUCCESS, path, 0)
