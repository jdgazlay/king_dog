extends Node2D

onready var tween: = $Tween as Tween
onready var anim: = $AnimationPlayer as AnimationPlayer

func fade_out() -> void:
	tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.75, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	tween.start()


func fade_in() -> void:
	$BarkHint/Sprite.visible = false
	$BarkHint/Label.text = "You unleashed the king."
	$BarkHint.modulate = Color.transparent
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property($BarkHint, "modulate", Color.transparent, Color.white, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
