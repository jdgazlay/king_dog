extends Camera2D


onready var target: Node2D = self setget set_target
onready var transition_speed: float = 0.10 setget set_transition_speed

const TRANS = {
	"NORMAL": 0.10,
	"OPENING": 0.01,
	"CINEMATIC": 0.03,
}


func set_target(new_target: Node2D):
	target = new_target
	

func set_transition_speed(new_transition_speed: float) -> void:
	transition_speed = new_transition_speed
	
	
func _physics_process(delta):
	global_position = lerp(global_position, target.global_position, transition_speed)
