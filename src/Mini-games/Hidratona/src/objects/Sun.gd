extends CanvasLayer

onready var animation: AnimationPlayer = $AnimationPlayer
var sun = "sun"
var fade_in = "fade_in"
var done_sun = true
var startAnimation = false

func _ready():
	animation.play("fade_in")
	
func _on_AnimationPlayer_animation_finished(fade_in):
	animation.play("fade_out")
	yield(animation, "animation_finished")
