extends Node2D

onready var sprite = get_node("Area2D/NumberSprite")
onready var effect = get_node("Effect")

var number
#flag to set true when it's the number zero 
var flag = false
var mouse_in = false
#variable to check if the number was selected or clicked
var is_clicked = false

func _ready():
	randomize()
	#gets a random number and sets a texture
	number = int( rand_range(0,9) )
	sprite.set("texture", load("res://Sprites/" + str(number) + ".png"))
	if number == 0:
		flag = true
	
	#spinning and fading effects on the number 
	effect.interpolate_property(sprite, "rotation_degrees", 0, 260, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)

func _input(event):
	if event is InputEventMouseButton:
		#detects when a number is selected and set its texture visible to indicate that
		#its now selected
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if mouse_in and Global.status == "released" and not is_clicked:
				Global.status = "pressed"
				is_clicked = true
				$Area2D/SelectedNow.set("visible", true)
				$Area2D/Selected.set("visible", true)
				Global.total += number
		#detects when the mouse button is released then call the total fuction
		#on the Game scene
		elif !event.is_pressed() and Global.status == "pressed":
			Global.status = "released"
			get_tree().get_root().get_node("Game")._total()
			
	#detects when the mouse is pressed and moving to select numbers
	#increases the total value of selected numbers
	elif event is InputEventMouseMotion:
		if Global.status == "pressed" and mouse_in and not is_clicked:
			is_clicked = true
			$Area2D/SelectedNow.set("visible", true)
			$Area2D/Selected.set("visible", true)
			Global.total += number

#detects when the mouse is on this number or not
func _mouse_entered():
	mouse_in = true

func _mouse_exited():
	mouse_in = false
	$Area2D/SelectedNow.set("visible", false)

#play the spinning and fading effect
func _play_anim():
		effect.start()

func _on_Effect_tween_completed(object, key):
	#get a new number and add to the same position of the current one
	var node = get_tree().get_root().get_node("Game").number.instance()
	#places the new number on the matrix
	get_tree().get_root().get_node("Game").matrix[get_parent().world_to_map(position).x][get_parent().world_to_map(position).y] = node
	node.position = position
	get_parent().add_child(node)
	queue_free()