extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var number = preload("res://Scenes/Number.tscn")

func _ready():
	
	for x in range(1,9):
		for i in range(1,9):
			print(str(x) +  " e " + str(i))
			var node = number.instance()
			$Grid.add_child(node)
			node.position = $Grid.map_to_world( Vector2(x,i))
			
			
		

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
