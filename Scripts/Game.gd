extends Node2D

var number = preload("res://Scenes/Number.tscn")

func _ready():
	$HUD.get_node("Message").hide()
	
	for x in range(1,9):
		for i in range(1,9):
			var node = number.instance()
			node.position = $Grid.map_to_world(Vector2(x,i)) + Vector2(32,32)
			$Grid.add_child(node)

func _process(delta):
	$HUD/Score.text = "Score: " + str(Global.score)
	$HUD/Time.text = "Time: " + str( " %02d:%02d" % [int($Timer.time_left) / 60, int($Timer.time_left) % 60] )

func _reload():
	for i in $Grid.get_children():
			i.is_clicked = false
			i.get_node("Area2D/SelectedNow").set("visible", false)
			i.get_node("Area2D/Selected").set("visible", false)

func _total():
	
	var total_selected = 0
	
	if Global.total == 10:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Uhuuu 10!!!"
		
		for i in $Grid.get_children():
			if i.is_clicked:
				total_selected += 1
				i._play_anim()
		
		Global.score += total_selected * 10
		
	elif Global.total < 10:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Total < 10"
		
	else:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Total > 10"
	
	Global.total = 0
	_reload()

func _on_Timer_timeout():
	pass # GAME OVER
