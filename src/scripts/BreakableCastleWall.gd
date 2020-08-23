extends StaticBody2D


onready var anim: = $AnimationPlayer as AnimationPlayer
onready var collider: = $CollisionShape2D as CollisionShape2D
onready var king_dog: = get_parent().get_parent().get_parent().get_node("Player")

var broken: = false


func _on_Player_bark():
	if not broken and king_dog.has_crown and global_position.distance_to(king_dog.global_position) <= 75:
		anim.play("break")
		broken = true
