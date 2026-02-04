class_name PieceData
extends Resource

enum PIECE_SHAPE {L,J,S,Z,T,O,I,R}
@export var piece_shape: PIECE_SHAPE

var piece_texture: Texture2D
var matrix: Dictionary[int, Array]

func _init(shape: PIECE_SHAPE) -> void:
	piece_shape = shape
	initialize()

func initialize() -> void:
	while piece_shape == PIECE_SHAPE.R:
		piece_shape = PIECE_SHAPE.values().pick_random()
	match piece_shape:
		PIECE_SHAPE.L:
			matrix = {
				1 : [Vector2i(1,1),Vector2i(0,1),Vector2i(2,1),Vector2i(2,0)] as Array[Vector2i]
				,2 : [Vector2i(1,1),Vector2i(1,0),Vector2i(1,2),Vector2i(2,2)] as Array[Vector2i]
				,3 : [Vector2i(1,1),Vector2i(2,1),Vector2i(0,1),Vector2i(0,2)] as Array[Vector2i]
				,4 : [Vector2i(1,1),Vector2i(1,2),Vector2i(1,0),Vector2i(0,0)] as Array[Vector2i]
			}
		PIECE_SHAPE.J:
			matrix = {
				1 : [Vector2i(1,1),Vector2i(0,1),Vector2i(2,1),Vector2i(0,0)] as Array[Vector2i]
				,2 : [Vector2i(1,1),Vector2i(1,0),Vector2i(1,2),Vector2i(2,0)] as Array[Vector2i]
				,3 : [Vector2i(1,1),Vector2i(2,1),Vector2i(0,1),Vector2i(2,2)] as Array[Vector2i]
				,4 : [Vector2i(1,1),Vector2i(1,2),Vector2i(1,0),Vector2i(0,2)] as Array[Vector2i]
			}
		PIECE_SHAPE.S:
			matrix = {
				1 : [Vector2i(1,1),Vector2i(0,1),Vector2i(1,0),Vector2i(2,0)] as Array[Vector2i]
				,2 : [Vector2i(1,1),Vector2i(1,0),Vector2i(2,1),Vector2i(2,2)] as Array[Vector2i]
				,3 : [Vector2i(1,1),Vector2i(2,1),Vector2i(1,2),Vector2i(0,2)] as Array[Vector2i]
				,4 : [Vector2i(1,1),Vector2i(1,2),Vector2i(0,1),Vector2i(0,0)] as Array[Vector2i]
			}
		PIECE_SHAPE.Z:
			matrix = {
				1 : [Vector2i(1,1),Vector2i(2,1),Vector2i(0,0),Vector2i(1,0)] as Array[Vector2i]
				,2 : [Vector2i(1,1),Vector2i(1,2),Vector2i(2,0),Vector2i(2,1)] as Array[Vector2i]
				,3 : [Vector2i(1,1),Vector2i(0,1),Vector2i(2,2),Vector2i(1,2)] as Array[Vector2i]
				,4 : [Vector2i(1,1),Vector2i(1,0),Vector2i(0,2),Vector2i(0,1)] as Array[Vector2i]
			}
		PIECE_SHAPE.T:
			matrix = {
				1 : [Vector2i(1,1),Vector2i(0,1),Vector2i(2,1),Vector2i(1,0)] as Array[Vector2i]
				,2 : [Vector2i(1,1),Vector2i(1,0),Vector2i(1,2),Vector2i(2,1)] as Array[Vector2i]
				,3 : [Vector2i(1,1),Vector2i(2,1),Vector2i(0,1),Vector2i(1,2)] as Array[Vector2i]
				,4 : [Vector2i(1,1),Vector2i(1,2),Vector2i(1,0),Vector2i(0,1)] as Array[Vector2i]
			}
		PIECE_SHAPE.O:
			matrix = {
				1 : [Vector2i(1,1),Vector2i(2,1),Vector2i(1,2),Vector2i(2,2)] as Array[Vector2i]
				,2 : [Vector2i(2,1),Vector2i(2,2),Vector2i(1,1),Vector2i(1,2)] as Array[Vector2i]
				,3 : [Vector2i(2,2),Vector2i(1,2),Vector2i(2,1),Vector2i(1,1)] as Array[Vector2i]
				,4 : [Vector2i(1,2),Vector2i(1,1),Vector2i(2,2),Vector2i(2,1)] as Array[Vector2i]
			}
		PIECE_SHAPE.I:
			matrix = {
				1 : [Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(3,1)] as Array[Vector2i]
				,2 : [Vector2i(2,0),Vector2i(2,1),Vector2i(2,2),Vector2i(2,3)] as Array[Vector2i]
				,3 : [Vector2i(3,2),Vector2i(2,2),Vector2i(1,2),Vector2i(0,2)] as Array[Vector2i]
				,4 : [Vector2i(1,3),Vector2i(1,2),Vector2i(1,1),Vector2i(1,0)] as Array[Vector2i]
			}
		_:
			matrix = {}
	piece_texture = ExtResources.PIECE_TEXTURES[piece_shape]
