class_name Board
extends Node2D

signal player_entered_piece

const PIECE_X_OFFSET: int = 3

var current_piece_position: Vector2i = Vector2i(0,0)
var current_piece: Piece
var board_state: Dictionary
var remaining_gravity_cd: float
var gravity_multiplier: float = 1
@onready var squares: Node2D = $Squares


func _ready() -> void:
	initialize()

func _process(delta: float) -> void:
	if not GlobalStates.toggle:
		return
	
	#region inputs
	if Input.is_action_just_pressed("drop"):
		hard_drop()

	if Input.is_action_just_pressed("left"):
		try_to_move(Vector2i.LEFT)
	
	if Input.is_action_just_pressed("right"):
		try_to_move(Vector2i.RIGHT)
	
	if Input.is_action_pressed("down"):
		gravity_multiplier = 3
	else:
		gravity_multiplier = 1

	if Input.is_action_just_pressed("rotate_cw"):
		try_to_rotate(1)

	if Input.is_action_just_pressed("rotate_cc"):
		try_to_rotate(-1)
	#endregion
	
	# apply gravity
	remaining_gravity_cd -= delta * gravity_multiplier
	if remaining_gravity_cd <= 0:
		remaining_gravity_cd = GameConfig.GRAVITY_CD
		if not try_to_move(Vector2i.DOWN):
			bottom_reached()


func initialize() -> void:
	remaining_gravity_cd = GameConfig.GRAVITY_CD
	for x in range(GameConfig.BOARD_SIZE.x):
		for y in range(GameConfig.BOARD_SIZE.y):
			board_state[Vector2i(x,y)] = null
	
	for square in squares.get_children():
		square.queue_free()
	
	if current_piece:
		current_piece.queue_free()
	spawn_piece()

#region piece movement and rotation
func check_valid_coords(coords: Array[Vector2i]) -> bool:
	var taken_tiles: Array[Vector2i]
	for tile: Vector2i in board_state:
		if board_state[tile] is PieceSquare:
			taken_tiles.append(tile)
	for coord in coords:
		if coord.x < 0 or coord.x > GameConfig.BOARD_SIZE.x -1:
			return false
		if coord.y > GameConfig.BOARD_SIZE.y -1:
			return false
		if coord in taken_tiles:
			return false
	return true

func try_to_move(direction: Vector2i) -> bool:
	var new_coords: Array[Vector2i] = current_piece.get_move_coords(direction)
	if check_valid_coords(new_coords):
		current_piece_position += direction
		move_piece(new_coords)
		return true
	return false

func try_to_rotate(direction: int) -> bool:
	var new_coords: Array[Vector2i] = current_piece.get_rotation_coords(direction, current_piece_position)
	if check_valid_coords(new_coords):
		current_piece.rotate_piece(new_coords, direction)
		return true
	return false

func move_piece(new_coords: Array[Vector2i]) -> void:
	var i: int = 0
	for square: PieceSquare in current_piece.squares:
		square.position = (new_coords[i]) * GameConfig.TILE_SIZE
		i += 1
#endregion

#region piece life cycle
func spawn_piece(piece_type: PieceData.PIECE_SHAPE = PieceData.PIECE_SHAPE.R) -> void:
	current_piece_position = Vector2i.ZERO
	current_piece = Piece.new(piece_type)
	current_piece.player_entered.connect(func(): player_entered_piece.emit())
	add_child(current_piece)
	try_to_move(Vector2i(PIECE_X_OFFSET, 0))

func bottom_reached() -> void:
	for square: PieceSquare in current_piece.squares:
		board_state[Vector2i(square.position / GameConfig.TILE_SIZE)] = square
		square.reparent(squares)
	var completed_lines = find_lines()
	if completed_lines.size() > 0:
		clear_lines(completed_lines)
	spawn_piece()
#endregion

#region drop
func find_bottom():
	var tiles_down: int = 1
	while true:
		var new_coords: Array[Vector2i] = current_piece.get_move_coords(Vector2i(0, tiles_down))
		if check_valid_coords(new_coords):
			tiles_down += 1
		else:
			return current_piece.get_move_coords(Vector2i(0, tiles_down - 1))

func hard_drop() -> void:
	var target_coords = find_bottom()
	var tiles_down: int = int(current_piece.squares[0].position.y / GameConfig.TILE_SIZE)
	current_piece_position += Vector2i(0, tiles_down)
	move_piece(target_coords)
	bottom_reached()
#endregion

#region lines
func find_lines() -> Array[int]:
	var lines: Array[int] = []
	for y in range(GameConfig.BOARD_SIZE.y):
		var line_complete: bool = true
		for x in range(GameConfig.BOARD_SIZE.x):
			if not board_state[Vector2i(x,y)]:
				line_complete = false
				break
		if line_complete:
			lines.append(y)
	return lines

func clear_lines(lines: Array[int]) -> void:
	lines.sort()
	
	for line in lines:
		for x in range(GameConfig.BOARD_SIZE.x):
			var pos = Vector2i(x, line)
			if board_state[pos] is PieceSquare:
				board_state[pos].queue_free()
				board_state[pos] = null
	
	var new_board_state = {}
	for x in range(GameConfig.BOARD_SIZE.x):
		for y in range(GameConfig.BOARD_SIZE.y):
			new_board_state[Vector2i(x, y)] = null
	
	for y in range(GameConfig.BOARD_SIZE.y - 1, -1, -1):
		if y in lines:
			continue
			
		var shift_amount = 0
		for line in lines:
			if line > y:
				shift_amount += 1
		
		var new_y = y + shift_amount
		
		for x in range(GameConfig.BOARD_SIZE.x):
			var current_pos = Vector2i(x, y)
			if board_state[current_pos] is PieceSquare:
				var square = board_state[current_pos]
				var new_pos = Vector2i(x, new_y)
				square.position = Vector2(new_pos.x, new_pos.y) * GameConfig.TILE_SIZE
				new_board_state[new_pos] = square
	
	board_state = new_board_state
#endregion
