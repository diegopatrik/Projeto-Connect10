extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var number = preload("res://Scenes/Number.tscn")

func _ready():
	
	for x in range(1,9):
		for i in range(1,9):
			var node = number.instance()
			node.position = $Grid.map_to_world(Vector2(x,i)) + Vector2(32,32)
			print("Pos: " + str(node.position))
			$Grid.add_child(node)
			
			
		

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
