class_name Piece
extends Node2D

signal piece_moved
signal player_entered

var piece_res: PieceData
var current_position: int = 1
var squares: Array[PieceSquare]


func _init(shape: PieceData.PIECE_SHAPE) -> void:
	piece_res = PieceData.new(shape)

func _ready() -> void:
	piece_res.initialize()
	create_piece(piece_res.matrix[current_position], Vector2i.ZERO)

func create_piece(coordinates: Array[Vector2i], board_position: Vector2i) -> void:
	for coord: Vector2i in coordinates:
		var piece_square := PieceSquare.create(piece_res.piece_texture)
		piece_square.position = (coord+board_position) * GameConfig.TILE_SIZE
		piece_square.player_entered.connect(func(): player_entered.emit())
		
		squares.append(piece_square)
		add_child(piece_square)

#region Rotation
func calculate_new_rotation_direction(direction: int) -> int:
	var new_direction: int = current_position + direction
	if new_direction == 0:
		new_direction = len(piece_res.matrix)
	elif new_direction == len(piece_res.matrix)+1:
		new_direction = 1
	return new_direction

func get_rotation_coords(direction: int, board_position: Vector2i) -> Array[Vector2i]:
	assert(direction in [-1,1], "direction can only be 1 or -1")
	var new_direction: int = calculate_new_rotation_direction(direction)
	var new_shape: Array[Vector2i] = piece_res.matrix[new_direction]
	var new_coords: Array[Vector2i]
	for coord: Vector2i in new_shape:
		new_coords.append(coord + board_position)
	return new_coords

func rotate_piece(new_coords: Array[Vector2i], direction: int) -> void:
	assert(direction in [-1,1], "direction can only be 1 or -1")
	
	var new_direction: int = calculate_new_rotation_direction(direction)
	current_position = new_direction
	
	var i = 0
	for square: PieceSquare in squares:
		square.position = new_coords[i] * GameConfig.TILE_SIZE
		i += 1
#endregion

#region Movement
func move_piece(new_coords: Array[Vector2i]) -> void:
	var i: int = 0
	for square: PieceSquare in squares:
		square.position = new_coords[i] * GameConfig.TILE_SIZE
		i += 1
	piece_moved.emit()

func get_move_coords(direction: Vector2i) -> Array[Vector2i]:
	var new_coords: Array[Vector2i]
	for square: PieceSquare in squares:
		new_coords.append(Vector2i(square.position / GameConfig.TILE_SIZE) + direction)
	return new_coords
#endregion
