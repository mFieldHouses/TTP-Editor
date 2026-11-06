extends Node

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

func save_project(name : String) -> void:
	pass

func new_project() -> void:
	pass
