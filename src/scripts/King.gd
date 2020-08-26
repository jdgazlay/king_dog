extends StaticBody2D

onready var anim: = $AnimationPlayer as AnimationPlayer
onready var player: = get_parent().get_node("Player") as KinematicBody2D

var has_crown = true


func _ready():
	anim.play("smoke")


func _on_Player_bark():
	if global_position.distance_to(player.global_position) <= 100 and has_crown:
		anim.play("flinch")
		has_crown = false
