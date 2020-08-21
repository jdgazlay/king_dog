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
