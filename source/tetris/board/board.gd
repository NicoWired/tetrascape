extends Node2D

var current_piece: Piece
var board_state: Dictionary
var remaining_gravity_cd: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_board()
	spawn_piece()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not GlobalStates.toggle:
		return
	
	#region inputs
	if Input.is_action_just_pressed("left"):
		try_to_move(Vector2i.LEFT)
	
	if Input.is_action_just_pressed("right"):
		try_to_move(Vector2i.RIGHT)

	if Input.is_action_just_pressed("rotate_cw"):
		try_to_rotate(1)

	if Input.is_action_just_pressed("rotate_cc"):
		try_to_rotate(-1)
	#endregion
	
	# apply gravity
	remaining_gravity_cd -= delta #* gravity_multiplier
	if remaining_gravity_cd <= 0:
		remaining_gravity_cd = GameConfig.GRAVITY_CD
		var new_coords: Array[Vector2i] = current_piece.get_move_coords(Vector2i.DOWN)
		if check_valid_cooords(new_coords):
			current_piece.move_piece(new_coords, Vector2i.DOWN)
		else:
			bottom_reached()

func initialize_board() -> void:
	remaining_gravity_cd = GameConfig.GRAVITY_CD
	#for i in range(PIECES_IN_QUEUE):
		#next_pieces.append(await piece_types.pick_random().new())
	for x in range(GameConfig.BOARD_SIZE.x):
		for y in range(GameConfig.BOARD_SIZE.y):
			board_state[Vector2i(x,y)] = null

#region piece movement and rotation
func check_valid_cooords(coords: Array[Vector2i]) -> bool:
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

func try_to_move(direction: Vector2i) -> void:
	var new_coords: Array[Vector2i] = current_piece.get_move_coords(direction)
	if check_valid_cooords(new_coords):
		current_piece.move_piece(new_coords, direction)

func try_to_rotate(direction: int) -> void:
	var new_coords: Array[Vector2i] = current_piece.get_rotation_coords(direction)
	if check_valid_cooords(new_coords):
		current_piece.rotate_piece(new_coords, direction)
#endregion

#region piece life cycle
func spawn_piece(piece_type: PieceData.PIECE_SHAPE = PieceData.PIECE_SHAPE.R) -> void:
	current_piece = Piece.new(piece_type)
	add_child(current_piece)

func bottom_reached() -> void:
	for square: PieceSquare in current_piece.squares:
		board_state[Vector2i(square.position / GameConfig.TILE_SIZE)] = square
		square.reparent(self)
	spawn_piece()
#endregion
