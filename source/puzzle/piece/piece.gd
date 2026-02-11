class_name Piece
extends Node2D

signal player_entered

var piece_res: PieceData
var current_position: int = 1
var squares: Array[PieceSquare]
var is_ghost: bool = false


static func create(input_shape: PieceData.PIECE_SHAPE) -> Piece:
	var own_scene = preload("res://source/puzzle/piece/piece.tscn")
	return own_scene.instantiate().initiate(input_shape)

func initiate(input_shape: PieceData.PIECE_SHAPE) -> Piece:
	piece_res = PieceData.new(input_shape)
	return self

func _ready() -> void:
	if not is_ghost:
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
		if direction == 1:
			square.rotate_spikes_cw()
		elif direction == -1:
			square.rotate_spikes_cc()
		i += 1
#endregion

func get_move_coords(direction: Vector2i) -> Array[Vector2i]:
	var new_coords: Array[Vector2i]
	for square: PieceSquare in squares:
		new_coords.append(Vector2i(square.position / GameConfig.TILE_SIZE) + direction)
	return new_coords
	
#func ghost() -> Piece:
	#assert(is_node_ready(), "Can't clone piece before running ready")
	#var ghost_piece: Piece = Piece.new(piece_res.piece_shape)
	#ghost_piece.piece_res = piece_res
	#ghost_piece.is_ghost = true
	#for square: PieceSquare in squares:
		#var new_square = PieceSquare.create(piece_res.piece_texture)
		#new_square.is_ghost = true
		#new_square.position = square.position
		#new_square.rng.seed = square.rng.seed
		#ghost_piece.squares.append(new_square)
		#new_square.collision_mask = 0
		#ghost_piece.add_child(new_square)
	#ghost_piece.modulate = Color(1,1,1,0.5)
	#return ghost_piece

func ghost() -> void:
	modulate = Color(1,1,1,0.5)
	for square: PieceSquare in get_children():
		square.is_ghost = true
