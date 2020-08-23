extends Node2D

onready var camera: = $Camera2D as Camera2D
onready var king_dog: = $Player as KinematicBody2D
onready var StartCameraTarget: = $StartCameraTarget as Area2D
onready var TitleText: = $Title as Node2D
onready var water_animation_player: = $Water/Fish/AnimationPlayer as AnimationPlayer
onready var bark_hint_tween: = $Title/BarkHint/HintTween as Tween
onready var bark_hint: = $Title/BarkHint as Node2D
onready var breakable_wall_collider: = $GroundColliders/CastlColliders/BreakableCastleWall/CollisionShape2D as CollisionShape2D
onready var breakable_wall_anim: = $GroundColliders/CastlColliders/BreakableCastleWall/AnimationPlayer as AnimationPlayer

var barks: = 0
var fish_timer: Timer
var bark_timer: Timer

func _ready():
	camera.set_transition_speed(camera.TRANS.OPENING)
	camera.set_target(StartCameraTarget)
	_start_bark_timer()
	_start_fish_timer()


func _input(event):
	if Global.current_mode == Global.game_mode.START and barks >= 2:
		if event is InputEventKey:
			if event.pressed:
				_start_game()
				bark_timer.queue_free()
		


func _give_bark_hint() -> void:
	bark_hint_tween.interpolate_property(
		bark_hint,
		"modulate",
		Color.transparent,
		Color.white,
		1.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	bark_hint_tween.start()


func _start_game() -> void:
	camera.set_transition_speed(camera.TRANS.NORMAL)
	camera.set_target(king_dog)
	TitleText.fade_out()
	Global.set_game_mode(Global.game_mode.NORMAL)


func _start_bark_timer() -> void:
	bark_timer = Timer.new()
	bark_timer.one_shot = true
	bark_timer.connect("timeout", self, "_give_bark_hint")
	add_child(bark_timer)
	bark_timer.start(10)


func _start_fish_timer() -> void:
	fish_timer = Timer.new()
	fish_timer.connect("timeout", water_animation_player, "play", ["fish_jump"])
	fish_timer.connect("timeout", self, "_play_fish_timer")
	fish_timer.one_shot = true
	add_child(fish_timer)
	_play_fish_timer()

func _play_fish_timer() -> void:
	fish_timer.start(rand_range(4, 7))
	

func _on_Player_bark():
	barks += 1


func _on_Area2D_area_entered(area):
	fish_timer.stop()
	fish_timer.queue_free()
	water_animation_player.connect("animation_finished", $Water/Fish, "queue_free")


func _on_KingCutscene_area_entered(area):
	Global.set_game_mode(Global.game_mode.CUTSCENE)
	$King/Particles2D.emitting = true
	camera.set_transition_speed(camera.TRANS.CINEMATIC)
	camera.set_target($King)
	yield(get_tree().create_timer(3), "timeout")
	camera.set_target(king_dog)
	camera.set_transition_speed(camera.TRANS.NORMAL)
	Global.set_game_mode(Global.game_mode.NORMAL)
	$KingCutscene.queue_free()
	$ClimbStairs.queue_free()


func _on_Crown_area_entered(area):
	king_dog.fetch_crown()
	$Crown.queue_free()






