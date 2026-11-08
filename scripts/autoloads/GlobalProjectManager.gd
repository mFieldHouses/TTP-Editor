extends Node

var project_configuration : LayerConfiguration

enum ProjectOpenError {
	SUCCESS,
	NOT_ZIP,
	NOT_TTP_PROJECT
}

func load_project() -> ProjectOpenError:
	var zip : FileAccess = await GlobalFileAccess.open(".zip")
	
	if !zip.get_path().get_extension() == "zip":
		printerr("Opened file is not a .zip file.")
		return ProjectOpenError.NOT_ZIP
	
	var zr : ZIPReader = ZIPReader.new()
	zr.open(zip.get_path())
	
	var files : PackedStringArray = zr.get_files()
	if !files.has("configuration.ttpc"):
		printerr("Opened ZIP file is not a TTP Project.")
		return ProjectOpenError.NOT_TTP_PROJECT
	
	return ProjectOpenError.SUCCESS

func save_project(_name : String) -> void:
	var zp : ZIPPacker = ZIPPacker.new()
	
	if !DirAccess.dir_exists_absolute("user://saved"):
		DirAccess.make_dir_absolute("user://saved")
	
	zp.open("user://saved/New Project.zip", ZIPPacker.APPEND_CREATE)
	zp.start_file("config.ttpc")
	zp.write_file(JSON.stringify("{'test': 'Hello World!'}").to_utf8_buffer())
	zp.close_file()
	zp.close()
	
	var file : FileAccess = FileAccess.open("user://saved/New Project.zip", FileAccess.READ)
	GlobalFileAccess.save(file)
	
func new_project() -> void:
	pass
