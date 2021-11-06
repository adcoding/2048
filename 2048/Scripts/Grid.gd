extends Node2D

var width := 4
var height := 4
var board := []
#var board :=  [ [null, null, null, null], [null, null, null, null], [null, null, null, null], [null, null, null, null], ]
var x_start := 377
var y_start := 440
var offset := 85

export var two_piece : PackedScene
export var four_piece : PackedScene
export var background_piece : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	board = make_2d_array(4, 4, null)
	generate_background()
	generate_new_piece()

func make_2d_array(width, height, value):
	var array = []
	for i in range(width):
		array.append([])
		array[i].resize(width)
		for j in range(height):
			array[i][j] = value
	return array

func grid_to_pixel(grid_position: Vector2):
	var new_x = x_start + offset * grid_position.x
	var new_y = y_start + -offset * grid_position.y
	return Vector2(new_x, new_y) 

func pixel_to_grid(pixel_position: Vector2):
	var new_x = round((pixel_position.x - x_start) / offset)
	var new_y = round((pixel_position.y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(grid_position: Vector2):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true
	return false


func is_blank_space():
	for i in width:
		for j in height:
			if board[i][j] == null:
				return true
	return false

func move_all_pieces(direction: Vector2):
	match direction:
		Vector2.UP:
			for i in width:
				for j in range(height -1, -1, -1):
					if board[i][j] != null:
						move_piece(Vector2(i, j), Vector2.UP)
		Vector2.DOWN:
			for i in width:
				for j in range(0, height, 1):
					if board[i][j] != null:
						move_piece(Vector2(i, j), Vector2.DOWN)
		Vector2.LEFT:
			for i in range(width -1, -1, -1):
				for j in height:
					if board[i][j] != null:
						move_piece(Vector2(i, j), Vector2.LEFT)
						print("left")
		Vector2.RIGHT:
			for i in range(width -2, -1, -1):
				for j in height:
					if board[i][j] != null:
						move_piece(Vector2(i, j), Vector2.RIGHT)
		_:
			continue
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generate_new_piece():
	if is_blank_space():
		var pieces_made = 0
		while pieces_made < 2:
			var x_position = int(floor((rand_range(0,4))))
			var y_position = int(floor((rand_range(0,4))))
			if board[x_position][y_position] == null:
				var temp = is_two_of_four().instance()
				add_child(temp)
				board[x_position][y_position] = temp
				temp.position = grid_to_pixel(Vector2(x_position, y_position))
				pieces_made += 1
	else:
		print("no more space")
 
func is_two_of_four():
	var temp = rand_range(0, 100)
	if temp <= 75:
		return two_piece
	else:
		return four_piece	

func generate_background():
	for i in width:
		for j in height:
			var temp = background_piece.instance()
			add_child(temp)
			temp.position = grid_to_pixel(Vector2(i, j))

func move_and_set_board_value(current: Vector2, desired: Vector2):
	var temp = board[current.x][current.y]
	temp.move(grid_to_pixel(Vector2(desired.x, desired.y)))
	board[current.x][current.y] = null
	board[current.x][current.y] = temp

func move_piece(piece: Vector2, direction):
	#store piece
	var this_piece = board[piece.x][piece.y]
	var value = this_piece.value
	#store the value of the next piece
	var next_space = piece + direction
	var temp = board[piece.x][piece.y].next_value
	#var next_value = board[next_space.x][next_space.y]
	match direction:
		Vector2.RIGHT:
			for i in range(next_space.x, width):
				if i == width -1 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(width -1, piece.y))
					break
				
				if board[i][piece.y] != null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i -1, piece.y))
					break
					
				if board[i][piece.y] != null && board[i][piece.y].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
		Vector2.LEFT:
			for i in range(next_space.x - 1, -1):
				if i == 0 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(0, piece.y))
					break
				
				if board[i][piece.y] != null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i + 1, piece.y))
					break
				
				if board[i][piece.y] != null && board[i][piece.y].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
		Vector2.UP:
			for i in range(piece.y + 1, height):
				if i == height - 1 && board[piece.x][i] == null:
					move_and_set_board_value(piece, Vector2(piece.x, height - 1))
					break
				if board[piece.x][i] != null && board[piece.x][i].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i - 1))
					break
				if board[piece.x][i] != null && board[piece.x][i].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(piece.x, i))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[piece.x][i] = new_piece
					new_piece.position = grid_to_pixel(Vector2(piece.x, i))
					break

		Vector2.DOWN:
			for i in range(piece.y -1, -1, -1):
				if i == 0 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(piece.x, 0))
					break;
		
				if board[i][piece.y] != null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i + 1))
					break;

				if board[piece.x][i] != null && board[piece.x][i].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(piece.x, i))
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(piece.x, i))
					break;


func remove_and_clear(piece: Vector2):
	if board[piece.x][piece.y] != null:
		board[piece.x][piece.y].remove()
		board[piece.x][piece.y] = null

func _on_TouchControl_move(direction: Vector2):
	pass # Replace with function body.


func _on_KeyboardControl_move(direction: Vector2):
	move_all_pieces(direction)
