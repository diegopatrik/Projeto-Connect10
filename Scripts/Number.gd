extends Node2D

onready var sprite = get_node("Area2D/NumberSprite")
onready var effect = get_node("Effect")

var number
var value
var mouse_in = false
var is_clicked = false

func _ready():
	randomize()
	number = int( rand_range(0,9) )
	value = number
	sprite.set("texture", load("res://Sprites/" + str(number) + ".png"))
	
	effect.interpolate_property(sprite, "rotation_degrees", 0, 260, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if mouse_in and Global.status == "released" and not is_clicked:
				Global.status = "pressed"
				is_clicked = true
				$Area2D/SelectedNow.set("visible", true)
				$Area2D/Selected.set("visible", true)
				Global.total += value
			
		elif !event.is_pressed() and Global.status == "pressed":
			Global.status = "released"
			print("released")
			get_tree().get_root().get_node("Game")._total()
			
		
	elif event is InputEventMouseMotion:
		if Global.status == "pressed" and mouse_in and not is_clicked:
			is_clicked = true
			$Area2D/SelectedNow.set("visible", true)
			$Area2D/Selected.set("visible", true)
			Global.total += value

func _mouse_entered():
	mouse_in = true
	print(value)

func _mouse_exited():
	mouse_in = false
	$Area2D/SelectedNow.set("visible", false)

func _play_anim():
	if value == 0:
		queue_free()
	else:
		effect.start()

func _get_new_number():
	sprite.rotation_degrees = 0
	sprite.modulate = Color(1,1,1,1)
	$Area2D/SelectedNow.set("visible", false)
	$Area2D/Selected.set("visible", false)
	
	number = int( rand_range(0,9) )
	value = number
	sprite.set("texture", load("res://Sprites/" + str(number) + ".png"))
	
	print("new number" + str(mouse_in) + str(is_clicked))

func _on_Effect_tween_completed(object, key):
	_get_new_number()
