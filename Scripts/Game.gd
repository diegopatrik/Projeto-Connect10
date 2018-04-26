extends Node2D

var number = preload("res://Scenes/Number.tscn")
var matrix = []

func _ready():
	$HUD.get_node("Message").hide()
	_clear_matrix()
	
	#places all numbers using Grid positions
	for x in range(1,9):
		for i in range(1,9):
			var node = number.instance()
			#adds the half size of the cell to place the number in the center
			node.position = $Grid.map_to_world(Vector2(x,i)) + Vector2(32,32)
			#adds the number to the matrix
			if matrix[x][i] == null:
				matrix[x][i] = node
			$Grid.add_child(node)

#creates a matrix[10][10] to hold numbers
func _clear_matrix():
	for x in range(10):
		matrix.append([])
		matrix[x] = []
		
		for y in range(10):
			matrix[x].append([])
			matrix[x][y] = null

func _process(delta):
	$HUD/Score.text = "Score: " + str(Global.score)
	$HUD/Time.text = "Time: " + str( " %02d:%02d" % [int($Timer.time_left) / 60, int($Timer.time_left) % 60] )

func _reload():
	#set all numbers to the original values
	for i in $Grid.get_children():
			i.is_clicked = false
			i.get_node("Area2D/SelectedNow").set("visible", false)
			i.get_node("Area2D/Selected").set("visible", false)

#function to move down 
func _move_down():
	#starts from the bottom to check for empty places on the matrix
	for y in range(8, -1, -1):
		for x in range(9):
			if matrix[x][y] != null:
				
				var moved = false
				var new_y
				#when find a empty place check for more empty places
				#under and store the destination on new_y
				for i in range(y + 1, 9):
					if matrix[x][i] == null:
						new_y = i 
						moved = true
					else:
						break 
				
				if moved:
					#sets the new y position, convet the new_y to a world position
					matrix[x][y].position.y =  ($Grid.map_to_world(Vector2(matrix[x][y].position.x, new_y)) + Vector2(32,32)).y
					matrix[x][new_y] = matrix[x][y]
					matrix[x][y] = null

func _total():
	#variable to store the total number of selected numbers
	var total_selected = 0
	
	if Global.total == 10:
		for i in $Grid.get_children():
			if i.is_clicked and not i.flag:
				i._play_anim()
				total_selected += 1
			
			#if number is zero (flag)
			#gets its position and set it as a empty place on
			#the matrix then call the movedown function
			elif i.is_clicked and i.flag:
				var x = $Grid.world_to_map(i.position).x
				var y = $Grid.world_to_map(i.position).y
				matrix[x][y] = null
				i.queue_free()
				total_selected += 1
				_move_down()
		
		#score increases according to the number of selected numbers
		Global.score += total_selected * 10
	
	#shows a message if the total value is higher or lesser than 10
	elif Global.total < 10:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Total < 10"
		$HUD/MessageTimer.start()
		
	else:
		$HUD.get_node("Message").show()
		$HUD.get_node("Message").text = "Total > 10"
		$HUD/MessageTimer.start()
	
	Global.total = 0
	_reload()

func _on_MessageTimer_timeout():
	$HUD/Message.hide()

func _on_Timer_timeout():
	pass # GAME OVER