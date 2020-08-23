extends KinematicBody2D

onready var animation_player: = $AnimationPlayer as AnimationPlayer
onready var sprite: = $Sprite as Sprite
onready var bark_tween: = $BarkTween as Tween
onready var woof: = $Woof as Label
onready var borf: = $Borf as Label
onready var bork: = $Bork as Label
onready var woof_sprite: = $WoofSprite1 as Sprite

signal bark

var velocity: = Vector2.ZERO
export(int) var HORIZONTAL_SPEED = 100
export(int) var JUMP_IMPULSE = -250
var GRAVITY = 9.8

var is_jumping: = false
var is_barking: = false
var just_landed: = false
var rand_bark: Label

onready var bark_words = [woof, borf, bork]


func _process(delta: float):
	_handle_movement()
	_handle_action()
	_animate()


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)


func _handle_action() -> void:
	if Global.current_mode == Global.game_mode.CUTSCENE:
		return
	
	if Input.is_action_just_pressed("bark"):
		is_barking = true
		emit_signal("bark")


func _handle_movement() -> void:
	if Global.current_mode == Global.game_mode.CUTSCENE:
		velocity = Vector2.ZERO
		return
	elif Global.current_mode != Global.game_mode.NORMAL:
		return
		
	var velocity_x = floor(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var jump_pressed = Input.is_action_just_pressed("ui_up") and is_on_floor()
	
	if jump_pressed:
		is_jumping = true
		velocity.y = JUMP_IMPULSE
	
	if is_on_floor():
		if is_jumping and !jump_pressed:
			just_landed = true
			is_jumping = false
		else:
			just_landed = false
	
	velocity.x = velocity_x * HORIZONTAL_SPEED
	
	if Input.is_action_just_released("ui_up") and is_jumping:
		velocity.y += (GRAVITY * 10)
	else:
		velocity.y += GRAVITY


func _animate() -> void:
	if is_jumping:
		animation_player.play("jump")
	elif just_landed:
		animation_player.play("land")
	else:
		if not animation_player.current_animation == "land":
			if velocity.x == 0:
				animation_player.play("idle")
			else:
				animation_player.play("run")
	
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	_bark_animations()


func _orient_borfs() -> void:
	if sprite.flip_h:
		woof_sprite.position = Vector2(-11, -3)
		if rand_bark:
			rand_bark.align = Label.ALIGN_LEFT
	else:
		woof_sprite.position = Vector2(11, -3)
		if rand_bark:
			rand_bark.align = Label.ALIGN_RIGHT


func _bark_animations() -> void:
	if not is_barking:
		return

	_orient_borfs()

	if bark_tween.is_active():
		return

	rand_bark = bark_words[rand_range(0, bark_words.size())]
	_orient_borfs()

	bark_tween.interpolate_property(
		woof_sprite,
		"scale",
		Vector2(0.382, 0.382),
		Vector2(1, 1),
		.25,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	if not bark_tween.get_signal_connection_list("tween_all_completed"):
		bark_tween.connect("tween_all_completed", self, "_reset_bark")

	woof_sprite.visible = true
	rand_bark.visible = true
	bark_tween.start()
	is_barking = false


func _reset_bark() -> void:
	woof_sprite.visible = false
	for i in range(bark_words.size()):
		bark_words[i].visible = false








