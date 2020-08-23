extends Node

enum game_mode {
	START = 0,
	CUTSCENE = 1,
	NORMAL = 2
}

onready var current_mode: int = game_mode.START setget set_game_mode

func _ready():
	Engine.target_fps = 60

func set_game_mode(mode: int):
	current_mode = mode


func get_files(root_path: String) -> Array:
	var files = []
	var dir = Directory.new()

	if dir.open(root_path) == OK:
		dir.list_dir_begin(true, false)

		var file_name = dir.get_next()

		while (file_name != ""):
			var path = dir.get_current_dir() + "/" + file_name

			if dir.current_is_dir():
				files = files + get_files(path)
			else:
				files.append(path)

			file_name = dir.get_next()

	return files
