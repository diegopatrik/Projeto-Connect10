extends Node2D

onready var sprite = get_node("Area2D/NumberSprite")
onready var effect = get_node("Effect")

var number
var flag = false
var mouse_in = false
var is_clicked = false

func _ready():
	randomize()
	number = int( rand_range(0,9) )
	sprite.set("texture", load("res://Sprites/" + str(number) + ".png"))
	if number == 0:
		flag = true
	
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
				Global.total += number
			
		elif !event.is_pressed() and Global.status == "pressed":
			Global.status = "released"
			print("released")
			get_tree().get_root().get_node("Game")._total()
			
		
	elif event is InputEventMouseMotion:
		if Global.status == "pressed" and mouse_in and not is_clicked:
			is_clicked = true
			$Area2D/SelectedNow.set("visible", true)
			$Area2D/Selected.set("visible", true)
			Global.total += number

func _mouse_entered():
	mouse_in = true

func _mouse_exited():
	mouse_in = false
	$Area2D/SelectedNow.set("visible", false)

func _play_anim():
		effect.start()

func _on_Effect_tween_completed(object, key):
	
	var node = get_tree().get_root().get_node("Game").number.instance()
	node.position = position
	get_parent().add_child(node)
	queue_free()