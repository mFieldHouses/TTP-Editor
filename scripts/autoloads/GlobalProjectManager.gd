extends Node

var layer_configuration : LayerConfiguration = LayerConfiguration.new()

enum ProjectOpenError {
	SUCCESS,
	NOT_ZIP,
	NOT_TTP_PROJECT,
	CANCELLED
}

const CONFIGURATION_FILE_NAME : String = "configuration.ttpc"

signal project_loaded

func load_project() -> ProjectOpenError:
	var zip : FileAccess = await GlobalFileAccess.open(".zip")
	
	if zip == null:
		return ProjectOpenError.CANCELLED
	
	if !zip.get_path().get_extension() == "zip":
		printerr("Opened file is not a .zip file.")
		return ProjectOpenError.NOT_ZIP
	
	var zr : ZIPReader = ZIPReader.new()
	zr.open(zip.get_path())
	
	var files : PackedStringArray = zr.get_files()
	if !files.has(CONFIGURATION_FILE_NAME):
		printerr("Opened ZIP file is not a TTP Project.")
		return ProjectOpenError.NOT_TTP_PROJECT
	
	var config_string : String = zr.read_file(CONFIGURATION_FILE_NAME).get_string_from_utf8()
	layer_configuration = LayerConfiguration.from_save_object(JSON.parse_string(config_string))
	
	project_loaded.emit()
	
	return ProjectOpenError.SUCCESS

func save_project(_name : String) -> void:
	var zp : ZIPPacker = ZIPPacker.new()
	
	if !DirAccess.dir_exists_absolute("user://saved"):
		DirAccess.make_dir_absolute("user://saved")
	
	zp.open("user://saved/New Project.zip", ZIPPacker.APPEND_CREATE)
	zp.start_file(CONFIGURATION_FILE_NAME)
	zp.write_file(JSON.stringify(layer_configuration.get_save_object(), " ").to_utf8_buffer())
	zp.close_file()
	zp.close()
	
	var file : FileAccess = FileAccess.open("user://saved/New Project.zip", FileAccess.READ)
	GlobalFileAccess.save(file)
	
func new_project() -> void:
	layer_configuration = LayerConfiguration.new()
	
	project_loaded.emit()
