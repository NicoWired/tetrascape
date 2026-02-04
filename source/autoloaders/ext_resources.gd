extends Node

const PLACEHOLDER_TEXTURE: Texture2D = preload("res://icon.svg")

#region puzzle piece
const PIECE1: Texture2D = preload("res://assets/pieces/piece1.png")
const PIECE2: Texture2D = preload("res://assets/pieces/piece2.png")
const PIECE3: Texture2D = preload("res://assets/pieces/piece3.png")
const PIECE4: Texture2D = preload("res://assets/pieces/piece4.png")

var chosen_piece_texture: Texture2D = PIECE4

var PIECE_TEXTURES: Dictionary[int,Texture2D] = {
	PieceData.PIECE_SHAPE.L: chosen_piece_texture,
	PieceData.PIECE_SHAPE.J: chosen_piece_texture,
	PieceData.PIECE_SHAPE.S: chosen_piece_texture,
	PieceData.PIECE_SHAPE.Z: chosen_piece_texture,
	PieceData.PIECE_SHAPE.T: chosen_piece_texture,
	PieceData.PIECE_SHAPE.O: chosen_piece_texture,
	PieceData.PIECE_SHAPE.I: chosen_piece_texture,
}
#endregion

#region spikes
const SPIKES1: Texture2D = preload("res://assets/props/spikes/spikes1.png")
const SPIKES2: Texture2D = preload("res://assets/props/spikes/spikes2.png")
const SPIKES3: Texture2D = preload("res://assets/props/spikes/spikes3.png")
const SPIKES4: Texture2D = preload("res://assets/props/spikes/spikes4.png")
const SPIKES5: Texture2D = preload("res://assets/props/spikes/spikes5.png")

var chosen_spikes_texture: Texture2D = SPIKES1
#endregion
