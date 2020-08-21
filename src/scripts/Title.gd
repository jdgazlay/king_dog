extends Node2D

onready var tween: = $Tween as Tween
onready var anim: = $AnimationPlayer as AnimationPlayer

func fade_out() -> void:
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.75, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	tween.connect("tween_all_completed", self, "queue_free")
	tween.start()
