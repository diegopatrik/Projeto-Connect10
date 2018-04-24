extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var number
var value

func _ready():
	randomize()
	number = int( rand_range(0,9) )
	value = number
	$Sprite.set("texture", load("res://Sprites/" + str(number) + ".png"))
	

#func _process(delta):
