extends Node

const PLACEHOLDER_TEXTURE: Texture2D = preload("res://icon.svg")
const PIECE1: Texture2D = preload("res://assets/pieces/piece1.png")
const PIECE2: Texture2D = preload("res://assets/pieces/piece2.png")
const PIECE3: Texture2D = preload("res://assets/pieces/piece3.png")
const PIECE4: Texture2D = preload("res://assets/pieces/piece4.png")

var chosen_piece_texture: Texture2D = PIECE2

var PIECE_TEXTURES: Dictionary[int,Texture2D] = {
	PieceData.PIECE_SHAPE.L: chosen_piece_texture,
	PieceData.PIECE_SHAPE.J: chosen_piece_texture,
	PieceData.PIECE_SHAPE.S: chosen_piece_texture,
	PieceData.PIECE_SHAPE.Z: chosen_piece_texture,
	PieceData.PIECE_SHAPE.T: chosen_piece_texture,
	PieceData.PIECE_SHAPE.O: chosen_piece_texture,
	PieceData.PIECE_SHAPE.I: chosen_piece_texture,
}
