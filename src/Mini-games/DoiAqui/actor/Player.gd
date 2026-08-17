extends KinematicBody2D

var typesPain = "normal"

onready var animation: AnimationPlayer = $AnimationPlayer
var gender


func _ready():
	gender = GlobalResource.gender
	print("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-parado.png")
	$sprite.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-parado.png")
	$wound.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-ferimento.png")
	$expressions/cold.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-frio.png")
	$expressions/stress.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-nervoso.png")
	$expressions/fever.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-febre.png")
	$pain.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-dores.png")

func _process(delta):
	if typesPain == "headache":
		animation.play("headache")
	elif typesPain == "armPain":
		animation.play("armPain")
	elif typesPain == "fever":
		animation.play("fever")
	elif typesPain == "wound":
		animation.play("wound")
	elif typesPain == "normal":
		animation.stop()
		$headache.visible = false
		$fever.visible = false
		$armPainCollection.visible = false
		$wound.visible = false
		animation.play("normal")	

func _on_AnimationPlayer_animation_finished(anim_name):
	$sprite.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-parado.png")

func setTextureNormal():
	$sprite.texture = load("res://assets/DoiAqui/sprites/actor/"+str(gender)+"/"+str(gender)+"-parado.png")

