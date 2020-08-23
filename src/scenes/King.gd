extends StaticBody2D

onready var anim: = $AnimationPlayer as AnimationPlayer


func _ready():
	anim.play("smoking")
