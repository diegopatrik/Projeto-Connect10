extends Node2D

var number
var value
var mouse_in = false
var is_clicked = false

func _ready():
	randomize()
	number = int( rand_range(0,9) )
	value = number
	$NumberSprite.set("texture", load("res://Sprites/" + str(number) + ".png"))

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if mouse_in and Global.status == "released" and not is_clicked:
				Global.status = "pressed"
				is_clicked = true
				$SelectedNow.set("visible", true)
				$Selected.set("visible", true)
				Global.total += value
			
		elif !event.is_pressed() and Global.status == "pressed":
			Global.status = "released"
			get_tree().get_root().get_node("Game")._total()
			
		
	elif event is InputEventMouseMotion:
		if Global.status == "pressed" and mouse_in and not is_clicked:
			is_clicked = true
			$SelectedNow.set("visible", true)
			$Selected.set("visible", true)
			Global.total += value

func _mouse_entered():
	mouse_in = true
	print("mouse_entered")

func _mouse_exited():
	mouse_in = false
	$SelectedNow.set("visible", false)
