extends KinematicBody2D

onready var animation_player: = $AnimationPlayer as AnimationPlayer
onready var sprite: = $Sprite as Sprite

signal bark

var velocity: = Vector2.ZERO
export(int) var HORIZONTAL_SPEED = 100
export(int) var JUMP_IMPULSE = -250
var GRAVITY = 9.8

var is_jumping: = false
var just_landed: = false


func _process(delta):
	_handle_movement()
	_handle_action()
	_animate()

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _handle_action() -> void:
	if Global.current_mode == Global.game_mode.CUTSCENE:
		return
	
	if Input.is_action_just_pressed("bark"):
		print('borf borf borf')
		emit_signal("bark")

func _handle_movement() -> void:
	if Global.current_mode != Global.game_mode.NORMAL:
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














