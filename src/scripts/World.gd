extends Node2D

onready var camera: = $Camera2D as Camera2D
onready var player: = $Player as KinematicBody2D
onready var StartCameraTarget: = $StartCameraTarget as Area2D
onready var TitleText: = $Title as Node2D
onready var water_animation_player: = $Water/Fish/AnimationPlayer as AnimationPlayer

var game_started: = false
var barks: = 0
var fish_timer: Timer

func _ready():
	camera.set_transition_speed(.01)
	camera.set_target(StartCameraTarget)
	_start_fish_timer()
	

func _input(event):
	if not game_started and barks >= 3:
		if event is InputEventKey:
			if event.pressed:
				game_started = true
				camera.set_transition_speed(.10)
				camera.set_target(player)
				TitleText.fade_out()
				Global.set_game_mode(Global.game_mode.NORMAL)


func _start_game() -> void:
	game_started = true
	camera.set_transition_speed(.10)
	camera.set_target(player)
	TitleText.fade_out()
	Global.set_game_mode(Global.game_mode.NORMAL)
	
	
func _start_fish_timer():
	fish_timer = Timer.new()
	fish_timer.connect("timeout", water_animation_player, "play", ["fish_jump"])
	fish_timer.one_shot = false
	add_child(fish_timer)
	fish_timer.start(5)


func _on_Player_bark():
	barks += 1


func _on_Area2D_area_entered(area):
	fish_timer.stop()
	fish_timer.queue_free()
	water_animation_player.connect("animation_finished", $Water/Fish, "queue_free")
