extends Node2D

var number = preload("res://Scenes/Number.tscn")

func _ready():
	$HUD.get_node("Message").hide()
	
	for x in range(1,9):
		for i in range(1,9):
			var node = number.instance()
			node.position = $Grid.map_to_world(Vector2(x,i)) + Vector2(32,32)
			print("Pos: " + str(node.position))
			$Grid.add_child(node)

func _process(delta):
	$HUD/Score.text = "Score: " + str(Global.score)
	$HUD/Time.text = "Time: " + str( " %02d:%02d" % [int($Timer.time_left) / 60, int($Timer.time_left) % 60] )

func _total():
	
	if Global.total == 10:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Uhuuu 10!!!"
		
	elif Global.total < 10:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Total < 10"
		
	else:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Total > 10"
	
	Global.total = 0

func _on_Timer_timeout():
	pass # GAME OVER
