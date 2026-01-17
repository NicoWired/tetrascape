extends Node

const TILE_SIZE: int = 32
const BOARD_SIZE: Vector2i = Vector2i(10,20)
const TARGET_FRAME_RATE: int = 60
const BOARD_X_OFFSET: int = 7
const PIECE_SPEED: int = 30


const GRAVITY_CD: float = PIECE_SPEED * (1.0 / TARGET_FRAME_RATE)
