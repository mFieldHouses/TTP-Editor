extends Node

var fd : FileDialog = FileDialog.new()

signal progress_changed(progress_factor : float)

func _ready() -> void:
	fd = FileDialog.new()
	fd.use_native_dialog = true
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	add_child(fd)
	
	WebFileAccess.progress.connect(_progress_changed)

func open(filters : String = "*") -> FileAccess:
	match OS.get_name():
		"Web":
			return await _open_web(filters)
		"Linux", "macOS", "Windows":
			return await _open_native(filters)
		
	return null

func _open_web(filters : String) -> FileAccess:
	WebFileAccess.open(filters)
	
	var results : Array = await WebFileAccess.loaded
	var file_name : String = results[0]
	var file_type : String = results[1]
	var file_contents : String = results[2]
	
	if !DirAccess.dir_exists_absolute("user://imported"):
		DirAccess.make_dir_absolute("user://imported")
	
	var file : FileAccess = FileAccess.open("user://imported/" + file_name, FileAccess.WRITE)
	file.store_buffer(Marshalls.base64_to_raw(file_contents))
	file.close()
	
	file = FileAccess.open("user://imported/" + file_name, FileAccess.READ)
	
	return file

func _open_native(filters : String) -> FileAccess:
	fd.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	fd.add_filter("*.zip", "ZIP Files", "application/zip")
	fd.popup_file_dialog()
	
	var result_path : String = await fd.file_selected
	
	if !DirAccess.dir_exists_absolute("user://imported"):
		DirAccess.make_dir_absolute("user://imported")
	
	var origin_file : FileAccess = FileAccess.open(result_path, FileAccess.READ)
	var target_file : FileAccess = FileAccess.open("user://imported/" + result_path.get_file(), FileAccess.WRITE)
	
	target_file.store_buffer(origin_file.get_buffer(origin_file.get_length()))
	target_file.close()
	
	target_file = FileAccess.open("user://imported/" + result_path.get_file(), FileAccess.READ)
	
	return target_file

func _progress_changed(current_count : int, max_count : int) -> void:
	progress_changed.emit(float(current_count)/float(max_count))
